import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/enums.dart';
import '../../core/database/app_database.dart';
import '../../core/services/backup_ui_service.dart';
import '../../core/services/pdf_report_service.dart';
import '../../core/services/report_service.dart';
import '../../core/services/session_service.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/date_utils.dart' as du;
import '../../shared/providers/providers.dart';
import '../../shared/widgets/common_widgets.dart';

/// شاشة التقارير: تقرير أسبوعي/شهري لكل طالب يقارن «المطلوب» بـ«المنجز»
/// مع مخططات نسب مئوية. المعلم يرى طلاب حلقته فقط، المشرف يرى الجميع.
class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});
  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  String _period = 'week'; // week | month
  String? _halaqaId; // فلتر المشرف (null = الكل)
  Student? _student;
  DateTime _weekRef = DateTime.now();
  int _month = DateTime.now().month;
  int _year = DateTime.now().year;
  PeriodReport? _report;
  bool _loading = false;

  Future<void> _generate() async {
    final st = _student;
    if (st == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('اختر الطالب أولاً')));
      return;
    }
    setState(() { _loading = true; _report = null; });
    try {
      final svc = ref.read(reportServiceProvider);
      final r = _period == 'week'
          ? await svc.weeklyReport(st.id, _weekRef)
          : await svc.monthlyReport(st.id, _year, _month);
      if (mounted) setState(() => _report = r);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('خطأ: $e'), backgroundColor: AppColors.danger));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  bool _exportingPdf = false;

  String get _periodLabel => _period == 'week'
      ? 'أسبوع ${du.formatDate(SessionService.weekStartOf(_weekRef))}'
      : '${_monthsAr[_month - 1]} $_year';

  /// تصدير التقرير الحالي (أسبوعي/شهري) كملف PDF عربي منسّق.
  Future<void> _exportPdf() async {
    final st = _student;
    final report = _report;
    if (st == null || report == null) return;
    setState(() => _exportingPdf = true);
    try {
      final halaqa = await ref.read(halaqaRepoProvider).getById(st.halaqaId);
      if (halaqa == null) throw StateError('تعذر العثور على بيانات الحلقة');
      final title = _period == 'week' ? 'التقرير الأسبوعي' : 'التقرير الشهري';
      final bytes = await PdfReportService.buildPeriodReportPdf(
        title: title,
        periodLabel: _periodLabel,
        student: st,
        halaqa: halaqa,
        report: report,
      );
      final name = 'تقرير_${_period == 'week' ? 'أسبوعي' : 'شهري'}_${st.studentCode}.pdf';
      final ok = await BackupUiService(ref.read(backupServiceProvider))
          .deliverPublic(name, bytes, 'application/pdf');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(ok ? 'تم إنشاء ملف PDF: $name' : 'تعذر تسليم ملف PDF'),
          backgroundColor: ok ? AppColors.success : AppColors.danger,
        ));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('فشل إنشاء PDF: $e'),
          backgroundColor: AppColors.danger,
        ));
      }
    } finally {
      if (mounted) setState(() => _exportingPdf = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionProvider);
    final allHalaqas = ref.watch(halaqasProvider).valueOrNull ?? [];
    final allStudents = ref.watch(studentsProvider).valueOrNull ?? [];

    // صلاحيات: المعلم يرى حلقاته فقط
    final halaqas = session == null || session.isSupervisor
        ? allHalaqas
        : allHalaqas.where((h) => h.teacherIds.split(',').contains(session.userId)).toList();
    final students = allStudents.where((s) =>
        s.active && (_halaqaId == null ? halaqas.any((h) => h.id == s.halaqaId) : s.halaqaId == _halaqaId)).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('التقارير')),
      body: ListView(padding: const EdgeInsets.all(12), children: [
        // الفترة
        SegmentedButton<String>(
          segments: const [
            ButtonSegment(value: 'week', label: Text('أسبوعي'), icon: Icon(Icons.date_range)),
            ButtonSegment(value: 'month', label: Text('شهري'), icon: Icon(Icons.calendar_month)),
          ],
          selected: {_period},
          onSelectionChanged: (v) => setState(() { _period = v.first; _report = null; }),
        ),
        const SizedBox(height: 12),

        // فلتر الحلقة
        DropdownButtonFormField<String?>(
          initialValue: _halaqaId,
          isExpanded: true,
          decoration: const InputDecoration(labelText: 'الحلقة', border: OutlineInputBorder(), prefixIcon: Icon(Icons.groups)),
          items: [
            const DropdownMenuItem<String?>(value: null, child: Text('كل الحلقات')),
            ...halaqas.map((h) => DropdownMenuItem<String?>(value: h.id, child: Text(h.name, overflow: TextOverflow.ellipsis))),
          ],
          onChanged: (v) => setState(() { _halaqaId = v; _student = null; _report = null; }),
        ),
        const SizedBox(height: 12),

        // الطالب
        DropdownButtonFormField<Student>(
          initialValue: students.contains(_student) ? _student : null,
          isExpanded: true,
          decoration: const InputDecoration(labelText: 'الطالب', border: OutlineInputBorder(), prefixIcon: Icon(Icons.person)),
          items: students.map((s) => DropdownMenuItem(value: s, child: Text('${s.fullName} (${s.studentCode})', overflow: TextOverflow.ellipsis))).toList(),
          onChanged: (v) => setState(() { _student = v; _report = null; }),
        ),
        const SizedBox(height: 12),

        // اختيار الأسبوع/الشهر
        if (_period == 'week')
          _weekPicker()
        else
          _monthPicker(),
        const SizedBox(height: 12),

        FilledButton.icon(
          onPressed: _loading ? null : _generate,
          icon: const Icon(Icons.assessment),
          label: Text(_loading ? 'جارٍ الإنشاء...' : 'إنشاء التقرير'),
          style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
        ),
        if (_report != null && _student != null) ...[
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: _exportingPdf ? null : _exportPdf,
            icon: _exportingPdf
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.picture_as_pdf),
            label: const Text('تصدير التقرير PDF'),
            style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(44)),
          ),
        ],
        const SizedBox(height: 16),

        if (_loading) const Center(child: CircularProgressIndicator()),
        if (_report != null && _student != null) ...[
          _summaryCard(_report!),
          const SizedBox(height: 12),
          _chartCard(_report!),
          const SizedBox(height: 12),
          _barsCard(_report!),
        ],
      ]),
    );
  }

  Widget _weekPicker() {
    final days = SessionService.weekDaysOf(_weekRef);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade400), borderRadius: BorderRadius.circular(8)),
      child: Row(children: [
        IconButton(icon: const Icon(Icons.chevron_right), onPressed: () => setState(() { _weekRef = _weekRef.subtract(const Duration(days: 7)); _report = null; })),
        Expanded(child: Text('أسبوع ${du.formatDate(days.first)} — ${du.formatDate(days.last)}',
            textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold))),
        IconButton(icon: const Icon(Icons.chevron_left), onPressed: () => setState(() { _weekRef = _weekRef.add(const Duration(days: 7)); _report = null; })),
      ]),
    );
  }

  static const _monthsAr = ['يناير','فبراير','مارس','أبريل','مايو','يونيو','يوليو','أغسطس','سبتمبر','أكتوبر','نوفمبر','ديسمبر'];

  Widget _monthPicker() {
    return Row(children: [
      Expanded(child: DropdownButtonFormField<int>(
        initialValue: _month,
        decoration: const InputDecoration(labelText: 'الشهر', border: OutlineInputBorder()),
        items: [for (int m = 1; m <= 12; m++) DropdownMenuItem(value: m, child: Text(_monthsAr[m - 1]))],
        onChanged: (v) => setState(() { _month = v ?? _month; _report = null; }),
      )),
      const SizedBox(width: 8),
      Expanded(child: DropdownButtonFormField<int>(
        initialValue: _year,
        decoration: const InputDecoration(labelText: 'السنة', border: OutlineInputBorder()),
        items: [for (int y = DateTime.now().year - 2; y <= DateTime.now().year + 1; y++) DropdownMenuItem(value: y, child: Text('$y'))],
        onChanged: (v) => setState(() { _year = v ?? _year; _report = null; }),
      )),
    ]);
  }

  String _fmt(double v) => v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(1);

  Widget _summaryCard(PeriodReport r) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('تقرير ${_student!.fullName} — ${_period == 'week' ? 'أسبوعي' : 'شهري'}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.primary)),
          const Divider(),
          Row(children: [
            _cell('المطلوب (صفحات)', _fmt(r.requiredTotal)),
            _cell('المنجز (صفحات)', _fmt(r.doneTotal)),
            _cell('النسبة الكلية', '${r.overallPct.toStringAsFixed(0)}%'),
          ]),
          const SizedBox(height: 8),
          Row(children: [
            _cell('أيام مسجلة', '${r.daysRecorded}'),
            _cell('جُمَع مسجلة', '${r.fridaysRecorded}'),
            _cell('التقدير الأسبوعي', r.weeklyGrade?.ar ?? '—',
                color: r.weeklyGrade != null ? gradeColor(r.weeklyGrade!.name) : null),
          ]),
        ]),
      ),
    );
  }

  Widget _cell(String label, String value, {Color? color}) => Expanded(
        child: Column(children: [
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.black54)),
          const SizedBox(height: 2),
          Text(value, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: color ?? AppColors.primary)),
        ]),
      );

  /// مخطط دائري: المنجز مقابل المتبقي من المطلوب
  Widget _chartCard(PeriodReport r) {
    final done = r.doneTotal;
    final remain = (r.requiredTotal - done).clamp(0.0, double.infinity);
    final pct = r.overallPct;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('نسبة الإنجاز الكلية', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
          const SizedBox(height: 8),
          SizedBox(
            height: 190,
            child: Stack(alignment: Alignment.center, children: [
              PieChart(PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 55,
                sections: [
                  PieChartSectionData(
                    value: done <= 0 ? 0.001 : done,
                    color: pct >= 90 ? AppColors.success : pct >= 60 ? AppColors.gold : AppColors.danger,
                    title: '', radius: 30,
                  ),
                  PieChartSectionData(
                    value: remain <= 0 ? 0.001 : remain,
                    color: Colors.grey.shade300,
                    title: '', radius: 30,
                  ),
                ],
              )),
              Column(mainAxisSize: MainAxisSize.min, children: [
                Text('${pct.toStringAsFixed(0)}%',
                    style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.primary)),
                const Text('من المطلوب', style: TextStyle(fontSize: 11, color: Colors.black54)),
              ]),
            ]),
          ),
          const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            _Legend(color: AppColors.primary, label: 'المنجز'),
            SizedBox(width: 16),
            _Legend(color: Color(0xFFE0E0E0), label: 'المتبقي'),
          ]),
        ]),
      ),
    );
  }

  /// أشرطة نسب الإنجاز لكل بند
  Widget _barsCard(PeriodReport r) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('تفاصيل البنود (المنجز / المطلوب)', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
          const SizedBox(height: 10),
          _bar('الجديد', r.doneNew, r.requiredNew, r.newPct),
          _bar('حديث العهد', r.doneRecent, r.requiredRecent, r.recentPct),
          _bar('المراجعة الصغرى', r.doneMinor, r.requiredMinor, r.minorPct),
          _bar('المراجعة الكبرى', r.doneMajor, r.requiredMajor, r.majorPct),
          _bar('ربط الجمعة', r.doneFriday, r.requiredFriday, r.fridayPct),
        ]),
      ),
    );
  }

  Widget _bar(String label, double done, double req, double pct) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(children: [
        SizedBox(width: 100, child: Text(label, style: const TextStyle(fontSize: 12))),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (pct / 100).clamp(0.0, 1.0), minHeight: 14,
              backgroundColor: Colors.grey.shade200,
              color: pct >= 90 ? AppColors.success : pct >= 60 ? AppColors.gold : AppColors.danger,
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(width: 110, child: Text('${_fmt(done)}/${_fmt(req)} (${pct.toStringAsFixed(0)}%)',
            style: const TextStyle(fontSize: 11), textAlign: TextAlign.end)),
      ]),
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String label;
  const _Legend({required this.color, required this.label});
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Container(width: 12, height: 12, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3))),
      const SizedBox(width: 4),
      Text(label, style: const TextStyle(fontSize: 11)),
    ]);
  }
}
