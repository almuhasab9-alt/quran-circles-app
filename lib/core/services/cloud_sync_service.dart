import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
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

  static const _base = CloudAuthService.baseUrl;
  Timer? _debounce;
  bool _uploading = false;
  bool _pendingAgain = false;
  DateTime? lastUploadAt;

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (auth.token != null) 'Authorization': 'Bearer ${auth.token}',
      };

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
      final r = await http
          .put(Uri.parse('$_base/api/data'),
              headers: _headers, body: jsonEncode({'data': data}))
          .timeout(const Duration(seconds: 30));
      if (r.statusCode != 200) {
        final err = (jsonDecode(r.body) as Map<String, dynamic>)['error'] as String?;
        return SyncResult(ok: false, error: err ?? 'فشل الرفع (${r.statusCode})');
      }
      lastUploadAt = DateTime.now();
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
      final r = await http
          .get(Uri.parse('$_base/api/data'), headers: _headers)
          .timeout(const Duration(seconds: 30));
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
      return SyncResult(ok: true, at: DateTime.now());
    } catch (e) {
      return const SyncResult(ok: false, error: 'تعذر الاتصال بالسحابة');
    }
  }

  /// عند بدء الجلسة: إن كانت القاعدة المحلية فارغة نزّل النسخة السحابية،
  /// وإلا نرفع النسخة المحلية لتكون السحابة مطابقة لآخر حالة.
  Future<void> initialSync({required bool localIsEmpty}) async {
    if (localIsEmpty) {
      await downloadAndReplace();
    } else {
      await uploadNow();
    }
  }

  void dispose() => _debounce?.cancel();
}
