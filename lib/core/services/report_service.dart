import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../database/app_database.dart';
import '../constants/enums.dart';
import '../utils/date_utils.dart' as du;
import 'session_service.dart';

const _uuid = Uuid();

/// عدد الصفحات في نطاق مراجعة (من صفحة إلى صفحة، شامل)
int pagesOfRange(int from, int to) => (from > 0 && to >= from) ? to - from + 1 : 0;

/// ملخص إنجاز فترة (أسبوع/شهر) مقارنة بالمطلوب
class PeriodReport {
  final double requiredNew, doneNew;
  final double requiredRecent, doneRecent;
  final double requiredMinor, doneMinor;
  final double requiredMajor, doneMajor;
  final double requiredFriday, doneFriday;
  final int daysRecorded;
  final int fridaysRecorded;
  final EvaluationGrade? weeklyGrade; // أدنى تقدير في الأسبوع (المتماثل)

  const PeriodReport({
    required this.requiredNew, required this.doneNew,
    required this.requiredRecent, required this.doneRecent,
    required this.requiredMinor, required this.doneMinor,
    required this.requiredMajor, required this.doneMajor,
    required this.requiredFriday, required this.doneFriday,
    required this.daysRecorded, required this.fridaysRecorded,
    this.weeklyGrade,
  });

  static double _pct(double done, double req) {
    if (req <= 0) return done > 0 ? 100 : 0;
    final p = done / req * 100;
    return p > 100 ? 100 : p;
  }

  double get newPct => _pct(doneNew, requiredNew);
  double get recentPct => _pct(doneRecent, requiredRecent);
  double get minorPct => _pct(doneMinor, requiredMinor);
  double get majorPct => _pct(doneMajor, requiredMajor);
  double get fridayPct => _pct(doneFriday, requiredFriday);

  double get requiredTotal =>
      requiredNew + requiredRecent + requiredMinor + requiredMajor + requiredFriday;
  double get doneTotal => doneNew + doneRecent + doneMinor + doneMajor + doneFriday;
  double get overallPct => _pct(doneTotal, requiredTotal);
}

class ReportService {
  final AppDatabase db;
  ReportService(this.db);

  /// حفظ/تحديث المطلوب الأسبوعي لطالب
  Future<void> saveWeeklyPlan({
    required String studentId,
    required String halaqaId,
    required DateTime anyDayInWeek,
    double requiredNewPages = 0,
    double requiredRecentPages = 0,
    double requiredMinorPages = 0,
    double requiredMajorPages = 0,
    double requiredFridayPages = 0,
  }) async {
    final weekStart = SessionService.weekStartOf(anyDayInWeek);
    final key = du.dateKeyOf(weekStart);
    final now = DateTime.now();
    await db.into(db.weeklyPlans).insertOnConflictUpdate(WeeklyPlansCompanion(
      id: Value(_uuid.v4()),
      studentId: Value(studentId),
      halaqaId: Value(halaqaId),
      weekStartKey: Value(key),
      requiredNewPages: Value(requiredNewPages),
      requiredRecentPages: Value(requiredRecentPages),
      requiredMinorPages: Value(requiredMinorPages),
      requiredMajorPages: Value(requiredMajorPages),
      requiredFridayPages: Value(requiredFridayPages),
      createdAt: Value(now),
      updatedAt: Value(now),
    ));
  }

  Future<WeeklyPlan?> weeklyPlanOf(String studentId, DateTime anyDayInWeek) {
    final key = du.dateKeyOf(SessionService.weekStartOf(anyDayInWeek));
    return (db.select(db.weeklyPlans)
          ..where((p) => p.studentId.equals(studentId) & p.weekStartKey.equals(key)))
        .getSingleOrNull();
  }

  /// التقرير الأسبوعي لطالب
  Future<PeriodReport> weeklyReport(String studentId, DateTime anyDayInWeek) async {
    final days = SessionService.weekDaysOf(anyDayInWeek);
    final from = days.first;
    final to = days.last;
    return _buildReport(studentId, from, to, singleWeek: true, anyDayInWeek: anyDayInWeek);
  }

