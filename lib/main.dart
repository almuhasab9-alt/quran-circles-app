import 'dart:async' show unawaited;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'core/services/api_client.dart';
import 'shared/providers/providers.dart';

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
  // زرع البيانات التجريبية في D1 السحابية — لا نعطّل بدء التطبيق إن فشل
  unawaited(container.read(seedServiceProvider).seed().then((_) {
    container.read(dataVersionProvider.notifier).state++;
  }).catchError((Object e) {
    if (kDebugMode) debugPrint('remote seed failed: $e');
  }));
  runApp(UncontrolledProviderScope(container: container, child: const QuranCenterApp()));
}
