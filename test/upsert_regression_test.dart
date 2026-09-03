import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_center/core/constants/enums.dart';
import 'package:quran_center/core/database/app_database.dart';
import 'package:quran_center/core/services/local_repositories.dart';
import 'package:quran_center/core/services/report_service.dart';
import 'package:quran_center/core/services/session_service.dart';

AppDatabase _memDb() => AppDatabase.forTesting(NativeDatabase.memory());

Future<void> _seed(AppDatabase db) async {
  final now = DateTime(2026, 8, 13, 10);
  await db.into(db.users).insert(UsersCompanion(
        id: const Value('u-t1'),
        fullName: const Value('الشيخ أحمد'),
        username: const Value('teacher1'),
        role: const Value('teacher'),
        assignedHalaqaIds: const Value('h1'),
        createdAt: Value(now),
        updatedAt: Value(now),
      ));
  await db.into(db.halaqas).insert(const HalaqasCompanion(
        id: Value('h1'),
        name: Value('حلقة الفرقان'),
        level: Value('متوسط'),
        teacherIds: Value('u-t1'),
        supervisorId: Value(''),
        capacity: Value(25),
        scheduleDescription: Value(''),
      ));
  await db.into(db.students).insert(StudentsCompanion(
        id: const Value('s1'),
        studentCode: const Value('ST1001'),
        fullName: const Value('أحمد مرزوق'),
        halaqaId: const Value('h1'),
        level: const Value('متوسط'),
        joinDate: Value(now),
        createdAt: Value(now),
        updatedAt: Value(now),
      ));
}

void main() {
  setUpAll(() {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  });

  _mirrorTests();

  test('إعادة حفظ تسميع نفس الطالب في نفس اليوم تُحدّث السجل بدل أن تفشل',
      () async {
    final db = _memDb();
    addTearDown(db.close);
    await _seed(db);
    final svc = SessionService(db);
    // الأحد 2026-08-16 (السبت هو أول أيام الأسبوع، فلا يوجد يوم سابق مطلوب)
    final day = DateTime(2026, 8, 15); // السبت

    final r1 = await svc.saveDailyRecord(
      studentId: 's1',
      halaqaId: 'h1',
      teacherId: 'u-t1',
      date: day,
      newFromSurah: 1,
      newFromAyah: 1,
      newToSurah: 1,
      newToAyah: 7,
      grade: EvaluationGrade.excellent,
    );
    expect(r1.ok, isTrue, reason: r1.error);

    final r2 = await svc.saveDailyRecord(
      studentId: 's1',
      halaqaId: 'h1',
      teacherId: 'u-t1',
      date: day,
      newFromSurah: 2,
      newFromAyah: 1,
      newToSurah: 2,
      newToAyah: 20,
      grade: EvaluationGrade.good,
      notes: 'تعديل',
    );
    expect(r2.ok, isTrue, reason: r2.error);

    final all = await db.select(db.dailyRecords).get();
    expect(all.length, 1);
    expect(all.single.id, r1.record!.id, reason: 'يجب الحفاظ على نفس المعرّف');
    expect(all.single.newFromSurah, 2);
    expect(all.single.grade, EvaluationGrade.good.name);
    expect(all.single.notes, 'تعديل');
    expect(all.single.createdAt, r1.record!.createdAt);
  });

  test('إعادة حفظ المطلوب الأسبوعي لنفس الأسبوع تُحدّث الخطة بدل أن تفشل',
      () async {
    final db = _memDb();
    addTearDown(db.close);
    await _seed(db);
    final svc = ReportService(db);
    final day = DateTime(2026, 8, 17);

    await svc.saveWeeklyPlan(
      studentId: 's1',
      halaqaId: 'h1',
      anyDayInWeek: day,
      requiredNewPages: 3,
    );
    final p1 = await svc.weeklyPlanOf('s1', day);
    expect(p1, isNotNull);

    await svc.saveWeeklyPlan(
      studentId: 's1',
      halaqaId: 'h1',
      anyDayInWeek: day.add(const Duration(days: 2)),
      requiredNewPages: 5,
      requiredMinorPages: 10,
    );
    final all = await db.select(db.weeklyPlans).get();
    expect(all.length, 1);
    expect(all.single.id, p1!.id);
    expect(all.single.requiredNewPages, 5);
    expect(all.single.requiredMinorPages, 10);
  });
}

void _mirrorTests() {
  test('مرآة الحساب السحابي في جدول المستخدمين المحلي (إدراج ثم تحديث)', () async {
    final db = _memDb();
    addTearDown(db.close);
    final repo = LocalUserRepository(db);

    await repo.upsert(
      id: 'acc-1',
      fullName: 'الشيخ خالد',
      username: 'khaled',
      role: 'teacher',
      assignedHalaqaIds: 'h1',
    );
    final first = await repo.getById('acc-1');
    expect(first, isNotNull);
    expect(first!.fullName, 'الشيخ خالد');
    expect((await repo.byRole('teacher')).length, 1);

    // تحديث الاسم وتعطيل الحساب — يجب أن يبقى صف واحد ويحتفظ بتاريخ الإنشاء
    await repo.upsert(
      id: 'acc-1',
      fullName: 'الشيخ خالد العمري',
      username: 'khaled',
      role: 'teacher',
      active: false,
      assignedHalaqaIds: 'h2',
    );
    final all = await repo.all();
    expect(all.length, 1);
    expect(all.single.fullName, 'الشيخ خالد العمري');
    expect(all.single.active, isFalse);
    expect(all.single.assignedHalaqaIds, 'h2');
    expect(all.single.createdAt, first.createdAt);
    expect((await repo.byRole('teacher')), isEmpty, reason: 'المعطّل لا يظهر في قائمة المعلمين');

    // اسم فارغ → يُستخدم اسم المستخدم بدلاً منه
    await repo.upsert(id: 'acc-2', fullName: '', username: 'omar', role: 'teacher');
    expect((await repo.getById('acc-2'))!.fullName, 'omar');

    // معرّف فارغ → يُتجاهل بأمان
    await repo.upsert(id: '', fullName: 'x', username: 'x', role: 'teacher');
    expect((await repo.all()).length, 2);
  });
}
