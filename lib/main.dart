import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'shared/widgets/common_widgets.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // تثبيت معالجات الأخطاء العامة: لا شاشة رمادية فارغة بعد اليوم —
  // أي خطأ في بناء الواجهة يظهر كرسالة عربية واضحة مع زر إعادة المحاولة.
  installGlobalErrorHandlers();
  runApp(const ProviderScope(child: QuranCenterApp()));
}
