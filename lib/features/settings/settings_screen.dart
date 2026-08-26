import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../core/services/backup_service.dart';
import '../../shared/providers/providers.dart';

/// الإعدادات: الوضع الداكن + النسخ الاحتياطي + إعادة ضبط البيانات + معلومات التطبيق.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final darkMode = ref.watch(darkModeProvider);
    final backupSettings = ref.watch(backupSettingsProvider);
    final session = ref.watch(sessionProvider);
    final teacherId = session != null && session.isTeacher ? session.userId : null;
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
        const _CloudSyncTile(),
        const Divider(),
        _BackupSection(teacherId: teacherId, settings: backupSettings),
        const Divider(),
        const ListTile(
          leading: Icon(Icons.info),
          title: Text(AppConstants.appName),
          subtitle: Text('${AppConstants.centerName}\n${AppConstants.centerBranch}\nالإصدار 1.0.2'),
          isThreeLine: true,
        ),
      ]),
    );
  }
}

/// زر الرفع اليدوي للسحابة (يرفع كل البيانات المحلية كنسخة واحدة مُحدَّثة في السحابة).
class _CloudSyncTile extends ConsumerStatefulWidget {
  const _CloudSyncTile();
  @override
  ConsumerState<_CloudSyncTile> createState() => _CloudSyncTileState();
}

class _CloudSyncTileState extends ConsumerState<_CloudSyncTile> {
  bool _busy = false;

  Future<void> _upload() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await ref.read(cloudSyncProvider).uploadNow();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('تم رفع البيانات إلى السحابة بنجاح ✓'),
        backgroundColor: Colors.green,
      ));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('تعذر الرفع للسحابة — تأكد من الاتصال بالإنترنت ($e)'),
        backgroundColor: Colors.red,
      ));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.cloud_sync, color: Color(0xFF0B5E48)),
      title: const Text('تحديث بيانات السحابة (رفع الآن)'),
      subtitle: const Text('يرفع كل بيانات الجهاز إلى السحابة فوراً — نسخة واحدة تُحدَّث في مكانها (للمشرف والمعلم)'),
      trailing: _busy
          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
          : const Icon(Icons.chevron_left),
      onTap: _upload,
    );
  }
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
      _PeriodExportTile(teacherId: widget.teacherId),
      ListTile(
        leading: const Icon(Icons.download_for_offline, color: Color(0xFF0B5E48)),
        title: const Text('استيراد نسخة احتياطية'),
        subtitle: const Text('استعادة البيانات من ملف نسخة سابقة (يستبدل البيانات الحالية) — ثم اضغط «تحديث بيانات السحابة» لحفظها سحابياً وإظهارها لكل المعلمين'),
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
            _toast('تم الاستيراد بنجاح: ${c['students']} طالب، ${c['dailyRecords']} سجل — لحفظها في السحابة اضغط «تحديث بيانات السحابة»');
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

/// تصدير نسخة محلية لفترة محددة: يوم، يومان، أسبوع ... حتى شهر كامل.
/// تشمل الهيكل كاملاً (الحلقات والطلاب) وسجلات الفترة المختارة فقط —
/// قابلة للاستيراد لاحقاً من زر «استيراد نسخة احتياطية».
class _PeriodExportTile extends ConsumerStatefulWidget {
  final String? teacherId;
  const _PeriodExportTile({required this.teacherId});
  @override
  ConsumerState<_PeriodExportTile> createState() => _PeriodExportTileState();
}

class _PeriodExportTileState extends ConsumerState<_PeriodExportTile> {
  bool _busy = false;

  static const _options = <(String, int)>[
    ('يوم واحد (اليوم)', 1),
    ('يومان', 2),
    ('3 أيام', 3),
    ('أسبوع', 7),
    ('أسبوعان', 14),
    ('3 أسابيع', 21),
    ('شهر كامل (30 يوماً)', 30),
  ];

  Future<void> _export() async {
    if (_busy) return;
    final days = await showDialog<int>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('نسخة بيانات فترة محددة'),
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 4),
            child: Text('اختر الفترة (من اليوم رجوعاً):',
                style: TextStyle(fontSize: 13, color: Colors.black54)),
          ),
          for (final o in _options)
            SimpleDialogOption(
              onPressed: () => Navigator.pop(ctx, o.$2),
              child: Row(children: [
                const Icon(Icons.calendar_month, size: 18, color: Color(0xFF0B5E48)),
                const SizedBox(width: 8),
                Text(o.$1),
              ]),
            ),
        ],
      ),
    );
    if (days == null || !mounted) return;
    setState(() => _busy = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final now = DateTime.now();
      final from = DateTime(now.year, now.month, now.day)
          .subtract(Duration(days: days - 1));
      final name = await ref.read(backupUiServiceProvider).exportAndDeliver(
          teacherId: widget.teacherId, fromDate: from, toDate: now);
      if (name != null) {
        messenger.showSnackBar(SnackBar(
          content: Text('تم إنشاء نسخة الفترة: $name'),
          backgroundColor: const Color(0xFF0B5E48),
        ));
      }
    } catch (e) {
      messenger.showSnackBar(SnackBar(
          content: Text('تعذر التصدير: $e'), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.date_range, color: Color(0xFF0B5E48)),
      title: const Text('نسخة محلية لفترة محددة'),
      subtitle: const Text('صدّر بيانات يوم أو يومين ... حتى شهر كامل — قابلة للاستيراد لاحقاً'),
      trailing: _busy
          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
          : const Icon(Icons.chevron_left),
      onTap: _export,
    );
  }
}
