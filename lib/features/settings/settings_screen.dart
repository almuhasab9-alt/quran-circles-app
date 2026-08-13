import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../shared/providers/providers.dart';

/// الإعدادات: الوضع الداكن + إعادة ضبط البيانات التجريبية + معلومات التطبيق.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<void> _resetDemo(BuildContext context, WidgetRef ref) async {
    final ok = await showDialog<bool>(context: context, builder: (ctx) => AlertDialog(
      title: const Text('إعادة ضبط البيانات التجريبية'),
      content: const Text('سيتم حذف جميع البيانات الحالية وإعادة توليد البيانات التجريبية من جديد (seed=2026). هل أنت متأكد؟'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('إلغاء')),
        FilledButton(style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true), child: const Text('إعادة الضبط')),
      ],
    ));
    if (ok == true && context.mounted) {
      showDialog(context: context, barrierDismissible: false,
          builder: (_) => const Center(child: Card(child: Padding(padding: EdgeInsets.all(24), child: Column(mainAxisSize: MainAxisSize.min, children: [CircularProgressIndicator(), SizedBox(height: 12), Text('جاري إعادة توليد البيانات...')])))));
      await ref.read(seedServiceProvider).seed(force: true);
      bumpDataVersion(ref);
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.green, content: Text('تمت إعادة ضبط البيانات التجريبية')));
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final darkMode = ref.watch(darkModeProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('الإعدادات')),
      body: ListView(padding: const EdgeInsets.all(12), children: [
        SwitchListTile(
          title: const Text('الوضع الداكن'),
          secondary: const Icon(Icons.dark_mode),
          value: darkMode,
          onChanged: (v) => ref.read(darkModeProvider.notifier).set(v),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.refresh, color: Colors.red),
          title: const Text('إعادة ضبط البيانات التجريبية'),
          subtitle: const Text('حذف البيانات وإعادة توليدها (seed=2026)'),
          onTap: () => _resetDemo(context, ref),
        ),
        const Divider(),
        const ListTile(
          leading: Icon(Icons.info),
          title: Text(AppConstants.appName),
          subtitle: Text('${AppConstants.centerName}\n${AppConstants.centerBranch}\nالإصدار 1.0.0 (نسخة تجريبية محلية)'),
          isThreeLine: true,
        ),
      ]),
    );
  }
}
