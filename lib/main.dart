import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'core/services/app_settings.dart';
import 'shared/providers/providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // تحميل الإعدادات أولاً
  await AppSettings.load();
  // تهيئة قاعدة البيانات وتوليد البيانات التجريبية إن لم توجد
  final container = ProviderContainer();
  await container.read(seedServiceProvider).seed();
  runApp(UncontrolledProviderScope(container: container, child: const QuranCenterApp()));
}
