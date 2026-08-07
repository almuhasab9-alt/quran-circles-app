import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../core/constants/enums.dart';
import '../../core/database/app_database.dart';
import '../../shared/providers/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/common_widgets.dart';

class StaffScreen extends ConsumerStatefulWidget {
  const StaffScreen({super.key});
  @override
  ConsumerState<StaffScreen> createState() => _StaffScreenState();
}

class _StaffScreenState extends ConsumerState<StaffScreen> {
  String _query = '';
  String _roleFilter = 'all';

  Future<void> _showUserDialog([User? u]) async {
    final halaqas = await ref.read(halaqaRepoProvider).getAll();
    if (!mounted) return;
    final nameCtrl = TextEditingController(text: u?.fullName ?? '');
    final userCtrl = TextEditingController(text: u?.username ?? '');
    String role = u?.role ?? 'teacher';
    List<String> selectedHalaqas = (u?.assignedHalaqaIds ?? '').split(',').where((x) => x.isNotEmpty).toList();
    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(builder: (ctx, setD) => AlertDialog(
        title: Text(u == null ? 'إضافة موظف' : 'تعديل موظف'),
        content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'الاسم (اسمان)')),
          const SizedBox(height: 8),
          TextField(controller: userCtrl, decoration: const InputDecoration(labelText: 'اسم المستخدم')),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: 'الدور'), initialValue: role,
            items: const [
              DropdownMenuItem(value: 'teacher', child: Text('معلم')),
              DropdownMenuItem(value: 'supervisor', child: Text('مشرف')),
              DropdownMenuItem(value: 'admin', child: Text('مدير')),
            ],
            onChanged: (v) => setD(() => role = v!),
          ),
          const SizedBox(height: 8),
          const Align(alignment: Alignment.centerRight, child: Text('الحلقات المرتبطة:', style: TextStyle(fontWeight: FontWeight.bold))),
          ...halaqas.where((h) => h.active).map((h) => CheckboxListTile(
                dense: true,
                title: Text(h.name, overflow: TextOverflow.ellipsis),
                value: selectedHalaqas.contains(h.id),
                onChanged: (v) => setD(() {
                  if (v == true) { selectedHalaqas.add(h.id); } else { selectedHalaqas.remove(h.id); }
                }),
              )),
        ])),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('إلغاء')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('حفظ')),
        ],
      )),
    );
    if (saved != true || nameCtrl.text.trim().isEmpty) return;
    final repo = ref.read(userRepoProvider);
    final now = DateTime.now();
    if (u == null) {
      await repo.insert(UsersCompanion(
        id: drift.Value(const Uuid().v4()),
        fullName: drift.Value(nameCtrl.text.trim()),
        username: drift.Value(userCtrl.text.trim().isEmpty ? 'user${now.millisecondsSinceEpoch % 10000}' : userCtrl.text.trim()),
        role: drift.Value(role),
        assignedHalaqaIds: drift.Value(selectedHalaqas.join(',')),
        createdAt: drift.Value(now), updatedAt: drift.Value(now),
      ));
    } else {
      await repo.updateEntity(u.copyWith(
        fullName: nameCtrl.text.trim(),
        username: userCtrl.text.trim().isEmpty ? u.username : userCtrl.text.trim(),
        role: role, assignedHalaqaIds: selectedHalaqas.join(','), updatedAt: now,
      ));
    }
    ref.read(dataVersionProvider.notifier).state++;
  }

  @override
  Widget build(BuildContext context) {
    final usersAsync = ref.watch(usersProvider);
    final isAdmin = ref.watch(sessionProvider)?.role == 'admin';
    return Scaffold(
      appBar: AppBar(title: const Text('إدارة الموظفين')),
      floatingActionButton: isAdmin ? FloatingActionButton.extended(
        onPressed: () => _showUserDialog(), icon: const Icon(Icons.person_add), label: const Text('موظف')) : null,
      body: Column(children: [
        Padding(padding: const EdgeInsets.all(12), child: Column(children: [
          TextField(
            decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'بحث بالاسم', border: OutlineInputBorder()),
            onChanged: (v) => setState(() => _query = v.trim()),
          ),
          const SizedBox(height: 8),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'all', label: Text('الكل')),
              ButtonSegment(value: 'teacher', label: Text('معلمون')),
              ButtonSegment(value: 'supervisor', label: Text('مشرفون')),
            ],
            selected: {_roleFilter},
            onSelectionChanged: (v) => setState(() => _roleFilter = v.first),
          ),
        ])),
        Expanded(child: usersAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => ErrorState(message: '$e'),
          data: (all) {
            var list = all.where((u) => u.role != 'admin' && u.active).toList();
            if (_roleFilter != 'all') list = list.where((u) => u.role == _roleFilter).toList();
            if (_query.isNotEmpty) list = list.where((u) => u.fullName.contains(_query)).toList();
            if (list.isEmpty) return const EmptyState(message: 'لا يوجد موظفون مطابقون');
            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (ctx, i) {
                final u = list[i];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: u.role == 'supervisor' ? AppColors.secondary : AppColors.primary,
                      child: Icon(u.role == 'supervisor' ? Icons.supervisor_account : Icons.person, color: Colors.white),
                    ),
                    title: Text(u.fullName, overflow: TextOverflow.ellipsis),
                    subtitle: Text('${UserRole.values.where((r) => r.name == u.role).firstOrNull?.ar ?? u.role} • ${u.assignedHalaqaIds.split(',').where((x) => x.isNotEmpty).length} حلقة', overflow: TextOverflow.ellipsis),
                    trailing: isAdmin ? PopupMenuButton<String>(onSelected: (v) async {
                      if (v == 'edit') _showUserDialog(u);
                      if (v == 'disable') {
                        await ref.read(userRepoProvider).deactivate(u.id);
                        ref.read(dataVersionProvider.notifier).state++;
                      }
                    }, itemBuilder: (_) => const [
                      PopupMenuItem(value: 'edit', child: Text('تعديل')),
                      PopupMenuItem(value: 'disable', child: Text('تعطيل')),
                    ]) : null,
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
