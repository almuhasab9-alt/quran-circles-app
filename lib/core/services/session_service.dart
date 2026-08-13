import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../database/app_database.dart';
import '../constants/enums.dart';
import '../utils/date_utils.dart' as du;
import 'quran_meta.dart';

const _uuid = Uuid();

/// نتيجة عملية التسجيل
class SessionSaveResult {
  final bool ok;
  final String? error;
  final DailyRecord? record;
  const SessionSaveResult({required this.ok, this.error, this.record});
  factory SessionSaveResult.fail(String error) => SessionSaveResult(ok: false, error: error);
  factory SessionSaveResult.success(DailyRecord r) => SessionSaveResult(ok: true, record: r);
}

/// خدمة التسميع اليومي — قلب نظام المعلم.
/// تفرض القواعد:
/// 1. لا يمكن التسجيل ليوم ما قبل تسجيل يوم العمل السابق (منع الإغفال).
/// 2. يوم الجمعة = ربط فقط (مراجعة) بدون جديد وبدون تقدير.
/// 3. أيام السبت..الخميس: الجديد من آية إلى آية + التقدير إلزامي.
class SessionService {
  final AppDatabase db;
  SessionService(this.db);

  static const _weekOrder = [
    DateTime.saturday, DateTime.sunday, DateTime.monday,
    DateTime.tuesday, DateTime.wednesday, DateTime.thursday, DateTime.friday,
  ];

  /// بداية الأسبوع (السبت) لتاريخ معيّن
  static DateTime weekStartOf(DateTime date) {
    final d = DateTime(date.year, date.month, date.day);
    final diff = (d.weekday - DateTime.saturday) % 7;
    return d.subtract(Duration(days: diff));
  }

  /// مفاتيح الأيام السبعة للأسبوع الذي يبدأ يوم السبت
  static List<DateTime> weekDaysOf(DateTime anyDay) {
    final start = weekStartOf(anyDay);
    return List.generate(7, (i) => start.add(Duration(days: i)));
  }

  /// يوم العمل السابق المطلوب تسجيله قبل [date].
  /// يعيد null إن كان [date] هو السبت (لا يوجد يوم قبله في الأسبوع).
  static DateTime? previousWorkDay(DateTime date) {
    final idx = _weekOrder.indexOf(date.weekday);
    if (idx <= 0) return null; // السبت أو يوم غير معروف
    final prevWeekday = _weekOrder[idx - 1];
    final diff = (date.weekday - prevWeekday) % 7;
    return DateTime(date.year, date.month, date.day).subtract(Duration(days: diff));
  }

  /// التحقق من أن المعلم لم يغفل تسجيل اليوم السابق لأي طالب في حلقته.
  /// يعيد رسالة خطأ إن وُجد إغفال، وإلا null.
  Future<String?> checkPreviousDayMissed({
    required String halaqaId,
    required DateTime date,
  }) async {
    final prev = previousWorkDay(date);
    if (prev == null) return null; // السبت: بداية أسبوع
    final prevKey = du.dateKeyOf(prev);
    final count = await (db.select(db.dailyRecords)
          ..where((r) => r.halaqaId.equals(halaqaId) & r.dateKey.equals(prevKey)))
        .get();
    if (count.isEmpty) {
      return 'لا يمكن التسجيل. لقد أغفلتَ تسجيل يوم ${_weekdayName(prev)} ($prevKey). سجّل ذلك اليوم أولاً.';
    }
    return null;
  }

  static String _weekdayName(DateTime d) => d.weekdayAr;

