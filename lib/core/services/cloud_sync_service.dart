import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'backup_service.dart';
import 'cloud_auth_service.dart';

/// نتيجة عملية مزامنة
class SyncResult {
  final bool ok;
  final String? error;
  final DateTime? at;
  const SyncResult({required this.ok, this.error, this.at});
}

/// خدمة المزامنة السحابية — نسخة واحدة فقط في السحابة:
/// - الرفع: UPSERT على صف ثابت (id=1) في D1 — **تحديث في المكان، لا نسخ جديدة أبداً**
/// - التنزيل: استبدال كامل للبيانات المحلية داخل معاملة — لا تكرار
/// - رفع تلقائي مؤجَّل (debounce) بعد كل تعديل حتى لا نغرق الشبكة
class CloudSyncService {
  final BackupService backup;
  final CloudAuthService auth;
  CloudSyncService({required this.backup, required this.auth});

  // العنوان الأساسي مُعرَّف في CloudAuthService.baseUrl، وتُستخدم قنوات
  // الاتصال المتعددة تلقائياً عبر auth.apiRequest (تبديل تلقائي عند الحجب)
  static const _kLastSyncAt = 'cloud_last_sync_at'; // ختم آخر نسخة سحابية تزامنا معها
  static const _kDirty = 'cloud_local_dirty'; // توجد تعديلات محلية لم تُرفع بعد
  Timer? _debounce;
  bool _uploading = false;
  bool _pendingAgain = false;
  DateTime? lastUploadAt;

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

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (auth.token != null) 'Authorization': 'Bearer ${auth.token}',
      };

  /// طلب عبر قنوات الاتصال المتعددة (تبديل تلقائي عند الحجب/الانقطاع)
  Future<http.Response> _api(String method, String path,
          {Object? body, Duration timeout = const Duration(seconds: 30)}) =>
      auth.apiRequest(method, path, headers: _headers, body: body, timeout: timeout);

  /// جدولة رفع تلقائي بعد التعديل (تأجيل 3 ثوانٍ لدمج التعديلات المتتابعة
  /// في رفعة واحدة — يمنع تعدد الطلبات ويوفر المساحة والباقة)
  void scheduleUpload() {
    if (auth.token == null) return;
    _debounce?.cancel();
    _debounce = Timer(const Duration(seconds: 3), () => uploadNow());
  }

  /// رفع فوري للنسخة الكاملة — تستبدل النسخة السحابية في مكانها.
  Future<SyncResult> uploadNow() async {
    if (auth.token == null) {
      return const SyncResult(ok: false, error: 'غير مسجل دخول');
    }
    if (_uploading) {
      // رفع جارٍ — علّم لإعادة الرفع بعده حتى لا نفقد آخر تعديل
      _pendingAgain = true;
      return const SyncResult(ok: true);
    }
    _uploading = true;
    try {
      final data = await backup.buildBackupData();
      final r = await _api('PUT', '/api/data', body: jsonEncode({'data': data}));
      if (r.statusCode != 200) {
        final err = (jsonDecode(r.body) as Map<String, dynamic>)['error'] as String?;
        return SyncResult(ok: false, error: err ?? 'فشل الرفع (${r.statusCode})');
      }
      lastUploadAt = DateTime.now();
      final body = jsonDecode(r.body) as Map<String, dynamic>;
      await _markSynced(body['updatedAt'] as String?);
      if (kDebugMode) debugPrint('cloud sync: uploaded in-place at $lastUploadAt');
      return SyncResult(ok: true, at: lastUploadAt);
    } catch (e) {
      return const SyncResult(ok: false, error: 'تعذر الاتصال بالسحابة — سيُعاد الرفع عند التعديل التالي');
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
    if (auth.token == null) {
      return const SyncResult(ok: false, error: 'غير مسجل دخول');
    }
    try {
      final r = await _api('GET', '/api/data');
      if (r.statusCode != 200) {
        final err = (jsonDecode(r.body) as Map<String, dynamic>)['error'] as String?;
        return SyncResult(ok: false, error: err ?? 'فشل التنزيل (${r.statusCode})');
      }
      final body = jsonDecode(r.body) as Map<String, dynamic>;
      final data = body['data'];
      if (data == null) {
        // لا توجد نسخة سحابية بعد — ليست مشكلة
        return const SyncResult(ok: true);
      }
      final res = await backup.importData((data as Map).cast<String, dynamic>());
      if (!res.ok) return SyncResult(ok: false, error: res.error);
      await _markSynced(body['updatedAt'] as String?);
      return SyncResult(ok: true, at: DateTime.now());
    } catch (e) {
      return const SyncResult(ok: false, error: 'تعذر الاتصال بالسحابة');
    }
  }

  /// مزامنة ذكية عند بدء الجلسة (تعمل على كل متصفح/جهاز):
  /// 1) القاعدة المحلية فارغة → تنزيل النسخة السحابية.
  /// 2) توجد تعديلات محلية لم تُرفع → رفعها (حتى لا تضيع).
  /// 3) السحابة أحدث من آخر نسخة تزامنّا معها → تنزيلها
  ///    (هذا يحل مشكلة فتح الرابط من متصفح آخر وعدم ظهور البيانات).
  Future<SyncResult> smartSync({required bool localIsEmpty}) async {
    if (auth.token == null) {
      return const SyncResult(ok: false, error: 'غير مسجل دخول');
    }
    if (localIsEmpty) return downloadAndReplace();
    final p = await SharedPreferences.getInstance();
    final dirty = p.getBool(_kDirty) ?? false;
    if (dirty) return uploadNow();
    // قارن ختم النسخة السحابية بآخر ختم تزامنّا معه
    try {
      final r = await _api('GET', '/api/data', timeout: const Duration(seconds: 20));
      if (r.statusCode != 200) return const SyncResult(ok: false, error: 'فشل الفحص');
      final body = jsonDecode(r.body) as Map<String, dynamic>;
      final cloudAt = body['updatedAt'] as String?;
      final data = body['data'];
      if (cloudAt == null || data == null) return const SyncResult(ok: true);
      final localAt = p.getString(_kLastSyncAt);
      if (localAt == cloudAt) return const SyncResult(ok: true); // متطابقتان
      // السحابة مختلفة (أحدث) → استبدال محلي كامل
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
