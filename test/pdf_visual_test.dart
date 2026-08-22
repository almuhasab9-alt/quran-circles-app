import 'dart:io';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_center/core/database/app_database.dart';
import 'package:quran_center/core/services/pdf_report_service.dart';
import 'package:quran_center/core/services/report_service.dart';
import 'package:quran_center/core/services/session_service.dart';
import 'package:quran_center/core/utils/date_utils.dart' as du;

/// فحص بصري: يولّد ملفات PDF حقيقية على القرص لمراجعتها بالعين.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('توليد ملفات PDF للفحص البصري في /home/user/review/', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler('flutter/assets', (message) async {
      final key = message != null
          ? String.fromCharCodes(message.buffer.asUint8List())
          : '';
      final path = key.contains('DejaVuSans-Bold')
          ? 'assets/fonts/DejaVuSans-Bold.ttf'
          : key.contains('DejaVuSans')
              ? 'assets/fonts/DejaVuSans.ttf'
              : 'assets/fonts/NotoNaskhArabic-Regular.ttf';
      final bytes = await File(path).readAsBytes();
      return bytes.buffer.asByteData();
    });
    addTearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler('flutter/assets', null);
    });

    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    final now = DateTime(2026, 8, 13, 10);

    await db.into(db.users).insert(UsersCompanion(
          id: const Value('u-t1'),
          fullName: const Value('الشيخ أحمد عبد الله'),
          username: const Value('teacher1'), role: const Value('teacher'),
          createdAt: Value(now), updatedAt: Value(now),
        ));
    await db.into(db.halaqas).insert(const HalaqasCompanion(
          id: Value('h1'), name: Value('حلقة الفرقان'),
          level: Value('متوسط'), teacherIds: Value('u-t1'),
        ));
    await db.into(db.students).insert(StudentsCompanion(
          id: const Value('s1'), studentCode: const Value('ST1001'),
          fullName: const Value('أحمد مرزوق'), halaqaId: const Value('h1'),
          level: const Value('متوسط'), joinDate: Value(now),
          createdAt: Value(now), updatedAt: Value(now),
        ));
    final weekRef = DateTime(2026, 8, 13);
    final weekStart = SessionService.weekStartOf(weekRef);
    await db.into(db.weeklyPlans).insert(WeeklyPlansCompanion(
          id: const Value('p1'), studentId: const Value('s1'),
          halaqaId: const Value('h1'),
          weekStartKey: Value(du.dateKeyOf(weekStart)),
          requiredNewPages: const Value(2), requiredRecentPages: const Value(3),
          requiredMinorPages: const Value(5),
          requiredMajorPages: const Value(10),
          requiredFridayPages: const Value(4),
          createdAt: Value(now), updatedAt: Value(now),
        ));
    for (var d = 0; d < 7; d++) {
      final date = weekStart.add(Duration(days: d));
      final isF = date.weekday == DateTime.friday;
      await db.into(db.dailyRecords).insert(DailyRecordsCompanion(
            id: Value('r$d'), studentId: const Value('s1'),
            halaqaId: const Value('h1'), teacherId: const Value('u-t1'),
            date: Value(date), dateKey: Value(du.dateKeyOf(date)),
            weekday: Value(date.weekday), isFriday: Value(isF),
            newFromSurah: isF ? const Value(0) : const Value(78),
            newFromAyah: isF ? const Value(0) : Value(1 + d * 5),
            newToSurah: isF ? const Value(0) : const Value(78),
            newToAyah: isF ? const Value(0) : Value(5 + d * 5),
            newPages: isF ? const Value(0) : const Value(0.35),
            grade: isF
                ? const Value('')
                : Value(d.isEven ? 'excellent' : 'veryGood'),
            repetition: isF ? const Value(0) : Value(3 + d),
            recentFromPage: Value(580 + d), recentToPage: Value(581 + d),
            minorFromPage: Value(400 + d), minorToPage: Value(402 + d),
            majorFromPage: Value(100 + d), majorToPage: Value(104 + d),
            notes: Value(isF
                ? 'ربط الجمعة'
                : (d == 2 ? 'يحتاج تركيزاً على التجويد' : '')),
            createdAt: Value(now), updatedAt: Value(now),
          ));
    }

    final recs = await db.select(db.dailyRecords).get();
    final report = await ReportService(db).weeklyReport('s1', weekRef);
    final student = (await db.select(db.students).get()).single;
    final halaqa = (await db.select(db.halaqas).get()).single;
    final teacher = (await db.select(db.users).get()).single;

    final dir = Directory('/home/user/review');
    if (!dir.existsSync()) dir.createSync(recursive: true);

    final pdf1 = await PdfReportService.buildWeeklySheetPdf(
      student: student, halaqa: halaqa, teacher: teacher,
      weekRef: weekRef, records: recs, report: report,
    );
    await File('${dir.path}/preview_weekly_sheet.pdf')
        .writeAsBytes(pdf1, flush: true);

    final monthly = await ReportService(db).monthlyReport('s1', 2026, 8);
    final pdf2 = await PdfReportService.buildPeriodReportPdf(
      title: 'التقرير الشهري', periodLabel: 'أغسطس 2026',
      student: student, halaqa: halaqa, report: monthly,
    );
    await File('${dir.path}/preview_monthly_report.pdf')
        .writeAsBytes(pdf2, flush: true);

    expect(pdf1.length, greaterThan(5000));
    expect(pdf2.length, greaterThan(3000));
  });
}
