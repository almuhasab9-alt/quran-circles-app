import 'dart:math';
import 'package:drift/drift.dart' show Value;
import 'package:uuid/uuid.dart';
import '../constants/app_constants.dart';
import '../constants/enums.dart';
import '../database/app_database.dart';
import '../utils/date_utils.dart' as du;
import 'alert_engine.dart';
import 'app_settings.dart';
import 'evaluation_service.dart';

// يولد بيانات تجريبية deterministic باستخدام seed ثابت
class DemoSeedService {
  final AppDatabase db;
  static const int seedValue = 2026;
  static const _uuid = Uuid();

  DemoSeedService(this.db);

  static const firstNames = [
    'محمد','أحمد','عبدالله','عبدالرحمن','خالد','سعد','فهد','عمر','يوسف',
    'إبراهيم','سلطان','ناصر','علي','حسن','طارق','زياد','ماجد','بدر',
    'فيصل','تركي','سالم','مشعل','راشد','هاني','وليد','أنس','عمار','بلال',
    'حمزة','صالح',
  ];
  static const secondNames = [
    'علي','حسين','سعيد','عوض','جابر','مبارك','قاسم','ناجي','عادل','طاهر',
    'شائع','مفلح','هديان','صائل','مرزوق','جمعان','داوود','لقمان','وهبان','هيثم',
  ];
  static const teacherFirst = [
    'عبدالعزيز','منصور','زكريا','يحيى','إسماعيل','عثمان','بلال','معاذ',
    'أنس','زيد','سفيان','طلحة',
  ];
  static const teacherSecond = [
    'أحمد','محمد','صالح','علي','حسن','يوسف','إبراهيم','عمر','خالد','سعد',
    'فهد','ناصر',
  ];
  static const halaqaNames = [
    'حلقة النور','حلقة الفرقان','حلقة الإخلاص','حلقة التقوى','حلقة الهدى',
    'حلقة الصديق','حلقة الفاروق','حلقة ذي النورين','حلقة سيف الله','حلقة الإتقان',
  ];

  String _name(Random r) =>
      '${firstNames[r.nextInt(firstNames.length)]} ${secondNames[r.nextInt(secondNames.length)]}';

  String _phone(Random r) => '77${1000000 + r.nextInt(9000000)}';

