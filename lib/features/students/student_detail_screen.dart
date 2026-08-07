import 'package:drift/drift.dart' as drift;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import '../../core/constants/enums.dart';
import '../../core/database/app_database.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/date_utils.dart';
import '../../shared/providers/providers.dart';
import '../../shared/widgets/common_widgets.dart';

final studentDetailProvider = FutureProvider.family<Student?, String>((ref, id) async {
  ref.watch(dataVersionProvider);
  final all = await ref.read(studentRepoProvider).getAll();
  return all.where((s) => s.id == id).firstOrNull;
});
final studentRecordsProvider = FutureProvider.family<List<DailyRecord>, String>((ref, studentId) async {
  ref.watch(dataVersionProvider);
  final records = await ref.read(recordRepoProvider).byStudent(studentId);
  records.sort((a, b) => b.dateKey.compareTo(a.dateKey));
  return records;
});
final studentGuardiansProvider = FutureProvider.family<List<Guardian>, String>((ref, studentId) async {
  ref.watch(dataVersionProvider);
  final all = await ref.read(guardianRepoProvider).getAll();
  final s = await ref.read(studentDetailProvider(studentId).future);
  if (s == null) return [];
  final ids = s.guardianIds.split(',').where((x) => x.isNotEmpty).toSet();
  return all.where((g) => ids.contains(g.id)).toList();
});
final studentContactsProvider = FutureProvider.family<List<ContactLog>, String>((ref, studentId) async {
  ref.watch(dataVersionProvider);
  final logs = await ref.read(contactRepoProvider).byStudent(studentId);
  logs.sort((a, b) => b.contactedAt.compareTo(a.contactedAt));
  return logs;
});
final studentPlansProvider = FutureProvider.family<List<FollowUpPlan>, String>((ref, studentId) async {
  ref.watch(dataVersionProvider);
  return ref.read(followUpRepoProvider).byStudent(studentId);
});

class StudentDetailScreen extends ConsumerWidget {
  final String studentId;
  const StudentDetailScreen({super.key, required this.studentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentAsync = ref.watch(studentDetailProvider(studentId));
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: studentAsync.when(data: (s) => Text(s?.fullName ?? 'الطالب'), loading: () => const Text('الطالب'), error: (_, __) => const Text('الطالب')),
          bottom: const TabBar(tabs: [Tab(text: 'المتابعة'), Tab(text: 'التواصل مع ولي الأمر')]),
        ),
        body: studentAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => ErrorState(message: '$e'),
          data: (s) => s == null
              ? const EmptyState(message: 'الطالب غير موجود')
              : TabBarView(children: [_FollowUpTab(student: s), _ContactTab(student: s)]),
        ),
      ),
    );
  }
}

