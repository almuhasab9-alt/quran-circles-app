import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../constants/app_constants.dart';
import '../database/app_database.dart';
import '../utils/date_utils.dart' as du;
import 'pdf_report_service.dart';

/// خدمة التصدير اليومي الشامل بصيغة PDF لحساب المشرف:
/// ملف واحد يحتوي كافة بيانات الحلقات والطلاب وسجلات اليوم
/// — حماية من ضياع البيانات.
class DailyPdfService {
  static const _primary = PdfColor.fromInt(0xFF0B5E48);
  static const _gold = PdfColor.fromInt(0xFFC9A227);
  static const _greyText = PdfColor.fromInt(0xFF555555);
  static const _rowAlt = PdfColor.fromInt(0xFFF4F8F6);

  static String _gradeAr(String g) => switch (g) {
        'excellent' => 'ممتاز',
        'veryGood' => 'جيد جداً',
        'good' => 'جيد',
        'repeat' => 'إعادة',
        _ => '—',
      };

  static String _surah(int n) =>
      (n >= 1 && n <= AppConstants.surahs.length) ? AppConstants.surahs[n - 1] : '—';

  static pw.TextStyle _s(pw.Font f, double size,
          {bool bold = false, PdfColor color = PdfColors.black}) =>
      pw.TextStyle(
        font: f,
        fontSize: size,
        color: color,
        fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
      );

  static pw.Widget _t(String text, pw.TextStyle style,
          {pw.TextAlign align = pw.TextAlign.center}) =>
      pw.Directionality(
        textDirection: pw.TextDirection.rtl,
        child: pw.Text(text, style: style, textAlign: align, textDirection: pw.TextDirection.rtl),
      );

  static pw.Widget _cell(pw.Font f, String text,
          {bool bold = false, PdfColor? bg, PdfColor? fg, double size = 8}) =>
      pw.Container(
        color: bg,
        padding: const pw.EdgeInsets.symmetric(vertical: 3, horizontal: 2),
        alignment: pw.Alignment.center,
        child: _t(text, _s(f, size, bold: bold, color: fg ?? PdfColors.black)),
      );

  /// إنشاء PDF يومي شامل: ملخص عام + جدول لكل حلقة يضم كل طلابها
  /// وسجل اليوم لكل طالب (الحفظ الجديد، التقدير، المراجعات) + الإجمالي التراكمي.
  static Future<Uint8List> buildDailyFullPdf({
    required DateTime date,
    required List<Halaqa> halaqas,
    required List<Student> students,
    required List<DailyRecord> allRecords,
    required List<User> users,
  }) async {
    final font = await PdfReportService.loadArabicFont();
    final fallbacks = await PdfReportService.loadFallbackFonts();
    await PdfReportService.loadLogoImage();
    final theme = pw.ThemeData.withFont(base: font, bold: font, fontFallback: fallbacks);
    final doc = pw.Document(title: 'التصدير اليومي الشامل', author: AppConstants.centerName, theme: theme);

    final dateKey = du.dateKeyOf(date);
    final todayRecords = allRecords.where((r) => r.dateKey == dateKey).toList();
    final activeHalaqas = halaqas.where((h) => h.active).toList();
    final teacherName = {for (final u in users) u.id: u.fullName};

    // إجمالي الصفحات التراكمي لكل طالب
    final totalPagesByStudent = <String, double>{};
    for (final r in allRecords) {
      totalPagesByStudent[r.studentId] = (totalPagesByStudent[r.studentId] ?? 0) + r.newPages;
    }
    final todayByStudent = {for (final r in todayRecords) r.studentId: r};

    pw.Widget header() => pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: pw.BoxDecoration(color: _primary, borderRadius: pw.BorderRadius.circular(6)),
          child: pw.Column(children: [
            _t(AppConstants.centerName, _s(font, 9, color: PdfColors.white)),
            pw.SizedBox(height: 2),
            _t('التصدير اليومي الشامل لكافة البيانات', _s(font, 15, bold: true, color: PdfColors.white)),
            pw.SizedBox(height: 2),
            _t('التاريخ: ${du.formatDate(date)} — الحلقات: ${activeHalaqas.length} — الطلاب: ${students.length} — سجلات اليوم: ${todayRecords.length}',
                _s(font, 9, color: _gold)),
          ]),
        );

