import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/date_utils.dart' as du;
import '../../shared/providers/providers.dart';
import '../../shared/widgets/common_widgets.dart';

// لوحة المدير + المشرف + المعلم (تتكيف حسب الدور)
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);
    final halaqasAsync = ref.watch(halaqasProvider);
    final studentsAsync = ref.watch(studentsProvider);
    final recordsAsync = ref.watch(allRecordsProvider);
    final alertsAsync = ref.watch(allAlertsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(session == null ? 'لوحة التحكم' : 'لوحة ${session.role == 'admin' ? 'المدير' : session.role == 'supervisor' ? 'المشرف' : 'المعلم'}'),
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
            data: (records) => alertsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => ErrorState(message: '$e'),
              data: (alerts) => _buildBody(context, ref, session, halaqas, students, records, alerts),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, session, halaqas, students, records, alerts) {
    final todayKey = du.dateKeyOf(DateTime.now());
    final todayRecords = records.where((r) => r.dateKey == todayKey).toList();
    final todayPresent = todayRecords.where((r) => r.attendance == 'present' || r.attendance == 'late').length;
    final todayAbsent = todayRecords.length - todayPresent;
    final avgScore = records.isEmpty ? 0.0 : records.map((r) => r.finalScore).reduce((a, b) => a + b) / records.length;
    final followUpCount = records.where((r) => r.needsFollowUp).map((r) => r.studentId).toSet().length;
    final halaqasWithToday = todayRecords.map((r) => r.halaqaId).toSet();
    final halaqasNoData = halaqas.where((h) => h.active && !halaqasWithToday.contains(h.id)).length;
    final openAlerts = alerts.where((a) => a.status != 'closed').length;

    // توزيع المستويات
    final levelCounts = <String, int>{};
    for (final r in records) {
      levelCounts[r.level] = (levelCounts[r.level] ?? 0) + 1;
    }

    // الحضور الأسبوعي (12 أسبوعاً)
    final weekly = <List<double>>[]; // [حاضر, غائب]
    final now = DateTime.now();
    for (int w = 11; w >= 0; w--) {
      final wEnd = now.subtract(Duration(days: w * 7));
      final wStart = wEnd.subtract(const Duration(days: 6));
      final wRecs = records.where((r) => !r.date.isBefore(wStart) && !r.date.isAfter(wEnd)).toList();
      final p = wRecs.where((r) => r.attendance == 'present' || r.attendance == 'late').length.toDouble();
      weekly.add([p, wRecs.length - p]);
    }

    // متوسط التسميع أسبوعياً
    final weeklyAvg = <double>[];
    for (int w = 11; w >= 0; w--) {
      final wEnd = now.subtract(Duration(days: w * 7));
      final wStart = wEnd.subtract(const Duration(days: 6));
      final wRecs = records.where((r) => !r.date.isBefore(wStart) && !r.date.isAfter(wEnd)).toList();
      weeklyAvg.add(wRecs.isEmpty ? 0 : wRecs.map((r) => r.finalScore).reduce((a, b) => a + b) / wRecs.length);
    }

    // مقارنة الحلقات
    final halaqaStats = halaqas.map((h) {
      final hRecs = records.where((r) => r.halaqaId == h.id).toList();
      final hp = hRecs.where((r) => r.attendance == 'present' || r.attendance == 'late').length;
      return MapEntry(h, hRecs.isEmpty ? 0.0 : hRecs.map((r) => r.finalScore).reduce((a, b) => a + b) / hRecs.length);
    }).toList()..sort((a, b) => b.value.compareTo(a.value));

    final struggling = students.where((s) {
      final sRecs = records.where((r) => r.studentId == s.id).toList();
      if (sRecs.length < 5) return false;
      final last5 = sRecs.reversed.take(5).toList();
      final avg = last5.map((r) => r.finalScore).reduce((a, b) => a + b) / 5;
      return avg < 60;
    }).take(6).toList();

    final isTeacher = session?.role == 'teacher';

    return ListView(padding: const EdgeInsets.all(12), children: [
      // بطاقات إحصائية
      Row(children: [
        StatCard(title: 'الطلاب النشطون', value: '${students.length}', icon: Icons.people, color: AppColors.primary,
            onTap: () => context.go('/home/students')),
        StatCard(title: 'حضور اليوم', value: '$todayPresent', icon: Icons.check_circle, color: AppColors.success),
        StatCard(title: 'غياب اليوم', value: '$todayAbsent', icon: Icons.cancel, color: AppColors.danger),
      ]),
      Row(children: [
        StatCard(title: 'متوسط التسميع', value: avgScore.toStringAsFixed(1), icon: Icons.menu_book, color: AppColors.gold),
        StatCard(title: 'حالات متابعة', value: '$followUpCount', icon: Icons.flag, color: AppColors.warning,
            onTap: () => context.go('/home/alerts')),
        StatCard(title: 'حلقات بلا بيانات اليوم', value: '$halaqasNoData', icon: Icons.warning_amber, color: Colors.blueGrey),
      ]),
      const SizedBox(height: 8),
      Card(
        color: Colors.amber.shade50,
        child: ListTile(
          leading: const Icon(Icons.notifications_active, color: Colors.orange),
          title: Text('تنبيهات مفتوحة: $openAlerts'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 14),
          onTap: () => context.go('/home/alerts'),
        ),
      ),

      _title('الحضور والغياب الأسبوعي', 'أعمدة مكدسة: الأخضر حضور، الأحمر غياب، لآخر 12 أسبوعاً'),
      Card(child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(height: 180, child: BarChart(BarChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          barGroups: [
            for (int i = 0; i < weekly.length; i++)
              BarChartGroupData(x: i, barRods: [
                BarChartRodData(toY: weekly[i][0] + weekly[i][1], width: 10,
                  borderRadius: BorderRadius.circular(2),
                  rodStackItems: [
                    BarChartRodStackItem(0, weekly[i][0], AppColors.success),
                    BarChartRodStackItem(weekly[i][0], weekly[i][0] + weekly[i][1], AppColors.danger),
                  ],
                  color: Colors.transparent),
              ]),
          ],
        ))),
      )),

      _title('توزيع مستويات التقييم', 'نسبة الطلاب في كل مستوى بناءً على التقييم النهائي'),
      Card(child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(height: 180, child: PieChart(PieChartData(
          sectionsSpace: 2, centerSpaceRadius: 36,
          sections: [
            for (final e in levelCounts.entries)
              PieChartSectionData(
                value: e.value.toDouble(),
                title: '${levelAr(e.key)}\n${(e.value / records.length * 100).toStringAsFixed(0)}%',
                color: levelColor(e.key), radius: 62,
                titleStyle: const TextStyle(fontSize: 9, color: Colors.white, fontWeight: FontWeight.bold),
              ),
          ],
        ))),
      )),

      _title('متوسط التقييم عبر الزمن', 'تطور متوسط النتيجة النهائية أسبوعياً'),
      Card(child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(height: 160, child: LineChart(LineChartData(
          minY: 0, maxY: 100,
          gridData: const FlGridData(show: true),
          titlesData: const FlTitlesData(
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          lineBarsData: [LineChartBarData(
            spots: [for (int i = 0; i < weeklyAvg.length; i++) FlSpot(i.toDouble(), weeklyAvg[i])],
            isCurved: true, color: AppColors.primary, barWidth: 3,
            belowBarData: BarAreaData(show: true, color: AppColors.primary.withValues(alpha: 0.12)),
            dotData: const FlDotData(show: false),
          )],
        ))),
      )),

      _title('مقارنة الحلقات', 'متوسط التقييم النهائي لكل حلقة — انقر للتفاصيل'),
      Card(child: Column(children: [
        for (final e in halaqaStats)
          ListTile(
            dense: true,
            title: Text(e.key.name, style: const TextStyle(fontSize: 13)),
            subtitle: LinearProgressIndicator(
              value: e.value / 100, minHeight: 8,
              backgroundColor: Colors.grey.shade200,
              color: e.value >= 80 ? AppColors.success : e.value >= 60 ? AppColors.warning : AppColors.danger,
              borderRadius: BorderRadius.circular(4),
            ),
            trailing: Text(e.value.toStringAsFixed(1), style: const TextStyle(fontWeight: FontWeight.bold)),
            onTap: () => context.push('/halaqa/${e.key.id}'),
          ),
      ])),

      if (struggling.isNotEmpty) ...[
        _title('طلاب يحتاجون إجراء', 'متوسط آخر 5 جلسات أقل من 60'),
        Card(child: Column(children: [
          for (final s in struggling)
            ListTile(
              dense: true,
              leading: const Icon(Icons.flag, color: AppColors.danger, size: 20),
              title: Text(s.fullName, style: const TextStyle(fontSize: 13)),
              subtitle: Text(halaqas.where((h) => h.id == s.halaqaId).map((h) => h.name).firstOrNull ?? '', style: const TextStyle(fontSize: 11)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 14),
              onTap: () => context.push('/student/${s.id}'),
            ),
        ])),
      ],

      if (isTeacher)
        Card(child: ListTile(
          leading: const Icon(Icons.how_to_reg, color: AppColors.primary),
          title: const Text('تسجيل حضور حلقتي'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 14),
          onTap: () => context.go('/home/halaqas'),
        )),

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