class _FollowUpTab extends ConsumerWidget {
  final Student student;
  const _FollowUpTab({required this.student});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordsAsync = ref.watch(studentRecordsProvider(student.id));
    final plansAsync = ref.watch(studentPlansProvider(student.id));
    final halaqas = ref.watch(halaqasProvider).valueOrNull ?? [];
    final halaqa = halaqas.where((h) => h.id == student.halaqaId).firstOrNull;
    return recordsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => ErrorState(message: '$e'),
      data: (records) {
        final weekAvg = _avg(records.take(3).toList());
        final monthAvg = _avg(records.take(12).toList());
        final attended = records.where((r) => r.attendance == 'present' || r.attendance == 'late').length;
        final attendPct = records.isEmpty ? 0.0 : attended / records.length * 100;
        final recitAvg = records.isEmpty ? 0.0 : records.map((r) => r.automaticScore).reduce((a, b) => a + b) / records.length;
        final planned = records.fold<double>(0, (a, r) => a + r.revisionPlannedPages);
        final completed = records.fold<double>(0, (a, r) => a + r.revisionCompletedPages);
        final lastLevel = records.isEmpty ? 'good' : records.first.level;
        // 8-week chart
        final weeklyAvgs = <double>[];
        for (var w = 0; w < 8; w++) {
          final slice = records.skip(w * 3).take(3).toList();
          weeklyAvgs.add(_avg(slice));
        }
        weeklyAvgs.removeWhere((v) => v == 0 && weeklyAvgs.indexOf(v) >= records.length ~/ 3);
        return ListView(padding: const EdgeInsets.all(12), children: [
          Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              CircleAvatar(radius: 26, backgroundColor: AppColors.primary, child: Text(student.fullName[0], style: const TextStyle(color: Colors.white, fontSize: 22))),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(student.fullName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('${student.studentCode} • ${halaqa?.name ?? "—"}', overflow: TextOverflow.ellipsis),
                Text('المستوى: ${student.level}', style: const TextStyle(fontSize: 12)),
              ])),
              Chip(backgroundColor: levelColor(lastLevel).withValues(alpha: 0.15),
                  label: Text(levelAr(lastLevel), style: TextStyle(color: levelColor(lastLevel)))),
            ]),
          ]))),
          const SizedBox(height: 8),
          GridView.count(crossAxisCount: 3, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), childAspectRatio: 1.2, children: [
            StatCard(title: 'متوسط الأسبوع', value: weekAvg.toStringAsFixed(0), icon: Icons.today, color: AppColors.primary),
            StatCard(title: 'متوسط الشهر', value: monthAvg.toStringAsFixed(0), icon: Icons.calendar_month, color: AppColors.secondary),
            StatCard(title: 'نسبة الحضور', value: '${attendPct.toStringAsFixed(0)}%', icon: Icons.how_to_reg, color: AppColors.success),
            StatCard(title: 'متوسط التسميع', value: recitAvg.toStringAsFixed(0), icon: Icons.menu_book, color: AppColors.gold),
            StatCard(title: 'إنجاز المراجعة', value: planned == 0 ? '—' : '${(completed / planned * 100).toStringAsFixed(0)}%', icon: Icons.refresh, color: AppColors.warning),
            StatCard(title: 'عدد الجلسات', value: '${records.length}', icon: Icons.event_note, color: AppColors.primary),
          ]),
          const SizedBox(height: 8),
          Card(child: Padding(padding: const EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('متوسط الأداء — آخر 8 أسابيع', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            SizedBox(height: 180, child: LineChart(LineChartData(
              minY: 0, maxY: 100,
              gridData: const FlGridData(show: true),
              titlesData: const FlTitlesData(rightTitles: AxisTitles(), topTitles: AxisTitles()),
              borderData: FlBorderData(show: false),
              lineBarsData: [LineChartBarData(
                isCurved: true, color: AppColors.primary, barWidth: 3, dotData: const FlDotData(show: true),
                spots: [for (var i = 0; i < weeklyAvgs.length; i++) FlSpot(i.toDouble(), weeklyAvgs[weeklyAvgs.length - 1 - i])],
              )],
            ))),
            const Text('يوضح الرسم تطور متوسط درجات الطالب أسبوعياً', style: TextStyle(fontSize: 11, color: Colors.grey)),
          ]))),
          const SizedBox(height: 8),
          FilledButton.icon(
            onPressed: () => context.push('/halaqa/${student.halaqaId}/recitation?student=${student.id}'),
            icon: const Icon(Icons.mic), label: const Text('تسجيل تسميع جديد'),
          ),
          const SizedBox(height: 8),
          const Text('آخر السجلات', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ...records.take(8).map((r) => Card(
            margin: const EdgeInsets.symmetric(vertical: 3),
            child: ListTile(
              dense: true,
              leading: Icon(attendanceIcon(r.attendance), color: r.attendance == 'present' ? AppColors.success : r.attendance == 'unexcusedAbsence' ? AppColors.danger : AppColors.warning),
              title: Text('${formatDateAr(r.date)} — ${attendanceAr(r.attendance)}', overflow: TextOverflow.ellipsis),
              subtitle: Text('درجة ${r.finalScore.toStringAsFixed(0)} • ${levelAr(r.level)}${r.overrideScore != null ? " • معدّلة يدوياً" : ""}', overflow: TextOverflow.ellipsis),
              trailing: r.needsFollowUp ? const Icon(Icons.flag, color: AppColors.danger) : null,
            ),
          )),
          const SizedBox(height: 8),
          const Text('خطط المتابعة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          plansAsync.when(
            loading: () => const LinearProgressIndicator(),
            error: (e, _) => Text('خطأ: $e'),
            data: (plans) => plans.isEmpty
                ? const Card(child: ListTile(title: Text('لا توجد خطط متابعة')))
                : Column(children: plans.map((p) => Card(
                    margin: const EdgeInsets.symmetric(vertical: 3),
                    child: ListTile(
                      leading: const Icon(Icons.assignment, color: AppColors.primary),
                      title: Text(p.goals, maxLines: 2, overflow: TextOverflow.ellipsis),
                      subtitle: Text('${formatDateAr(p.startDate)} → ${formatDateAr(p.endDate ?? p.startDate)} • ${_planStatusAr(p.status)}', overflow: TextOverflow.ellipsis),
                    ))).toList()),
          ),
          const SizedBox(height: 24),
        ]);
      },
    );
  }

  double _avg(List<DailyRecord> rs) => rs.isEmpty ? 0 : rs.map((r) => r.finalScore).reduce((a, b) => a + b) / rs.length;
  String _planStatusAr(String s) => switch (s) { 'active' => 'نشطة', 'completed' => 'مكتملة', 'cancelled' => 'ملغاة', _ => s };
  IconData attendanceIcon(String a) => switch (a) { 'present' => Icons.check_circle, 'late' => Icons.access_time, 'excusedAbsence' => Icons.event_busy, _ => Icons.cancel };
}