    pw.Widget footer() => pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.only(top: 6),
          decoration: const pw.BoxDecoration(
              border: pw.Border(top: pw.BorderSide(color: _primary, width: 0.8))),
          child: _t(
              'نسخة حفظ يومية — ${AppConstants.appName} — ${du.formatDateTime(DateTime.now())}',
              _s(font, 7, color: _greyText)),
        );

    // جدول حلقة: كل الطلاب + سجل اليوم
    pw.Widget halaqaTable(Halaqa h) {
      final hStudents = students.where((s) => s.halaqaId == h.id && s.active).toList()
        ..sort((a, b) => a.fullName.compareTo(b.fullName));
      final tName = h.teacherIds.split(',').where((e) => e.isNotEmpty)
          .map((id) => teacherName[id] ?? '').where((n) => n.isNotEmpty).join('، ');
      final headers = ['الطالب', 'الحفظ الجديد اليوم', 'صفحات', 'التكرار', 'التقدير',
        'قريب (ص)', 'ربط قريب (ص)', 'ربط بعيد (ص)', 'إجمالي تراكمي'];
      final rows = <pw.TableRow>[
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: _primary),
          children: [for (final t in headers) _cell(font, t, bold: true, fg: PdfColors.white)],
        ),
      ];
      for (int i = 0; i < hStudents.length; i++) {
        final st = hStudents[i];
        final r = todayByStudent[st.id];
        final newTxt = r == null || r.newFromSurah == 0
            ? '—'
            : 'من ${_surah(r.newFromSurah)} ${r.newFromAyah} إلى ${_surah(r.newToSurah)} ${r.newToAyah}';
        String range(int a, int b) => (a == 0 && b == 0) ? '0' : '$a-$b';
        rows.add(pw.TableRow(
          decoration: pw.BoxDecoration(color: i.isOdd ? _rowAlt : PdfColors.white),
          children: [
            _cell(font, '${st.fullName} (${st.studentCode})'),
            _cell(font, newTxt, size: 7),
            _cell(font, r == null ? '—' : r.newPages.toStringAsFixed(2)),
            _cell(font, r == null ? '—' : '${r.repetition}'),
            _cell(font, r == null ? 'لم يسجل' : _gradeAr(r.grade),
                fg: r == null ? PdfColors.red : null),
            _cell(font, r == null ? '—' : range(r.recentFromPage, r.recentToPage)),
            _cell(font, r == null ? '—' : range(r.minorFromPage, r.minorToPage)),
            _cell(font, r == null ? '—' : range(r.majorFromPage, r.majorToPage)),
            _cell(font, (totalPagesByStudent[st.id] ?? 0).toStringAsFixed(1), bold: true),
          ],
        ));
      }
      return pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.stretch, children: [
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          decoration: pw.BoxDecoration(
            color: _gold,
            borderRadius: pw.BorderRadius.circular(4),
          ),
          child: _t('حلقة: ${h.name}${h.level.isEmpty ? '' : ' — ${h.level}'}${tName.isEmpty ? '' : ' — المعلم: $tName'} — طلابها: ${hStudents.length}',
              _s(font, 10, bold: true, color: PdfColors.white), align: pw.TextAlign.right),
        ),
        pw.SizedBox(height: 3),
        if (hStudents.isEmpty)
          _t('لا يوجد طلاب نشطون في هذه الحلقة', _s(font, 9, color: _greyText))
        else
          pw.Table(
            border: pw.TableBorder.all(color: _primary, width: 0.4),
            columnWidths: const {
              0: pw.FlexColumnWidth(2.4),
              1: pw.FlexColumnWidth(2.6),
              2: pw.FlexColumnWidth(0.9),
              3: pw.FlexColumnWidth(0.9),
              4: pw.FlexColumnWidth(1.1),
              5: pw.FlexColumnWidth(1.1),
              6: pw.FlexColumnWidth(1.2),
              7: pw.FlexColumnWidth(1.2),
              8: pw.FlexColumnWidth(1.2),
            },
            children: rows,
          ),
        pw.SizedBox(height: 10),
      ]);
    }

    doc.addPage(pw.MultiPage(
      pageTheme: PdfReportService.themedPage(PdfPageFormat.a4.landscape,
          margin: const pw.EdgeInsets.all(20)),
      textDirection: pw.TextDirection.rtl,
      footer: (_) => footer(),
      build: (_) => [
        header(),
        pw.SizedBox(height: 10),
        for (final h in activeHalaqas) halaqaTable(h),
        if (activeHalaqas.isEmpty)
          _t('لا توجد حلقات نشطة', _s(font, 12, color: _greyText)),
      ],
    ));
    return doc.save();
  }

  /// اسم الملف اليومي المقترح
  static String suggestedFileName(DateTime date) =>
      'التصدير_اليومي_الشامل_${du.dateKeyOf(date)}.pdf';
}
