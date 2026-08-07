import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../shared/providers/providers.dart';

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});
  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  String _kind = 'center';
  String _period = 'week';
  String? _targetId;
  String _report = '';
  bool _loading = false;

  Future<void> _generate() async {
    setState(() { _loading = true; _report = ''; });
    try {
      final svc = ref.read(reportServiceProvider);
      String text;
      if (_kind == 'center') {
        text = await svc.centerReport();
      } else if (_kind == 'halaqa' && _targetId != null) {
        final h = ref.read(halaqasProvider).valueOrNull?.where((x) => x.id == _targetId).firstOrNull;
        text = h == null ? 'الحلقة غير موجودة' : await svc.halaqaReport(h);
      } else if (_kind == 'student' && _targetId != null) {
        final s = ref.read(studentsProvider).valueOrNull?.where((x) => x.id == _targetId).firstOrNull;
        text = s == null ? 'الطالب غير موجود' : await svc.studentReport(s);
      } else {
        text = 'اختر الهدف أولاً';
      }
      setState(() => _report = '(${_period == 'week' ? 'أسبوعي' : 'شهري'})\n\n$text');
    } catch (e) {
      setState(() => _report = 'خطأ: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _exportCsv() async {
    try {
      final svc = ref.read(reportServiceProvider);
      final csv = await svc.csvExport(halaqaId: _kind == 'halaqa' ? _targetId : null);
      await Clipboard.setData(ClipboardData(text: csv));
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم نسخ تقرير CSV إلى الحافظة')));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('خطأ: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final halaqas = ref.watch(halaqasProvider).valueOrNull ?? [];
    final students = ref.watch(studentsProvider).valueOrNull ?? [];
    final lastUpdate = ref.watch(reportServiceProvider).lastGeneratedAt;
    return Scaffold(
      appBar: AppBar(title: const Text('التقارير')),
      body: ListView(padding: const EdgeInsets.all(12), children: [
        SegmentedButton<String>(
          segments: const [
            ButtonSegment(value: 'center', label: Text('المركز')),
            ButtonSegment(value: 'halaqa', label: Text('حلقة')),
            ButtonSegment(value: 'student', label: Text('طالب')),
          ],
          selected: {_kind},
          onSelectionChanged: (v) => setState(() { _kind = v.first; _targetId = null; }),
        ),
        const SizedBox(height: 12),
        SegmentedButton<String>(
          segments: const [
            ButtonSegment(value: 'week', label: Text('أسبوعي')),
            ButtonSegment(value: 'month', label: Text('شهري')),
          ],
          selected: {_period},
          onSelectionChanged: (v) => setState(() => _period = v.first),
        ),
        const SizedBox(height: 12),
        if (_kind == 'halaqa')
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: 'اختر الحلقة', border: OutlineInputBorder()),
            initialValue: _targetId, isExpanded: true,
            items: halaqas.map((h) => DropdownMenuItem(value: h.id, child: Text(h.name, overflow: TextOverflow.ellipsis))).toList(),
            onChanged: (v) => setState(() => _targetId = v),
          ),
        if (_kind == 'student')
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: 'اختر الطالب', border: OutlineInputBorder()),
            initialValue: _targetId, isExpanded: true,
            items: students.where((s) => s.active).map((s) => DropdownMenuItem(value: s.id, child: Text('${s.fullName} (${s.studentCode})', overflow: TextOverflow.ellipsis))).toList(),
            onChanged: (v) => setState(() => _targetId = v),
          ),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: FilledButton.icon(
            onPressed: _loading ? null : _generate,
            icon: const Icon(Icons.assessment), label: const Text('إنشاء التقرير'),
            style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
          )),
          const SizedBox(width: 8),
          Expanded(child: OutlinedButton.icon(
            onPressed: _exportCsv, icon: const Icon(Icons.download), label: const Text('تصدير CSV'),
            style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
          )),
        ]),
        if (lastUpdate != null)
          Padding(padding: const EdgeInsets.only(top: 8),
              child: Text('آخر تحديث: ${DateFormat('yyyy-MM-dd HH:mm').format(lastUpdate!)}', style: const TextStyle(fontSize: 12, color: Colors.grey))),
        const SizedBox(height: 12),
        if (_loading) const Center(child: CircularProgressIndicator()),
        if (_report.isNotEmpty)
          Card(child: Padding(padding: const EdgeInsets.all(16),
              child: SelectableText(_report, style: const TextStyle(fontSize: 14, height: 1.8)))),
      ]),
    );
  }
}
