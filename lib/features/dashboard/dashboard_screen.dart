import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';
import '../../core/database/app_database.dart';
import '../../core/services/session_service.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/providers/providers.dart';
import '../../shared/widgets/common_widgets.dart';

// ─── نموذج الإحصاءات المجمعة من الخادم (بدل سحب كل السجلات) ───

class StrugglingStudent {
  final String id;
  final String fullName;
  final String halaqaId;
  final int recordCount;
  final double repeatRatio;
  const StrugglingStudent({
    required this.id,
    required this.fullName,
    required this.halaqaId,
    required this.recordCount,
    required this.repeatRatio,
  });
}

class DashboardStats {
  final int todayRecordCount;
  final Set<String> halaqaIdsWithRecordsToday;
  final double totalNewPages;
  final int repeatStudentCount;
  final Map<String, int> gradeCounts;

  /// 12 قيمة: صفحات الجديد لكل أسبوع (الأقدم أولاً)
  final List<double> weeklyNewPages;

  /// إجمالي صفحات الجديد لكل حلقة (معرّف الحلقة ← الصفحات)
  final Map<String, double> halaqaNewPages;

  final List<StrugglingStudent> strugglingStudents;

  const DashboardStats({
    required this.todayRecordCount,
    required this.halaqaIdsWithRecordsToday,
    required this.totalNewPages,
    required this.repeatStudentCount,
    required this.gradeCounts,
    required this.weeklyNewPages,
    required this.halaqaNewPages,
    required this.strugglingStudents,
  });

  static const empty = DashboardStats(
    todayRecordCount: 0,
    halaqaIdsWithRecordsToday: {},
    totalNewPages: 0,
    repeatStudentCount: 0,
    gradeCounts: {},
    weeklyNewPages: [],
    halaqaNewPages: {},
    strugglingStudents: [],
  );

  /// [from] = بداية نافذة الأسابيع الـ 12 (سبت)، تُستخدم لملء الأسابيع الفارغة بصفر
  factory DashboardStats.fromJson(Map<String, dynamic> j, DateTime from) {
    String fmt(DateTime d) =>
        '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

    final rawWeekly = <String, double>{};
    for (final w in (j['weeklyNewPages'] as List? ?? [])) {
      final m = w as Map<String, dynamic>;
      rawWeekly[(m['weekStart'] ?? '') as String] = ((m['pages'] ?? 0) as num).toDouble();
    }
    final weekly = List<double>.generate(
        12, (i) => rawWeekly[fmt(from.add(Duration(days: 7 * i)))] ?? 0.0);

    return DashboardStats(
      todayRecordCount: (j['todayRecordCount'] ?? 0) as int,
      halaqaIdsWithRecordsToday:
          ((j['halaqaIdsWithRecordsToday'] as List? ?? []).cast<String>()).toSet(),
      totalNewPages: ((j['totalNewPages'] ?? 0) as num).toDouble(),
      repeatStudentCount: (j['repeatStudentCount'] ?? 0) as int,
      gradeCounts: ((j['gradeCounts'] as Map? ?? {})
          .map((k, v) => MapEntry(k as String, (v as num).toInt()))),
      weeklyNewPages: weekly,
      halaqaNewPages: ((j['halaqaNewPages'] as Map? ?? {})
          .map((k, v) => MapEntry(k as String, (v as num).toDouble()))),
      strugglingStudents: [
        for (final s in (j['strugglingStudents'] as List? ?? []))
          StrugglingStudent(
            id: (s['id'] ?? '') as String,
            fullName: (s['fullName'] ?? '') as String,
            halaqaId: (s['halaqaId'] ?? '') as String,
            recordCount: (s['recordCount'] ?? 0) as int,
            repeatRatio: ((s['repeatRatio'] ?? 0) as num).toDouble(),
          ),
      ],
    );
  }
}

