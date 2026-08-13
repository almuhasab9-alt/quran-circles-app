import 'package:flutter_test/flutter_test.dart';
import 'package:quran_center/core/constants/enums.dart';
import 'package:quran_center/core/services/report_service.dart';
import 'package:quran_center/core/services/session_service.dart';

void main() {
  group('EvaluationGrade (4 خيارات فقط)', () {
    test('القيم والترتيب والترجمة العربية', () {
      expect(EvaluationGrade.values.length, 4);
      expect(EvaluationGrade.excellent.ar, 'ممتاز');
      expect(EvaluationGrade.veryGood.ar, 'جيد جداً');
      expect(EvaluationGrade.good.ar, 'جيد');
      expect(EvaluationGrade.repeat.ar, 'إعادة');
      expect(EvaluationGrade.excellent.rank, 4);
      expect(EvaluationGrade.repeat.rank, 1);
      expect(EvaluationGradeAr.fromName('excellent'), EvaluationGrade.excellent);
      expect(EvaluationGradeAr.fromName('bad'), isNull);
    });
  });

  group('الأدوار', () {
    test('دوران فقط: مشرف ومعلم', () {
      expect(UserRole.values.length, 2);
      expect(UserRole.supervisor.ar, 'مشرف');
      expect(UserRole.teacher.ar, 'معلم');
    });
  });

  group('نظام الأسابيع (تبدأ السبت)', () {
    test('weekStartOf يرجّع السبت', () {
      // 2026-01-14 أربعاء → السبت 2026-01-10
      final ws = SessionService.weekStartOf(DateTime(2026, 1, 14));
      expect(ws.weekday, DateTime.saturday);
      expect(ws, DateTime(2026, 1, 10));
      // الجمعة تتبع نفس الأسبوع الذي بدأ بالسبت الماضي
      final fr = SessionService.weekStartOf(DateTime(2026, 1, 16));
      expect(fr, DateTime(2026, 1, 10));
      // السبت نفسه هو بداية أسبوع جديد
      final sa = SessionService.weekStartOf(DateTime(2026, 1, 17));
      expect(sa, DateTime(2026, 1, 17));
    });

    test('weekDaysOf يرجّع 7 أيام من السبت للجمعة', () {
      final days = SessionService.weekDaysOf(DateTime(2026, 1, 14));
      expect(days.length, 7);
      expect(days.first.weekday, DateTime.saturday);
      expect(days.last.weekday, DateTime.friday);
    });

    test('previousWorkDay يتخطى إلى اليوم السابق مباشرة', () {
      final prev = SessionService.previousWorkDay(DateTime(2026, 1, 14));
      expect(prev, DateTime(2026, 1, 13));
      // الأحد السابق له السبت (نفس الأسبوع)
      final prevSun = SessionService.previousWorkDay(DateTime(2026, 1, 18));
      expect(prevSun, DateTime(2026, 1, 17));
    });
  });

  group('pagesOfRange (صفحات المراجعة)', () {
    test('حساب النطاق الشامل', () {
      expect(pagesOfRange(1, 1), 1);
      expect(pagesOfRange(100, 110), 11);
      expect(pagesOfRange(0, 5), 0);   // بداية غير صالحة
      expect(pagesOfRange(10, 5), 0);  // نهاية قبل البداية
    });
  });

  group('PeriodReport (نسب الإنجاز)', () {
    PeriodReport make({double req = 10, double done = 5}) => PeriodReport(
      requiredNew: req, doneNew: done,
      requiredRecent: 0, doneRecent: 0,
      requiredMinor: 0, doneMinor: 0,
      requiredMajor: 0, doneMajor: 0,
      requiredFriday: 0, doneFriday: 0,
      daysRecorded: 3, fridaysRecorded: 1,
    );

    test('النسبة تُحسب بدقة وتُحجب عند 100', () {
      expect(make(req: 10, done: 5).newPct, 50);
      expect(make(req: 10, done: 20).newPct, 100);
      expect(make(req: 0, done: 0).newPct, 0);
      expect(make(req: 0, done: 3).newPct, 100); // مطلوب صفر مع إنجاز = مكتمل
    });

    test('الإجمالي يجمع البنود الخمسة', () {
      const r = PeriodReport(
        requiredNew: 2, doneNew: 2,
        requiredRecent: 3, doneRecent: 3,
        requiredMinor: 5, doneMinor: 0,
        requiredMajor: 10, doneMajor: 5,
        requiredFriday: 4, doneFriday: 4,
        daysRecorded: 6, fridaysRecorded: 1,
      );
      expect(r.requiredTotal, 24);
      expect(r.doneTotal, 14);
    });
  });

  group('أيام الأسبوع بالعربية', () {
    test('weekdayAr و isFriday', () {
      expect(DateTime(2026, 1, 16).isFriday, isTrue);   // جمعة
      expect(DateTime(2026, 1, 17).isFriday, isFalse);  // سبت
      expect(DateTime(2026, 1, 17).weekdayAr, 'السبت');
      expect(DateTime(2026, 1, 16).weekdayAr, 'الجمعة');
    });
  });
}
