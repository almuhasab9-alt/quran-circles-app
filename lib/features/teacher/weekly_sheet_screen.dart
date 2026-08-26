import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/enums.dart';
import '../../core/database/app_database.dart';
import '../../core/services/pdf_report_service.dart';
import '../../core/services/quran_meta.dart';
import '../../core/services/report_service.dart';
import '../../core/services/session_service.dart';
import '../../core/services/backup_ui_service.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/date_utils.dart' as du;
import '../../shared/providers/providers.dart';
import '../../shared/widgets/common_widgets.dart';

/// كشف «متابعة الحفظ والمراجعة» — جدول أسبوعي لطالب واحد يطابق الكشف الورقي.
/// الأعمدة (RTL): اليوم والتاريخ | الجديد (من، إلى) | التقدير | التكرار |
/// حديث العهد (من، إلى) | الصغرى (من، إلى) | الكبرى (من، إلى) | الملاحظات
class WeeklySheetScreen extends ConsumerStatefulWidget {
  final String halaqaId;
  final String? studentId;
  const WeeklySheetScreen({super.key, required this.halaqaId, this.studentId});

  @override
  ConsumerState<WeeklySheetScreen> createState() => _WeeklySheetScreenState();
}

class _WeeklySheetScreenState extends ConsumerState<WeeklySheetScreen> {
  Student? _student;
  DateTime _weekRef = DateTime.now();
  List<DailyRecord> _records = [];
  WeeklyPlan? _plan;
  PeriodReport? _report;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final students = await ref.read(studentRepoProvider).byHalaqa(widget.halaqaId);
    final st = widget.studentId != null
        ? students.where((s) => s.id == widget.studentId).firstOrNull ?? students.firstOrNull
        : students.firstOrNull;
    if (st == null) { setState(() { _student = null; _loading = false; }); return; }
    // القراءة من السحابة: سجلات الأسبوع + خطط الطالب + التقرير المحسوب منهما
    final weekStart = SessionService.weekStartOf(_weekRef);
    final weekEnd = weekStart.add(const Duration(days: 6));
    final recs = await ref.read(recordRepoProvider).inRange(st.id, weekStart, weekEnd);
    final allPlans = await ref.read(weeklyPlanRepoProvider).byStudent(st.id);
    final weekKey = du.dateKeyOf(weekStart);
    final plan = allPlans.where((p) => p.weekStartKey == weekKey).firstOrNull;
    final report = ref.read(reportServiceProvider)
        .buildFromData(recs: recs, plans: allPlans, from: weekStart, to: weekEnd);
    if (!mounted) return;
    setState(() {
      _student = st;
      _records = recs;
      _plan = plan;
      _report = report;
      _loading = false;
    });
  }

  void _changeWeek(int delta) {
    _weekRef = _weekRef.add(Duration(days: 7 * delta));
    _load();
  }

  bool _exportingPdf = false;

  /// تصدير كشف المتابعة الأسبوعي كملف PDF عربي منسّق.
  Future<void> _exportPdf() async {
    final st = _student;
    final report = _report;
    if (st == null || report == null) return;
    setState(() => _exportingPdf = true);
    try {
      final halaqa = await ref.read(halaqaRepoProvider).getById(widget.halaqaId);
      final session = ref.read(sessionProvider);
      User? teacher;
      if (session != null) {
        teacher = await ref.read(userRepoProvider).getById(session.userId);
      }
      teacher ??= (await ref.read(userRepoProvider).all()).firstOrNull;
      if (halaqa == null || teacher == null) {
        throw StateError('تعذر العثور على بيانات الحلقة أو المعلم');
      }
      final bytes = await PdfReportService.buildWeeklySheetPdf(
        student: st,
        halaqa: halaqa,
        teacher: teacher,
        weekRef: _weekRef,
        records: _records,
        report: report,
      );
      final name = 'كشف_متابعة_${st.studentCode}_${du.formatDate(SessionService.weekStartOf(_weekRef))}.pdf';
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
    final weekDays = SessionService.weekDaysOf(_weekRef);
    final byKey = {for (final r in _records) r.dateKey: r};
    final weekLabel = 'أسبوع ${du.formatDate(weekDays.first)} — ${du.formatDate(weekDays.last)}';

    return Scaffold(
      appBar: AppBar(
        title: const Text('كشف متابعة الحفظ والمراجعة'),
        actions: [
          if (_student != null)
            IconButton(
              icon: const Icon(Icons.picture_as_pdf),
              tooltip: 'تصدير PDF',
              onPressed: _exportingPdf ? null : _exportPdf,
            ),
          if (_student != null)
            IconButton(
              icon: const Icon(Icons.edit_note),
              tooltip: 'تسجيل يومي',
              onPressed: () async {
                await context.push('/halaqa/${widget.halaqaId}/entry?student=${_student!.id}');
                _load();
              },
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _student == null
              ? const EmptyState(message: 'لا يوجد طلاب في الحلقة')
              : Column(children: [
                  // رأس الكشف: الطالب + تنقل الأسابيع
                  Container(
                    color: AppColors.primary.withValues(alpha: 0.07),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Column(children: [
                      Row(children: [
                        const Icon(Icons.person, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Expanded(child: Text(_student!.fullName,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primary))),
                        Text(_student!.studentCode, style: const TextStyle(color: Colors.black54, fontSize: 12)),
                      ]),
                      const SizedBox(height: 6),
                      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        IconButton(icon: const Icon(Icons.chevron_right), onPressed: () => _changeWeek(-1), tooltip: 'الأسبوع السابق'),
                        Expanded(child: Text(weekLabel, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold))),
                        IconButton(icon: const Icon(Icons.chevron_left), onPressed: () => _changeWeek(1), tooltip: 'الأسبوع التالي'),
                      ]),
                    ]),
                  ),

                  // الجدول (قابل للتمرير أفقياً)
                  Expanded(
                    child: SingleChildScrollView(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            _table(weekDays, byKey),
                            const SizedBox(height: 8),
                            if (_report != null) _weeklyReportCard(_report!),
                          ]),
                        ),
                      ),
                    ),
                  ),
                ]),
      floatingActionButton: _student == null ? null : FloatingActionButton.extended(
        onPressed: () => _editPlan(),
        backgroundColor: AppColors.gold,
        icon: const Icon(Icons.flag, color: Colors.white),
        label: const Text('المطلوب', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  // ---------- الجدول ----------
  static const _hStyle = TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11);
  static const _cStyle = TextStyle(fontSize: 11);

  Widget _hCell(String t, {double w = 70}) => Container(
        width: w, padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        color: AppColors.primary,
        alignment: Alignment.center,
        child: Text(t, style: _hStyle, textAlign: TextAlign.center),
      );

  Widget _cCell(String t, {double w = 70, Color? bg, Color? fg, bool bold = false}) => Container(
        width: w, padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        color: bg,
        alignment: Alignment.center,
        child: Text(t, style: _cStyle.copyWith(color: fg, fontWeight: bold ? FontWeight.bold : FontWeight.normal), textAlign: TextAlign.center),
      );

  Widget _table(List<DateTime> weekDays, Map<String, DailyRecord> byKey) {
    final rows = <Widget>[];
    // صف العناوين
    rows.add(Row(children: [
      _hCell('اليوم والتاريخ', w: 96),
      _hCell('الجديد\nمن — إلى', w: 120),
      _hCell('التقدير', w: 66),
      _hCell('التكرار', w: 52),
      _hCell('حديث العهد\nمن — إلى', w: 84),
      _hCell('الصغرى\nمن — إلى', w: 84),
      _hCell('الكبرى\nمن — إلى', w: 84),
      _hCell('الملاحظات', w: 120),
    ]));

    for (final day in weekDays) {
      final isF = day.weekday == DateTime.friday;
      final rec = byKey[du.dateKeyOf(day)];
      final bg = isF ? AppColors.gold.withValues(alpha: 0.10) : null;

      if (isF) {
        // صف الجمعة: ربط الجمعة — مراجعة فقط
        final fridayPages = rec == null
            ? ''
            : '${rec.recentFromPage > 0 ? '${rec.recentFromPage}-${rec.recentToPage}' : ''}'
              '${rec.minorFromPage > 0 ? '  ${rec.minorFromPage}-${rec.minorToPage}' : ''}'
              '${rec.majorFromPage > 0 ? '  ${rec.majorFromPage}-${rec.majorToPage}' : ''}';
        rows.add(Row(children: [
          _cCell('الجمعة\n${du.formatDate(day)}', w: 96, bg: bg, bold: true),
          _cCell('ربط الجمعة (مراجعة فقط)', w: 120, bg: bg, fg: AppColors.primary, bold: true),
          _cCell('—', w: 66, bg: bg),
          _cCell('—', w: 52, bg: bg),
          _cCell(rec != null && rec.recentFromPage > 0 ? '${rec.recentFromPage} — ${rec.recentToPage}' : '—', w: 84, bg: bg),
          _cCell(rec != null && rec.minorFromPage > 0 ? '${rec.minorFromPage} — ${rec.minorToPage}' : '—', w: 84, bg: bg),
          _cCell(rec != null && rec.majorFromPage > 0 ? '${rec.majorFromPage} — ${rec.majorToPage}' : '—', w: 84, bg: bg),
          _cCell(rec?.notes.isNotEmpty == true ? rec!.notes : (fridayPages.isEmpty ? '' : ''), w: 120, bg: bg),
        ]));
      } else {
        final newRange = rec == null || rec.newFromSurah == 0
            ? '—'
            : '${QuranMeta.surahName(rec.newFromSurah)} ${rec.newFromAyah}\n— ${QuranMeta.surahName(rec.newToSurah)} ${rec.newToAyah}';
        final newPages = rec == null || rec.newPages <= 0 ? '' : ' (${rec.newPages.toStringAsFixed(2)} ص)';
        rows.add(Row(children: [
          _cCell('${day.weekdayAr}\n${du.formatDate(day)}', w: 96, bold: true),
          _cCell(rec == null ? 'لم يُسجَّل' : '$newRange$newPages', w: 120,
              fg: rec == null ? Colors.red.shade300 : null),
          _cCell(rec == null || rec.grade.isEmpty ? '—' : gradeAr(rec.grade), w: 66,
              fg: rec != null ? gradeColor(rec.grade) : null, bold: rec != null && rec.grade.isNotEmpty),
          _cCell(rec == null || rec.repetition == 0 ? '—' : '${rec.repetition}', w: 52),
          _cCell(rec == null || rec.recentFromPage == 0 ? '—' : '${rec.recentFromPage} — ${rec.recentToPage}', w: 84),
          _cCell(rec == null || rec.minorFromPage == 0 ? '—' : '${rec.minorFromPage} — ${rec.minorToPage}', w: 84),
          _cCell(rec == null || rec.majorFromPage == 0 ? '—' : '${rec.majorFromPage} — ${rec.majorToPage}', w: 84),
          _cCell(rec?.notes.isNotEmpty == true ? rec!.notes : '—', w: 120),
        ]));
      }
      rows.add(const Divider(height: 1, thickness: 0.4));
    }
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade400)),
      child: Column(children: rows),
    );
  }

  // ---------- التقرير الأسبوعي ----------
  Widget _weeklyReportCard(PeriodReport r) {
    const totalW = 706.0;
    return Container(
      width: totalW,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primary, width: 1.4),
        borderRadius: BorderRadius.circular(8),
        color: AppColors.primary.withValues(alpha: 0.04),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('التقرير الأسبوعي', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.primary)),
        const SizedBox(height: 8),
        Row(children: [
          _repCell('المطلوب', _fmt(r.requiredTotal)),
          _repCell('المنجز', _fmt(r.doneTotal)),
          _repCell('النسبة', '${r.overallPct.toStringAsFixed(0)}%'),
          _repCell('التقدير الأسبوعي', r.weeklyGrade?.ar ?? '—'),
          _repCell('ربط الجمعة (صفحات)', _fmt(r.doneFriday)),
        ]),
        const SizedBox(height: 8),
        _barRow('الجديد', r.doneNew, r.requiredNew, r.newPct),
        _barRow('حديث العهد', r.doneRecent, r.requiredRecent, r.recentPct),
        _barRow('الصغرى', r.doneMinor, r.requiredMinor, r.minorPct),
        _barRow('الكبرى', r.doneMajor, r.requiredMajor, r.majorPct),
        _barRow('ربط الجمعة', r.doneFriday, r.requiredFriday, r.fridayPct),
      ]),
    );
  }

  String _fmt(double v) => v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(1);

  Widget _repCell(String label, String value) => Expanded(
        child: Column(children: [
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.black54)),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primary)),
        ]),
      );

  Widget _barRow(String label, double done, double req, double pct) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(children: [
        SizedBox(width: 90, child: Text(label, style: const TextStyle(fontSize: 11))),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (pct / 100).clamp(0.0, 1.0), minHeight: 12,
              backgroundColor: Colors.grey.shade200,
              color: pct >= 90 ? AppColors.success : pct >= 60 ? AppColors.gold : AppColors.danger,
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(width: 110, child: Text('${_fmt(done)}/${_fmt(req)} (${pct.toStringAsFixed(0)}%)',
            style: const TextStyle(fontSize: 10), textAlign: TextAlign.end)),
      ]),
    );
  }

  // ---------- تحرير المطلوب ----------
  Future<void> _editPlan() async {
    if (_student == null) return;
    final p = _plan;
    final newCtrl = TextEditingController(text: _fmt(p?.requiredNewPages ?? 0));
    final recentCtrl = TextEditingController(text: _fmt(p?.requiredRecentPages ?? 0));
    final minorCtrl = TextEditingController(text: _fmt(p?.requiredMinorPages ?? 0));
    final majorCtrl = TextEditingController(text: _fmt(p?.requiredMajorPages ?? 0));
    final fridayCtrl = TextEditingController(text: _fmt(p?.requiredFridayPages ?? 0));

    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('المطلوب الأسبوعي (بالصفحات)'),
        content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
          _planField('الجديد', newCtrl),
          _planField('حديث العهد', recentCtrl),
          _planField('المراجعة الصغرى', minorCtrl),
          _planField('المراجعة الكبرى', majorCtrl),
          _planField('ربط الجمعة', fridayCtrl),
        ])),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('إلغاء')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('حفظ')),
        ],
      ),
    );
    if (saved == true) {
      await ref.read(reportServiceProvider).saveWeeklyPlan(
        studentId: _student!.id, halaqaId: widget.halaqaId, anyDayInWeek: _weekRef,
        requiredNewPages: double.tryParse(newCtrl.text) ?? 0,
        requiredRecentPages: double.tryParse(recentCtrl.text) ?? 0,
        requiredMinorPages: double.tryParse(minorCtrl.text) ?? 0,
        requiredMajorPages: double.tryParse(majorCtrl.text) ?? 0,
        requiredFridayPages: double.tryParse(fridayCtrl.text) ?? 0,
      );
      bumpDataVersion(ref);
      _load();
    }
  }

  Widget _planField(String label, TextEditingController c) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: TextField(
          controller: c, keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: label, border: const OutlineInputBorder(), isDense: true, suffixText: 'صفحة'),
        ),
      );
}
