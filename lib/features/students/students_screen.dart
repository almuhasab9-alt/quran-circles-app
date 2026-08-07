import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart' as drift;
import '../../core/constants/app_constants.dart';
import '../../core/database/app_database.dart';
import '../../shared/providers/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/common_widgets.dart';

class StudentsScreen extends ConsumerStatefulWidget {
  const StudentsScreen({super.key});
  @override
  ConsumerState<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends ConsumerState<StudentsScreen> {
  String _query = '';
  String? _halaqaFilter;

  Future<void> _showStudentDialog([Student? s]) async {
    final halaqas = await ref.read(halaqaRepoProvider).getAll();
    if (!mounted) return;
    final nameCtrl = TextEditingController(text: s?.fullName ?? '');
    String? halaqaId = s?.halaqaId ?? halaqas.where((h) => h.active).firstOrNull?.id;
    String level = s?.level ?? AppConstants.levels.first;
    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(builder: (ctx, setD) => AlertDialog(
        title: Text(s == null ? 'إضافة طالب' : 'تعديل طالب'),
        content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'اسم الطالب (اسمان)')),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: 'الحلقة'), initialValue: halaqaId, isExpanded: true,
            items: halaqas.where((h) => h.active).map((h) => DropdownMenuItem(value: h.id, child: Text(h.name, overflow: TextOverflow.ellipsis))).toList(),
            onChanged: (v) => setD(() => halaqaId = v),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: 'المستوى'), initialValue: level, isExpanded: true,
            items: AppConstants.levels.map((l) => DropdownMenuItem(value: l, child: Text(l))).toList(),
            onChanged: (v) => setD(() => level = v!),
          ),
        ])),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('إلغاء')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('حفظ')),
        ],
      )),
    );
    if (saved != true || nameCtrl.text.trim().isEmpty || halaqaId == null) return;
    final repo = ref.read(studentRepoProvider);
    final now = DateTime.now();
    if (s == null) {
      final all = await repo.getAll();
      final code = 'ST${1001 + all.length}';
      await repo.insert(StudentsCompanion(
        id: drift.Value(const Uuid().v4()), studentCode: drift.Value(code),
        fullName: drift.Value(nameCtrl.text.trim()), halaqaId: drift.Value(halaqaId!),
        level: drift.Value(level), joinDate: drift.Value(now),
        createdAt: drift.Value(now), updatedAt: drift.Value(now),
      ));
    } else {
      await repo.updateEntity(s.copyWith(fullName: nameCtrl.text.trim(), halaqaId: halaqaId!, level: level, updatedAt: now));
    }
    ref.read(dataVersionProvider.notifier).state++;
  }

  Future<void> _transfer(Student s) async {
    final halaqas = (await ref.read(halaqaRepoProvider).getAll()).where((h) => h.active && h.id != s.halaqaId).toList();
    if (!mounted || halaqas.isEmpty) return;
    String? target;
    final ok = await showDialog<bool>(context: context, builder: (ctx) => StatefulBuilder(builder: (ctx, setD) => AlertDialog(
      title: Text('نقل ${s.fullName}'),
      content: DropdownButtonFormField<String>(
        decoration: const InputDecoration(labelText: 'إلى الحلقة'), initialValue: target, isExpanded: true,
        items: halaqas.map((h) => DropdownMenuItem(value: h.id, child: Text(h.name, overflow: TextOverflow.ellipsis))).toList(),
        onChanged: (v) => setD(() => target = v),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('إلغاء')),
        FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('نقل')),
      ],
    )));
    if (ok == true && target != null) {
      await ref.read(studentRepoProvider).transfer(s.id, target!, ref.read(sessionProvider)?.userId ?? 'demo');
      ref.read(dataVersionProvider.notifier).state++;
    }
  }

  @override
  Widget build(BuildContext context) {
    final studentsAsync = ref.watch(studentsProvider);
    final halaqasAsync = ref.watch(halaqasProvider);
    final isAdmin = ref.watch(sessionProvider)?.role != 'teacher';
    return Scaffold(
      appBar: AppBar(title: const Text('إدارة الطلاب')),
      floatingActionButton: isAdmin ? FloatingActionButton.extended(
        onPressed: () => _showStudentDialog(), icon: const Icon(Icons.person_add), label: const Text('طالب')) : null,
      body: Column(children: [
        Padding(padding: const EdgeInsets.all(12), child: Column(children: [
          TextField(
            decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'بحث بالاسم أو رقم الطالب', border: OutlineInputBorder()),
            onChanged: (v) => setState(() => _query = v.trim()),
          ),
          const SizedBox(height: 8),
          halaqasAsync.when(
            loading: () => const SizedBox.shrink(), error: (_, __) => const SizedBox.shrink(),
            data: (hs) => DropdownButtonFormField<String?>(
              decoration: const InputDecoration(labelText: 'فلترة بالحلقة', border: OutlineInputBorder()),
              initialValue: _halaqaFilter, isExpanded: true,
              items: [
                const DropdownMenuItem<String?>(value: null, child: Text('كل الحلقات')),
                ...hs.map((h) => DropdownMenuItem<String?>(value: h.id, child: Text(h.name, overflow: TextOverflow.ellipsis))),
              ],
              onChanged: (v) => setState(() => _halaqaFilter = v),
            ),
          ),
        ])),
        Expanded(child: studentsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => ErrorState(message: '$e'),
          data: (all) {
            var list = all.where((s) => s.active).toList();
            if (_query.isNotEmpty) {
              list = list.where((s) => s.fullName.contains(_query) || s.studentCode.contains(_query)).toList();
            }
            if (_halaqaFilter != null) list = list.where((s) => s.halaqaId == _halaqaFilter).toList();
            if (list.isEmpty) return const EmptyState(message: 'لا توجد نتائج مطابقة');
            final halaqas = halaqasAsync.valueOrNull ?? [];
            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (ctx, i) {
                final s = list[i];
                final hName = halaqas.where((h) => h.id == s.halaqaId).firstOrNull?.name ?? '—';
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: ListTile(
                    leading: CircleAvatar(backgroundColor: AppColors.primary, child: Text(s.fullName.isNotEmpty ? s.fullName[0] : '؟', style: const TextStyle(color: Colors.white))),
                    title: Text(s.fullName, overflow: TextOverflow.ellipsis),
                    subtitle: Text('${s.studentCode} • $hName • ${s.level}', overflow: TextOverflow.ellipsis),
                    onTap: () => context.push('/student/${s.id}'),
                    trailing: isAdmin ? PopupMenuButton<String>(onSelected: (v) async {
                      if (v == 'edit') await _showStudentDialog(s);
                      if (v == 'transfer') await _transfer(s);
                      if (v == 'disable') {
                        await ref.read(studentRepoProvider).deactivate(s.id);
                        ref.read(dataVersionProvider.notifier).state++;
                      }
                    }, itemBuilder: (_) => const [
                      PopupMenuItem(value: 'edit', child: Text('تعديل')),
                      PopupMenuItem(value: 'transfer', child: Text('نقل لحلقة أخرى')),
                      PopupMenuItem(value: 'disable', child: Text('تعطيل')),
                    ]) : const Icon(Icons.chevron_left),
                  ),
                );
              },
            );
          },
        )),
      ]),
    );
  }
}
