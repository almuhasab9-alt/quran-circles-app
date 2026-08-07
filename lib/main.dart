import 'dart:async' show unawaited;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'core/services/app_settings.dart';
import 'shared/providers/providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await AppSettings.load();
  } catch (e) {
    if (kDebugMode) debugPrint('settings load failed: $e');
  }
  final container = ProviderContainer();
  // توليد البيانات التجريبية في الخلفية — لا نعطّل بدء التطبيق إن فشل
  unawaited(container.read(seedServiceProvider).seed().then((_) {
    container.read(dataVersionProvider.notifier).state++;
  }).catchError((Object e) {
    if (kDebugMode) debugPrint('seed failed: $e');
  }));
  runApp(UncontrolledProviderScope(container: container, child: const QuranCenterApp()));
}
