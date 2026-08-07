import '../constants/enums.dart';
import 'app_settings.dart';

// نتيجة التقييم الكاملة لسجل يومي
class EvaluationResult {
  final double recitationScore; // 0-100
  final double revisionScore; // 0-100
  final double attendanceScore; // 0-100
  final double homeworkScore; // 0-100
  final double finalScore; // 0-100
  final PerformanceLevel level;

  const EvaluationResult({
    required this.recitationScore,
    required this.revisionScore,
    required this.attendanceScore,
    required this.homeworkScore,
    required this.finalScore,
    required this.level,
  });
}

class EvaluationService {
  final AppSettings settings;
  const EvaluationService(this.settings);

  static double _clamp(double v) => v < 0 ? 0 : (v > 100 ? 100 : v);

  // درجة التسميع: تبدأ من 100 مع خصومات الأخطاء
  double recitationScore({
    required int minorErrors,
    required int mediumErrors,
    required int majorErrors,
    int selfCorrections = 0,
  }) {
    final s = 100 -
        minorErrors * settings.minorDeduction -
        mediumErrors * settings.mediumDeduction -
        majorErrors * settings.majorDeduction -
        selfCorrections * settings.selfCorrectionDeduction;
    return _clamp(s);
  }

  // درجة المراجعة: نسبة الإنجاز من المخطط
  double revisionScore({
    required double plannedPages,
    required double completedPages,
  }) {
    if (plannedPages <= 0) return completedPages > 0 ? 100 : 0;
    return _clamp(completedPages / plannedPages * 100);
  }

  double attendanceScore(AttendanceStatus status) => switch (status) {
    AttendanceStatus.present => 100,
    AttendanceStatus.late => 80,
    AttendanceStatus.excusedAbsence => 50,
    AttendanceStatus.unexcusedAbsence => 0,
  };

  double homeworkScore(HomeworkStatus status) => switch (status) {
    HomeworkStatus.completed => 100,
    HomeworkStatus.partial => 50,
    HomeworkStatus.notCompleted => 0,
  };

  PerformanceLevel levelOf(double finalScore) {
    if (finalScore >= 90) return PerformanceLevel.excellent;
    if (finalScore >= 80) return PerformanceLevel.veryGood;
    if (finalScore >= 70) return PerformanceLevel.good;
    if (finalScore >= 60) return PerformanceLevel.improve;
    return PerformanceLevel.followUp;
  }

  EvaluationResult evaluate({
    required AttendanceStatus attendance,
    required int minorErrors,
    required int mediumErrors,
    required int majorErrors,
    int selfCorrections = 0,
    required double revisionPlannedPages,
    required double revisionCompletedPages,
    required HomeworkStatus homework,
    double? overrideScore,
  }) {
    final rec = recitationScore(
      minorErrors: minorErrors, mediumErrors: mediumErrors,
      majorErrors: majorErrors, selfCorrections: selfCorrections,
    );
    final rev = revisionScore(
      plannedPages: revisionPlannedPages, completedPages: revisionCompletedPages,
    );
    final att = attendanceScore(attendance);
    final hw = homeworkScore(homework);
    var finalScore = rec * settings.recitationWeight +
        rev * settings.revisionWeight +
        att * settings.attendanceWeight +
        hw * settings.homeworkWeight;
    if (overrideScore != null) finalScore = overrideScore;
    finalScore = _clamp(finalScore);
    return EvaluationResult(
      recitationScore: rec,
      revisionScore: rev,
      attendanceScore: att,
      homeworkScore: hw,
      finalScore: finalScore,
      level: levelOf(finalScore),
    );
  }
}
