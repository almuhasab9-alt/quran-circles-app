import '../constants/enums.dart';
import 'app_settings.dart';

// سجل مبسط يستخدمه المحرك (مستقل عن طبقة قاعدة البيانات لسهولة الاختبار)
class DailyRecordLite {
  final String studentId;
  final String halaqaId;
  final DateTime date;
  final String attendance; // present | late | excusedAbsence | unexcusedAbsence
  final double finalScore;
  final int majorErrors;
  final bool hasRecitation;
  const DailyRecordLite({
    required this.studentId,
    required this.halaqaId,
    required this.date,
    required this.attendance,
    this.finalScore = 0,
    this.majorErrors = 0,
    this.hasRecitation = false,
  });
}

class AlertDraft {
  final String studentId;
  final String halaqaId;
  final AlertType type;
  final AlertSeverity severity;
  final String message;
  final DateTime createdAt;
  const AlertDraft({
    required this.studentId,
    required this.halaqaId,
    required this.type,
    required this.severity,
    required this.message,
    required this.createdAt,
  });
}

// محرك التنبيهات المحلي
class AlertEngine {
  final AppSettings settings;
  const AlertEngine(this.settings);

  static DateTime _day(DateTime d) => DateTime(d.year, d.month, d.day);

  // يفحص سجلات طالب واحد (مرتبة تصاعدياً حسب التاريخ) ويعيد تنبيهات جديدة
  // openTypes: أنواع التنبيهات المفتوحة حالياً للطالب لمنع التكرار
  List<AlertDraft> evaluate({
    required String studentId,
    required String halaqaId,
    required List<DailyRecordLite> records,
    required Set<AlertType> openTypes,
    DateTime? now,
  }) {
    final out = <AlertDraft>[];
    final n = now ?? DateTime.now();
    if (records.isEmpty) return out;

    void add(AlertType type, AlertSeverity sev, String msg) {
      if (openTypes.contains(type)) return;
      if (out.any((a) => a.type == type)) return;
      out.add(AlertDraft(
        studentId: studentId, halaqaId: halaqaId, type: type,
        severity: sev, message: msg, createdAt: n,
      ));
    }

    // 1) غيابات غير مبررة خلال نافذة زمنية
    if (settings.ruleAbsenceEnabled) {
      final from = _day(n).subtract(Duration(days: settings.absenceDaysWindow));
      final count = records.where((r) =>
          !r.date.isBefore(from) && r.attendance == 'unexcusedAbsence').length;
      if (count >= settings.absenceCount) {
        add(AlertType.repeatedUnexcusedAbsence, AlertSeverity.urgent,
            'غياب بلا عذر $count مرات خلال ${settings.absenceDaysWindow} يوماً');
      }
    }

    // 2) متوسط نهائي منخفض في آخر N جلسات
    if (settings.ruleLowAvgEnabled) {
      final last = records.reversed.take(settings.lowAvgSessions).toList();
      if (last.length >= settings.lowAvgSessions) {
        final avg = last.map((r) => r.finalScore).reduce((a, b) => a + b) / last.length;
        if (avg < settings.lowAvgThreshold) {
          add(AlertType.lowAverage, AlertSeverity.important,
              'متوسط آخر ${last.length} جلسات ${avg.toStringAsFixed(1)} (أقل من ${settings.lowAvgThreshold.toStringAsFixed(0)})');
        }
      }
    }

    // 3) تراجع 20 نقطة بين الأسبوع الحالي والسابق
    if (settings.ruleDropEnabled) {
      final today = _day(n);
      final weekStart = today.subtract(Duration(days: today.weekday - 1));
      final prevWeekStart = weekStart.subtract(const Duration(days: 7));
      final curr = records.where((r) => !r.date.isBefore(weekStart)).toList();
      final prev = records.where((r) =>
          !r.date.isBefore(prevWeekStart) && r.date.isBefore(weekStart)).toList();
      if (curr.isNotEmpty && prev.isNotEmpty) {
        final currAvg = curr.map((r) => r.finalScore).reduce((a, b) => a + b) / curr.length;
        final prevAvg = prev.map((r) => r.finalScore).reduce((a, b) => a + b) / prev.length;
        if (prevAvg - currAvg >= settings.dropThreshold) {
          add(AlertType.performanceDrop, AlertSeverity.important,
              'تراجع من ${prevAvg.toStringAsFixed(1)} إلى ${currAvg.toStringAsFixed(1)} خلال أسبوع');
        }
      }
    }

    // 4) أخطاء كبيرة متكررة خلال أسبوع
    if (settings.ruleMajorErrorsEnabled) {
      final from = _day(n).subtract(Duration(days: settings.majorErrorsDays));
      final count = records.where((r) =>
          !r.date.isBefore(from) && r.majorErrors > 0).length;
      if (count >= settings.majorErrorsCount) {
        add(AlertType.frequentMajorErrors, AlertSeverity.important,
            '$count تسميعات بأخطاء كبيرة خلال ${settings.majorErrorsDays} أيام');
      }
    }

    // 5) تميز متواصل (تنبيه إيجابي)
    if (settings.ruleExcellentEnabled) {
      final last = records.reversed.take(settings.excellentStreakCount).toList();
      if (last.length >= settings.excellentStreakCount &&
          last.every((r) => r.finalScore >= 90)) {
        add(AlertType.excellentStreak, AlertSeverity.normal,
            'تميز متواصل: ${last.length} تقييمات ممتازة متتالية');
      }
    }

    return out;
  }
}