  /// حفظ سجل يومي كامل مع كل التحققات.
  Future<SessionSaveResult> saveDailyRecord({
    required String studentId,
    required String halaqaId,
    required String teacherId,
    required DateTime date,
    // الجديد
    int newFromSurah = 0,
    int newFromAyah = 0,
    int newToSurah = 0,
    int newToAyah = 0,
    EvaluationGrade? grade,
    int repetition = 0,
    // المراجعات بالصفحات
    int recentFromPage = 0,
    int recentToPage = 0,
    int minorFromPage = 0,
    int minorToPage = 0,
    int majorFromPage = 0,
    int majorToPage = 0,
    String notes = '',
  }) async {
    final day = DateTime(date.year, date.month, date.day);
    final isFriday = day.weekday == DateTime.friday;

    // 1. منع الإغفال: تحقق من اليوم السابق
    final missed = await checkPreviousDayMissed(halaqaId: halaqaId, date: day);
    if (missed != null) return SessionSaveResult.fail(missed);

    double newPages = 0;

    if (isFriday) {
      // الجمعة: ربط فقط — لا جديد ولا تقدير
      if (newFromSurah != 0 || grade != null) {
        return SessionSaveResult.fail('يوم الجمعة مخصص لربط المراجعة فقط، بدون جديد أو تقدير.');
      }
      if (recentToPage <= 0 && minorToPage <= 0 && majorToPage <= 0) {
        return SessionSaveResult.fail('سجّل مقدار ربط الجمعة (صفحات المراجعة).');
      }
    } else {
      // السبت..الخميس: الجديد + التقدير إلزاميان
      if (!QuranMeta.isValidAyah(newFromSurah, newFromAyah) ||
          !QuranMeta.isValidAyah(newToSurah, newToAyah)) {
        return SessionSaveResult.fail('نطاق الجديد غير صحيح. تأكد من السورة والآية (من/إلى).');
      }
      final absFrom = newFromSurah * 10000 + newFromAyah;
      final absTo = newToSurah * 10000 + newToAyah;
      if (absTo < absFrom) {
        return SessionSaveResult.fail('آية النهاية يجب أن تكون بعد آية البداية.');
      }
      if (grade == null) {
        return SessionSaveResult.fail('اختر التقدير: ممتاز، جيد جداً، جيد، أو إعادة.');
      }
      newPages = QuranMeta.rangeInPages((newFromSurah, newFromAyah), (newToSurah, newToAyah));
    }

    // تحقق من نطاقات الصفحات للمراجعات
    for (final (f, t, label) in [
      (recentFromPage, recentToPage, 'حديث العهد'),
      (minorFromPage, minorToPage, 'المراجعة الصغرى'),
      (majorFromPage, majorToPage, 'المراجعة الكبرى'),
    ]) {
      if ((f == 0) != (t == 0)) {
        return SessionSaveResult.fail('أكمل نطاق $label (من صفحة / إلى صفحة).');
      }
      if (f != 0) {
        if (!QuranMeta.isValidPage(f) || !QuranMeta.isValidPage(t)) {
          return SessionSaveResult.fail('صفحات $label خارج نطاق المصحف (1-604).');
        }
        if (t < f) {
          return SessionSaveResult.fail('صفحة نهاية $label يجب أن تكون بعد صفحة البداية.');
        }
      }
    }

    final now = DateTime.now();
    final dateKey = du.dateKeyOf(day);
    final companion = DailyRecordsCompanion(
      id: Value(_uuid.v4()),
      studentId: Value(studentId),
      halaqaId: Value(halaqaId),
      teacherId: Value(teacherId),
      date: Value(day),
      dateKey: Value(dateKey),
      weekday: Value(day.weekday),
      isFriday: Value(isFriday),
      newFromSurah: Value(newFromSurah),
      newFromAyah: Value(newFromAyah),
      newToSurah: Value(newToSurah),
      newToAyah: Value(newToAyah),
      newPages: Value(newPages),
      grade: Value(grade?.name ?? ''),
      repetition: Value(repetition),
      recentFromPage: Value(recentFromPage),
      recentToPage: Value(recentToPage),
      minorFromPage: Value(minorFromPage),
      minorToPage: Value(minorToPage),
      majorFromPage: Value(majorFromPage),
      majorToPage: Value(majorToPage),
      notes: Value(notes),
      createdAt: Value(now),
      updatedAt: Value(now),
    );

    await db.into(db.dailyRecords).insertOnConflictUpdate(companion);
    final saved = await (db.select(db.dailyRecords)
          ..where((r) => r.studentId.equals(studentId) & r.dateKey.equals(dateKey)))
        .getSingleOrNull();
    return SessionSaveResult.success(saved!);
  }

  /// سجلات طالب في أسبوع معيّن (يحتوي أي يوم منه)
  Future<List<DailyRecord>> weekRecords(String studentId, DateTime anyDay) async {
    final days = weekDaysOf(anyDay);
    final keys = days.map(du.dateKeyOf).toList();
    final recs = await (db.select(db.dailyRecords)
          ..where((r) => r.studentId.equals(studentId) & r.dateKey.isIn(keys)))
        .get();
    return recs;
  }

  /// سجلات طالب في نطاق تاريخي
  Future<List<DailyRecord>> recordsInRange(String studentId, DateTime from, DateTime to) async {
    return (db.select(db.dailyRecords)
          ..where((r) =>
              r.studentId.equals(studentId) &
              r.dateKey.isBetweenValues(du.dateKeyOf(from), du.dateKeyOf(to)))
          ..orderBy([(r) => OrderingTerm.asc(r.dateKey)]))
        .get();
  }

  Future<DailyRecord?> recordOn(String studentId, DateTime day) {
    final key = du.dateKeyOf(DateTime(day.year, day.month, day.day));
    return (db.select(db.dailyRecords)
          ..where((r) => r.studentId.equals(studentId) & r.dateKey.equals(key)))
        .getSingleOrNull();
  }

  /// آخر يوم عمل مسجّل للحلقة (لمعرفة اليوم المتوقع تسجيله تالياً)
  Future<DateTime?> nextExpectedDay(String halaqaId, DateTime today) async {
    final recs = await (db.select(db.dailyRecords)
          ..where((r) => r.halaqaId.equals(halaqaId))
          ..orderBy([(r) => OrderingTerm.desc(r.dateKey)])
          ..limit(1))
        .get();
    if (recs.isEmpty) return weekStartOf(today); // ابدأ من سبت هذا الأسبوع
    final last = DateTime.parse(recs.first.dateKey);
    // اليوم التالي في ترتيب الأسبوع
    final idx = _weekOrder.indexOf(last.weekday);
    if (idx < 0 || idx >= 6) {
      // كان الجمعة -> التالي سبت الأسبوع القادم
      return last.add(const Duration(days: 1));
    }
    final nextWeekday = _weekOrder[idx + 1];
    final diff = (nextWeekday - last.weekday) % 7;
    return last.add(Duration(days: diff == 0 ? 7 : diff));
  }
}
