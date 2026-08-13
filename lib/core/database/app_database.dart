import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

/// المستخدمون: مشرف (يرى كل شيء) أو معلم (يرى حلقته فقط)
class Users extends Table {
  TextColumn get id => text()();
  TextColumn get fullName => text()();
  TextColumn get username => text()();
  TextColumn get role => text()(); // supervisor | teacher
  BoolColumn get active => boolean().withDefault(const Constant(true))();
  TextColumn get assignedHalaqaIds => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  @override
  Set<Column> get primaryKey => {id};
}

class Halaqas extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get level => text().withDefault(const Constant(''))();
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
  TextColumn get internalNotes => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  @override
  Set<Column> get primaryKey => {id};
}

/// سجل التسميع اليومي — مطابق لكشف «متابعة ربط الأخ القرآني».
/// أيام السبت..الخميس: جديد + حديث عهد + صغرى + كبرى + تقدير + تكرار + ملاحظات.
/// يوم الجمعة (isFriday=true): ربط فقط (مراجعة) بدون جديد وبدون تقدير.
/// قيد منع التكرار: طالب واحد + يوم واحد = سجل واحد.
class DailyRecords extends Table {
  TextColumn get id => text()();
  TextColumn get studentId => text()();
  TextColumn get halaqaId => text()();
  TextColumn get teacherId => text().withDefault(const Constant(''))();
  DateTimeColumn get date => dateTime()();
  TextColumn get dateKey => text()(); // YYYY-MM-DD
  IntColumn get weekday => integer()(); // 1=اثنين..6=سبت، 7=أحد (Dart DateTime.weekday)
  BoolColumn get isFriday => boolean().withDefault(const Constant(false))();

  // الجديد: من آية إلى آية (سورة + آية)
  IntColumn get newFromSurah => integer().withDefault(const Constant(0))();
  IntColumn get newFromAyah => integer().withDefault(const Constant(0))();
  IntColumn get newToSurah => integer().withDefault(const Constant(0))();
  IntColumn get newToAyah => integer().withDefault(const Constant(0))();
  RealColumn get newPages => real().withDefault(const Constant(0))(); // محسوبة تلقائياً بدقة
  // التقدير: excellent | veryGood | good | repeat (فارغ يوم الجمعة)
  TextColumn get grade => text().withDefault(const Constant(''))();
  // التكرار: عدد مرات تكرار الجديد
  IntColumn get repetition => integer().withDefault(const Constant(0))();
  // حديث العهد: من صفحة إلى صفحة
  IntColumn get recentFromPage => integer().withDefault(const Constant(0))();
  IntColumn get recentToPage => integer().withDefault(const Constant(0))();
  // المراجعة الصغرى: من صفحة إلى صفحة
  IntColumn get minorFromPage => integer().withDefault(const Constant(0))();
  IntColumn get minorToPage => integer().withDefault(const Constant(0))();
  // المراجعة الكبرى: من صفحة إلى صفحة
  IntColumn get majorFromPage => integer().withDefault(const Constant(0))();
  IntColumn get majorToPage => integer().withDefault(const Constant(0))();
  // الملاحظات
  TextColumn get notes => text().withDefault(const Constant(''))();

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  @override
  Set<Column> get primaryKey => {id};
  @override
  List<Set<Column>> get uniqueKeys => [
    {studentId, dateKey},
  ];
}

/// المطلوب الأسبوعي لكل طالب — يحدده المعلم لكل أسبوع.
class WeeklyPlans extends Table {
  TextColumn get id => text()();
  TextColumn get studentId => text()();
  TextColumn get halaqaId => text()();
  TextColumn get weekStartKey => text()(); // YYYY-MM-DD ليوم السبت
  // المطلوب من الجديد (صفحات)
  RealColumn get requiredNewPages => real().withDefault(const Constant(0))();
  // المطلوب من حديث العهد (صفحات)
  RealColumn get requiredRecentPages => real().withDefault(const Constant(0))();
  // المطلوب من المراجعة الصغرى (صفحات)
  RealColumn get requiredMinorPages => real().withDefault(const Constant(0))();
  // المطلوب من المراجعة الكبرى (صفحات)
  RealColumn get requiredMajorPages => real().withDefault(const Constant(0))();
  // المطلوب من ربط الجمعة (صفحات)
  RealColumn get requiredFridayPages => real().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  @override
  Set<Column> get primaryKey => {id};
  @override
  List<Set<Column>> get uniqueKeys => [
    {studentId, weekStartKey},
  ];
}

/// سجل نقل الطلاب بين الحلقات — كل بيانات الطالب تنتقل معه.
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
  Users, Halaqas, Students, DailyRecords, WeeklyPlans, StudentTransfers,
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
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      // إعادة هيكلة جذرية: حذف الجداول القديمة وإنشاء الجديدة
      if (from < 2) {
        for (final t in allTables) {
          await m.drop(t);
        }
        await m.createAll();
      }
    },
  );
}