class _ContactTab extends ConsumerStatefulWidget {
  final Student student;
  const _ContactTab({required this.student});
  @override
  ConsumerState<_ContactTab> createState() => _ContactTabState();
}

class _ContactTabState extends ConsumerState<_ContactTab> {
  final _reasonCtrl = TextEditingController(text: 'متابعة مستوى الطالب في الحلقة');
  final _outcomeCtrl = TextEditingController();
  String _channel = 'call';

  String get _message => 'السلام عليكم ورحمة الله، نتواصل معكم من ${'مركز السنة للعلوم الشرعية'} بخصوص الطالب ${widget.student.fullName}. السبب: ${_reasonCtrl.text}. نرجو التواصل مع الحلقة.';

  Future<void> _open(String scheme, String phone) async {
    final clean = phone.replaceAll(RegExp(r'[^0-9+]'), '');
    final uri = scheme == 'tel'
        ? Uri.parse('tel:$clean')
        : Uri.parse('https://wa.me/${clean.replaceAll('+', '')}?text=${Uri.encodeComponent(_message)}');
    try { await launchUrl(uri, mode: LaunchMode.externalApplication); } catch (_) {}
  }

  Future<void> _logOutcome(String guardianId) async {
    if (_outcomeCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('اكتب نتيجة التواصل أولاً')));
      return;
    }
    await ref.read(contactRepoProvider).insert(ContactLogsCompanion(
      id: drift.Value(const Uuid().v4()),
      studentId: drift.Value(widget.student.id), guardianId: drift.Value(guardianId),
      channel: drift.Value(_channel), reason: drift.Value(_reasonCtrl.text.trim()),
      note: drift.Value(_outcomeCtrl.text.trim()), outcome: drift.Value(_outcomeCtrl.text.trim()),
      contactedBy: drift.Value(ref.read(sessionProvider)?.userId ?? 'demo'),
      contactedAt: drift.Value(DateTime.now()),
    ));
    _outcomeCtrl.clear();
    ref.read(dataVersionProvider.notifier).state++;
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: AppColors.success, content: Text('تم تسجيل نتيجة التواصل')));
  }

  @override
  Widget build(BuildContext context) {
    final guardiansAsync = ref.watch(studentGuardiansProvider(widget.student.id));
    final contactsAsync = ref.watch(studentContactsProvider(widget.student.id));
    return guardiansAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => ErrorState(message: '$e'),
      data: (guardians) {
        if (guardians.isEmpty) return const EmptyState(message: 'لا يوجد ولي أمر مرتبط بهذا الطالب');
        final g = guardians.first;
        return ListView(padding: const EdgeInsets.all(12), children: [
          Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              const Icon(Icons.family_restroom, color: AppColors.primary, size: 32),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(g.fullName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('صلة القرابة: ${g.relation}'),
                Text('يفضل: ${PreferredContact.values.where((p) => p.name == g.preferredContact).firstOrNull?.ar ?? g.preferredContact}'),
              ])),
            ]),
            const Divider(),
            ListTile(dense: true, leading: const Icon(Icons.phone), title: Text(g.primaryPhone), subtitle: const Text('رقم الاتصال')),
            ListTile(dense: true, leading: const Icon(Icons.chat, color: AppColors.success), title: Text(g.whatsappPhone), subtitle: const Text('واتساب')),
          ]))),
          const SizedBox(height: 8),
          TextField(controller: _reasonCtrl, maxLines: 2, onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(labelText: 'سبب التواصل المقترح', border: OutlineInputBorder())),
          const SizedBox(height: 8),
          Wrap(spacing: 8, runSpacing: 8, children: [
            FilledButton.icon(onPressed: () { _channel = 'call'; _open('tel', g.primaryPhone); }, icon: const Icon(Icons.call), label: const Text('اتصال')),
            FilledButton.icon(style: FilledButton.styleFrom(backgroundColor: AppColors.success),
                onPressed: () { _channel = 'whatsapp'; _open('wa', g.whatsappPhone); }, icon: const Icon(Icons.chat), label: const Text('واتساب')),
            OutlinedButton.icon(onPressed: () async {
              await Clipboard.setData(ClipboardData(text: g.primaryPhone));
              if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم نسخ الرقم')));
            }, icon: const Icon(Icons.copy), label: const Text('نسخ الرقم')),
            OutlinedButton.icon(onPressed: () async {
              await Clipboard.setData(ClipboardData(text: _message));
              if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم نسخ الرسالة')));
            }, icon: const Icon(Icons.message), label: const Text('نسخ الرسالة')),
          ]),
          const SizedBox(height: 8),
          TextField(controller: _outcomeCtrl, maxLines: 2,
              decoration: const InputDecoration(labelText: 'نتيجة التواصل', border: OutlineInputBorder())),
          const SizedBox(height: 8),
          FilledButton.tonalIcon(onPressed: () => _logOutcome(g.id), icon: const Icon(Icons.save), label: const Text('تسجيل نتيجة التواصل')),
          const SizedBox(height: 16),
          const Text('سجل التواصل السابق', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          contactsAsync.when(
            loading: () => const LinearProgressIndicator(),
            error: (e, _) => Text('خطأ: $e'),
            data: (logs) => logs.isEmpty
                ? const Card(child: ListTile(title: Text('لا يوجد سجل تواصل سابق')))
                : Column(children: logs.take(10).map((l) => Card(
                    margin: const EdgeInsets.symmetric(vertical: 3),
                    child: ListTile(
                      dense: true,
                      leading: Icon(l.channel == 'whatsapp' ? Icons.chat : l.channel == 'sms' ? Icons.sms : Icons.call,
                          color: l.channel == 'whatsapp' ? AppColors.success : AppColors.primary),
                      title: Text(l.reason, maxLines: 1, overflow: TextOverflow.ellipsis),
                      subtitle: Text('${formatDateTime(l.contactedAt)} • ${l.outcome ?? "—"}', maxLines: 2, overflow: TextOverflow.ellipsis),
                    ))).toList()),
          ),
          const SizedBox(height: 24),
        ]);
      },
    );
  }
}
