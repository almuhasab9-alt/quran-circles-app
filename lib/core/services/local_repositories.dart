import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../../shared/models/repositories.dart';

class LocalHalaqaRepository implements IHalaqaRepository {
  final AppDatabase db;
  LocalHalaqaRepository(this.db);
  @override
  Future<List<Halaqa>> getAll({bool includeInactive = false}) =>
      (db.select(db.halaqas)..where((h) => includeInactive ? const Constant(true) : h.active.equals(true))).get();
  @override
  Future<Halaqa?> getById(String id) =>
      (db.select(db.halaqas)..where((h) => h.id.equals(id))).getSingleOrNull();
  @override
  Future<List<Halaqa>> byTeacher(String teacherId) =>
      (db.select(db.halaqas)..where((h) => h.teacherIds.like('%$teacherId%'))).get();
  @override
  Future<List<Halaqa>> bySupervisor(String supervisorId) =>
      (db.select(db.halaqas)..where((h) => h.supervisorId.equals(supervisorId))).get();
  @override
  Future<void> insert(HalaqasCompanion h) => db.into(db.halaqas).insert(h);
  @override
  Future<void> update(HalaqasCompanion h) =>
      (db.update(db.halaqas)..where((x) => x.id.equals(h.id.value))).write(h);
  @override
  Future<void> deactivate(String id) =>
      (db.update(db.halaqas)..where((h) => h.id.equals(id)))
          .write(const HalaqasCompanion(active: Value(false)));
}

class LocalStudentRepository implements IStudentRepository {
  final AppDatabase db;
  LocalStudentRepository(this.db);
  @override
  Future<List<Student>> getAll({bool includeInactive = false}) =>
      (db.select(db.students)..where((s) => includeInactive ? const Constant(true) : s.active.equals(true))).get();
  @override
  Future<List<Student>> byHalaqa(String halaqaId) =>
      (db.select(db.students)..where((s) => s.halaqaId.equals(halaqaId) & s.active.equals(true))).get();
  @override
  Future<Student?> getById(String id) =>
      (db.select(db.students)..where((s) => s.id.equals(id))).getSingleOrNull();
  @override
  Future<List<Student>> search(String query) =>
      (db.select(db.students)..where((s) => s.fullName.like('%$query%') | s.studentCode.like('%$query%'))).get();
  @override
  Future<void> insert(StudentsCompanion s) => db.into(db.students).insert(s);
  @override
  Future<void> update(StudentsCompanion s) =>
      (db.update(db.students)..where((x) => x.id.equals(s.id.value))).write(s);
  @override
  Future<void> deactivate(String id) =>
      (db.update(db.students)..where((s) => s.id.equals(id)))
          .write(const StudentsCompanion(active: Value(false)));
}

class LocalDailyRecordRepository implements IDailyRecordRepository {
  final AppDatabase db;
  LocalDailyRecordRepository(this.db);
  @override
  Future<List<DailyRecord>> all() => db.select(db.dailyRecords).get();
  @override
  Future<List<DailyRecord>> byStudent(String studentId) =>
      (db.select(db.dailyRecords)..where((r) => r.studentId.equals(studentId))).get();
  @override
  Future<List<DailyRecord>> byHalaqa(String halaqaId) =>
      (db.select(db.dailyRecords)..where((r) => r.halaqaId.equals(halaqaId))).get();
  @override
  Future<List<DailyRecord>> byHalaqaAndDate(String halaqaId, String dateKey) =>
      (db.select(db.dailyRecords)..where((r) => r.halaqaId.equals(halaqaId) & r.dateKey.equals(dateKey))).get();
  @override
  Future<DailyRecord?> byStudentAndDate(String studentId, String dateKey) =>
      (db.select(db.dailyRecords)..where((r) => r.studentId.equals(studentId) & r.dateKey.equals(dateKey))).getSingleOrNull();
}

class LocalUserRepository implements IUserRepository {
  final AppDatabase db;
  LocalUserRepository(this.db);
  @override
  Future<List<User>> byRole(String role) =>
      (db.select(db.users)..where((u) => u.role.equals(role) & u.active.equals(true))).get();
  @override
  Future<List<User>> all() => db.select(db.users).get();
  @override
  Future<User?> getById(String id) =>
      (db.select(db.users)..where((u) => u.id.equals(id))).getSingleOrNull();

  /// إدراج/تحديث مستخدم في الجدول المحلي (مرآة للحساب السحابي).
  /// يحافظ على تاريخ الإنشاء الأصلي إن وُجد الصف من قبل.
  @override
  Future<void> upsert({
    required String id,
    required String fullName,
    required String username,
    required String role,
    bool active = true,
    String assignedHalaqaIds = '',
  }) async {
    if (id.isEmpty) return;
    final existing = await getById(id);
    final now = DateTime.now();
    await db.into(db.users).insertOnConflictUpdate(UsersCompanion(
          id: Value(id),
          fullName: Value(fullName.isEmpty ? username : fullName),
          username: Value(username),
          role: Value(role),
          active: Value(active),
          assignedHalaqaIds: Value(assignedHalaqaIds),
          createdAt: Value(existing?.createdAt ?? now),
          updatedAt: Value(now),
        ));
  }
}
