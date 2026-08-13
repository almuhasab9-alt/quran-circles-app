import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../database/app_database.dart';

const _uuid = Uuid();

class TransferResult {
  final bool ok;
  final String? error;
  const TransferResult({required this.ok, this.error});
}

/// خدمة نقل الطالب من حلقة إلى أخرى.
/// تنقل كل بيانات الطالب (سجلاته اليومية + خططه الأسبوعية) إلى الحلقة الجديدة
/// حتى تظهر تقاريره في الحلقة الجديدة دون فقدان أي شيء.
class TransferService {
  final AppDatabase db;
  TransferService(this.db);

  Future<TransferResult> transferStudent({
    required String studentId,
    required String toHalaqaId,
    required String byUserId,
  }) async {
    final student = await (db.select(db.students)
          ..where((s) => s.id.equals(studentId)))
        .getSingleOrNull();
    if (student == null) return const TransferResult(ok: false, error: 'الطالب غير موجود.');

    final target = await (db.select(db.halaqas)
          ..where((h) => h.id.equals(toHalaqaId)))
        .getSingleOrNull();
    if (target == null) return const TransferResult(ok: false, error: 'الحلقة المستهدفة غير موجودة.');
    if (!target.active) return const TransferResult(ok: false, error: 'الحلقة المستهدفة غير نشطة.');
    if (student.halaqaId == toHalaqaId) {
      return const TransferResult(ok: false, error: 'الطالب موجود أصلاً في هذه الحلقة.');
    }

    // التحقق من السعة
    final currentCount = await (db.select(db.students)
          ..where((s) => s.halaqaId.equals(toHalaqaId) & s.active.equals(true)))
        .get();
    if (currentCount.length >= target.capacity) {
      return TransferResult(ok: false, error: 'الحلقة «${target.name}» ممتلئة (السعة ${target.capacity}).');
    }

    final fromHalaqaId = student.halaqaId;
    final now = DateTime.now();

    await db.transaction(() async {
      // 1) سجل عملية النقل
      await db.into(db.studentTransfers).insert(StudentTransfersCompanion(
        id: Value(_uuid.v4()),
        studentId: Value(studentId),
        fromHalaqaId: Value(fromHalaqaId),
        toHalaqaId: Value(toHalaqaId),
        transferredAt: Value(now),
        byUser: Value(byUserId),
      ));

      // 2) حدّث حلقة الطالب
      await (db.update(db.students)..where((s) => s.id.equals(studentId))).write(
        StudentsCompanion(halaqaId: Value(toHalaqaId), updatedAt: Value(now)),
      );

      // 3) انقل كل السجلات اليومية إلى الحلقة الجديدة + المعلم الجديد
      final newTeacherId = target.teacherIds.split(',').firstWhere(
            (e) => e.trim().isNotEmpty,
            orElse: () => '',
          ).trim();
      await (db.update(db.dailyRecords)..where((r) => r.studentId.equals(studentId))).write(
        DailyRecordsCompanion(
          halaqaId: Value(toHalaqaId),
          teacherId: Value(newTeacherId),
          updatedAt: Value(now),
        ),
      );

      // 4) انقل الخطط الأسبوعية إلى الحلقة الجديدة
      await (db.update(db.weeklyPlans)..where((p) => p.studentId.equals(studentId))).write(
        WeeklyPlansCompanion(halaqaId: Value(toHalaqaId), updatedAt: Value(now)),
      );
    });

    return const TransferResult(ok: true);
  }

  /// سجل نقل الطالب
  Future<List<StudentTransfer>> historyOf(String studentId) {
    return (db.select(db.studentTransfers)
          ..where((t) => t.studentId.equals(studentId))
          ..orderBy([(t) => OrderingTerm.desc(t.transferredAt)]))
        .get();
  }
}
