import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';
import '../../core/services/api_client.dart';
import '../../core/services/backup_service.dart';
import '../../shared/providers/providers.dart';

/// الإعدادات: الوضع الداكن + النسخ الاحتياطي + إعادة ضبط البيانات + معلومات التطبيق.
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
      await ref.read(seedServiceProvider).wipe();
      await ref.read(seedServiceProvider).seed();
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
    final backupSettings = ref.watch(backupSettingsProvider);
    final session = ref.watch(sessionProvider);
    final teacherId = session != null && session.isTeacher ? session.userId : null;
    final isSupervisor = session?.isSupervisor ?? false;
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
        // إدارة الحسابات — للمشرف فقط
        if (isSupervisor) ...[
          ListTile(
            leading: const Icon(Icons.manage_accounts, color: Color(0xFF0B5E48)),
            title: const Text('إدارة الحسابات'),
            subtitle: const Text('تغيير كلمات المرور وأسماء المستخدمين للمعلمين'),
            trailing: const Icon(Icons.chevron_left),
            onTap: () => context.go('/home/accounts'),
          ),
          const Divider(),
        ],
        _BackupSection(teacherId: teacherId, settings: backupSettings),
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
        const Divider(),
        const _ServerSection(),
      ]),
    );
  }

  /// قسم عنوان الخادم السحابي — يسمح بتغيير عنوان API عند الحجب دون إعادة بناء
  static const String serverPrefsKey = 'apiBaseUrl';
  static const String serverAuthPrefsKey = 'apiAuthBaseUrl';
}

/// قسم النسخ الاحتياطي: تصدير / استيراد / تذكير يومي-أسبوعي / نسخ آلي.
class _BackupSection extends ConsumerStatefulWidget {
  final String? teacherId;
  final BackupSettings settings;
  const _BackupSection({required this.teacherId, required this.settings});

  @override
  ConsumerState<_BackupSection> createState() => _BackupSectionState();
}

class _BackupSectionState extends ConsumerState<_BackupSection> {
  bool _busy = false;

  Future<void> _run(Future<void> Function() action) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await action();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _toast(String msg, {bool error = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: error ? Colors.red : Colors.green,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.settings;
    final lastText = s.lastBackupAt == null
        ? 'لم يتم إنشاء نسخة بعد'
        : 'آخر نسخة: ${s.lastBackupAt!.toIso8601String().substring(0, 16).replaceFirst('T', ' ')}';
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Text('النسخ الاحتياطي للبيانات',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF0B5E48))),
      ),
      ListTile(
        leading: const Icon(Icons.upload_file, color: Color(0xFF0B5E48)),
        title: const Text('تصدير نسخة احتياطية'),
        subtitle: Text(widget.teacherId == null
            ? 'نسخة كاملة لكل البيانات (مشرف) — $lastText'
            : 'نسخة لبيانات حلقاتك (معلم) — $lastText'),
        trailing: _busy
            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
            : null,
        onTap: () => _run(() async {
          final name = await ref
              .read(backupUiServiceProvider)
              .exportAndDeliver(teacherId: widget.teacherId);
          await ref.read(backupSettingsProvider.notifier).reload();
          if (name != null) {
            _toast('تم إنشاء النسخة الاحتياطية: $name');
          }
        }),
      ),
      ListTile(
        leading: const Icon(Icons.download_for_offline, color: Color(0xFF0B5E48)),
        title: const Text('استيراد نسخة احتياطية'),
        subtitle: const Text('استعادة البيانات من ملف نسخة سابقة (يستبدل البيانات الحالية)'),
        onTap: () => _run(() async {
          final confirm = await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('استيراد نسخة احتياطية'),
              content: const Text(
                  'سيتم استبدال جميع البيانات الحالية بمحتوى ملف النسخة الاحتياطية. هل تريد المتابعة؟'),
              actions: [
                TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('إلغاء')),
                FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('متابعة')),
              ],
            ),
          );
          if (confirm != true) return;
          final res = await ref.read(backupUiServiceProvider).importFromPickedFile();
          if (res == null) return; // أُلغي الاختيار
          if (res.ok) {
            await ref.read(backupSettingsProvider.notifier).reload();
            bumpDataVersion(ref);
            final c = res.counts;
            _toast('تم الاستيراد بنجاح: ${c['students']} طالب، ${c['dailyRecords']} سجل');
          } else {
            _toast('فشل الاستيراد: ${res.error}', error: true);
          }
        }),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('التذكير بالنسخ الاحتياطي', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          SegmentedButton<BackupReminder>(
            segments: const [
              ButtonSegment(value: BackupReminder.daily, label: Text('يومي'), icon: Icon(Icons.today)),
              ButtonSegment(value: BackupReminder.weekly, label: Text('أسبوعي'), icon: Icon(Icons.date_range)),
              ButtonSegment(value: BackupReminder.off, label: Text('إيقاف'), icon: Icon(Icons.notifications_off)),
            ],
            selected: {s.reminder},
            onSelectionChanged: (v) =>
                ref.read(backupSettingsProvider.notifier).setReminder(v.first),
          ),
        ]),
      ),
      SwitchListTile(
        title: const Text('النسخ الاحتياطي التلقائي'),
        subtitle: const Text('يقوم التطبيق بالنسخ بنفسه عند حلول وقت النسخ'),
        secondary: const Icon(Icons.autorenew),
        value: s.autoBackup,
        onChanged: (v) => ref.read(backupSettingsProvider.notifier).setAutoBackup(v),
      ),
    ]);
  }
}

