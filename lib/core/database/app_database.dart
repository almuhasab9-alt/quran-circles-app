import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

class Users extends Table {
  TextColumn get id => text()();
  TextColumn get fullName => text()();
  TextColumn get username => text()();
  TextColumn get role => text()(); // admin | supervisor | teacher
  BoolColumn get active => boolean().withDefault(const Constant(true))();
  TextColumn get assignedHalaqaIds => text().withDefault(const Constant(''))(); // مفصولة بفواصل
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  @override
  Set<Column> get primaryKey => {id};
}

class Guardians extends Table {
  TextColumn get id => text()();
  TextColumn get fullName => text()();
  TextColumn get relation => text().withDefault(const Constant('والد'))();
  TextColumn get primaryPhone => text()();
  TextColumn get whatsappPhone => text().withDefault(const Constant(''))();
  TextColumn get secondaryPhone => text().withDefault(const Constant(''))();
  TextColumn get preferredContact => text().withDefault(const Constant('whatsapp'))();
  TextColumn get notes => text().withDefault(const Constant(''))();
  @override
  Set<Column> get primaryKey => {id};
}

class Halaqas extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get level => text()();
  TextColumn get teacherIds => text().withDefault(const Constant(''))();
  TextColumn get supervisorId => text().withDefault(const Constant(''))();
  IntColumn get capacity => integer().withDefault(const Constant(25))();
  TextColumn get scheduleDescription => text().withDefault(const Constant(''))();
  BoolColumn get active => boolean().withDefault(const Constant(true))();
  @override
  Set<Column> get primaryKey => {id};
}

class Students extends Table {
  TextColumn get id => text()();
  TextColumn get studentCode => text()();
  TextColumn get fullName => text()();
  TextColumn get halaqaId => text()();
  TextColumn get level => text().withDefault(const Constant(''))();
  BoolColumn get active => boolean().withDefault(const Constant(true))();
  DateTimeColumn get joinDate => dateTime()();
  TextColumn get guardianIds => text().withDefault(const Constant(''))();
  TextColumn get internalNotes => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  @override
  Set<Column> get primaryKey => {id};
}

// قيد منع التكرار: طالب واحد + يوم واحد = سجل واحد
class DailyRecords extends Table {
  TextColumn get id => text()();
  TextColumn get studentId => text()();
  TextColumn get halaqaId => text()();
  TextColumn get teacherId => text().withDefault(const Constant(''))();
  DateTimeColumn get date => dateTime()();
  TextColumn get dateKey => text()(); // YYYY-MM-DD
  TextColumn get attendance => text().withDefault(const Constant('present'))();
  // الحفظ
  TextColumn get fromSurah => text().withDefault(const Constant(''))();
  IntColumn get fromAyah => integer().withDefault(const Constant(0))();
  TextColumn get toSurah => text().withDefault(const Constant(''))();
  IntColumn get toAyah => integer().withDefault(const Constant(0))();
  RealColumn get estimatedPages => real().withDefault(const Constant(0))();
  // المراجعة
  RealColumn get revisionPlannedPages => real().withDefault(const Constant(0))();
  RealColumn get revisionCompletedPages => real().withDefault(const Constant(0))();
  RealColumn get revisionScore => real().withDefault(const Constant(0))();
  // التسميع
  IntColumn get minorErrors => integer().withDefault(const Constant(0))();
  IntColumn get mediumErrors => integer().withDefault(const Constant(0))();
  IntColumn get majorErrors => integer().withDefault(const Constant(0))();
  IntColumn get selfCorrections => integer().withDefault(const Constant(0))();
  RealColumn get automaticScore => real().withDefault(const Constant(0))();
  RealColumn get overrideScore => real().nullable()();
  TextColumn get overrideReason => text().nullable()();
  // الواجب
  TextColumn get homeworkStatus => text().withDefault(const Constant('completed'))();
  RealColumn get homeworkScore => real().withDefault(const Constant(0))();
  // النهائي
  RealColumn get finalScore => real().withDefault(const Constant(0))();
  TextColumn get level => text().withDefault(const Constant('good'))();
  TextColumn get internalNote => text().withDefault(const Constant(''))();
  BoolColumn get needsFollowUp => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  @override
  Set<Column> get primaryKey => {id};
  @override
  List<Set<Column>> get uniqueKeys => [
    {studentId, dateKey},
  ];
}

class FollowUpPlans extends Table {
  TextColumn get id => text()();
  TextColumn get studentId => text()();
  TextColumn get createdBy => text()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime().nullable()();
  TextColumn get goals => text().withDefault(const Constant(''))();
  TextColumn get actions => text().withDefault(const Constant(''))();
  TextColumn get status => text().withDefault(const Constant('active'))();
  TextColumn get notes => text().withDefault(const Constant(''))();
  @override
  Set<Column> get primaryKey => {id};
}

class Alerts extends Table {
  TextColumn get id => text()();
  TextColumn get studentId => text()();
  TextColumn get halaqaId => text().withDefault(const Constant(''))();
  TextColumn get type => text()();
  TextColumn get severity => text().withDefault(const Constant('normal'))();
  TextColumn get message => text()();
  TextColumn get status => text().withDefault(const Constant('pendingReview'))();
  TextColumn get createdBy => text().withDefault(const Constant('system'))();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get reviewedBy => text().nullable()();
  TextColumn get reviewNote => text().nullable()();
  @override
  Set<Column> get primaryKey => {id};
}

class ContactLogs extends Table {
  TextColumn get id => text()();
  TextColumn get studentId => text()();
  TextColumn get guardianId => text().withDefault(const Constant(''))();
  TextColumn get channel => text()();
  TextColumn get reason => text().withDefault(const Constant(''))();
  TextColumn get note => text().withDefault(const Constant(''))();
  TextColumn get contactedBy => text().withDefault(const Constant(''))();
  DateTimeColumn get contactedAt => dateTime()();
  TextColumn get outcome => text().nullable()();
  @override
  Set<Column> get primaryKey => {id};
}

class StudentTransfers extends Table {
  TextColumn get id => text()();
  TextColumn get studentId => text()();
  TextColumn get fromHalaqaId => text()();
  TextColumn get toHalaqaId => text()();
  DateTimeColumn get transferredAt => dateTime()();
  TextColumn get byUser => text().withDefault(const Constant(''))();
  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [
  Users, Guardians, Halaqas, Students, DailyRecords,
  FollowUpPlans, Alerts, ContactLogs, StudentTransfers,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(
    name: 'quran_center_db',
    web: DriftWebOptions(
      sqlite3Wasm: Uri.parse('sqlite3.wasm'),
      driftWorker: Uri.parse('drift_worker.js'),
    ),
  ));
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;
}
