import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';
import '../../core/services/session_service.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/date_utils.dart' as du;
import '../../shared/providers/providers.dart';
import '../../shared/widgets/common_widgets.dart';

// لوحة المشرف (كل الحلقات) أو المعلم (حلقته فقط)
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);
    final halaqasAsync = ref.watch(halaqasProvider);
    final studentsAsync = ref.watch(studentsProvider);
    final recordsAsync = ref.watch(allRecordsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(session == null ? 'لوحة التحكم' : 'لوحة ${session.isSupervisor ? 'المشرف' : 'المعلم'}'),
        actions: [
          if (session != null)
            Center(child: Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Text(session.name, style: const TextStyle(fontSize: 12)),
            )),
        ],
      ),
      body: halaqasAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => ErrorState(message: 'خطأ في تحميل البيانات: $e'),
        data: (halaqas) => studentsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => ErrorState(message: '$e'),
          data: (students) => recordsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => ErrorState(message: '$e'),
            data: (records) => _buildBody(context, ref, session, halaqas, students, records),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, session, halaqas, students, records) {
    final isTeacher = session?.isTeacher ?? false;
    // فلترة حسب الدور
    final myHalaqas = isTeacher
        ? halaqas.where((h) => h.id == session!.halaqaId || h.teacherIds.contains(session.userId)).toList()
        : halaqas;
    final myHalaqaIds = myHalaqas.map((h) => h.id).toSet();
    final myStudents = isTeacher ? students.where((s) => myHalaqaIds.contains(s.halaqaId)).toList() : students;
    final myRecords = isTeacher ? records.where((r) => myHalaqaIds.contains(r.halaqaId)).toList() : records;

    final todayKey = du.dateKeyOf(DateTime.now());
    final todayRecords = myRecords.where((r) => r.dateKey == todayKey).toList();
    final totalNewPages = myRecords.fold<double>(0.0, (a, r) => a + r.newPages);
    final repeatCount = myRecords.where((r) => r.grade == 'repeat').map((r) => r.studentId).toSet().length;
    final halaqasWithToday = todayRecords.map((r) => r.halaqaId).toSet();
    final halaqasNoData = myHalaqas.where((h) => h.active && !halaqasWithToday.contains(h.id)).length;

    // توزيع التقديرات
    final gradeCounts = <String, int>{};
    for (final r in myRecords) {
      if (r.grade.isNotEmpty) gradeCounts[r.grade] = (gradeCounts[r.grade] ?? 0) + 1;
    }
    final gradedTotal = gradeCounts.values.fold(0, (a, b) => a + b);

    // صفحات الحفظ الجديد أسبوعياً (12 أسبوعاً)
    final now = DateTime.now();
    final weeklyNew = <double>[];
    for (int w = 11; w >= 0; w--) {
      final wStart = SessionService.weekStartOf(now).subtract(Duration(days: w * 7));
      final wEnd = wStart.add(const Duration(days: 6));
      final wRecs = myRecords.where((r) => !r.date.isBefore(wStart) && !r.date.isAfter(wEnd));
      weeklyNew.add(wRecs.fold(0.0, (a, r) => a + r.newPages));
    }

    // مقارنة الحلقات (للمشرف): إجمالي صفحات الجديد
    final halaqaStats = myHalaqas.map((h) {
      final hRecs = myRecords.where((r) => r.halaqaId == h.id);
      return MapEntry(h, hRecs.fold<double>(0.0, (a, r) => a + r.newPages));
    }).toList()..sort((a, b) => b.value.compareTo(a.value));
    final maxPages = halaqaStats.isEmpty ? 1.0 : (halaqaStats.first.value <= 0 ? 1.0 : halaqaStats.first.value);

    // طلاب «إعادة» متكررة
    final struggling = myStudents.where((s) {
      final sRecs = myRecords.where((r) => r.studentId == s.id).toList();
      if (sRecs.length < 4) return false;
      final repeats = sRecs.where((r) => r.grade == 'repeat').length;
      return repeats / sRecs.length >= 0.4;
    }).take(6).toList();

    return ListView(padding: const EdgeInsets.all(12), children: [
      Row(children: [
        Expanded(child: StatCard(title: 'الطلاب', value: '${myStudents.length}', icon: Icons.people, color: AppColors.primary,
            onTap: () => context.go('/home/students'))),
        Expanded(child: StatCard(title: isTeacher ? 'حلقتي' : 'الحلقات', value: '${myHalaqas.length}', icon: Icons.groups, color: AppColors.secondary,
            onTap: () => context.go('/home/halaqas'))),
        Expanded(child: StatCard(title: 'سجلات اليوم', value: '${todayRecords.length}', icon: Icons.edit_note, color: AppColors.success)),
      ]),
      Row(children: [
        Expanded(child: StatCard(title: 'حفظ جديد (صفحات)', value: totalNewPages.toStringAsFixed(1), icon: Icons.auto_stories, color: AppColors.gold)),
        Expanded(child: StatCard(title: 'طلاب «إعادة»', value: '$repeatCount', icon: Icons.flag, color: AppColors.danger)),
        Expanded(child: StatCard(title: 'حلقات بلا تسجيل اليوم', value: '$halaqasNoData', icon: Icons.warning_amber, color: Colors.blueGrey)),
      ]),

      if (isTeacher) ...[
        const SizedBox(height: 8),
        Card(child: ListTile(
          leading: const Icon(Icons.table_chart, color: AppColors.primary),
          title: const Text('كشف التسميع الأسبوعي'),
          subtitle: const Text('عرض كشف متابعة الحفظ والمراجعة'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 14),
          onTap: () {
            if (myHalaqas.isNotEmpty) context.push('/halaqa/${myHalaqas.first.id}/sheet');
          },
        )),
        Card(child: ListTile(
          leading: const Icon(Icons.edit_note, color: AppColors.gold),
          title: const Text('تسجيل التسميع اليومي'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 14),
          onTap: () {
            if (myHalaqas.isNotEmpty) context.push('/halaqa/${myHalaqas.first.id}/entry');
          },
        )),
      ],

      _title('توزيع التقديرات', 'نسب التقديرات الأربعة في كل السجلات'),
      Card(child: Padding(
        padding: const EdgeInsets.all(16),
        child: gradedTotal == 0
            ? const Text('لا توجد تقييمات بعد', textAlign: TextAlign.center)
            : SizedBox(height: 180, child: PieChart(PieChartData(
                sectionsSpace: 2, centerSpaceRadius: 36,
                sections: [
                  for (final e in gradeCounts.entries)
                    PieChartSectionData(
                      value: e.value.toDouble(),
                      title: '${gradeAr(e.key)}\n${(e.value / gradedTotal * 100).toStringAsFixed(0)}%',
                      color: gradeColor(e.key), radius: 62,
                      titleStyle: const TextStyle(fontSize: 9, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                ],
              ))),
      )),

      _title('صفحات الحفظ الجديد أسبوعياً', 'إجمالي صفحات الجديد المسجلة في آخر 12 أسبوعاً'),
      Card(child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(height: 170, child: BarChart(BarChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          barGroups: [
            for (int i = 0; i < weeklyNew.length; i++)
              BarChartGroupData(x: i, barRods: [
                BarChartRodData(toY: weeklyNew[i], width: 12, borderRadius: BorderRadius.circular(3), color: AppColors.primary),
              ]),
          ],
        ))),
      )),

      if (!isTeacher) ...[
        _title('مقارنة الحلقات', 'إجمالي صفحات الحفظ الجديد لكل حلقة — انقر للتفاصيل'),
        Card(child: Column(children: [
          for (final e in halaqaStats)
            ListTile(
              dense: true,
              title: Text(e.key.name, style: const TextStyle(fontSize: 13)),
              subtitle: LinearProgressIndicator(
                value: (e.value / maxPages).clamp(0.0, 1.0), minHeight: 8,
                backgroundColor: Colors.grey.shade200,
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(4),
              ),
              trailing: Text(e.value.toStringAsFixed(1), style: const TextStyle(fontWeight: FontWeight.bold)),
              onTap: () => context.push('/halaqa/${e.key.id}'),
            ),
        ])),
      ],

      if (struggling.isNotEmpty) ...[
        _title('طلاب يحتاجون متابعة', 'تقدير «إعادة» في 40% أو أكثر من سجلاتهم'),
        Card(child: Column(children: [
          for (final s in struggling)
            ListTile(
              dense: true,
              leading: const Icon(Icons.flag, color: AppColors.danger, size: 20),
              title: Text(s.fullName, style: const TextStyle(fontSize: 13)),
              subtitle: Text(myHalaqas.where((h) => h.id == s.halaqaId).map((h) => h.name).firstOrNull ?? '', style: const TextStyle(fontSize: 11)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 14),
              onTap: () => context.push('/student/${s.id}'),
            ),
        ])),
      ],

      const SizedBox(height: 40),
    ]);
  }

  Widget _title(String t, String subtitle) => Padding(
    padding: const EdgeInsets.only(top: 14, bottom: 4),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(t, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.primary)),
      Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.black45)),
    ]),
  );
}
