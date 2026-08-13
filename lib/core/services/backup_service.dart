import 'dart:async';
import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:drift/drift.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_io/io.dart';

import '../database/app_database.dart';
import '../utils/date_utils.dart' as du;

/// نتيجة عملية الاستيراد
class ImportResult {
  final bool ok;
  final String error;
  final Map<String, int> counts;
  const ImportResult.ok(this.counts) : ok = true, error = '';
  const ImportResult.fail(this.error) : ok = false, counts = const {};
}

/// تكرار التذكير بالنسخ الاحتياطي
enum BackupReminder { off, daily, weekly }

extension BackupReminderAr on BackupReminder {
  String get ar => switch (this) {
        BackupReminder.off => 'إيقاف',
        BackupReminder.daily => 'يومي',
        BackupReminder.weekly => 'أسبوعي',
      };
  static BackupReminder fromName(String? n) => switch (n) {
        'daily' => BackupReminder.daily,
        'weekly' => BackupReminder.weekly,
        _ => BackupReminder.off,
      };
}

/// إعدادات النسخ الاحتياطي المحفوظة محلياً
class BackupSettings {
  final BackupReminder reminder;
  final bool autoBackup;
  final DateTime? lastBackupAt;
  const BackupSettings({
    this.reminder = BackupReminder.weekly,
    this.autoBackup = true,
    this.lastBackupAt,
  });

  BackupSettings copyWith({
    BackupReminder? reminder,
    bool? autoBackup,
    DateTime? lastBackupAt,
  }) =>
      BackupSettings(
        reminder: reminder ?? this.reminder,
        autoBackup: autoBackup ?? this.autoBackup,
        lastBackupAt: lastBackupAt ?? this.lastBackupAt,
      );

  /// هل حان موعد النسخ الاحتياطي ولم يتم بعد؟
  bool get isOverdue {
    if (reminder == BackupReminder.off) return false;
    final last = lastBackupAt;
    if (last == null) return true;
    final limit = reminder == BackupReminder.daily
        ? const Duration(hours: 24)
        : const Duration(days: 7);
    return DateTime.now().isAfter(last.add(limit));
  }
}

/// خدمة النسخ الاحتياطي والاستعادة.
///
/// التصدير: JSON (UTF-8) مضغوط بصيغة GZip داخل ملف `.qcbak`.
/// - المشرف: تصدير كامل لكل الجداول الستة.
/// - المعلم: حلقاته وطلابه وسجلاتهم وخططهم ونقلهم فقط.
///
/// الاستيراد: يستبدل البيانات الحالية (داخل معاملة واحدة) ويعيد
/// إدخال كل الصفوف مع الحفاظ على المفاتيح الأساسية كما هي.
class BackupService {
  final AppDatabase db;
  BackupService(this.db);

  static const String formatName = 'quran_center_backup';
  static const int formatVersion = 1;
  static const String ext = 'qcbak';

  // ---------------- التصدير ----------------

