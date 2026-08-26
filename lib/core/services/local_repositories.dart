import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../../shared/models/repositories.dart';
import '../utils/date_utils.dart' as du;

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

  @override
  Future<List<DailyRecord>> inRange(String studentId, DateTime from, DateTime to) =>
      (db.select(db.dailyRecords)
            ..where((r) =>
                r.studentId.equals(studentId) &
                r.dateKey.isBetweenValues(du.dateKeyOf(from), du.dateKeyOf(to)))
            ..orderBy([(r) => OrderingTerm.asc(r.dateKey)]))
          .get();

  @override
  Future<void> upsertPayload(Map<String, dynamic> p) async {
    final companion = DailyRecordsCompanion(
      id: Value(p['id'] as String),
      studentId: Value(p['studentId'] as String),
      halaqaId: Value(p['halaqaId'] as String),
      teacherId: Value((p['teacherId'] ?? '') as String),
      date: Value(DateTime.fromMillisecondsSinceEpoch(p['date'] as int)),
      dateKey: Value(p['dateKey'] as String),
      weekday: Value(p['weekday'] as int),
      isFriday: Value(p['isFriday'] as bool),
      newFromSurah: Value(p['newFromSurah'] as int),
      newFromAyah: Value(p['newFromAyah'] as int),
      newToSurah: Value(p['newToSurah'] as int),
      newToAyah: Value(p['newToAyah'] as int),
      newPages: Value((p['newPages'] as num).toDouble()),
      grade: Value(p['grade'] as String),
      repetition: Value(p['repetition'] as int),
      recentFromPage: Value(p['recentFromPage'] as int),
      recentToPage: Value(p['recentToPage'] as int),
      minorFromPage: Value(p['minorFromPage'] as int),
      minorToPage: Value(p['minorToPage'] as int),
      majorFromPage: Value(p['majorFromPage'] as int),
      majorToPage: Value(p['majorToPage'] as int),
      notes: Value(p['notes'] as String),
      createdAt: Value(DateTime.fromMillisecondsSinceEpoch(p['createdAt'] as int)),
      updatedAt: Value(DateTime.fromMillisecondsSinceEpoch(p['updatedAt'] as int)),
    );
    await db.into(db.dailyRecords).insertOnConflictUpdate(companion);
  }
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
}
