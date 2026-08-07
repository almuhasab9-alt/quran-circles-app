import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../core/services/app_settings.dart';
import '../../shared/providers/providers.dart';
import '../../shared/widgets/common_widgets.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});
  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  Widget _numField(String label, double value, void Function(double) onChanged) {
    final ctrl = TextEditingController(text: value.toString());
    return Padding(padding: const EdgeInsets.only(bottom: 8), child: TextField(
      controller: ctrl, keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder(), isDense: true),
      onChanged: (v) { final n = double.tryParse(v); if (n != null) onChanged(n); },
    ));
  }

  Widget _intField(String label, int value, void Function(int) onChanged) {
    final ctrl = TextEditingController(text: '$value');
    return Padding(padding: const EdgeInsets.only(bottom: 8), child: TextField(
      controller: ctrl, keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder(), isDense: true),
      onChanged: (v) { final n = int.tryParse(v); if (n != null) onChanged(n); },
    ));
  }

  Future<void> _resetDemo() async {
    final ok = await showDialog<bool>(context: context, builder: (ctx) => AlertDialog(
      title: const Text('إعادة ضبط البيانات التجريبية'),
      content: const Text('سيتم حذف جميع البيانات الحالية وإعادة توليد البيانات التجريبية من جديد (seed=2026). هل أنت متأكد؟'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('إلغاء')),
        FilledButton(style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true), child: const Text('إعادة الضبط')),
      ],
    ));
    if (ok == true) {
      showDialog(context: context, barrierDismissible: false,
          builder: (_) => const Center(child: Card(child: Padding(padding: EdgeInsets.all(24), child: Column(mainAxisSize: MainAxisSize.min, children: [CircularProgressIndicator(), SizedBox(height: 12), Text('جاري إعادة توليد البيانات...')])))));
      await ref.read(seedServiceProvider).seed(force: true);
      ref.read(dataVersionProvider.notifier).state++;
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.green, content: Text('تمت إعادة ضبط البيانات التجريبية')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(settingsProvider);
    final isAdmin = ref.watch(sessionProvider)?.role == 'admin';
    return Scaffold(
      appBar: AppBar(title: const Text('الإعدادات')),
      body: settingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => ErrorState(message: '$e'),
        data: (s) => ListView(padding: const EdgeInsets.all(12), children: [
          SwitchListTile(
            title: const Text('الوضع الداكن'),
            secondary: const Icon(Icons.dark_mode),
            value: s.darkMode,
            onChanged: (v) { s.darkMode = v; s.save(); ref.invalidate(settingsProvider); setState(() {}); },
          ),
          const Divider(),
          if (isAdmin) ...[
            const ListTile(title: Text('أوزان التقييم', style: TextStyle(fontWeight: FontWeight.bold)), leading: Icon(Icons.calculate)),
            _numField('وزن التسميع (%)', s.recitationWeight * 100, (v) => s.recitationWeight = v / 100),
            _numField('وزن المراجعة (%)', s.revisionWeight * 100, (v) => s.revisionWeight = v / 100),
            _numField('وزن الحضور (%)', s.attendanceWeight * 100, (v) => s.attendanceWeight = v / 100),
            _numField('وزن الواجب (%)', s.homeworkWeight * 100, (v) => s.homeworkWeight = v / 100),
            const ListTile(title: Text('خصومات الأخطاء', style: TextStyle(fontWeight: FontWeight.bold)), leading: Icon(Icons.remove_circle)),
            _numField('خصم الخطأ الخفيف', s.minorDeduction, (v) => s.minorDeduction = v),
            _numField('خصم الخطأ المتوسط', s.mediumDeduction, (v) => s.mediumDeduction = v),
            _numField('خصم الخطأ الكبير', s.majorDeduction, (v) => s.majorDeduction = v),
            const Divider(),
            const ListTile(title: Text('قواعد التنبيه', style: TextStyle(fontWeight: FontWeight.bold)), leading: Icon(Icons.notifications)),
            SwitchListTile(title: const Text('تنبيه الغياب المتكرر'), value: s.ruleAbsenceEnabled, onChanged: (v) => setState(() => s.ruleAbsenceEnabled = v)),
            if (s.ruleAbsenceEnabled) _intField('عدد الغيابات', s.absenceCount, (v) => s.absenceCount = v),
            SwitchListTile(title: const Text('تنبيه انخفاض المتوسط'), value: s.ruleLowAvgEnabled, onChanged: (v) => setState(() => s.ruleLowAvgEnabled = v)),
            if (s.ruleLowAvgEnabled) _numField('حد المتوسط', s.lowAvgThreshold, (v) => s.lowAvgThreshold = v),
            SwitchListTile(title: const Text('تنبيه التراجع الأسبوعي'), value: s.ruleDropEnabled, onChanged: (v) => setState(() => s.ruleDropEnabled = v)),
            if (s.ruleDropEnabled) _numField('حد التراجع (نقاط)', s.dropThreshold, (v) => s.dropThreshold = v),
            SwitchListTile(title: const Text('تنبيه الأخطاء الكبيرة'), value: s.ruleMajorErrorsEnabled, onChanged: (v) => setState(() => s.ruleMajorErrorsEnabled = v)),
            SwitchListTile(title: const Text('تنبيه التميز المتواصل'), value: s.ruleExcellentEnabled, onChanged: (v) => setState(() => s.ruleExcellentEnabled = v)),
            FilledButton.icon(
              onPressed: () async {
                await s.save();
                AppSettings.invalidate();
                ref.invalidate(settingsProvider);
                if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.green, content: Text('تم حفظ الإعدادات')));
              },
              icon: const Icon(Icons.save), label: const Text('حفظ الإعدادات'),
              style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
            ),
            const Divider(),
          ],
          ListTile(
            leading: const Icon(Icons.refresh, color: Colors.red),
            title: const Text('إعادة ضبط البيانات التجريبية'),
            subtitle: const Text('حذف البيانات وإعادة توليدها (seed=2026)'),
            onTap: _resetDemo,
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.info),
            title: Text(AppConstants.appName),
            subtitle: Text('${AppConstants.centerName}\n${AppConstants.centerBranch}\nالإصدار 1.0.0 (نسخة تجريبية محلية)'),
            isThreeLine: true,
          ),
        ]),
      ),
    );
  }
}