  /// بناء خريطة بيانات النسخة الاحتياطية.
  /// [teacherId] إن مُرّر فالتصدير مقصور على حلقات هذا المعلم.
  Future<Map<String, dynamic>> buildBackupData({String? teacherId}) async {
    Set<String>? halaqaIds;
    Set<String>? studentIds;

    if (teacherId != null) {
      final myHalaqas = await (db.select(db.halaqas)
            ..where((h) => h.teacherIds.like('%$teacherId%')))
          .get();
      halaqaIds = myHalaqas.map((h) => h.id).toSet();
      final myStudents = (await db.select(db.students).get())
          .where((s) => halaqaIds!.contains(s.halaqaId))
          .toList();
      studentIds = myStudents.map((s) => s.id).toSet();
    }

    bool ownH(String halaqaId) => halaqaIds == null || halaqaIds.contains(halaqaId);
    bool ownS(String studentId) => studentIds == null || studentIds.contains(studentId);

    final users = await db.select(db.users).get();
    final halaqas = (await db.select(db.halaqas).get())
        .where((h) => halaqaIds == null || halaqaIds.contains(h.id))
        .toList();
    final students = (await db.select(db.students).get())
        .where((s) => ownH(s.halaqaId))
        .toList();
    final records = (await db.select(db.dailyRecords).get())
        .where((r) => ownS(r.studentId))
        .toList();
    final plans = (await db.select(db.weeklyPlans).get())
        .where((p) => ownS(p.studentId))
        .toList();
    final transfers = (await db.select(db.studentTransfers).get())
        .where((t) => ownS(t.studentId))
        .toList();

    return {
      'format': formatName,
      'version': formatVersion,
      'createdAt': DateTime.now().toIso8601String(),
      'scope': teacherId == null ? 'full' : 'teacher',
      'counts': {
        'users': users.length,
        'halaqas': halaqas.length,
        'students': students.length,
        'dailyRecords': records.length,
        'weeklyPlans': plans.length,
        'studentTransfers': transfers.length,
      },
      'users': [for (final u in users) _userJson(u)],
      'halaqas': [for (final h in halaqas) _halaqaJson(h)],
      'students': [for (final s in students) _studentJson(s)],
      'dailyRecords': [for (final r in records) _recordJson(r)],
      'weeklyPlans': [for (final p in plans) _planJson(p)],
      'studentTransfers': [for (final t in transfers) _transferJson(t)],
    };
  }

  /// تصدير النسخة الاحتياطية إلى بايتات (JSON → UTF8 → GZip).
  Future<List<int>> exportBytes({String? teacherId}) async {
    final data = await buildBackupData(teacherId: teacherId);
    final jsonStr = const JsonEncoder.withIndent('  ').convert(data);
    final raw = utf8.encode(jsonStr);
    return GZipEncoder().encode(raw);
  }

  /// حفظ النسخة الاحتياطية التلقائية في ملف داخل مجلد المستندات.
  /// تُستخدم أيضاً لإرجاع البايتات على الويب لعرضها للمستخدم.
  /// تُعيد مسار الملف إن حُفظ، أو null (على الويب نكتفي بتسجيل الوقت).
  Future<String?> saveAutoBackupFile(List<int> bytes) async {
    try {
      // لا يعمل على الويب — نتجاوز بهدوء
      final dir = Directory('${Directory.current.path}/backups');
      if (!dir.existsSync()) dir.createSync(recursive: true);
      final stamp = du.dateKeyOf(DateTime.now());
      final file = File('${dir.path}/auto_backup_$stamp.$ext');
      await file.writeAsBytes(bytes, flush: true);
      return file.path;
    } catch (_) {
      return null;
    }
  }

  /// اسم ملف مقترح للتنزيل/المشاركة.
  String suggestedFileName({String? teacherId}) {
    final stamp = du.dateKeyOf(DateTime.now());
    final scope = teacherId == null ? 'full' : 'teacher';
    return 'quran_backup_${scope}_$stamp.$ext';
  }

  // ---------------- الاستيراد ----------------

  /// فك النسخة الاحتياطية من بايتات إلى خريطة بيانات (مع التحقق من الصيغة).
  Map<String, dynamic> decodeBackup(List<int> bytes) {
    List<int> raw;
    try {
      raw = GZipDecoder().decodeBytes(bytes);
    } catch (_) {
      // ربما الملف JSON غير مضغوط
      raw = bytes;
    }
    final jsonStr = utf8.decode(raw);
    final data = jsonDecode(jsonStr);
    if (data is! Map<String, dynamic>) {
      throw const FormatException('ملف النسخة الاحتياطية غير صالح: ليس كائن JSON');
    }
    if (data['format'] != formatName) {
      throw const FormatException('ملف النسخة الاحتياطية غير صالح: التنسيق غير معروف');
    }
    final v = data['version'];
    if (v is! int || v > formatVersion) {
      throw const FormatException('إصدار النسخة الاحتياطية أحدث من المدعوم');
    }
    for (final key in const [
      'users', 'halaqas', 'students', 'dailyRecords', 'weeklyPlans', 'studentTransfers'
    ]) {
      if (data[key] is! List) {
        throw FormatException('ملف النسخة الاحتياطية غير صالح: القسم «$key» مفقود');
      }
    }
    return data;
  }

