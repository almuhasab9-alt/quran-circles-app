import 'dart:async' show unawaited;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'shared/providers/providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final container = ProviderContainer();
  // زرع البيانات التجريبية في D1 السحابية — لا نعطّل بدء التطبيق إن فشل
  unawaited(container.read(seedServiceProvider).seed().then((_) {
    container.read(dataVersionProvider.notifier).state++;
  }).catchError((Object e) {
    if (kDebugMode) debugPrint('remote seed failed: $e');
  }));
  runApp(UncontrolledProviderScope(container: container, child: const QuranCenterApp()));
}
