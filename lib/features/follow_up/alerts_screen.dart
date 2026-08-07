import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/enums.dart';
import '../../core/database/app_database.dart';
import '../../core/utils/date_utils.dart';
import '../../shared/providers/providers.dart';
import '../../shared/widgets/common_widgets.dart';

class AlertsScreen extends ConsumerStatefulWidget {
  const AlertsScreen({super.key});
  @override
  ConsumerState<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends ConsumerState<AlertsScreen> {
  String _status = 'pendingReview';

  Future<void> _closeAlert(Alert a) async {
    final reasonCtrl = TextEditingController();
    final ok = await showDialog<bool>(context: context, builder: (ctx) => AlertDialog(
      title: const Text('إغلاق التنبيه'),
      content: TextField(controller: reasonCtrl, maxLines: 2,
          decoration: const InputDecoration(labelText: 'سبب الإغلاق (إلزامي)', border: OutlineInputBorder())),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('إلغاء')),
        FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('إغلاق')),
      ],
    ));
    if (ok == true && reasonCtrl.text.trim().isNotEmpty) {
      await ref.read(alertRepoProvider).setStatus(a.id, 'closed',
          reviewedBy: ref.read(sessionProvider)?.userId, reviewNote: reasonCtrl.text.trim());
      ref.read(dataVersionProvider.notifier).state++;
    } else if (ok == true) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.red, content: Text('سبب الإغلاق إلزامي')));
    }
  }

  Future<void> _approveAlert(Alert a) async {
    // approve → create follow-up plan
    final goalsCtrl = TextEditingController(text: 'تحسين مستوى الطالب ومعالجة سبب التنبيه');
    final actionsCtrl = TextEditingController(text: 'متابعة أسبوعية مع المعلم والتواصل مع ولي الأمر');
    final ok = await showDialog<bool>(context: context, builder: (ctx) => AlertDialog(
      title: const Text('اعتماد خطة متابعة'),
      content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(controller: goalsCtrl, maxLines: 2, decoration: const InputDecoration(labelText: 'الأهداف', border: OutlineInputBorder())),
        const SizedBox(height: 8),
        TextField(controller: actionsCtrl, maxLines: 2, decoration: const InputDecoration(labelText: 'الإجراءات', border: OutlineInputBorder())),
      ])),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('إلغاء')),
        FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('اعتماد')),
      ],
    ));
    if (ok == true) {
      final session = ref.read(sessionProvider);
      final now = DateTime.now();
      await ref.read(alertRepoProvider).setStatus(a.id, 'approved', reviewedBy: session?.userId, reviewNote: 'تم الاعتماد مع خطة متابعة');
      await ref.read(followUpRepoProvider).insertPlan(
        studentId: a.studentId, createdBy: session?.userId ?? 'admin',
        startDate: now, endDate: now.add(const Duration(days: 30)),
        goals: goalsCtrl.text.trim(), actions: actionsCtrl.text.trim(),
      );
      ref.read(dataVersionProvider.notifier).state++;
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.green, content: Text('تم اعتماد التنبيه وإنشاء خطة متابعة')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final alertsAsync = ref.watch(allAlertsProvider);
    final students = ref.watch(studentsProvider).valueOrNull ?? [];
    final isAdmin = ref.watch(sessionProvider)?.role == 'admin';
    return Scaffold(
      appBar: AppBar(title: const Text('مركز التنبيهات')),
      body: Column(children: [
        Padding(padding: const EdgeInsets.all(12), child: SegmentedButton<String>(
          segments: const [
            ButtonSegment(value: 'draft', label: Text('مسودات')),
            ButtonSegment(value: 'pendingReview', label: Text('بانتظار المراجعة')),
            ButtonSegment(value: 'approved', label: Text('معتمدة')),
            ButtonSegment(value: 'closed', label: Text('مغلقة')),
          ],
          selected: {_status},
          onSelectionChanged: (v) => setState(() => _status = v.first),
        )),
        Expanded(child: alertsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => ErrorState(message: '$e'),
          data: (all) {
            final list = all.where((a) => a.status == _status).toList()
              ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
            if (list.isEmpty) return const EmptyState(message: 'لا توجد تنبيهات في هذه الحالة');
            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (ctx, i) {
                final a = list[i];
                final type = AlertType.values.where((t) => t.name == a.type).firstOrNull;
                final sev = AlertSeverity.values.where((s) => s.name == a.severity).firstOrNull;
                final studentName = students.where((s) => s.id == a.studentId).firstOrNull?.fullName ?? '—';
                final color = a.severity == 'urgent' ? Colors.red : a.severity == 'important' ? Colors.orange : Colors.green;
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: Padding(padding: const EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      Icon(type == AlertType.excellentStreak ? Icons.emoji_events : Icons.warning_amber, color: color),
                      const SizedBox(width: 8),
                      Expanded(child: Text(type?.ar ?? a.type, style: const TextStyle(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)),
                      Chip(visualDensity: VisualDensity.compact, backgroundColor: color.withValues(alpha: 0.15),
                          label: Text(sev?.ar ?? a.severity, style: TextStyle(fontSize: 11, color: color))),
                    ]),
                    const SizedBox(height: 4),
                    InkWell(onTap: () => context.push('/student/${a.studentId}'),
                        child: Text('الطالب: $studentName', style: const TextStyle(color: Colors.blue))),
                    const SizedBox(height: 4),
                    Text(a.message),
                    const SizedBox(height: 4),
                    Text(formatDateTime(a.createdAt), style: const TextStyle(fontSize: 11, color: Colors.grey)),
                    if (a.reviewNote != null) Text('ملاحظة المراجعة: ${a.reviewNote}', style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic)),
                    if (isAdmin && (a.status == 'pendingReview' || a.status == 'draft')) ...[
                      const Divider(),
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                        TextButton.icon(onPressed: () => _approveAlert(a), icon: const Icon(Icons.check, color: Colors.green), label: const Text('اعتماد خطة')),
                        TextButton.icon(onPressed: () => _closeAlert(a), icon: const Icon(Icons.close, color: Colors.red), label: const Text('إغلاق')),
                      ]),
                    ],
                  ])),
                );
              },
            );
          },
        )),
      ]),
    );
  }
}