  /// التقرير الشهري لطالب (من أول يوم لآخر يوم في الشهر)
  Future<PeriodReport> monthlyReport(String studentId, int year, int month) async {
    final from = DateTime(year, month, 1);
    final to = DateTime(year, month + 1, 0);
    return _buildReport(studentId, from, to, singleWeek: false, month: month, year: year);
  }

  Future<PeriodReport> _buildReport(
    String studentId,
    DateTime from,
    DateTime to, {
    required bool singleWeek,
    DateTime? anyDayInWeek,
    int? month,
    int? year,
  }) async {
    // جلب المطلوب والمنجز من القاعدة المحلية ثم التفويض إلى الحساب النقي
    List<WeeklyPlan> plans;
    if (singleWeek) {
      final p = await weeklyPlanOf(studentId, anyDayInWeek!);
      plans = p != null ? [p] : const [];
    } else {
      plans = await (db.select(db.weeklyPlans)
            ..where((p) => p.studentId.equals(studentId)))
          .get();
    }
    final recs = await (db.select(db.dailyRecords)
          ..where((r) =>
              r.studentId.equals(studentId) &
              r.dateKey.isBetweenValues(du.dateKeyOf(from), du.dateKeyOf(to)))
          ..orderBy([(r) => OrderingTerm.asc(r.dateKey)]))
        .get();
    return buildFromData(recs: recs, plans: plans, from: from, to: to);
  }

  /// بناء تقرير فترة من بيانات جاهزة (سجلات وخطط) — دون الوصول لأي قاعدة.
  ///
  /// تُستخدم لمسار السحابة: تُجلب السجلات والخطط من الـ API ثم تُحسب هنا.
  /// [recs] يجب أن تكون ضمن الفترة [from, to]، و[plans] كل خطط الطالب
  /// (يُحتسب منها ما يتقاطع مع الفترة فقط).
  PeriodReport buildFromData({
    required List<DailyRecord> recs,
    required List<WeeklyPlan> plans,
    required DateTime from,
    required DateTime to,
  }) {
    // 1) اجمع المطلوب من الخطط المتقاطعة مع الفترة
    double reqNew = 0, reqRecent = 0, reqMinor = 0, reqMajor = 0, reqFriday = 0;
    for (final p in plans) {
      final ws = DateTime.parse(p.weekStartKey);
      final we = ws.add(const Duration(days: 6));
      if (ws.isBefore(to.add(const Duration(days: 1))) &&
          we.isAfter(from.subtract(const Duration(days: 1)))) {
        reqNew += p.requiredNewPages;
        reqRecent += p.requiredRecentPages;
        reqMinor += p.requiredMinorPages;
        reqMajor += p.requiredMajorPages;
        reqFriday += p.requiredFridayPages;
      }
    }

    // 2) اجمع المنجز من السجلات
    double doneNew = 0, doneRecent = 0, doneMinor = 0, doneMajor = 0, doneFriday = 0;
    int days = 0, fridays = 0;
    int minGradeRank = 5; // لحساب «المتماثل» (أدنى تقدير)
    EvaluationGrade? weeklyGrade;

    for (final r in recs) {
      if (r.isFriday) {
        fridays++;
        doneFriday += pagesOfRange(r.recentFromPage, r.recentToPage) +
            pagesOfRange(r.minorFromPage, r.minorToPage) +
            pagesOfRange(r.majorFromPage, r.majorToPage);
      } else {
        days++;
        doneNew += r.newPages;
        doneRecent += pagesOfRange(r.recentFromPage, r.recentToPage);
        doneMinor += pagesOfRange(r.minorFromPage, r.minorToPage);
        doneMajor += pagesOfRange(r.majorFromPage, r.majorToPage);
        final g = EvaluationGradeAr.fromName(r.grade);
        if (g != null && g.rank < minGradeRank) {
          minGradeRank = g.rank;
          weeklyGrade = g;
        }
      }
    }

    return PeriodReport(
      requiredNew: reqNew, doneNew: doneNew,
      requiredRecent: reqRecent, doneRecent: doneRecent,
      requiredMinor: reqMinor, doneMinor: doneMinor,
      requiredMajor: reqMajor, doneMajor: doneMajor,
      requiredFriday: reqFriday, doneFriday: doneFriday,
      daysRecorded: days, fridaysRecorded: fridays,
      weeklyGrade: weeklyGrade,
    );
  }
}