  /// استيراد النسخة الاحتياطية: استبدال كامل للبيانات داخل معاملة واحدة.
  Future<ImportResult> importBackup(List<int> bytes) async {
    Map<String, dynamic> data;
    try {
      data = decodeBackup(bytes);
    } on FormatException catch (e) {
      return ImportResult.fail(e.message);
    } catch (e) {
      return ImportResult.fail('تعذر قراءة ملف النسخة الاحتياطية: $e');
    }

    final users = (data['users'] as List).cast<Map<String, dynamic>>();
    final halaqas = (data['halaqas'] as List).cast<Map<String, dynamic>>();
    final students = (data['students'] as List).cast<Map<String, dynamic>>();
    final records = (data['dailyRecords'] as List).cast<Map<String, dynamic>>();
    final plans = (data['weeklyPlans'] as List).cast<Map<String, dynamic>>();
    final transfers = (data['studentTransfers'] as List).cast<Map<String, dynamic>>();

    try {
      await db.transaction(() async {
        // حذف كل البيانات الحالية بترتيب آمن
        await db.delete(db.studentTransfers).go();
        await db.delete(db.weeklyPlans).go();
        await db.delete(db.dailyRecords).go();
        await db.delete(db.students).go();
        await db.delete(db.halaqas).go();
        await db.delete(db.users).go();

        await db.batch((b) {
          b.insertAll(db.users, [for (final u in users) _userC(u)]);
          b.insertAll(db.halaqas, [for (final h in halaqas) _halaqaC(h)]);
          b.insertAll(db.students, [for (final s in students) _studentC(s)]);
          b.insertAll(db.dailyRecords, [for (final r in records) _recordC(r)]);
          b.insertAll(db.weeklyPlans, [for (final p in plans) _planC(p)]);
          b.insertAll(db.studentTransfers, [for (final t in transfers) _transferC(t)]);
        });
      });
    } catch (e) {
      return ImportResult.fail('فشل الاستيراد أثناء الكتابة في قاعدة البيانات: $e');
    }

    return ImportResult.ok({
      'users': users.length,
      'halaqas': halaqas.length,
      'students': students.length,
      'dailyRecords': records.length,
      'weeklyPlans': plans.length,
      'studentTransfers': transfers.length,
    });
  }

  // ---------------- الإعدادات والتذكير ----------------

  static const _kReminder = 'backup_reminder';
  static const _kAuto = 'backup_auto';
  static const _kLastAt = 'backup_last_at';

  Future<BackupSettings> loadSettings() async {
    final p = await SharedPreferences.getInstance();
    final lastStr = p.getString(_kLastAt);
    return BackupSettings(
      reminder: BackupReminderAr.fromName(p.getString(_kReminder)),
      autoBackup: p.getBool(_kAuto) ?? true,
      lastBackupAt: lastStr == null ? null : DateTime.tryParse(lastStr),
    );
  }

