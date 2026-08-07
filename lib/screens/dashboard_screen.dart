import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/models.dart';
import '../services/data_service.dart';

class DashboardScreen extends StatelessWidget {
  final AppUser user;
  const DashboardScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final ds = DataService.instance;
    final totalStudents = ds.students.length;
    final totalCircles = ds.circles.length;

    // حساب معدلات عامة
    final allAtt = ds.attendance;
    final presentCount = allAtt.where((a) => a.status == AttendanceStatus.present || a.status == AttendanceStatus.late).length;
    final attRate = allAtt.isEmpty ? 0.0 : presentCount / allAtt.length * 100;
    final absentRate = 100 - attRate;
    final recAvg = ds.recitations.isEmpty
        ? 0.0
        : ds.recitations.map((r) => r.recitationScore).reduce((a, b) => a + b) / ds.recitations.length;
    final alertsCount = ds.activeAlerts().length;

    // توزيع المستويات
    final levelCounts = <String, int>{};
    for (final s in ds.students) {
      levelCounts[s.level] = (levelCounts[s.level] ?? 0) + 1;
    }

    // مقارنة الحلقات (أعلى 6 للرسم)
    final circleAvgs = ds.circles.map((c) => MapEntry(c.name, ds.circleRecitationAvg(c.id))).toList();

    // الحضور الأسبوعي (آخر 12 أسبوعاً)
    final weeklyRate = <double>[];
    final now = DateTime.now();
    for (int w = 11; w >= 0; w--) {
      final weekStart = now.subtract(Duration(days: w * 7 + 6));
      final weekEnd = now.subtract(Duration(days: w * 7));
      final wAtt = allAtt.where((a) => !a.date.isBefore(weekStart) && !a.date.isAfter(weekEnd)).toList();
      if (wAtt.isEmpty) {
        weeklyRate.add(0);
      } else {
        final p = wAtt.where((a) => a.status == AttendanceStatus.present || a.status == AttendanceStatus.late).length;
        weeklyRate.add(p / wAtt.length * 100);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('لوحة المدير'),
        backgroundColor: const Color(0xFF0B7A5E),
        foregroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Center(child: Text('${user.name} (${user.roleName})', style: const TextStyle(fontSize: 12))),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {},
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // بطاقات إحصائية
            Row(children: [
              _statCard('الحلقات', '$totalCircles', Icons.groups, Colors.teal),
              _statCard('الطلاب', '$totalStudents', Icons.people, Colors.indigo),
            ]),
            Row(children: [
              _statCard('نسبة الحضور', '${attRate.toStringAsFixed(1)}%', Icons.check_circle, Colors.green),
              _statCard('تنبيهات نشطة', '$alertsCount', Icons.warning_amber, Colors.orange),
            ]),
            const SizedBox(height: 8),

            _sectionTitle('الحضور والغيار خلال 12 أسبوعاً'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  height: 180,
                  child: LineChart(LineChartData(
                    minY: 50, maxY: 100,
                    gridData: const FlGridData(show: true),
                    titlesData: const FlTitlesData(
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: [for (int i = 0; i < weeklyRate.length; i++) FlSpot(i.toDouble(), weeklyRate[i])],
                        isCurved: true, color: const Color(0xFF0B7A5E), barWidth: 3,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(show: true, color: const Color(0xFF0B7A5E).withValues(alpha: 0.15)),
                      ),
                    ],
                  )),
                ),
              ),
            ),

            _sectionTitle('الحضور مقابل الغياب'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  height: 180,
                  child: PieChart(PieChartData(
                    sectionsSpace: 2, centerSpaceRadius: 40,
                    sections: [
                      PieChartSectionData(value: attRate, title: 'حضور\n${attRate.toStringAsFixed(0)}%', color: const Color(0xFF0B7A5E), radius: 60, titleStyle: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold)),
                      PieChartSectionData(value: absentRate, title: 'غياب\n${absentRate.toStringAsFixed(0)}%', color: Colors.red.shade400, radius: 60, titleStyle: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold)),
                    ],
                  )),
                ),
              ),
            ),

            _sectionTitle('متوسط جودة التسميع لكل حلقة'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  height: 200,
                  child: BarChart(BarChartData(
                    minY: 0, maxY: 10,
                    gridData: const FlGridData(show: true),
                    titlesData: const FlTitlesData(
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    barGroups: [
                      for (int i = 0; i < circleAvgs.length; i++)
                        BarChartGroupData(x: i, barRods: [
                          BarChartRodData(
                            toY: circleAvgs[i].value,
                            color: circleAvgs[i].value >= 7 ? const Color(0xFF0B7A5E) : circleAvgs[i].value >= 5.5 ? const Color(0xFFC9A227) : Colors.red.shade400,
                            width: 14, borderRadius: BorderRadius.circular(4),
                          ),
                        ]),
                    ],
                  )),
                ),
              ),
            ),

            _sectionTitle('توزيع المستويات'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(children: [
                  for (final e in levelCounts.entries)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(children: [
                        SizedBox(width: 100, child: Text(e.key, style: const TextStyle(fontSize: 13))),
                        Expanded(
                          child: LinearProgressIndicator(
                            value: e.value / totalStudents,
                            minHeight: 12,
                            backgroundColor: Colors.grey.shade200,
                            color: const Color(0xFF0B7A5E),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text('${e.value}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      ]),
                    ),
                ]),
              ),
            ),

            _sectionTitle('متوسط التسميع العام: ${recAvg.toStringAsFixed(2)}/10'),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 6),
            Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
            Text(title, style: const TextStyle(fontSize: 12, color: Colors.black54)),
          ]),
        ),
      ),
    );
  }

  Widget _sectionTitle(String t) => Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 6),
        child: Text(t, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0B7A5E))),
      );
}