  Future<void> seed({bool force = false}) async {
    final existing = await db.select(db.users).get();
    if (existing.isNotEmpty && !force) return;
    if (force) await wipe();
    final r = Random(seedValue);
    final now = DateTime.now();
    final settings = await AppSettings.load();
    final evaluator = EvaluationService(settings);

    // مستخدمون: مدير + 3 مشرفين + 12 معلماً
    final adminId = _uuid.v4();
    final supervisors = <String>[];
    final teachers = <String>[];
    final teacherNames = <String, String>{};

    await db.into(db.users).insert(UsersCompanion(
      id: Value(adminId), fullName: const Value('أبو عمر صالح'),
      username: const Value('admin'), role: const Value('admin'),
      createdAt: Value(now), updatedAt: Value(now),
    ));
    for (int i = 0; i < 3; i++) {
      final id = _uuid.v4();
      supervisors.add(id);
      await db.into(db.users).insert(UsersCompanion(
        id: Value(id),
        fullName: Value('${teacherFirst[i]} ${teacherSecond[i]}'),
        username: Value('supervisor${i + 1}'), role: const Value('supervisor'),
        createdAt: Value(now), updatedAt: Value(now),
      ));
    }
    for (int i = 0; i < 12; i++) {
      final id = _uuid.v4();
      teachers.add(id);
      final nm = '${teacherFirst[i]} ${teacherSecond[i]}';
      teacherNames[id] = nm;
      await db.into(db.users).insert(UsersCompanion(
        id: Value(id), fullName: Value(nm),
        username: Value('teacher${i + 1}'), role: const Value('teacher'),
        createdAt: Value(now), updatedAt: Value(now),
      ));
    }

    // 10 حلقات
    final halaqaIds = <String>[];
    final halaqaTeacher = <String, String>{};
    for (int i = 0; i < 10; i++) {
      final id = _uuid.v4();
      halaqaIds.add(id);
      final tid = teachers[i % teachers.length];
      halaqaTeacher[id] = tid;
      await db.into(db.halaqas).insert(HalaqasCompanion(
        id: Value(id), name: Value(halaqaNames[i]),
        level: Value(AppConstants.levels[i % AppConstants.levels.length]),
        teacherIds: Value(tid),
        supervisorId: Value(supervisors[i % supervisors.length]),
        capacity: const Value(25),
        scheduleDescription: Value(i % 2 == 0
            ? 'السبت والاثنين والأربعاء - بعد العصر'
            : 'الأحد والثلاثاء والخميس - بعد المغرب'),
      ));
      // ربط المعلم بالحلقة
      await (db.update(db.users)..where((u) => u.id.equals(tid))).write(
        UsersCompanion(assignedHalaqaIds: Value(id)),
      );
    }

    // 200 طالب (20 لكل حلقة) + أولياء أمور
    final studentIds = <String>[];
    final studentHalaqa = <String, String>{};
    int code = 1000;
    for (final hid in halaqaIds) {
      final hlevel = AppConstants.levels[halaqaIds.indexOf(hid) % AppConstants.levels.length];
      for (int j = 0; j < 20; j++) {
        code++;
        final stId = _uuid.v4();
        final name = _name(r);
        studentIds.add(stId);
        studentHalaqa[stId] = hid;
        // ولي الأمر: أبو + الاسم الأول للطالب
        final gId = _uuid.v4();
        final phone = _phone(r);
        await db.into(db.guardians).insert(GuardiansCompanion(
          id: Value(gId),
          fullName: Value('أبو ${name.split(' ').first}'),
          primaryPhone: Value(phone),
          whatsappPhone: Value(phone),
          preferredContact: Value(r.nextBool() ? 'whatsapp' : 'call'),
        ));
        await db.into(db.students).insert(StudentsCompanion(
          id: Value(stId), studentCode: Value('ST$code'),
          fullName: Value(name), halaqaId: Value(hid), level: Value(hlevel),
          joinDate: Value(now.subtract(Duration(days: 60 + r.nextInt(500)))),
          guardianIds: Value(gId),
          createdAt: Value(now), updatedAt: Value(now),
        ));
      }
    }

    // توزيع فئات الأداء: 20% متقن، 30% جيد جداً، 30% جيد، 12% يحتاج تحسين، 8% متابعة
    double perfOf(String sid) {
      final idx = studentIds.indexOf(sid) % 100;
      if (idx < 20) return 90 + r.nextDouble() * 10; // متقن
      if (idx < 50) return 80 + r.nextDouble() * 9; // جيد جداً
      if (idx < 80) return 70 + r.nextDouble() * 9; // جيد
      if (idx < 92) return 60 + r.nextDouble() * 9; // يحتاج تحسيناً
      return 35 + r.nextDouble() * 24; // يحتاج متابعة
    }

    // 12 أسبوعاً × 3 جلسات = 36 سجلاً لكل طالب
    final today = DateTime(now.year, now.month, now.day);
    final batch = <DailyRecordsCompanion>[];
    for (int week = 0; week < 12; week++) {
      for (int session = 0; session < 3; session++) {
        final date = today.subtract(Duration(days: (11 - week) * 7 + (2 - session) * 2));
        final dateKey = du.dateKeyOf(date);
        for (final sid in studentIds) {
          final hid = studentHalaqa[sid]!;
          final target = perfOf(sid);
          // تحديد الحضور بناءً على الفئة
          final roll = r.nextDouble() * 100;
          AttendanceStatus att;
          if (target >= 80) {
            att = roll < 93 ? AttendanceStatus.present : roll < 97 ? AttendanceStatus.late : roll < 99 ? AttendanceStatus.excusedAbsence : AttendanceStatus.unexcusedAbsence;
          } else if (target >= 60) {
            att = roll < 85 ? AttendanceStatus.present : roll < 92 ? AttendanceStatus.late : roll < 97 ? AttendanceStatus.excusedAbsence : AttendanceStatus.unexcusedAbsence;
          } else {
            att = roll < 65 ? AttendanceStatus.present : roll < 78 ? AttendanceStatus.late : roll < 88 ? AttendanceStatus.excusedAbsence : AttendanceStatus.unexcusedAbsence;
          }
          final present = att == AttendanceStatus.present || att == AttendanceStatus.late;

          // أخطاء تُعطي درجة قريبة من المستهدفة
          int minor = 0, medium = 0, major = 0, selfCorr = 0;
          double planned = 0, completed = 0;
          HomeworkStatus hw = HomeworkStatus.completed;
          String fromS = '', toS = '';
          int fromA = 0, toA = 0;
          double pages = 0;

          if (present) {
            final gap = (100 - target).clamp(0, 70);
            // توزيع الفجوة على الأخطاء
            major = gap > 40 ? (r.nextBool() ? 2 : 1) : gap > 25 ? (r.nextDouble() < 0.4 ? 1 : 0) : 0;
            medium = ((gap - major * 6) / 3).clamp(0, 8).round();
            minor = (gap - major * 6 - medium * 3).clamp(0, 12).round();
            if (r.nextDouble() < 0.3) selfCorr = r.nextInt(3);
            fromS = AppConstants.surahs[r.nextInt(AppConstants.surahs.length)];
            toS = fromS;
            fromA = 1 + r.nextInt(10);
            toA = fromA + 3 + r.nextInt(10);
            pages = 0.5 + r.nextDouble() * 1.5;
            planned = 1 + r.nextInt(3).toDouble();
            completed = (planned * (0.6 + r.nextDouble() * 0.4)).clamp(0, planned);
            hw = r.nextDouble() < 0.8 ? HomeworkStatus.completed : r.nextDouble() < 0.6 ? HomeworkStatus.partial : HomeworkStatus.notCompleted;
          }

          final ev = evaluator.evaluate(
            attendance: att, minorErrors: minor, mediumErrors: medium,
            majorErrors: major, selfCorrections: selfCorr,
            revisionPlannedPages: planned, revisionCompletedPages: completed,
            homework: hw,
          );

          batch.add(DailyRecordsCompanion(
            id: Value(_uuid.v4()),
            studentId: Value(sid), halaqaId: Value(hid),
            teacherId: Value(halaqaTeacher[hid] ?? ''),
            date: Value(date), dateKey: Value(dateKey),
            attendance: Value(att.name),
            fromSurah: Value(fromS), fromAyah: Value(fromA),
            toSurah: Value(toS), toAyah: Value(toA),
            estimatedPages: Value(pages),
            revisionPlannedPages: Value(planned),
            revisionCompletedPages: Value(completed),
            revisionScore: Value(ev.revisionScore),
            minorErrors: Value(minor), mediumErrors: Value(medium),
            majorErrors: Value(major), selfCorrections: Value(selfCorr),
            automaticScore: Value(ev.recitationScore),
            homeworkStatus: Value(hw.name), homeworkScore: Value(ev.homeworkScore),
            finalScore: Value(ev.finalScore), level: Value(ev.level.name),
            needsFollowUp: Value(ev.level == PerformanceLevel.followUp),
            createdAt: Value(now), updatedAt: Value(now),
          ));
        }
      }
    }
    // إدراج جماعي ضمن معاملة
    await db.batch((b) => b.insertAll(db.dailyRecords, batch));

    // توليد تنبيهات أولية
    await _generateInitialAlerts();

    // خطط متابعة لبعض الطلاب المتعثرين
    final struggling = (await db.select(db.dailyRecords).get())
        .where((d) => d.needsFollowUp).map((d) => d.studentId).toSet().take(15);
    for (final sid in struggling) {
      await db.into(db.followUpPlans).insert(FollowUpPlansCompanion(
        id: Value(_uuid.v4()), studentId: Value(sid),
        createdBy: Value(supervisors.first),
        startDate: Value(now.subtract(const Duration(days: 7))),
        goals: const Value('رفع متوسط التقييم إلى 70 فأكثر خلال شهر'),
        actions: const Value('مراجعة يومية 10 دقائق + تواصل أسبوعي مع ولي الأمر + جلسة تقوية'),
      ));
      await db.into(db.contactLogs).insert(ContactLogsCompanion(
        id: Value(_uuid.v4()), studentId: Value(sid),
        channel: const Value('call'),
        reason: const Value('مناقشة مستوى الطالب'),
        note: const Value('تم التواصل مع ولي الأمر وأبدى تعاونه'),
        contactedBy: Value(supervisors.first),
        contactedAt: Value(now.subtract(Duration(days: 2 + r.nextInt(5)))),
        outcome: const Value('وعد بمتابعة الطالب في المنزل'),
      ));
    }
  }

