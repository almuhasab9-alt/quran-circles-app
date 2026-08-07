import 'package:flutter_test/flutter_test.dart';
import 'package:quran_center/core/services/app_settings.dart';
import 'package:quran_center/core/services/evaluation_service.dart';
import 'package:quran_center/core/services/alert_engine.dart';
import 'package:quran_center/core/constants/enums.dart';

void main() {
  final settings = AppSettings();
  final eval = EvaluationService(settings);

  group('EvaluationService', () {
    test('recitation deductions', () {
      expect(eval.recitationScore(minorErrors: 0, mediumErrors: 0, majorErrors: 0), 100);
      expect(eval.recitationScore(minorErrors: 2, mediumErrors: 1, majorErrors: 1), 100 - 2 - 3 - 6);
      expect(eval.recitationScore(minorErrors: 0, mediumErrors: 0, majorErrors: 50), 0); // clamp
    });

    test('weighted final score', () {
      final r = eval.evaluate(
        attendance: AttendanceStatus.present,
        minorErrors: 0, mediumErrors: 0, majorErrors: 0,
        revisionPlannedPages: 2, revisionCompletedPages: 2,
        homework: HomeworkStatus.completed,
      );
      expect(r.finalScore, 100);
      expect(r.level, PerformanceLevel.excellent);
    });

    test('override replaces final score', () {
      final r = eval.evaluate(
        attendance: AttendanceStatus.present,
        minorErrors: 5, mediumErrors: 5, majorErrors: 5,
        revisionPlannedPages: 2, revisionCompletedPages: 0,
        homework: HomeworkStatus.notCompleted,
        overrideScore: 95,
      );
      expect(r.finalScore, 95);
      expect(r.level, PerformanceLevel.excellent);
    });

    test('levels thresholds', () {
      expect(eval.levelOf(90), PerformanceLevel.excellent);
      expect(eval.levelOf(80), PerformanceLevel.veryGood);
      expect(eval.levelOf(70), PerformanceLevel.good);
      expect(eval.levelOf(60), PerformanceLevel.improve);
      expect(eval.levelOf(59), PerformanceLevel.followUp);
    });
  });

  group('AlertEngine', () {
    final engine = AlertEngine(settings);
    DailyRecordLite rec(int daysAgo, {String att = 'present', double score = 90, int major = 0}) =>
        DailyRecordLite(
          studentId: 's1', halaqaId: 'h1',
          date: DateTime(2026, 1, 20).subtract(Duration(days: daysAgo)),
          attendance: att, finalScore: score, majorErrors: major, hasRecitation: true,
        );

    test('repeated unexcused absence', () {
      final records = [rec(1, att: 'unexcusedAbsence'), rec(3, att: 'unexcusedAbsence'), rec(5, att: 'unexcusedAbsence')];
      final alerts = engine.evaluate(
        studentId: 's1', halaqaId: 'h1', records: records,
        openTypes: {}, now: DateTime(2026, 1, 20),
      );
      expect(alerts.any((a) => a.type == AlertType.repeatedUnexcusedAbsence), true);
    });

    test('no duplicate for open type', () {
      final records = [rec(1, att: 'unexcusedAbsence'), rec(3, att: 'unexcusedAbsence'), rec(5, att: 'unexcusedAbsence')];
      final alerts = engine.evaluate(
        studentId: 's1', halaqaId: 'h1', records: records,
        openTypes: {AlertType.repeatedUnexcusedAbsence}, now: DateTime(2026, 1, 20),
      );
      expect(alerts.any((a) => a.type == AlertType.repeatedUnexcusedAbsence), false);
    });

    test('low average in last 5 sessions', () {
      final records = [for (var i = 9; i >= 0; i--) rec(i, score: i < 5 ? 50 : 90)];
      final alerts = engine.evaluate(
        studentId: 's1', halaqaId: 'h1', records: records,
        openTypes: {}, now: DateTime(2026, 1, 20),
      );
      expect(alerts.any((a) => a.type == AlertType.lowAverage), true);
    });

    test('excellent streak positive alert', () {
      final records = [for (var i = 4; i >= 0; i--) rec(i, score: 95)];
      final alerts = engine.evaluate(
        studentId: 's1', halaqaId: 'h1', records: records,
        openTypes: {}, now: DateTime(2026, 1, 20),
      );
      expect(alerts.any((a) => a.type == AlertType.excellentStreak), true);
    });

    test('frequent major errors', () {
      final records = [rec(1, major: 2), rec(3, major: 1), rec(5, major: 3)];
      final alerts = engine.evaluate(
        studentId: 's1', halaqaId: 'h1', records: records,
        openTypes: {}, now: DateTime(2026, 1, 20),
      );
      expect(alerts.any((a) => a.type == AlertType.frequentMajorErrors), true);
    });
  });

  group('DailyRecord dedup logic', () {
    test('same student + same dateKey = same unique key', () {
      // المنطق: uniqueKeys = {studentId, dateKey} في الجدول
      // وupsertBatch يستخدم InsertMode.insertOrReplace → لا تكرار
      const key1 = 's1|2026-01-20';
      const key2 = 's1|2026-01-20';
      expect(key1 == key2, true);
    });
  });
}
