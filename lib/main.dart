import 'dart:async' show unawaited;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'core/services/api_client.dart';
import 'shared/providers/providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // قراءة عنوان الخادم المخصص (إن ضُبط من الإعدادات) — يعمل على الويب والجوال
  // + استعادة الجلسة المحفوظة (التوكن وبيانات المستخدم) إن وُجدت
  DemoSession? savedSession;
  try {
    final prefs = await SharedPreferences.getInstance();
    final api = prefs.getString('apiBaseUrl') ?? '';
    final auth = prefs.getString('apiAuthBaseUrl') ?? '';
    ApiClient.overrideBaseUrl = api.isEmpty ? null : api;
    ApiClient.overrideAuthBaseUrl = auth.isEmpty ? null : auth;

    final token = prefs.getString('authToken') ?? '';
    final userId = prefs.getString('sessionUserId') ?? '';
    if (token.isNotEmpty && userId.isNotEmpty) {
      ApiClient.authToken = token;
      savedSession = DemoSession(
        userId: userId,
        name: prefs.getString('sessionName') ?? '',
        role: prefs.getString('sessionRole') ?? 'teacher',
      );
    }
  } catch (_) {/* التخزين غير متاح — نستخدم الافتراضي */}

  final container = ProviderContainer(overrides: [
    if (savedSession != null) sessionProvider.overrideWith((_) => savedSession!),
  ]);

  // التحقق من صلاحية الجلسة المستعادة في الخلفية — دون تعطيل الإقلاع.
  // إن رُفضت (انتهاء/إلغاء تفعيل الحساب) تُمسح ويُعاد التوجيه لتسجيل الدخول.
  if (savedSession != null) {
    unawaited(() async {
      try {
        await container.read(apiClientProvider).me();
      } catch (_) {
        ApiClient.authToken = null;
        container.read(sessionProvider.notifier).state = null;
        try {
          final p = await SharedPreferences.getInstance();
          await p.remove('authToken');
          await p.remove('sessionUserId');
          await p.remove('sessionName');
          await p.remove('sessionRole');
        } catch (_) {/* تجاهل */}
      }
    }());
  }

  runApp(UncontrolledProviderScope(container: container, child: const QuranCenterApp()));
}
