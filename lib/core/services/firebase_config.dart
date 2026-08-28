import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_core/firebase_core.dart';

/// إعدادات Firebase — تُملأ تلقائياً من ملف google-services.json
///
/// ⚠️ هذه القيم تُقرأ من ملف google-services.json الذي تضعه في
///    android/app/google-services.json ثم تُمرَّر هنا يدوياً مرة واحدة.
///    حتى يتم ذلك، يبقى isConfigured=false ويعمل التطبيق محلياً فقط
///    دون أخطاء (تسجيل الدخول السحابي يُظهر رسالة توجيهية واضحة).
class FirebaseConfig {
  FirebaseConfig._();

  /// هل تم ملء إعدادات المشروع؟ (تصبح true بعد لصق القيم أدناه)
  static bool get isConfigured =>
      _apiKey.isNotEmpty && _projectId.isNotEmpty && _appId.isNotEmpty;

  // ======================================================
  // ⬇️⬇️⬇️ الصق القيم من ملف google-services.json هنا ⬇️⬇️⬇️
  //
  //   من داخل الملف:
  //     apiKey        = client[0].api_key[0].current_key
  //     appId         = client[0].client_info.mobilesdk_app_id
  //     projectId     = project_info.project_id
  //     messagingSenderId = project_info.project_number
  //     storageBucket = project_info.storage_bucket
  // ======================================================
  static const String _apiKey = '';
  static const String _appId = '';
  static const String _projectId = '';
  static const String _messagingSenderId = '';
  static const String _storageBucket = '';
  // ⬆️⬆️⬆️ انتهى الجزء المطلوب تعبئته ⬆️⬆️⬆️

  /// تهيئة Firebase عند إقلاع التطبيق. آمنة للاستدعاء حتى قبل ملء القيم:
  /// عندها تتخطى التهيئة بهدوء ويعمل التطبيق محلياً فقط.
  static Future<void> init() async {
    if (!isConfigured) return; // لم تُلصق القيم بعد — وضع محلي فقط
    try {
      if (kIsWeb) {
        await Firebase.initializeApp(options: _webOptions);
      } else if (Platform.isAndroid) {
        await Firebase.initializeApp(options: _androidOptions);
      } else {
        await Firebase.initializeApp(options: _androidOptions);
      }
    } catch (_) {
      // Firebase مهيأ مسبقاً أو فشل — لا نُوقف التطبيق
    }
  }

  static FirebaseOptions get _androidOptions => FirebaseOptions(
        apiKey: _apiKey,
        appId: _appId,
        projectId: _projectId,
        messagingSenderId: _messagingSenderId,
        storageBucket: _storageBucket.isEmpty ? null : _storageBucket,
      );

  // على الويب نستخدم نفس قيم أندرويد — كافية لـ Firestore.
  static FirebaseOptions get _webOptions => FirebaseOptions(
        apiKey: _apiKey,
        appId: _appId,
        projectId: _projectId,
        messagingSenderId: _messagingSenderId,
        storageBucket: _storageBucket.isEmpty ? null : _storageBucket,
      );
}
