import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/providers/providers.dart';
import '../../shared/widgets/common_widgets.dart';

class HalaqaDetailScreen extends ConsumerWidget {
  final String halaqaId;
  const HalaqaDetailScreen({super.key, required this.halaqaId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final halaqasAsync = ref.watch(halaqasProvider);
    final studentsAsync = ref.watch(studentsProvider);
    final recordsAsync = ref.watch(allRecordsProvider);
    final usersAsync = ref.watch(usersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('تفاصيل الحلقة')),
      body: halaqasAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => ErrorState(message: '$e'),
        data: (halaqas) {
          final h = halaqas.where((x) => x.id == halaqaId).firstOrNull;
          if (h == null) return const EmptyState(message: 'الحلقة غير موجودة');
          final students = (studentsAsync.value ?? []).where((s) => s.halaqaId == halaqaId).toList();
          final records = (recordsAsync.value ?? []).where((r) => r.halaqaId == halaqaId).toList();
          final users = usersAsync.value ?? [];
          final teacherName = users.where((u) => h.teacherIds.contains(u.id)).map((u) => u.fullName).firstOrNull ?? '—';
          final totalNew = records.fold<double>(0.0, (a, r) => a + r.newPages);
          final excellent = records.where((r) => r.grade == 'excellent').length;

          return Column(children: [
            Container(
              width: double.infinity, padding: const EdgeInsets.all(16),
              color: AppColors.primary.withValues(alpha: 0.08),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(h.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
                Text('المستوى: ${h.level} • المعلم: $teacherName'),
                Text('المواعيد: ${h.scheduleDescription}'),
                Text('الطلاب: ${students.length}/${h.capacity} • حفظ جديد ${totalNew.toStringAsFixed(1)} صفحة • ممتاز $excellent'),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(children: [
                Expanded(child: FilledButton.icon(
                  onPressed: () => context.push('/halaqa/$halaqaId/sheet'),
                  icon: const Icon(Icons.table_chart),
                  label: const Text('كشف التسميع'),
                  style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
                )),
                const SizedBox(width: 8),
                Expanded(child: FilledButton.icon(
                  onPressed: () => context.push('/halaqa/$halaqaId/entry'),
                  icon: const Icon(Icons.edit_note),
                  label: const Text('تسجيل يومي'),
                  style: FilledButton.styleFrom(backgroundColor: AppColors.gold),
                )),
              ]),
            ),
            const Divider(height: 1),
            Expanded(
              child: students.isEmpty
                  ? const EmptyState(message: 'لا يوجد طلاب في هذه الحلقة')
                  : ListView.builder(
                      itemCount: students.length,
                      itemBuilder: (ctx, i) {
                        final s = students[i];
                        final sRecs = records.where((r) => r.studentId == s.id).toList();
                        final lastGrade = sRecs.isEmpty ? '' : sRecs.last.grade;
                        final sNew = sRecs.fold<double>(0.0, (a, r) => a + r.newPages);
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: gradeColor(lastGrade).withValues(alpha: 0.15),
                            child: Text('${i + 1}', style: TextStyle(color: gradeColor(lastGrade), fontSize: 13)),
                          ),
                          title: Text(s.fullName, style: const TextStyle(fontSize: 14)),
                          subtitle: Text(s.studentCode, style: const TextStyle(fontSize: 11)),
                          trailing: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end, children: [
                            Text('${sNew.toStringAsFixed(1)} صفحة', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            if (lastGrade.isNotEmpty)
                              Text(gradeAr(lastGrade), style: TextStyle(fontSize: 10, color: gradeColor(lastGrade))),
                          ]),
                          onTap: () => ctx.push('/student/${s.id}'),
                        );
                      },
                    ),
            ),
          ]);
        },
      ),
    );
  }
}
