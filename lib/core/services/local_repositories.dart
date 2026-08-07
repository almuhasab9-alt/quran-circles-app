import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../database/app_database.dart';
import '../../shared/models/repositories.dart';

const _uuid = Uuid();

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
  Future<void> updateEntity(Halaqa h) => db.update(db.halaqas).replace(h);
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
  Future<void> updateEntity(Student s) => db.update(db.students).replace(s);
  @override
  Future<void> deactivate(String id) =>
      (db.update(db.students)..where((s) => s.id.equals(id)))
          .write(const StudentsCompanion(active: Value(false)));
  @override
  Future<void> transfer(String studentId, String toHalaqaId, String byUser) async {
    await db.transaction(() async {
      final st = await getById(studentId);
      if (st == null) return;
      await db.into(db.studentTransfers).insert(StudentTransfersCompanion(
        id: Value(_uuid.v4()), studentId: Value(studentId),
        fromHalaqaId: Value(st.halaqaId), toHalaqaId: Value(toHalaqaId),
        transferredAt: Value(DateTime.now()), byUser: Value(byUser),
      ));
      await (db.update(db.students)..where((s) => s.id.equals(studentId))).write(
        StudentsCompanion(halaqaId: Value(toHalaqaId), updatedAt: Value(DateTime.now())),
      );
    });
  }
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
  @override
  Future<void> upsertRecord(DailyRecordsCompanion r) =>
      db.into(db.dailyRecords).insertOnConflictUpdate(r);
  @override
  Future<void> upsertBatch(List<DailyRecordsCompanion> rs) async {
    await db.transaction(() async {
      await db.batch((b) => b.insertAll(db.dailyRecords, rs, mode: InsertMode.insertOrReplace));
    });
  }
}

class LocalAlertRepository implements IAlertRepository {
  final AppDatabase db;
  LocalAlertRepository(this.db);
  @override
  Future<List<Alert>> byStatus(String status) =>
      (db.select(db.alerts)..where((a) => a.status.equals(status))).get();
  @override
  Future<List<Alert>> all() => db.select(db.alerts).get();
  @override
  Future<void> insertMany(List<AlertsCompanion> alerts) async {
    await db.batch((b) => b.insertAll(db.alerts, alerts));
  }
  @override
  Future<void> insert(AlertsCompanion a) => db.into(db.alerts).insert(a);
  @override
  Future<void> setStatus(String id, String status, {String? reviewedBy, String? reviewNote}) =>
      (db.update(db.alerts)..where((a) => a.id.equals(id))).write(AlertsCompanion(
        status: Value(status),
        reviewedBy: Value(reviewedBy),
        reviewNote: Value(reviewNote),
      ));
  @override
  Future<Set<String>> openTypesForStudent(String studentId) async {
    final open = await (db.select(db.alerts)
          ..where((a) => a.studentId.equals(studentId) & a.status.isNotIn(['closed'])))
        .get();
    return open.map((a) => a.type).toSet();
  }
}

class LocalFollowUpRepository implements IFollowUpRepository {
  final AppDatabase db;
  LocalFollowUpRepository(this.db);
  @override
  Future<List<FollowUpPlan>> byStudent(String studentId) =>
      (db.select(db.followUpPlans)..where((p) => p.studentId.equals(studentId))).get();
  @override
  Future<List<FollowUpPlan>> active() =>
      (db.select(db.followUpPlans)..where((p) => p.status.equals('active'))).get();
  @override
  Future<void> insert(FollowUpPlansCompanion p) => db.into(db.followUpPlans).insert(p);
  @override
  Future<void> insertPlan({
    required String studentId, required String createdBy,
    required DateTime startDate, required DateTime endDate,
    required String goals, required String actions, String? notes,
  }) =>
      db.into(db.followUpPlans).insert(FollowUpPlansCompanion(
        id: Value(_uuid.v4()), studentId: Value(studentId), createdBy: Value(createdBy),
        startDate: Value(startDate), endDate: Value(endDate),
        goals: Value(goals), actions: Value(actions),
        notes: notes == null ? const Value.absent() : Value(notes),
      ));
}

class LocalContactRepository implements IContactRepository {
  final AppDatabase db;
  LocalContactRepository(this.db);
  @override
  Future<List<ContactLog>> byStudent(String studentId) =>
      (db.select(db.contactLogs)..where((c) => c.studentId.equals(studentId))).get();
  @override
  Future<void> insert(ContactLogsCompanion c) => db.into(db.contactLogs).insert(c);
}

class LocalUserRepository implements IUserRepository {
  final AppDatabase db;
  LocalUserRepository(this.db);
  @override
  Future<List<User>> byRole(String role) =>
      (db.select(db.users)..where((u) => u.role.equals(role))).get();
  @override
  Future<List<User>> all() => db.select(db.users).get();
  @override
  Future<void> insert(UsersCompanion u) => db.into(db.users).insert(u);
  @override
  Future<void> update(UsersCompanion u) =>
      (db.update(db.users)..where((x) => x.id.equals(u.id.value))).write(u);
  @override
  Future<void> updateEntity(User u) => db.update(db.users).replace(u);
  @override
  Future<void> deactivate(String id) =>
      (db.update(db.users)..where((u) => u.id.equals(id)))
          .write(const UsersCompanion(active: Value(false)));
}

class LocalGuardianRepository implements IGuardianRepository {
  final AppDatabase db;
  LocalGuardianRepository(this.db);
  @override
  Future<Guardian?> getById(String id) =>
      (db.select(db.guardians)..where((g) => g.id.equals(id))).getSingleOrNull();
  @override
  Future<List<Guardian>> byIds(List<String> ids) =>
      (db.select(db.guardians)..where((g) => g.id.isIn(ids))).get();
  @override
  Future<List<Guardian>> getAll() => db.select(db.guardians).get();
  @override
  Future<void> insert(GuardiansCompanion g) => db.into(db.guardians).insert(g);
}
