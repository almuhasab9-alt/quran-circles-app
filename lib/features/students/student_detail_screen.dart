import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/enums.dart';
import '../../core/database/app_database.dart';
import '../../core/services/quran_meta.dart';
import '../../core/services/report_service.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/date_utils.dart';
import '../../shared/providers/providers.dart';
import '../../shared/widgets/common_widgets.dart';

final studentDetailProvider = FutureProvider.family<Student?, String>((ref, id) async {
  ref.watch(dataVersionProvider);
  final all = await ref.read(studentRepoProvider).getAll();
  return all.where((s) => s.id == id).firstOrNull;
});

final studentRecordsProvider = FutureProvider.family<List<DailyRecord>, String>((ref, studentId) async {
  ref.watch(dataVersionProvider);
  final records = await ref.read(recordRepoProvider).byStudent(studentId);
  records.sort((a, b) => b.dateKey.compareTo(a.dateKey));
  return records;
});

final studentWeeklyReportProvider = FutureProvider.family<PeriodReport, String>((ref, studentId) async {
  ref.watch(dataVersionProvider);
  return ref.read(reportServiceProvider).weeklyReport(studentId, DateTime.now());
});

final studentMonthlyReportProvider = FutureProvider.family<PeriodReport, String>((ref, studentId) async {
  ref.watch(dataVersionProvider);
  final now = DateTime.now();
  return ref.read(reportServiceProvider).monthlyReport(studentId, now.year, now.month);
});

class StudentDetailScreen extends ConsumerWidget {
  final String studentId;
  const StudentDetailScreen({super.key, required this.studentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentAsync = ref.watch(studentDetailProvider(studentId));
    return Scaffold(
      appBar: AppBar(
        title: studentAsync.when(
          data: (s) => Text(s?.fullName ?? 'الطالب'),
          loading: () => const Text('الطالب'),
          error: (_, __) => const Text('الطالب'),
        ),
      ),
      body: studentAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => ErrorState(message: '$e'),
        data: (s) => s == null ? const EmptyState(message: 'الطالب غير موجود') : _StudentBody(student: s),
      ),
    );
  }
}

class _StudentBody extends ConsumerWidget {
  final Student student;
  const _StudentBody({required this.student});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordsAsync = ref.watch(studentRecordsProvider(student.id));
    final weeklyAsync = ref.watch(studentWeeklyReportProvider(student.id));
    final monthlyAsync = ref.watch(studentMonthlyReportProvider(student.id));
    final halaqas = ref.watch(halaqasProvider).valueOrNull ?? [];
    final halaqa = halaqas.where((h) => h.id == student.halaqaId).firstOrNull;

    return recordsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => ErrorState(message: '$e'),
      data: (records) {
        final week = weeklyAsync.valueOrNull;
        final month = monthlyAsync.valueOrNull;
        final lastGrade = records.isEmpty ? '' : records.first.grade;
        final totalNew = records.fold<double>(0.0, (a, r) => a + r.newPages);

        // منحنى صفحات الحفظ الجديد — آخر 8 أسابيع
        final weeklyNew = <double>[];
        final now = DateTime.now();
        for (var w = 7; w >= 0; w--) {
          final wEnd = now.subtract(Duration(days: w * 7));
          final wStart = wEnd.subtract(const Duration(days: 6));
          final slice = records.where((r) => !r.date.isBefore(wStart) && !r.date.isAfter(wEnd));
          weeklyNew.add(slice.fold<double>(0.0, (a, r) => a + r.newPages));
        }

        return ListView(padding: const EdgeInsets.all(12), children: [
          // بطاقة الهوية
          Card(child: Padding(padding: const EdgeInsets.all(16), child: Row(children: [
            CircleAvatar(radius: 26, backgroundColor: AppColors.primary,
                child: Text(student.fullName.isNotEmpty ? student.fullName[0] : '؟', style: const TextStyle(color: Colors.white, fontSize: 22))),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(student.fullName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text('${student.studentCode} • ${halaqa?.name ?? "—"}', overflow: TextOverflow.ellipsis),
              Text('المستوى: ${student.level}', style: const TextStyle(fontSize: 12)),
            ])),
            if (lastGrade.isNotEmpty)
              Chip(backgroundColor: gradeColor(lastGrade).withValues(alpha: 0.15),
                  label: Text(gradeAr(lastGrade), style: TextStyle(color: gradeColor(lastGrade), fontWeight: FontWeight.bold))),
          ]))),
          const SizedBox(height: 8),

          // إحصائيات
          GridView.count(crossAxisCount: 3, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), childAspectRatio: 1.15, children: [
            StatCard(title: 'حفظ جديد (الكل)', value: totalNew.toStringAsFixed(1), icon: Icons.auto_stories, color: AppColors.primary),
            StatCard(title: 'إنجاز الأسبوع', value: week == null ? '—' : '${week.overallPct.toStringAsFixed(0)}%', icon: Icons.today, color: AppColors.success),
            StatCard(title: 'إنجاز الشهر', value: month == null ? '—' : '${month.overallPct.toStringAsFixed(0)}%', icon: Icons.calendar_month, color: AppColors.secondary),
            StatCard(title: 'أيام مسجلة', value: '${records.where((r) => !r.isFriday).length}', icon: Icons.event_note, color: AppColors.gold),
            StatCard(title: 'أيام الجمعة', value: '${records.where((r) => r.isFriday).length}', icon: Icons.star, color: AppColors.warning),
            StatCard(title: 'تقدير الأسبوع', value: week?.weeklyGrade?.ar ?? '—', icon: Icons.grade, color: AppColors.primary),
          ]),
          const SizedBox(height: 8),