/// إحصاءات اللوحة — تُجمع في الخادم وتُحسب حسب دور المستخدم:
/// المعلم: حلقاته فقط، المشرف: كل الحلقات.
final dashboardStatsProvider = FutureProvider<DashboardStats>((ref) async {
  final session = ref.watch(sessionProvider);
  if (session == null) return DashboardStats.empty;

  String fmt(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  final halaqas = await ref.watch(halaqasProvider.future);
  final myIds = session.isTeacher
      ? halaqas
          .where((h) =>
              h.teacherIds.split(',').map((e) => e.trim()).contains(session.userId))
          .map((h) => h.id)
          .toList()
      : const <String>[];
  // معلم بلا حلقات مسندة: لا بيانات لعرضها
  if (session.isTeacher && myIds.isEmpty) return DashboardStats.empty;

  final now = DateTime.now();
  final weekStart = SessionService.weekStartOf(now);
  final from = weekStart.subtract(const Duration(days: 7 * 11));

  final j = await ref.read(apiClientProvider).getOne('/api/stats', query: {
    'todayKey': fmt(now),
    'from': fmt(from),
    if (myIds.isNotEmpty) 'halaqaIds': myIds.join(','),
  });
  if (j == null) return DashboardStats.empty;
  return DashboardStats.fromJson(j, from);
});

// لوحة المشرف (كل الحلقات) أو المعلم (حلقته فقط)
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);
    final halaqasAsync = ref.watch(halaqasProvider);
    final studentsAsync = ref.watch(studentsProvider);
    final statsAsync = ref.watch(dashboardStatsProvider);

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
          data: (students) => statsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => ErrorState(message: 'خطأ في تحميل الإحصاءات: $e'),
            data: (stats) => _buildBody(context, ref, session, halaqas, students, stats),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, DemoSession? session,
      List<Halaqa> halaqas, List<Student> students, DashboardStats stats) {
    final isTeacher = session?.isTeacher ?? false;
    // فلترة القوائم حسب الدور (السجلات تُفلتر في الخادم عبر /api/stats)
    final myHalaqas = isTeacher
        ? halaqas
            .where((h) => h.teacherIds.split(',').map((e) => e.trim()).contains(session!.userId))
            .toList()
        : halaqas;
    final myHalaqaIds = myHalaqas.map((h) => h.id).toSet();
    final myStudents = isTeacher
        ? students.where((s) => myHalaqaIds.contains(s.halaqaId)).toList()
        : students;

    final halaqasNoData = myHalaqas
        .where((h) => h.active && !stats.halaqaIdsWithRecordsToday.contains(h.id))
        .length;
    final gradedTotal = stats.gradeCounts.values.fold(0, (a, b) => a + b);
    final weeklyNew = stats.weeklyNewPages;

    // مقارنة الحلقات (للمشرف): إجمالي صفحات الجديد
    final halaqaStats = myHalaqas
        .map((h) => MapEntry(h, stats.halaqaNewPages[h.id] ?? 0.0))
        .toList()
      ..sort((MapEntry<Halaqa, double> a, MapEntry<Halaqa, double> b) =>
          b.value.compareTo(a.value));
    final maxPages = halaqaStats.isEmpty
        ? 1.0
        : (halaqaStats.first.value <= 0 ? 1.0 : halaqaStats.first.value);

    return ListView(padding: const EdgeInsets.all(12), children: [
      Row(children: [
        Expanded(child: StatCard(title: 'الطلاب', value: '${myStudents.length}', icon: Icons.people, color: AppColors.primary,
            onTap: () => context.go('/home/students'))),
        Expanded(child: StatCard(title: isTeacher ? 'حلقتي' : 'الحلقات', value: '${myHalaqas.length}', icon: Icons.groups, color: AppColors.secondary,
            onTap: () => context.go('/home/halaqas'))),
        Expanded(child: StatCard(title: 'سجلات اليوم', value: '${stats.todayRecordCount}', icon: Icons.edit_note, color: AppColors.success)),
      ]),
      Row(children: [
        Expanded(child: StatCard(title: 'حفظ جديد (صفحات)', value: stats.totalNewPages.toStringAsFixed(1), icon: Icons.auto_stories, color: AppColors.gold)),
        Expanded(child: StatCard(title: 'طلاب «إعادة»', value: '${stats.repeatStudentCount}', icon: Icons.flag, color: AppColors.danger)),
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
                  for (final e in stats.gradeCounts.entries)
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

      if (stats.strugglingStudents.isNotEmpty) ...[
        _title('طلاب يحتاجون متابعة', 'تقدير «إعادة» في 40% أو أكثر من سجلاتهم'),
        Card(child: Column(children: [
          for (final s in stats.strugglingStudents)
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