  Future<void> saveReminder(BackupReminder r) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_kReminder, r.name);
  }

  Future<void> saveAutoBackupEnabled(bool v) async {
    final p = await SharedPreferences.getInstance();
    await p.setBool(_kAuto, v);
  }

  Future<void> markBackupDone([DateTime? at]) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_kLastAt, (at ?? DateTime.now()).toIso8601String());
  }

  // ---------------- تحويلات JSON ↔ Companions ----------------

  static String _s(Map<String, dynamic> m, String k, [String d = '']) =>
      m[k] is String ? m[k] as String : d;
  static int _i(Map<String, dynamic> m, String k, [int d = 0]) =>
      m[k] is int ? m[k] as int : (m[k] is num ? (m[k] as num).toInt() : d);
  static double _d(Map<String, dynamic> m, String k, [double d = 0]) =>
      m[k] is num ? (m[k] as num).toDouble() : d;
  static bool _b(Map<String, dynamic> m, String k, [bool d = true]) =>
      m[k] is bool ? m[k] as bool : d;
  static DateTime _t(Map<String, dynamic> m, String k) =>
      DateTime.tryParse(_s(m, k)) ?? DateTime.fromMillisecondsSinceEpoch(0);

  static Map<String, dynamic> _userJson(User u) => {
        'id': u.id, 'fullName': u.fullName, 'username': u.username,
        'role': u.role, 'active': u.active,
        'assignedHalaqaIds': u.assignedHalaqaIds,
        'createdAt': u.createdAt.toIso8601String(),
        'updatedAt': u.updatedAt.toIso8601String(),
      };
  static Map<String, dynamic> _halaqaJson(Halaqa h) => {
        'id': h.id, 'name': h.name, 'level': h.level,
        'teacherIds': h.teacherIds, 'supervisorId': h.supervisorId,
        'capacity': h.capacity, 'scheduleDescription': h.scheduleDescription,
        'active': h.active,
      };
  static Map<String, dynamic> _studentJson(Student s) => {
        'id': s.id, 'studentCode': s.studentCode, 'fullName': s.fullName,
        'halaqaId': s.halaqaId, 'level': s.level, 'active': s.active,
        'joinDate': s.joinDate.toIso8601String(),
        'internalNotes': s.internalNotes,
        'createdAt': s.createdAt.toIso8601String(),
        'updatedAt': s.updatedAt.toIso8601String(),
      };
  static Map<String, dynamic> _recordJson(DailyRecord r) => {
        'id': r.id, 'studentId': r.studentId, 'halaqaId': r.halaqaId,
        'teacherId': r.teacherId,
        'date': r.date.toIso8601String(), 'dateKey': r.dateKey,
        'weekday': r.weekday, 'isFriday': r.isFriday,
        'newFromSurah': r.newFromSurah, 'newFromAyah': r.newFromAyah,
        'newToSurah': r.newToSurah, 'newToAyah': r.newToAyah,
        'newPages': r.newPages, 'grade': r.grade, 'repetition': r.repetition,
        'recentFromPage': r.recentFromPage, 'recentToPage': r.recentToPage,
        'minorFromPage': r.minorFromPage, 'minorToPage': r.minorToPage,
        'majorFromPage': r.majorFromPage, 'majorToPage': r.majorToPage,
        'notes': r.notes,
        'createdAt': r.createdAt.toIso8601String(),
        'updatedAt': r.updatedAt.toIso8601String(),
      };
  static Map<String, dynamic> _planJson(WeeklyPlan p) => {
        'id': p.id, 'studentId': p.studentId, 'halaqaId': p.halaqaId,
        'weekStartKey': p.weekStartKey,
        'requiredNewPages': p.requiredNewPages,
        'requiredRecentPages': p.requiredRecentPages,
        'requiredMinorPages': p.requiredMinorPages,
        'requiredMajorPages': p.requiredMajorPages,
        'requiredFridayPages': p.requiredFridayPages,
        'createdAt': p.createdAt.toIso8601String(),
        'updatedAt': p.updatedAt.toIso8601String(),
      };
  static Map<String, dynamic> _transferJson(StudentTransfer t) => {
        'id': t.id, 'studentId': t.studentId,
        'fromHalaqaId': t.fromHalaqaId, 'toHalaqaId': t.toHalaqaId,
        'transferredAt': t.transferredAt.toIso8601String(),
        'byUser': t.byUser,
      };

  static UsersCompanion _userC(Map<String, dynamic> m) => UsersCompanion(
        id: Value(_s(m, 'id')), fullName: Value(_s(m, 'fullName')),
        username: Value(_s(m, 'username')), role: Value(_s(m, 'role')),
        active: Value(_b(m, 'active')),
        assignedHalaqaIds: Value(_s(m, 'assignedHalaqaIds')),
        createdAt: Value(_t(m, 'createdAt')), updatedAt: Value(_t(m, 'updatedAt')),
      );
  static HalaqasCompanion _halaqaC(Map<String, dynamic> m) => HalaqasCompanion(
        id: Value(_s(m, 'id')), name: Value(_s(m, 'name')),
        level: Value(_s(m, 'level')), teacherIds: Value(_s(m, 'teacherIds')),
        supervisorId: Value(_s(m, 'supervisorId')),
        capacity: Value(_i(m, 'capacity', 25)),
        scheduleDescription: Value(_s(m, 'scheduleDescription')),
        active: Value(_b(m, 'active')),
      );
  static StudentsCompanion _studentC(Map<String, dynamic> m) => StudentsCompanion(
        id: Value(_s(m, 'id')), studentCode: Value(_s(m, 'studentCode')),
        fullName: Value(_s(m, 'fullName')), halaqaId: Value(_s(m, 'halaqaId')),
        level: Value(_s(m, 'level')), active: Value(_b(m, 'active')),
        joinDate: Value(_t(m, 'joinDate')),
        internalNotes: Value(_s(m, 'internalNotes')),
        createdAt: Value(_t(m, 'createdAt')), updatedAt: Value(_t(m, 'updatedAt')),
      );
  static DailyRecordsCompanion _recordC(Map<String, dynamic> m) => DailyRecordsCompanion(
        id: Value(_s(m, 'id')), studentId: Value(_s(m, 'studentId')),
        halaqaId: Value(_s(m, 'halaqaId')), teacherId: Value(_s(m, 'teacherId')),
        date: Value(_t(m, 'date')), dateKey: Value(_s(m, 'dateKey')),
        weekday: Value(_i(m, 'weekday')), isFriday: Value(_b(m, 'isFriday', false)),
        newFromSurah: Value(_i(m, 'newFromSurah')),
        newFromAyah: Value(_i(m, 'newFromAyah')),
        newToSurah: Value(_i(m, 'newToSurah')),
        newToAyah: Value(_i(m, 'newToAyah')),
        newPages: Value(_d(m, 'newPages')), grade: Value(_s(m, 'grade')),
        repetition: Value(_i(m, 'repetition')),
        recentFromPage: Value(_i(m, 'recentFromPage')),
        recentToPage: Value(_i(m, 'recentToPage')),
        minorFromPage: Value(_i(m, 'minorFromPage')),
        minorToPage: Value(_i(m, 'minorToPage')),
        majorFromPage: Value(_i(m, 'majorFromPage')),
        majorToPage: Value(_i(m, 'majorToPage')),
        notes: Value(_s(m, 'notes')),
        createdAt: Value(_t(m, 'createdAt')), updatedAt: Value(_t(m, 'updatedAt')),
      );
  static WeeklyPlansCompanion _planC(Map<String, dynamic> m) => WeeklyPlansCompanion(
        id: Value(_s(m, 'id')), studentId: Value(_s(m, 'studentId')),
        halaqaId: Value(_s(m, 'halaqaId')),
        weekStartKey: Value(_s(m, 'weekStartKey')),
        requiredNewPages: Value(_d(m, 'requiredNewPages')),
        requiredRecentPages: Value(_d(m, 'requiredRecentPages')),
        requiredMinorPages: Value(_d(m, 'requiredMinorPages')),
        requiredMajorPages: Value(_d(m, 'requiredMajorPages')),
        requiredFridayPages: Value(_d(m, 'requiredFridayPages')),
        createdAt: Value(_t(m, 'createdAt')), updatedAt: Value(_t(m, 'updatedAt')),
      );
  static StudentTransfersCompanion _transferC(Map<String, dynamic> m) =>
      StudentTransfersCompanion(
        id: Value(_s(m, 'id')), studentId: Value(_s(m, 'studentId')),
        fromHalaqaId: Value(_s(m, 'fromHalaqaId')),
        toHalaqaId: Value(_s(m, 'toHalaqaId')),
        transferredAt: Value(_t(m, 'transferredAt')),
        byUser: Value(_s(m, 'byUser')),
      );
}
