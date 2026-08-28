import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'core/services/firebase_config.dart';
import 'shared/widgets/common_widgets.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // تهيئة Firebase (قاعدة البيانات البديلة عن Cloudflare المحظورة في اليمن).
  // آمنة حتى قبل إضافة ملف google-services.json: تتخطى بهدوء ويعمل التطبيق محلياً.
  await FirebaseConfig.init();
  // تثبيت معالجات الأخطاء العامة: لا شاشة رمادية فارغة بعد اليوم —
  // أي خطأ في بناء الواجهة يظهر كرسالة عربية واضحة مع زر إعادة المحاولة.
  installGlobalErrorHandlers();
  runApp(const ProviderScope(child: QuranCenterApp()));
}