          // نسب الإنجاز مقابل المطلوب
          if (week != null) _pctCard('التقرير الأسبوعي (مقابل المطلوب)', week),
          if (month != null) _pctCard('التقرير الشهري (مقابل المطلوب)', month),

          // منحنى الحفظ الجديد
          Card(child: Padding(padding: const EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('صفحات الحفظ الجديد — آخر 8 أسابيع', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            SizedBox(height: 170, child: LineChart(LineChartData(
              minY: 0,
              gridData: const FlGridData(show: true),
              titlesData: const FlTitlesData(rightTitles: AxisTitles(), topTitles: AxisTitles(), bottomTitles: AxisTitles()),
              borderData: FlBorderData(show: false),
              lineBarsData: [LineChartBarData(
                isCurved: true, color: AppColors.primary, barWidth: 3, dotData: const FlDotData(show: true),
                spots: [for (var i = 0; i < weeklyNew.length; i++) FlSpot(i.toDouble(), weeklyNew[i])],
              )],
            ))),
          ]))),
          const SizedBox(height: 8),

          FilledButton.icon(
            onPressed: () => context.push('/halaqa/${student.halaqaId}/entry?student=${student.id}'),
            icon: const Icon(Icons.edit_note), label: const Text('تسجيل تسميع جديد'),
            style: FilledButton.styleFrom(backgroundColor: AppColors.gold),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => context.push('/halaqa/${student.halaqaId}/sheet?student=${student.id}'),
            icon: const Icon(Icons.table_chart), label: const Text('عرض كشف التسميع الأسبوعي'),
          ),
          const SizedBox(height: 12),

          const Text('آخر السجلات', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ...records.take(10).map((r) => Card(
            margin: const EdgeInsets.symmetric(vertical: 3),
            child: ListTile(
              dense: true,
              leading: Icon(r.isFriday ? Icons.star : Icons.menu_book,
                  color: r.isFriday ? AppColors.gold : AppColors.primary),
              title: Text('${r.date.weekdayAr} — ${formatDateAr(r.date)}${r.isFriday ? ' (ربط)' : ''}', overflow: TextOverflow.ellipsis),
              subtitle: Text(_recordSummary(r), overflow: TextOverflow.ellipsis, maxLines: 2),
              trailing: r.grade.isNotEmpty
                  ? Chip(visualDensity: VisualDensity.compact,
                      backgroundColor: gradeColor(r.grade).withValues(alpha: 0.15),
                      label: Text(gradeAr(r.grade), style: TextStyle(fontSize: 10, color: gradeColor(r.grade))))
                  : null,
            ),
          )),
          const SizedBox(height: 24),
        ]);
      },
    );
  }

  String _recordSummary(DailyRecord r) {
    if (r.isFriday) {
      final parts = <String>[];
      if (r.recentFromPage > 0) parts.add('حديث ${r.recentFromPage}-${r.recentToPage}');
      if (r.minorFromPage > 0) parts.add('صغرى ${r.minorFromPage}-${r.minorToPage}');
      if (r.majorFromPage > 0) parts.add('كبرى ${r.majorFromPage}-${r.majorToPage}');
      return parts.isEmpty ? 'ربط جمعة' : parts.join(' • ');
    }
    final newPart = r.newFromSurah > 0
        ? 'جديد: ${QuranMeta.surahName(r.newFromSurah)} ${r.newFromAyah}—${r.newToAyah} (${r.newPages.toStringAsFixed(2)} ص)'
        : '';
    final rep = r.repetition > 0 ? ' • تكرار ${r.repetition}' : '';
    return '$newPart$rep';
  }

  Widget _pctCard(String title, PeriodReport r) {
    return Card(child: Padding(padding: const EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
      const SizedBox(height: 8),
      _bar('الجديد', r.doneNew, r.requiredNew, r.newPct),
      _bar('حديث العهد', r.doneRecent, r.requiredRecent, r.recentPct),
      _bar('الصغرى', r.doneMinor, r.requiredMinor, r.minorPct),
      _bar('الكبرى', r.doneMajor, r.requiredMajor, r.majorPct),
      _bar('ربط الجمعة', r.doneFriday, r.requiredFriday, r.fridayPct),
      const Divider(),
      _bar('الإجمالي', r.doneTotal, r.requiredTotal, r.overallPct, bold: true),
    ])));
  }

  String _fmt(double v) => v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(1);

  Widget _bar(String label, double done, double req, double pct, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(children: [
        SizedBox(width: 92, child: Text(label, style: TextStyle(fontSize: 12, fontWeight: bold ? FontWeight.bold : FontWeight.normal))),
        Expanded(child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: (pct / 100).clamp(0.0, 1.0), minHeight: bold ? 14 : 10,
            backgroundColor: Colors.grey.shade200,
            color: pct >= 90 ? AppColors.success : pct >= 60 ? AppColors.gold : AppColors.danger,
          ),
        )),
        const SizedBox(width: 8),
        SizedBox(width: 96, child: Text('${_fmt(done)}/${_fmt(req)} (${pct.toStringAsFixed(0)}%)',
            style: TextStyle(fontSize: 10, fontWeight: bold ? FontWeight.bold : FontWeight.normal), textAlign: TextAlign.end)),
      ]),
    );
  }
}
