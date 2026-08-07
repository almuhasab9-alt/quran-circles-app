import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' show Value;
import 'package:uuid/uuid.dart';
import '../../core/constants/enums.dart';
import '../../core/database/app_database.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/date_utils.dart' as du;
import '../../shared/providers/providers.dart';
import '../../shared/widgets/common_widgets.dart';

// حضور المعلم السريع — حفظ جماعي ضمن معاملة مع منع التكرار
class AttendanceScreen extends ConsumerStatefulWidget {
  final String halaqaId;
  const AttendanceScreen({super.key, required this.halaqaId});
  @override
  ConsumerState<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends ConsumerState<AttendanceScreen> {
  final Map<String, AttendanceStatus> statuses = {};
  bool loaded = false;
  bool hadPrevious = false;
  bool saving = false;
  final todayKey = du.dateKeyOf(DateTime.now());

  Future<void> _load(List<Student> students) async {
    final repo = ref.read(recordRepoProvider);
    final existing = await repo.byHalaqaAndDate(widget.halaqaId, todayKey);
    hadPrevious = existing.isNotEmpty;
    for (final s in students) {
      final prev = existing.where((e) => e.studentId == s.id).firstOrNull;
      statuses[s.id] = prev != null
          ? AttendanceStatus.values.firstWhere((v) => v.name == prev.attendance, orElse: () => AttendanceStatus.present)
          : AttendanceStatus.present;
    }
    if (mounted) setState(() => loaded = true);
  }

  void _setAllPresent(List<Student> students) {
    setState(() {
      for (final s in students) { statuses[s.id] = AttendanceStatus.present; }
    });
  }

  Future<void> _save() async {
    setState(() => saving = true);
    final session = ref.read(sessionProvider);
    final now = DateTime.now();
    final batch = statuses.entries.map((e) => DailyRecordsCompanion(
      id: Value(const Uuid().v4()),
      studentId: Value(e.key), halaqaId: Value(widget.halaqaId),
      teacherId: Value(session?.userId ?? ''),
      date: Value(now), dateKey: Value(todayKey),
      attendance: Value(e.value.name),
      createdAt: Value(now), updatedAt: Value(now),
    )).toList();
    // حفظ جماعي ضمن معاملة + insertOrReplace لمنع تكرار نفس اليوم
    await ref.read(recordRepoProvider).upsertBatch(batch);
    ref.read(dataVersionProvider.notifier).state++;
    if (mounted) {
      setState(() => saving = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('تم حفظ الحضور بنجاح'), backgroundColor: AppColors.primary));
      Navigator.pop(context);
    }
  }

  Color _color(AttendanceStatus s) => switch (s) {
    AttendanceStatus.present => AppColors.success,
    AttendanceStatus.late => AppColors.warning,
    AttendanceStatus.excusedAbsence => Colors.blue,
    AttendanceStatus.unexcusedAbsence => AppColors.danger,
  };

  @override
  Widget build(BuildContext context) {
    final studentsAsync = ref.watch(studentsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('تسجيل الحضور')),
      body: studentsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => ErrorState(message: '$e'),
        data: (all) {
          final students = all.where((s) => s.halaqaId == widget.halaqaId).toList();
          if (!loaded) {
            _load(students);
            return const Center(child: CircularProgressIndicator());
          }
          if (students.isEmpty) return const EmptyState(message: 'لا يوجد طلاب');
          final counts = <AttendanceStatus, int>{for (final v in AttendanceStatus.values) v: 0};
          for (final v in statuses.values) { counts[v] = (counts[v] ?? 0) + 1; }
          return Column(children: [
            if (hadPrevious)
              Container(
                width: double.infinity, padding: const EdgeInsets.all(8),
                color: Colors.blue.shade50,
                child: const Text('يوجد سجل حضور سابق لهذا اليوم — أنت في وضع التعديل',
                    textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.blue)),
              ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              color: Colors.grey.shade100,
              child: Row(children: [
                for (final v in AttendanceStatus.values)
                  Expanded(child: Text('${v.ar}: ${counts[v]}',
                      style: TextStyle(fontSize: 11, color: _color(v), fontWeight: FontWeight.bold))),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _setAllPresent(students),
                  icon: const Icon(Icons.done_all),
                  label: const Text('تعيين الجميع حاضراً'),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: students.length,
                itemBuilder: (ctx, i) {
                  final s = students[i];
                  final st = statuses[s.id]!;
                  return ListTile(
                    dense: true,
                    leading: CircleAvatar(
                      backgroundColor: _color(st).withValues(alpha: 0.15),
                      child: Text('${i + 1}', style: TextStyle(color: _color(st), fontSize: 12)),
                    ),
                    title: Text(s.fullName, style: const TextStyle(fontSize: 14)),
                    trailing: SegmentedButton<AttendanceStatus>(
                      showSelectedIcon: false,
                      style: ButtonStyle(
                        visualDensity: VisualDensity.compact,
                        textStyle: WidgetStateProperty.all(const TextStyle(fontSize: 10)),
                      ),
                      segments: const [
                        ButtonSegment(value: AttendanceStatus.present, label: Text('حاضر')),
                        ButtonSegment(value: AttendanceStatus.late, label: Text('متأخر')),
                        ButtonSegment(value: AttendanceStatus.excusedAbsence, label: Text('بعذر')),
                        ButtonSegment(value: AttendanceStatus.unexcusedAbsence, label: Text('بلا عذر')),
                      ],
                      selected: {st},
                      onSelectionChanged: (v) => setState(() => statuses[s.id] = v.first),
                    ),
                  );
                },
              ),
            ),
            SafeArea(child: Padding(
              padding: const EdgeInsets.all(12),
              child: SizedBox(
                width: double.infinity, height: 48,
                child: FilledButton.icon(
                  onPressed: saving ? null : _save,
                  icon: saving ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.save),
                  label: Text(hadPrevious ? 'تحديث الحضور' : 'حفظ الحضور', style: const TextStyle(fontSize: 16)),
                  style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
                ),
              ),
            )),
          ]);
        },
      ),
    );
  }
}