  Future<void> _generateInitialAlerts() async {
    final settings = await AppSettings.load();
    final engine = AlertEngine(settings);
    final records = await db.select(db.dailyRecords).get();
    final byStudent = <String, List<DailyRecord>>{};
    for (final rec in records) {
      byStudent.putIfAbsent(rec.studentId, () => []).add(rec);
    }
    final alertsBatch = <AlertsCompanion>[];
    byStudent.forEach((sid, recs) {
      recs.sort((a, b) => a.date.compareTo(b.date));
      final lites = recs.map((e) => DailyRecordLite(
        studentId: e.studentId, halaqaId: e.halaqaId, date: e.date,
        attendance: e.attendance, finalScore: e.finalScore,
        majorErrors: e.majorErrors, hasRecitation: e.fromSurah.isNotEmpty,
      )).toList();
      final drafts = engine.evaluate(
        studentId: sid, halaqaId: recs.first.halaqaId,
        records: lites, openTypes: {},
      );
      for (final d in drafts) {
        alertsBatch.add(AlertsCompanion(
          id: Value(_uuid.v4()), studentId: Value(d.studentId),
          halaqaId: Value(d.halaqaId), type: Value(d.type.name),
          severity: Value(d.severity.name), message: Value(d.message),
          status: const Value('pendingReview'),
          createdAt: Value(d.createdAt),
        ));
      }
    });
    await db.batch((b) => b.insertAll(db.alerts, alertsBatch));
  }

  Future<void> wipe() async {
    await db.transaction(() async {
      await db.delete(db.dailyRecords).go();
      await db.delete(db.alerts).go();
      await db.delete(db.contactLogs).go();
      await db.delete(db.followUpPlans).go();
      await db.delete(db.studentTransfers).go();
      await db.delete(db.students).go();
      await db.delete(db.guardians).go();
      await db.delete(db.halaqas).go();
      await db.delete(db.users).go();
    });
  }
}
