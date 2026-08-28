import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'backup_service.dart';
import 'cloud_auth_service.dart';
import 'firebase_config.dart';

/// نتيجة عملية مزامنة
class SyncResult {
  final bool ok;
  final String? error;
  final DateTime? at;
  const SyncResult({required this.ok, this.error, this.at});
}

/// خدمة المزامنة السحابية — Firebase Firestore (بديل Cloudflare D1)
///
/// نفس الفكرة السابقة حرفياً: نسخة واحدة فقط في السحابة تُحدَّث في مكانها.
/// - الرفع: كتابة كاملة على وثيقة ثابتة في مجموعة `backups` (تحديث في المكان)
/// - التنزيل: استبدال كامل للبيانات المحلية داخل معاملة — لا تكرار
/// - رفع تلقائي مؤجَّل (debounce) بعد كل تعديل حتى لا نغرق الشبكة
///
/// الوثيقة المشتركة: backups/main_backup  — يكتبها/يقرؤها المشرف والمعلمون
/// حتى تظهر البيانات نفسها على كل الأجهزة والمتصفحات.
class CloudSyncService {
  final BackupService backup;
  final CloudAuthService auth;
  CloudSyncService({required this.backup, required this.auth});

  static const String _col = 'backups';
  static const String _docId = 'main_backup';

  static const _kLastSyncAt = 'cloud_last_sync_at'; // ختم آخر نسخة سحابية تزامنا معها
  static const _kDirty = 'cloud_local_dirty'; // توجد تعديلات محلية لم تُرفع بعد
  Timer? _debounce;
  bool _uploading = false;
  bool _pendingAgain = false;
  DateTime? lastUploadAt;

  FirebaseFirestore get _db => FirebaseFirestore.instance;

  /// تعليم وجود تعديلات محلية غير مرفوعة (حتى لا تضيع عند المزامنة الذكية)
  Future<void> markLocalChanged() async {
    final p = await SharedPreferences.getInstance();
    await p.setBool(_kDirty, true);
  }

  Future<void> _markSynced(String? cloudUpdatedAt) async {
    final p = await SharedPreferences.getInstance();
    await p.setBool(_kDirty, false);
    if (cloudUpdatedAt != null) await p.setString(_kLastSyncAt, cloudUpdatedAt);
  }

  bool get _loggedIn => auth.token != null;
  bool get _ready => FirebaseConfig.isConfigured;

  /// جدولة رفع تلقائي بعد التعديل (تأجيل 3 ثوانٍ لدمج التعديلات المتتابعة)
  void scheduleUpload() {
    if (!_loggedIn || !_ready) return;
    _debounce?.cancel();
    _debounce = Timer(const Duration(seconds: 3), () => uploadNow());
  }

  /// رفع فوري للنسخة الكاملة — تستبدل النسخة السحابية في مكانها.
  Future<SyncResult> uploadNow() async {
    if (!_loggedIn) return const SyncResult(ok: false, error: 'غير مسجل دخول');
    if (!_ready) {
      return const SyncResult(ok: false, error: 'قاعدة Firebase غير مهيأة بعد');
    }
    if (_uploading) {
      _pendingAgain = true; // رفع جارٍ — أعد الرفع بعده حتى لا نفقد آخر تعديل
      return const SyncResult(ok: true);
    }
    _uploading = true;
    try {
      final data = await backup.buildBackupData();
      final stamp = DateTime.now().toIso8601String();
      await _db.collection(_col).doc(_docId).set({
        'data': data,
        'updatedAt': stamp,
        'updatedBy': auth.currentUser?.username ?? '',
      });
      lastUploadAt = DateTime.now();
      await _markSynced(stamp);
      if (kDebugMode) debugPrint('firebase sync: uploaded in-place at $lastUploadAt');
      return SyncResult(ok: true, at: lastUploadAt);
    } catch (_) {
      return const SyncResult(
          ok: false, error: 'تعذر الاتصال بالسحابة — سيُعاد الرفع عند التعديل التالي');
    } finally {
      _uploading = false;
      if (_pendingAgain) {
        _pendingAgain = false;
        scheduleUpload();
      }
    }
  }

  /// تنزيل النسخة السحابية واستبدال البيانات المحلية بها بالكامل
  /// (تُستخدم عند الدخول من جهاز جديد/فارغ).
  Future<SyncResult> downloadAndReplace() async {
    if (!_loggedIn) return const SyncResult(ok: false, error: 'غير مسجل دخول');
    if (!_ready) return const SyncResult(ok: false, error: 'قاعدة Firebase غير مهيأة بعد');
    try {
      final snap = await _db.collection(_col).doc(_docId).get();
      if (!snap.exists) return const SyncResult(ok: true); // لا نسخة سحابية بعد
      final body = snap.data()!;
      final data = body['data'];
      if (data == null) return const SyncResult(ok: true);
      final res = await backup.importData((data as Map).cast<String, dynamic>());
      if (!res.ok) return SyncResult(ok: false, error: res.error);
      await _markSynced(body['updatedAt'] as String?);
      return SyncResult(ok: true, at: DateTime.now());
    } catch (_) {
      return const SyncResult(ok: false, error: 'تعذر الاتصال بالسحابة');
    }
  }

  /// مزامنة ذكية عند بدء الجلسة (تعمل على كل متصفح/جهاز):
  /// 1) القاعدة المحلية فارغة → تنزيل النسخة السحابية.
  /// 2) توجد تعديلات محلية لم تُرفع → رفعها (حتى لا تضيع).
  /// 3) السحابة أحدث من آخر نسخة تزامنّا معها → تنزيلها.
  Future<SyncResult> smartSync({required bool localIsEmpty}) async {
    if (!_loggedIn) return const SyncResult(ok: false, error: 'غير مسجل دخول');
    if (!_ready) return const SyncResult(ok: false, error: 'قاعدة Firebase غير مهيأة بعد');
    if (localIsEmpty) return downloadAndReplace();
    final p = await SharedPreferences.getInstance();
    final dirty = p.getBool(_kDirty) ?? false;
    if (dirty) return uploadNow();
    try {
      final snap = await _db.collection(_col).doc(_docId).get();
      if (!snap.exists) return const SyncResult(ok: true);
      final body = snap.data()!;
      final cloudAt = body['updatedAt'] as String?;
      final data = body['data'];
      if (cloudAt == null || data == null) return const SyncResult(ok: true);
      final localAt = p.getString(_kLastSyncAt);
      if (localAt == cloudAt) return const SyncResult(ok: true); // متطابقتان
      final res = await backup.importData((data as Map).cast<String, dynamic>());
      if (!res.ok) return SyncResult(ok: false, error: res.error);
      await _markSynced(cloudAt);
      return SyncResult(ok: true, at: DateTime.now());
    } catch (_) {
      return const SyncResult(ok: false, error: 'تعذر الاتصال بالسحابة');
    }
  }

  void dispose() => _debounce?.cancel();
}
