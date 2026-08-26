import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:drift/drift.dart' show Value;
import 'package:uuid/uuid.dart';
import '../../core/database/app_database.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/providers/providers.dart';
import '../../shared/widgets/common_widgets.dart';

class HalaqasScreen extends ConsumerWidget {
  const HalaqasScreen({super.key});

  Future<void> _halaqaDialog(BuildContext context, WidgetRef ref, {Halaqa? existing}) async {
    final users = await ref.read(userRepoProvider).all();
    final teachers = users.where((u) => u.role == 'teacher' && u.active).toList();
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    final schedCtrl = TextEditingController(text: existing?.scheduleDescription ?? 'يومياً من السبت إلى الجمعة - بعد العصر');
    final capCtrl = TextEditingController(text: existing?.capacity.toString() ?? '25');
    final levelCtrl = TextEditingController(text: existing?.level ?? '');
    String? teacherId = existing != null && existing.teacherIds.isNotEmpty
        ? existing.teacherIds.split(',').first
        : (teachers.isNotEmpty ? teachers.first.id : null);
    // خيار المشرف أُزيل من النموذج — نحتفظ بالقيمة السابقة كما هي فقط
    final supervisorId = existing?.supervisorId ?? '';
    if (!context.mounted) {
      nameCtrl.dispose(); schedCtrl.dispose(); capCtrl.dispose(); levelCtrl.dispose();
      return;
    }

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(builder: (ctx, setD) {
        return AlertDialog(
          title: Text(existing == null ? 'إضافة حلقة' : 'تعديل حلقة'),
          content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'اسم الحلقة')),
            const SizedBox(height: 8),
            TextField(controller: levelCtrl, decoration: const InputDecoration(labelText: 'المستوى', hintText: 'اكتب مستوى الحلقة')),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: teacherId, decoration: const InputDecoration(labelText: 'المعلم'),
              items: teachers.map((t) => DropdownMenuItem(value: t.id, child: Text(t.fullName))).toList(),
              onChanged: (v) => setD(() => teacherId = v),
            ),
            TextField(controller: schedCtrl, decoration: const InputDecoration(labelText: 'المواعيد')),
            TextField(controller: capCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'السعة')),
          ])),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
            FilledButton(
              onPressed: () async {
                if (nameCtrl.text.trim().isEmpty) return;
                final repo = ref.read(halaqaRepoProvider);
                final c = HalaqasCompanion(
                  id: Value(existing?.id ?? const Uuid().v4()),
                  name: Value(nameCtrl.text.trim()),
                  level: Value(levelCtrl.text.trim()),
                  teacherIds: Value(teacherId ?? ''),
                  supervisorId: Value(supervisorId),
                  capacity: Value(int.tryParse(capCtrl.text) ?? 25),
                  scheduleDescription: Value(schedCtrl.text.trim()),
                );
                if (existing == null) { await repo.insert(c); } else { await repo.update(c); }
                bumpDataVersion(ref);
                if (ctx.mounted) Navigator.pop(ctx);
              },
              child: const Text('حفظ'),
            ),
          ],
        );
      }),
    );
    nameCtrl.dispose(); schedCtrl.dispose(); capCtrl.dispose(); levelCtrl.dispose();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);
    final halaqasAsync = ref.watch(halaqasProvider);
    final studentsAsync = ref.watch(studentsProvider);
    final recordsAsync = ref.watch(allRecordsProvider);
    final isSupervisor = session?.isSupervisor ?? false;

    return Scaffold(
      appBar: AppBar(title: Text(isSupervisor ? 'كل الحلقات' : 'حلقتي')),
      floatingActionButton: isSupervisor ? FloatingActionButton(
        onPressed: () => _halaqaDialog(context, ref),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ) : null,
      body: halaqasAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => ErrorState(message: '$e'),
        data: (halaqas) {
          // المعلم يرى حلقته فقط، المشرف يرى الكل
          var list = halaqas;
          if (session?.isTeacher ?? false) {
            list = halaqas.where((h) => h.id == session!.halaqaId || h.teacherIds.contains(session.userId)).toList();
          }
          if (list.isEmpty) return const EmptyState(icon: Icons.groups, message: 'لا توجد حلقات');
          final students = studentsAsync.value ?? [];
          final records = recordsAsync.value ?? [];
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: list.length,
            itemBuilder: (ctx, i) {
              final h = list[i];
              final count = students.where((s) => s.halaqaId == h.id).length;
              final hRecs = records.where((r) => r.halaqaId == h.id).toList();
              final totalNew = hRecs.fold<double>(0, (a, r) => a + r.newPages);
              final excellent = hRecs.where((r) => r.grade == 'excellent').length;
              return Card(child: ListTile(
                leading: CircleAvatar(backgroundColor: AppColors.primary, child: Text('${i + 1}', style: const TextStyle(color: Colors.white))),
                title: Text(h.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('${h.level} • $count طالب\nحفظ جديد ${totalNew.toStringAsFixed(1)} صفحة • ممتاز $excellent'),
                isThreeLine: true,
                trailing: isSupervisor
                    ? PopupMenuButton<String>(
                        onSelected: (v) async {
                          if (v == 'edit') _halaqaDialog(context, ref, existing: h);
                          if (v == 'disable') {
                            await ref.read(halaqaRepoProvider).deactivate(h.id);
                            bumpDataVersion(ref);
                          }
                        },
                        itemBuilder: (_) => const [
                          PopupMenuItem(value: 'edit', child: Text('تعديل')),
                          PopupMenuItem(value: 'disable', child: Text('تعطيل')),
                        ],
                      )
                    : const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => ctx.push('/halaqa/${h.id}'),
              ));
            },
          );
        },
      ),
    );
  }
}
