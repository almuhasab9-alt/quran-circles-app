import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'core/services/api_client.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // قراءة عنوان الخادم المخصص (إن ضُبط من الإعدادات) — يعمل على الويب والجوال
  try {
    final prefs = await SharedPreferences.getInstance();
    final api = prefs.getString('apiBaseUrl') ?? '';
    final auth = prefs.getString('apiAuthBaseUrl') ?? '';
    ApiClient.overrideBaseUrl = api.isEmpty ? null : api;
    ApiClient.overrideAuthBaseUrl = auth.isEmpty ? null : auth;
  } catch (_) {/* التخزين غير متاح — نستخدم الافتراضي */}
  final container = ProviderContainer();
  // ملاحظة: زرع البيانات التجريبية أصبح عملية مشرف صريحة (الإعدادات ← إعادة الضبط)
  // لأن /api/seed يتطلب توكن مشرف ولا يمكن تنفيذه قبل تسجيل الدخول.
  runApp(UncontrolledProviderScope(container: container, child: const QuranCenterApp()));
}