/// قسم عنوان الخادم السحابي — عند الحجب يمكن وضع أي عنوان خادم بديل يعمل
class _ServerSection extends ConsumerStatefulWidget {
  const _ServerSection();

  @override
  ConsumerState<_ServerSection> createState() => _ServerSectionState();
}

class _ServerSectionState extends ConsumerState<_ServerSection> {
  final _controller = TextEditingController();
  String _status = '';

  @override
  void initState() {
    super.initState();
    _controller.text = ApiClient.overrideBaseUrl ?? '';
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _saveAndTest() async {
    final url = _controller.text.trim();
    final prefs = await SharedPreferences.getInstance();
    if (url.isEmpty) {
      await prefs.remove(SettingsScreen.serverPrefsKey);
      await prefs.remove(SettingsScreen.serverAuthPrefsKey);
      ApiClient.overrideBaseUrl = null;
      ApiClient.overrideAuthBaseUrl = null;
    } else {
      final base = url.endsWith('/') ? url.substring(0, url.length - 1) : url;
      await prefs.setString(SettingsScreen.serverPrefsKey, base);
      await prefs.setString(SettingsScreen.serverAuthPrefsKey, '$base/auth');
      ApiClient.overrideBaseUrl = base;
      ApiClient.overrideAuthBaseUrl = '$base/auth';
    }
    setState(() => _status = 'جارٍ اختبار الاتصال...');
    try {
      final testUrl = ApiClient.defaultBaseUrl + '/api/health';
      final res = await http
          .get(Uri.parse(testUrl))
          .timeout(const Duration(seconds: 8));
      if (res.statusCode == 200) {
        setState(() => _status = '✅ الاتصال ناجح — تم الحفظ');
      } else {
        setState(() => _status = '⚠ الخادم رد برمز ${res.statusCode} — تحقق من الرابط');
      }
    } catch (e) {
      setState(() => _status = '❌ تعذر الاتصال: تحقق من الرابط والإنترنت');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const ListTile(
        leading: Icon(Icons.dns, color: Color(0xFF0B5E48)),
        title: Text('عنوان الخادم السحابي'),
        subtitle: Text('يُترك فارغاً لاستخدام العنوان الافتراضي'),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: TextField(
          controller: _controller,
          keyboardType: TextInputType.url,
          decoration: const InputDecoration(
            hintText: 'https://example.com',
            border: OutlineInputBorder(),
            isDense: true,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(children: [
          FilledButton.icon(
            onPressed: _saveAndTest,
            icon: const Icon(Icons.save),
            label: const Text('حفظ واختبار الاتصال'),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(_status,
                style: const TextStyle(fontSize: 12), textAlign: TextAlign.start),
          ),
        ]),
      ),
    ]);
  }
}
