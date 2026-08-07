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
          final hp = records.where((r) => r.attendance == 'present' || r.attendance == 'late').length;
          final attRate = records.isEmpty ? 0.0 : hp / records.length * 100;
          final avg = records.isEmpty ? 0.0 : records.map((r) => r.finalScore).reduce((a, b) => a + b) / records.length;

          return Column(children: [
            Container(
              width: double.infinity, padding: const EdgeInsets.all(16),
              color: AppColors.primary.withValues(alpha: 0.08),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(h.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
                Text('المستوى: ${h.level} • المعلم: $teacherName'),
                Text('المواعيد: ${h.scheduleDescription}'),
                Text('الطلاب: ${students.length}/${h.capacity} • حضور ${attRate.toStringAsFixed(0)}% • تقييم ${avg.toStringAsFixed(1)}'),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(children: [
                Expanded(child: FilledButton.icon(
                  onPressed: () => context.push('/halaqa/$halaqaId/attendance'),
                  icon: const Icon(Icons.how_to_reg),
                  label: const Text('تسجيل الحضور'),
                  style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
                )),
                const SizedBox(width: 8),
                Expanded(child: FilledButton.icon(
                  onPressed: () => context.push('/halaqa/$halaqaId/recitation'),
                  icon: const Icon(Icons.menu_book),
                  label: const Text('تسجيل التسميع'),
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
                        final sAvg = sRecs.isEmpty ? 0.0 : sRecs.map((r) => r.finalScore).reduce((a, b) => a + b) / sRecs.length;
                        final lastLevel = sRecs.isEmpty ? 'good' : sRecs.last.level;
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: levelColor(lastLevel).withValues(alpha: 0.15),
                            child: Text('${i + 1}', style: TextStyle(color: levelColor(lastLevel), fontSize: 13)),
                          ),
                          title: Text(s.fullName, style: const TextStyle(fontSize: 14)),
                          subtitle: Text(s.studentCode, style: const TextStyle(fontSize: 11)),
                          trailing: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end, children: [
                            Text(sAvg.toStringAsFixed(1), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                            Text(levelAr(lastLevel), style: TextStyle(fontSize: 10, color: levelColor(lastLevel))),
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
