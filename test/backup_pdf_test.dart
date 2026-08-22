import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_center/core/database/app_database.dart';
import 'package:quran_center/core/services/backup_service.dart';
import 'package:quran_center/core/services/pdf_report_service.dart';
import 'package:quran_center/core/services/report_service.dart';
import 'package:quran_center/core/services/session_service.dart';
import 'package:quran_center/core/utils/date_utils.dart' as du;

AppDatabase _memDb() => AppDatabase.forTesting(NativeDatabase.memory());

Future<void> _insertFixture(AppDatabase db) async {
  final now = DateTime(2026, 8, 13, 10);
  await db.into(db.users).insert(UsersCompanion(
        id: const Value('u-sup'), fullName: const Value('أبو عمر صالح'),
        username: const Value('supervisor'), role: const Value('supervisor'),
        createdAt: Value(now), updatedAt: Value(now),
      ));
  await db.into(db.users).insert(UsersCompanion(
        id: const Value('u-t1'), fullName: const Value('الشيخ أحمد'),
        username: const Value('teacher1'), role: const Value('teacher'),
        assignedHalaqaIds: const Value('h1'),
        createdAt: Value(now), updatedAt: Value(now),
      ));
  await db.into(db.halaqas).insert(HalaqasCompanion(
        id: const Value('h1'), name: const Value('حلقة الفرقان'),
        level: const Value('متوسط'), teacherIds: const Value('u-t1'),
        supervisorId: const Value('u-sup'), capacity: const Value(25),
        scheduleDescription: const Value('يومياً بعد الفجر'),
      ));
  await db.into(db.students).insert(StudentsCompanion(
        id: const Value('s1'), studentCode: const Value('ST1001'),
        fullName: const Value('أحمد مرزوق'), halaqaId: const Value('h1'),
        level: const Value('متوسط'), joinDate: Value(now),
        createdAt: Value(now), updatedAt: Value(now),
      ));

  final weekStart = SessionService.weekStartOf(DateTime(2026, 8, 13));
  final weekKey = du.dateKeyOf(weekStart);
  await db.into(db.weeklyPlans).insert(WeeklyPlansCompanion(
        id: const Value('p1'), studentId: const Value('s1'),
        halaqaId: const Value('h1'), weekStartKey: Value(weekKey),
        requiredNewPages: const Value(2), requiredRecentPages: const Value(3),
        requiredMinorPages: const Value(5), requiredMajorPages: const Value(10),
        requiredFridayPages: const Value(4),
        createdAt: Value(now), updatedAt: Value(now),
      ));

  // سجل يوم عادي (سبت) + سجل جمعة
  final sat = weekStart;
  await db.into(db.dailyRecords).insert(DailyRecordsCompanion(
        id: const Value('r1'), studentId: const Value('s1'),
        halaqaId: const Value('h1'), teacherId: const Value('u-t1'),
        date: Value(sat), dateKey: Value(du.dateKeyOf(sat)),
        weekday: Value(sat.weekday), isFriday: const Value(false),
        newFromSurah: const Value(78), newFromAyah: const Value(1),
        newToSurah: const Value(78), newToAyah: const Value(10),
        newPages: const Value(0.5), grade: const Value('excellent'),
        repetition: const Value(5),
        recentFromPage: const Value(580), recentToPage: const Value(581),
        minorFromPage: const Value(400), minorToPage: const Value(401),
        majorFromPage: const Value(100), majorToPage: const Value(103),
        notes: const Value('ممتاز'),
        createdAt: Value(now), updatedAt: Value(now),
      ));
  final fri = weekStart.add(const Duration(days: 6));
  await db.into(db.dailyRecords).insert(DailyRecordsCompanion(
        id: const Value('r2'), studentId: const Value('s1'),
        halaqaId: const Value('h1'), teacherId: const Value('u-t1'),
        date: Value(fri), dateKey: Value(du.dateKeyOf(fri)),
        weekday: Value(fri.weekday), isFriday: const Value(true),
        recentFromPage: const Value(580), recentToPage: const Value(583),
        notes: const Value('ربط الجمعة'),
        createdAt: Value(now), updatedAt: Value(now),
      ));
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('BackupService - التصدير والاستيراد', () {
    late AppDatabase db;
    late BackupService svc;

    setUp(() async {
      db = _memDb();
      svc = BackupService(db);
      await _insertFixture(db);
    });
    tearDown(() async => db.close());

    test('التصدير الكامل (مشرف) يشمل كل الجداول الستة', () async {
      final data = await svc.buildBackupData();
      expect(data['format'], BackupService.formatName);
      expect(data['version'], BackupService.formatVersion);
      expect(data['scope'], 'full');
      expect((data['users'] as List).length, 2);
      expect((data['halaqas'] as List).length, 1);
      expect((data['students'] as List).length, 1);
      expect((data['dailyRecords'] as List).length, 2);
      expect((data['weeklyPlans'] as List).length, 1);
      expect((data['studentTransfers'] as List).length, 0);
    });

    test('تصدير المعلم مقصور على حلقاته فقط', () async {
      // حلقة أخرى لا يملكها المعلم u-t1
      await db.into(db.halaqas).insert(HalaqasCompanion(
            id: const Value('h2'), name: const Value('حلقة النور'),
            teacherIds: const Value('u-t2'),
          ));
      await db.into(db.students).insert(StudentsCompanion(
            id: const Value('s2'), studentCode: const Value('ST1002'),
            fullName: const Value('خالد'), halaqaId: const Value('h2'),
            joinDate: Value(DateTime(2026, 1, 1)),
            createdAt: Value(DateTime(2026, 1, 1)), updatedAt: Value(DateTime(2026, 1, 1)),
          ));
      await db.into(db.dailyRecords).insert(DailyRecordsCompanion(
            id: const Value('r9'), studentId: const Value('s2'),
            halaqaId: const Value('h2'), teacherId: const Value('u-t2'),
            date: Value(DateTime(2026, 8, 8)), dateKey: const Value('2026-08-08'),
            weekday: const Value(6), createdAt: Value(DateTime(2026, 8, 8)),
            updatedAt: Value(DateTime(2026, 8, 8)),
          ));

      final data = await svc.buildBackupData(teacherId: 'u-t1');
      expect(data['scope'], 'teacher');
      expect((data['halaqas'] as List).length, 1); // h1 فقط
      expect((data['students'] as List).length, 1); // s1 فقط
      expect((data['dailyRecords'] as List).length, 2); // سجلات s1 فقط
      expect((data['halaqas'] as List).first['id'], 'h1');
    });

    test('roundtrip كامل: تصدير → مسح → استيراد → تطابق البيانات', () async {
      final bytes = await svc.exportBytes();
      expect(bytes.isNotEmpty, true);

      // قاعدة جديدة فارغة تماماً
      final db2 = _memDb();
      addTearDown(db2.close);
      final svc2 = BackupService(db2);
      final res = await svc2.importBackup(bytes);
      expect(res.ok, true, reason: res.error);
      expect(res.counts['students'], 1);
      expect(res.counts['dailyRecords'], 2);

      final students = await db2.select(db2.students).get();
      expect(students.single.fullName, 'أحمد مرزوق');
      expect(students.single.studentCode, 'ST1001');

      final recs = await db2.select(db2.dailyRecords).get();
      expect(recs.length, 2);
      final sat = recs.firstWhere((r) => !r.isFriday);
      expect(sat.grade, 'excellent');
      expect(sat.newFromSurah, 78);
      expect(sat.newToAyah, 10);
      expect(sat.newPages, closeTo(0.5, 0.001));
      final fri = recs.firstWhere((r) => r.isFriday);
      expect(fri.recentFromPage, 580);
      expect(fri.recentToPage, 583);
      expect(fri.grade, '');

      final plans = await db2.select(db2.weeklyPlans).get();
      expect(plans.single.requiredFridayPages, 4);

      final users = await db2.select(db2.users).get();
      expect(users.length, 2);
    });

    test('الاستيراد يستبدل البيانات الحالية (لا يضاعف)', () async {
      final bytes = await svc.exportBytes();
      // استيراد في نفس القاعدة التي فيها بيانات
      final res = await svc.importBackup(bytes);
      expect(res.ok, true, reason: res.error);
      final recs = await db.select(db.dailyRecords).get();
      expect(recs.length, 2); // لم تتضاعف
      final students = await db.select(db.students).get();
      expect(students.length, 1);
    });

    test('رفض ملف غير صالح برسالة واضحة دون كسر القاعدة', () async {
      final bad = utf8.encode('{"format":"other_app","version":1}');
      final res = await svc.importBackup(bad);
      expect(res.ok, false);
      expect(res.error, contains('غير صالح'));
      // البيانات الأصلية سليمة
      final students = await db.select(db.students).get();
      expect(students.length, 1);
    });

    test('رفض JSON تالف تماماً', () async {
      final res = await svc.importBackup(utf8.encode('not json at all ###'));
      expect(res.ok, false);
    });

    test('اسم الملف المقترح يحمل النطاق والتاريخ والامتداد', () {
      final name = svc.suggestedFileName();
      expect(name, startsWith('quran_backup_full_'));
      expect(name, endsWith('.${BackupService.ext}'));
      final tName = svc.suggestedFileName(teacherId: 'u-t1');
      expect(tName, contains('teacher'));
    });
  });

  group('BackupSettings - التذكير والاستحقاق', () {
    test('يومي: مستحق بعد 24 ساعة، غير مستحق قبلها', () {
      final now = DateTime.now();
      final s = BackupSettings(
        reminder: BackupReminder.daily,
        lastBackupAt: now.subtract(const Duration(hours: 25)),
      );
      expect(s.isOverdue, true);
      final s2 = BackupSettings(
        reminder: BackupReminder.daily,
        lastBackupAt: now.subtract(const Duration(hours: 2)),
      );
      expect(s2.isOverdue, false);
    });

    test('أسبوعي: مستحق بعد 7 أيام، غير مستحق قبلها', () {
      final now = DateTime.now();
      expect(
        BackupSettings(reminder: BackupReminder.weekly,
                lastBackupAt: now.subtract(const Duration(days: 8)))
            .isOverdue,
        true,
      );
      expect(
        BackupSettings(reminder: BackupReminder.weekly,
                lastBackupAt: now.subtract(const Duration(days: 2)))
            .isOverdue,
        false,
      );
    });

    test('إيقاف: لا تنبيه أبداً حتى بدون أي نسخة', () {
      expect(const BackupSettings(reminder: BackupReminder.off).isOverdue, false);
    });

    test('بدون أي نسخة سابقة والتذكير مفعّل = مستحق', () {
      expect(
        const BackupSettings(reminder: BackupReminder.daily).isOverdue, true);
    });

    test('الوضع الافتراضي عند أول تشغيل: أسبوعي (يظهر التنبيه تلقائياً)', () async {
      TestWidgetsFlutterBinding.ensureInitialized();
      final Map<String, Object> values = {};
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('plugins.flutter.io/shared_preferences'),
        (MethodCall call) async {
          if (call.method == 'getAll') return values;
          if (call.method == 'setString') {
            values[call.arguments['key'] as String] =
                call.arguments['value'] as Object;
          }
          return true;
        },
      );
      final db = _memDb();
      addTearDown(db.close);
      final service = BackupService(db);

      // لم يختر المستخدم شيئاً بعد → أسبوعي افتراضياً ومستحق فوراً
      final s1 = await service.loadSettings();
      expect(s1.reminder, BackupReminder.weekly);
      expect(s1.isOverdue, true);
      expect(s1.autoBackup, true);

      // بعد اختيار المستخدم «إيقاف» صراحةً يبقى إيقاف (لا يرجع للافتراضي)
      await service.saveReminder(BackupReminder.off);
      final s2 = await service.loadSettings();
      expect(s2.reminder, BackupReminder.off);
      expect(s2.isOverdue, false);
    });

    test('الأسماء العربية والتحويل من الاسم', () {
      expect(BackupReminder.daily.ar, 'يومي');
      expect(BackupReminder.weekly.ar, 'أسبوعي');
      expect(BackupReminder.off.ar, 'إيقاف');
      expect(BackupReminderAr.fromName('daily'), BackupReminder.daily);
      expect(BackupReminderAr.fromName('weekly'), BackupReminder.weekly);
      expect(BackupReminderAr.fromName('xyz'), BackupReminder.off);
      expect(BackupReminderAr.fromName(null), BackupReminder.off);
    });
  });

  group('PdfReportService - توليد PDF عربي', () {
    test('الخط العربي موجود في الأصول وقابل للتحميل في PDF', () async {
      final f = File('assets/fonts/NotoNaskhArabic-Regular.ttf');
      expect(await f.exists(), true,
          reason: 'يجب نسخ خط NotoNaskhArabic إلى assets/fonts');
      final bytes = await f.readAsBytes();
      expect(bytes.length, greaterThan(100000));
      final font = PdfReportService.fontFromBytes(bytes);
      expect(font, isNotNull);
    });

    test('buildWeeklySheetRows يبني 7 صفوف صحيحة (سبت..جمعة)', () async {
      final db = _memDb();
      addTearDown(db.close);
      await _insertFixture(db);

      final weekRef = DateTime(2026, 8, 13); // خميس
      final weekDays = SessionService.weekDaysOf(weekRef);
      expect(weekDays.length, 7);
      expect(weekDays.first.weekday, DateTime.saturday);
      expect(weekDays.last.weekday, DateTime.friday);

      final recs = await db.select(db.dailyRecords).get();
      final byKey = {for (final r in recs) r.dateKey: r};
      final rows = PdfReportService.buildWeeklySheetRows(weekDays, byKey);
      expect(rows.length, 7);

      // صف السبت: يحوي نطاق الحفظ الجديد
      final satRow = rows.first;
      expect(satRow[0], contains('السبت'));
      expect(satRow[1], contains('النَّبَإ')); // الاسم مشكول في بيانات المصحف
      expect(satRow[2], 'ممتاز');
      expect(satRow[3], '5');
      expect(satRow[4], '580 - 581');

      // صف الأحد..الخميس غير المسجلة: «لم يُسجَّل»
      expect(rows[1][1], 'لم يُسجَّل');

      // صف الجمعة: مراجعة فقط بدون تقدير
      final friRow = rows.last;
      expect(friRow[0], contains('الجمعة'));
      expect(friRow[1], contains('ربط الجمعة'));
      expect(friRow[2], '-'); // لا تقدير يوم الجمعة
      expect(friRow[4], '580 - 583');
    });

    test('توليد مستند PDF كامل للكشف الأسبوعي يبدأ بتوقيع PDF', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler('flutter/assets', (message) async {
        // تغذية rootBundle بالخطوط الحقيقية من القرص
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

      final db = _memDb();
      addTearDown(db.close);
      await _insertFixture(db);

      final weekRef = DateTime(2026, 8, 13);
      final recs = await db.select(db.dailyRecords).get();
      final report = await ReportService(db).weeklyReport('s1', weekRef);
      final student = (await db.select(db.students).get()).single;
      final halaqa = (await db.select(db.halaqas).get()).single;
      final teacher = (await db.select(db.users).get())
          .firstWhere((u) => u.role == 'teacher');

      final pdfBytes = await PdfReportService.buildWeeklySheetPdf(
        student: student, halaqa: halaqa, teacher: teacher,
        weekRef: weekRef, records: recs, report: report,
      );
      expect(pdfBytes.length, greaterThan(5000));
      // توقيع ملف PDF
      expect(String.fromCharCodes(pdfBytes.take(5)), '%PDF-');
    });
  });
}
