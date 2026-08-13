import 'dart:math';
import 'package:drift/drift.dart' show Value;
import 'package:uuid/uuid.dart';
import '../constants/app_constants.dart';
import '../constants/enums.dart';
import '../database/app_database.dart';
import '../utils/date_utils.dart' as du;
import 'quran_meta.dart';
import 'quran_meta_data.dart';
import 'session_service.dart';

// يولد بيانات تجريبية deterministic باستخدام seed ثابت
// النظام الجديد: مشرف + معلمون، سجلات يومية (جديد بالآيات + مراجعات بالصفحات)
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
    'حلقة الصديق','حلقة الفاروق','حلقة ذي النورين',
  ];

  String _name(Random r) =>
      '${firstNames[r.nextInt(firstNames.length)]} ${secondNames[r.nextInt(secondNames.length)]}';

  Future<void> seed({bool force = false}) async {
    final existing = await db.select(db.users).get();
    if (existing.isNotEmpty && !force) return;
    if (force) await wipe();
    final r = Random(seedValue);
    final now = DateTime.now();

    // مشرف واحد رئيسي + مشرف ثانٍ
    final supervisors = <String>[];
    for (int i = 0; i < 2; i++) {
      final id = _uuid.v4();
      supervisors.add(id);
      await db.into(db.users).insert(UsersCompanion(
        id: Value(id),
        fullName: Value(i == 0 ? 'أبو عمر صالح' : '${teacherFirst[i]} ${teacherSecond[i]}'),
        username: Value(i == 0 ? 'supervisor' : 'supervisor2'),
        role: const Value('supervisor'),
        createdAt: Value(now), updatedAt: Value(now),
      ));
    }

    // 8 معلمين
    final teachers = <String>[];
    for (int i = 0; i < 8; i++) {
      final id = _uuid.v4();
      teachers.add(id);
      final nm = '${teacherFirst[i + 2]} ${teacherSecond[i]}';
      await db.into(db.users).insert(UsersCompanion(
        id: Value(id), fullName: Value(nm),
        username: Value('teacher${i + 1}'), role: const Value('teacher'),
        createdAt: Value(now), updatedAt: Value(now),
      ));
    }

    // 8 حلقات — معلم لكل حلقة
    final halaqaIds = <String>[];
    final halaqaTeacher = <String, String>{};
    for (int i = 0; i < 8; i++) {
      final id = _uuid.v4();
      halaqaIds.add(id);
      final tid = teachers[i];
      halaqaTeacher[id] = tid;
      await db.into(db.halaqas).insert(HalaqasCompanion(
        id: Value(id), name: Value(halaqaNames[i]),
        level: Value(AppConstants.levels[i % AppConstants.levels.length]),
        teacherIds: Value(tid),
        supervisorId: Value(supervisors[i % supervisors.length]),
        capacity: const Value(25),
        scheduleDescription: const Value('يومياً من السبت إلى الجمعة - بعد العصر'),
      ));
      await (db.update(db.users)..where((u) => u.id.equals(tid))).write(
        UsersCompanion(assignedHalaqaIds: Value(id)),
      );
    }

    // 12 طالباً لكل حلقة
    final studentIds = <String>[];
    final studentHalaqa = <String, String>{};
    int code = 1000;
    for (final hid in halaqaIds) {
      final hlevel = AppConstants.levels[halaqaIds.indexOf(hid) % AppConstants.levels.length];
      for (int j = 0; j < 12; j++) {
        code++;
        final stId = _uuid.v4();
        studentIds.add(stId);
        studentHalaqa[stId] = hid;
        await db.into(db.students).insert(StudentsCompanion(
          id: Value(stId), studentCode: Value('ST$code'),
          fullName: Value(_name(r)), halaqaId: Value(hid), level: Value(hlevel),
          joinDate: Value(now.subtract(Duration(days: 60 + r.nextInt(400)))),
          createdAt: Value(now), updatedAt: Value(now),
        ));
      }
    }

    // مواضع حفظ متدرجة لكل طالب (يبدأ كل طالب من موضع مختلف قليلاً)
    // ثلاثة أشهر تتطلب التقدم في السور — نبدأ من المطففين (83) للأقدم
    // حتى لا يتجاوز أي طالب نهاية المصحف (الناس 114).
    final progress = <String, (int surah, int ayah)>{};
    for (int i = 0; i < studentIds.length; i++) {
      progress[studentIds[i]] = (83 + (i % 8), 1);
    }

    // ثلاثة أشهر (12 أسبوعاً) كاملة من السجلات (السبت..الجمعة) لكل طالب
    final today = DateTime(now.year, now.month, now.day);
    final thisWeekStart = SessionService.weekStartOf(today);
    final grades = [
      EvaluationGrade.excellent, EvaluationGrade.veryGood,
      EvaluationGrade.veryGood, EvaluationGrade.good,
      EvaluationGrade.good, EvaluationGrade.excellent,
      EvaluationGrade.veryGood, EvaluationGrade.repeat,
    ];

    final batch = <DailyRecordsCompanion>[];
    final plans = <WeeklyPlansCompanion>[];

    for (int w = 0; w < 12; w++) {
      final weekStart = thisWeekStart.subtract(Duration(days: 7 * (11 - w)));
      final weekKey = du.dateKeyOf(weekStart);
      for (final sid in studentIds) {
        final hid = studentHalaqa[sid]!;
        final tid = halaqaTeacher[hid]!;

        // المطلوب الأسبوعي
        plans.add(WeeklyPlansCompanion(
          id: Value(_uuid.v4()), studentId: Value(sid), halaqaId: Value(hid),
          weekStartKey: Value(weekKey),
          requiredNewPages: const Value(2),
          requiredRecentPages: const Value(3),
          requiredMinorPages: const Value(5),
          requiredMajorPages: const Value(10),
          requiredFridayPages: const Value(4),
        ));

        // 7 أيام
        for (int d = 0; d < 7; d++) {
          final date = weekStart.add(Duration(days: d));
          if (date.isAfter(today)) continue; // لا سجلات مستقبلية
          final dateKey = du.dateKeyOf(date);
          final isFriday = date.weekday == DateTime.friday;

          if (isFriday) {
            // ربط الجمعة: مراجعة فقط
            final rf = 1 + r.nextInt(500);
            final rt = rf + 2 + r.nextInt(3);
            batch.add(DailyRecordsCompanion(
              id: Value(_uuid.v4()), studentId: Value(sid), halaqaId: Value(hid),
              teacherId: Value(tid), date: Value(date), dateKey: Value(dateKey),
              weekday: Value(date.weekday), isFriday: const Value(true),
              recentFromPage: Value(rf), recentToPage: Value(rt.clamp(rf, 604)),
              notes: const Value('ربط الجمعة'),
              createdAt: Value(now), updatedAt: Value(now),
            ));
          } else {
            // يوم عادي: جديد بالآيات + مراجعات بالصفحات
            final cur = progress[sid]!;
            final span = 4 + r.nextInt(8); // 4-11 آية جديدة
            var (fs, fa) = cur;
            var ts = fs, ta = fa + span;
            // إذا تجاوز آيات السورة، انتقل للسورة التالية
            if (ta > _ayahCount(ts)) {
              final extra = ta - _ayahCount(ts);
              ts = ts + 1 > 114 ? 114 : ts + 1;
              ta = extra.clamp(1, _ayahCount(ts));
            }
            final pages = QuranMeta.rangeInPages((fs, fa), (ts, ta));
            final nextAyah = ta + 1;
            progress[sid] = nextAyah > _ayahCount(ts)
                ? ((ts + 1 > 114 ? 114 : ts + 1), 1)
                : (ts, nextAyah);

            final recentF = 1 + r.nextInt(100);
            final minorF = 100 + r.nextInt(200);
            final majorF = 300 + r.nextInt(200);
            batch.add(DailyRecordsCompanion(
              id: Value(_uuid.v4()), studentId: Value(sid), halaqaId: Value(hid),
              teacherId: Value(tid), date: Value(date), dateKey: Value(dateKey),
              weekday: Value(date.weekday), isFriday: const Value(false),
              newFromSurah: Value(fs), newFromAyah: Value(fa),
              newToSurah: Value(ts), newToAyah: Value(ta),
              newPages: Value(pages),
              grade: Value(grades[r.nextInt(grades.length)].name),
              repetition: Value(3 + r.nextInt(8)),
              recentFromPage: Value(recentF), recentToPage: Value(recentF + r.nextInt(2)),
              minorFromPage: Value(minorF), minorToPage: Value(minorF + r.nextInt(3)),
              majorFromPage: Value(majorF), majorToPage: Value(majorF + 1 + r.nextInt(4)),
              notes: Value(r.nextDouble() < 0.15 ? 'يحتاج تركيزاً على مخارج الحروف' : ''),
              createdAt: Value(now), updatedAt: Value(now),
            ));
          }
        }
      }
    }

    await db.batch((b) {
      b.insertAll(db.weeklyPlans, plans);
      b.insertAll(db.dailyRecords, batch);
    });
  }

  int _ayahCount(int surah) {
    if (surah < 1 || surah > 114) return 1;
    return QuranMetaData.ayahCount[surah];
  }

  Future<void> wipe() async {
    await db.transaction(() async {
      await db.delete(db.dailyRecords).go();
      await db.delete(db.weeklyPlans).go();
      await db.delete(db.studentTransfers).go();
      await db.delete(db.students).go();
      await db.delete(db.halaqas).go();
      await db.delete(db.users).go();
    });
  }
}
