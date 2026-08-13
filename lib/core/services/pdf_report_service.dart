import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../constants/enums.dart';
import '../database/app_database.dart';
import '../utils/date_utils.dart' as du;
import 'quran_meta.dart';
import 'report_service.dart';
import 'session_service.dart';

/// خدمة إنشاء تقارير PDF عربية منسّقة (RTL) بدون أي تشوهات بصرية.
///
/// تعتمد على خط Noto Naskh Arabic المضمّن في الأصول، مع تفعيل
/// معالجة الاتجاه RTL وإعادة ترتيب النص حتى تظهر الحروف العربية
/// متصلة وبالاتجاه الصحيح.
class PdfReportService {
  static const String fontAssetPath = 'assets/fonts/NotoNaskhArabic-Regular.ttf';
  static const String fallbackAssetPath = 'assets/fonts/DejaVuSans.ttf';
  static const String fallbackBoldAssetPath = 'assets/fonts/DejaVuSans-Bold.ttf';

  static pw.Font? _cachedFont;
  static List<pw.Font>? _cachedFallbacks;

  /// تحميل خط Noto Naskh Arabic من الأصول (مع تخزين مؤقت).
  static Future<pw.Font> loadArabicFont() async {
    final cached = _cachedFont;
    if (cached != null) return cached;
    final data = await rootBundle.load(fontAssetPath);
    final font = pw.Font.ttf(data);
    _cachedFont = font;
    return font;
  }

  /// تحميل الخطوط الاحتياطية (DejaVu Sans) من الأصول - مضمّنة داخل الملف،
  /// وتغطي الأرقام اللاتينية والشرطات والرموز غير الموجودة في خط النسخ.
  static Future<List<pw.Font>> loadFallbackFonts() async {
    final cached = _cachedFallbacks;
    if (cached != null) return cached;
    final fonts = <pw.Font>[
      pw.Font.ttf(await rootBundle.load(fallbackAssetPath)),
      pw.Font.ttf(await rootBundle.load(fallbackBoldAssetPath)),
    ];
    _cachedFallbacks = fonts;
    return fonts;
  }

  /// حقن الخطوط مباشرة (لأدوات سطر الأوامر والفحص البصري خارج إطار Flutter).
  static void debugSetFonts(Uint8List main, Uint8List fallback, Uint8List fallbackBold) {
    _cachedFont = pw.Font.ttf(main.buffer.asByteData());
    _cachedFallbacks = [
      pw.Font.ttf(fallback.buffer.asByteData()),
      pw.Font.ttf(fallbackBold.buffer.asByteData()),
    ];
  }

  /// إنشاء خط عربي من بايتات TTF مباشرة (مفيد للاختبارات).
  static pw.Font fontFromBytes(Uint8List bytes) => pw.Font.ttf(bytes.buffer.asByteData());

  static const _primary = PdfColor.fromInt(0xFF0B5E48);
  static const _gold = PdfColor.fromInt(0xFFC9A227);
  static const _danger = PdfColor.fromInt(0xFFC62828);
  static const _greyText = PdfColor.fromInt(0xFF555555);
  static const _rowAlt = PdfColor.fromInt(0xFFF4F8F6);
  static const _fridayBg = PdfColor.fromInt(0xFFFBF5E0);

  /// نمط نص بخط النسخ العربي + خطوط DejaVu الاحتياطية المضمّنة -
  /// يمنع ظهور مربعات فارغة أو تشوهات في الملف النهائي.
  static pw.TextStyle _s(pw.Font f, double size,
          {bool bold = false, PdfColor color = PdfColors.black}) =>
      pw.TextStyle(
        font: f,
        fontFallback: _cachedFallbacks ?? const [],
        fontSize: size,
        color: color,
        fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
      );

  static String _fmt(double v) =>
      v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(2);

  static pw.Widget _arabic(String text, pw.TextStyle style,
          {pw.TextAlign align = pw.TextAlign.center}) =>
      pw.Directionality(
        textDirection: pw.TextDirection.rtl,
        child: pw.Text(text,
            style: style, textAlign: align, textDirection: pw.TextDirection.rtl),
      );

  static pw.Widget _hCell(String text, pw.Font font,
          {double w = 60, double fontSize = 8}) =>
      pw.Container(
        width: w,
        padding: const pw.EdgeInsets.symmetric(vertical: 5, horizontal: 2),
        color: _primary,
        alignment: pw.Alignment.center,
        child: _arabic(text, _s(font, fontSize, bold: true, color: PdfColors.white)),
      );

  static pw.Widget _cCell(String text, pw.Font font,
          {double w = 60,
          PdfColor? bg,
          PdfColor? fg,
          bool bold = false,
          double fontSize = 8}) =>
      pw.Container(
        width: w,
        padding: const pw.EdgeInsets.symmetric(vertical: 5, horizontal: 2),
        decoration: pw.BoxDecoration(
          color: bg,
          border: pw.Border.all(color: const PdfColor.fromInt(0xFFCCCCCC), width: 0.3),
        ),
        alignment: pw.Alignment.center,
        child: _arabic(text, _s(font, fontSize, bold: bold, color: fg ?? PdfColors.black)),
      );

  static pw.Widget _header(pw.Font font, String title, String subtitle,
          {String? extra}) =>
      pw.Directionality(
        textDirection: pw.TextDirection.rtl,
        child: pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: pw.BoxDecoration(
            color: _primary,
            borderRadius: pw.BorderRadius.circular(6),
          ),
          child: pw.Column(children: [
            _arabic('مركز السنة للعلوم الشرعية وتأهيل الدعاة',
                _s(font, 9, color: PdfColors.white)),
            pw.SizedBox(height: 2),
            _arabic(title, _s(font, 15, bold: true, color: PdfColors.white)),
            pw.SizedBox(height: 2),
            _arabic(subtitle, _s(font, 9, color: PdfColors.white)),
            if (extra != null) ...[
              pw.SizedBox(height: 2),
              _arabic(extra, _s(font, 8, color: _gold)),
            ],
          ]),
        ),
      );

  /// صف ملخص بخانات (المطلوب / المنجز / النسبة / التقدير)
  static pw.Widget _summaryRow(pw.Font font, PeriodReport r,
      {bool showGrade = true}) {
    pw.Widget box(String label, String value, {PdfColor? vc}) => pw.Expanded(
          child: pw.Container(
            margin: const pw.EdgeInsets.symmetric(horizontal: 2),
            padding: const pw.EdgeInsets.symmetric(vertical: 6),
            decoration: pw.BoxDecoration(
              color: _rowAlt,
              borderRadius: pw.BorderRadius.circular(4),
              border: pw.Border.all(color: _primary, width: 0.5),
            ),
            child: pw.Column(children: [
              _arabic(label, _s(font, 8, color: _greyText)),
              pw.SizedBox(height: 2),
              _arabic(value, _s(font, 11, bold: true, color: vc ?? _primary)),
            ]),
          ),
        );
    final children = <pw.Widget>[
      box('المطلوب (صفحات)', _fmt(r.requiredTotal)),
      box('المنجز (صفحات)', _fmt(r.doneTotal)),
      box('نسبة الإنجاز', '${r.overallPct.toStringAsFixed(0)}%'),
      box('أيام مسجلة', '${r.daysRecorded}'),
    ];
    if (showGrade) {
      children.add(box('التقدير', r.weeklyGrade?.ar ?? '-'));
    }
    return pw.Directionality(
      textDirection: pw.TextDirection.rtl,
      child: pw.Row(children: children),
    );
  }

  /// جدول مقارنة المطلوب مقابل المنجز لكل فئة
  static pw.Widget _categoryTable(pw.Font font, PeriodReport r) {
    pw.Widget th(String t) => pw.Container(
          padding: const pw.EdgeInsets.symmetric(vertical: 4),
          color: _primary,
          alignment: pw.Alignment.center,
          child: _arabic(t, _s(font, 8, bold: true, color: PdfColors.white)),
        );
    pw.Widget td(String t, {PdfColor? c, bool alt = false}) => pw.Container(
          padding: const pw.EdgeInsets.symmetric(vertical: 4),
          color: alt ? _rowAlt : PdfColors.white,
          alignment: pw.Alignment.center,
          child: _arabic(t, _s(font, 8, color: c ?? PdfColors.black)),
        );

    final rows = <pw.TableRow>[
      pw.TableRow(children: [th('الفئة'), th('المطلوب'), th('المنجز'), th('النسبة')]),
    ];
    void cat(String name, double req, double done, double pct, bool alt) {
      rows.add(pw.TableRow(children: [
        td(name, alt: alt),
        td(_fmt(req), alt: alt),
        td(_fmt(done), alt: alt),
        td('${pct.toStringAsFixed(0)}%',
            c: pct >= 90
                ? const PdfColor.fromInt(0xFF2E7D32)
                : pct >= 60
                    ? _gold
                    : _danger,
            alt: alt),
      ]));
    }

    cat('الجديد (الحفظ)', r.requiredNew, r.doneNew, r.newPct, false);
    cat('حديث العهد', r.requiredRecent, r.doneRecent, r.recentPct, true);
    cat('المراجعة الصغرى', r.requiredMinor, r.doneMinor, r.minorPct, false);
    cat('المراجعة الكبرى', r.requiredMajor, r.doneMajor, r.majorPct, true);
    cat('ربط الجمعة', r.requiredFriday, r.doneFriday, r.fridayPct, false);

    return pw.Directionality(
      textDirection: pw.TextDirection.rtl,
      child: pw.Table(
        border: pw.TableBorder.all(color: const PdfColor.fromInt(0xFFBBBBBB), width: 0.4),
        columnWidths: const {
          0: pw.FlexColumnWidth(2.2),
          1: pw.FlexColumnWidth(1.4),
          2: pw.FlexColumnWidth(1.4),
          3: pw.FlexColumnWidth(1.2),
        },
        children: rows,
      ),
    );
  }

  static pw.Widget _footer(pw.Font font) => pw.Directionality(
        textDirection: pw.TextDirection.rtl,
        child: pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.only(top: 6),
          decoration: const pw.BoxDecoration(
            border: pw.Border(top: pw.BorderSide(color: _primary, width: 0.8)),
          ),
          child: _arabic(
            'أُنشئ بواسطة نظام متابعة حلقات مركز السنة للعلوم الشرعية وتأهيل الدعاة - ${du.formatDateTime(DateTime.now())}',
            _s(font, 7, color: _greyText),
            align: pw.TextAlign.center,
          ),
        ),
      );

  /// بناء صفوف جدول الكشف الأسبوعي (مشترك بين الشاشة و PDF)
  static List<List<String>> buildWeeklySheetRows(
      List<DateTime> weekDays, Map<String, DailyRecord> byKey) {
    final rows = <List<String>>[];
    for (final day in weekDays) {
      final isF = day.weekday == DateTime.friday;
      final rec = byKey[du.dateKeyOf(day)];
      if (isF) {
        rows.add([
          'الجمعة ${du.formatDate(day)}',
          'ربط الجمعة (مراجعة فقط)',
          '-',
          '-',
          rec != null && rec.recentFromPage > 0
              ? '${rec.recentFromPage} - ${rec.recentToPage}'
              : '-',
          rec != null && rec.minorFromPage > 0
              ? '${rec.minorFromPage} - ${rec.minorToPage}'
              : '-',
          rec != null && rec.majorFromPage > 0
              ? '${rec.majorFromPage} - ${rec.majorToPage}'
              : '-',
          rec?.notes.isNotEmpty == true ? rec!.notes : '',
        ]);
      } else {
        final newRange = rec == null || rec.newFromSurah == 0
            ? null
            : '${QuranMeta.surahName(rec.newFromSurah)} ${rec.newFromAyah} - '
                '${QuranMeta.surahName(rec.newToSurah)} ${rec.newToAyah}'
                '${rec.newPages > 0 ? ' (${rec.newPages.toStringAsFixed(2)} ص)' : ''}';
        rows.add([
          '${day.weekdayAr} ${du.formatDate(day)}',
          rec == null ? 'لم يُسجَّل' : (newRange ?? '-'),
          rec == null || rec.grade.isEmpty
              ? '-'
              : (EvaluationGradeAr.fromName(rec.grade)?.ar ?? '-'),
          rec == null || rec.repetition == 0 ? '-' : '${rec.repetition}',
          rec == null || rec.recentFromPage == 0
              ? '-'
              : '${rec.recentFromPage} - ${rec.recentToPage}',
          rec == null || rec.minorFromPage == 0
              ? '-'
              : '${rec.minorFromPage} - ${rec.minorToPage}',
          rec == null || rec.majorFromPage == 0
              ? '-'
              : '${rec.majorFromPage} - ${rec.majorToPage}',
          rec?.notes.isNotEmpty == true ? rec!.notes : '-',
        ]);
      }
    }
    return rows;
  }

  /// إنشاء PDF لكشف المتابعة الأسبوعي لطالب واحد.
  static Future<Uint8List> buildWeeklySheetPdf({
    required Student student,
    required Halaqa halaqa,
    required User teacher,
    required DateTime weekRef,
    required List<DailyRecord> records,
    required PeriodReport report,
  }) async {
    final font = await loadArabicFont();
    await loadFallbackFonts();
    final weekDays = SessionService.weekDaysOf(weekRef);
    final byKey = {for (final r in records) r.dateKey: r};
    final rows = buildWeeklySheetRows(weekDays, byKey);

    final doc = pw.Document(title: 'كشف متابعة الحفظ والمراجعة', author: 'مركز السنة');

    final widths = [78.0, 105.0, 48.0, 38.0, 66.0, 66.0, 66.0, 78.0];
    final headers = [
      'اليوم والتاريخ',
      'الجديد من - إلى',
      'التقدير',
      'التكرار',
      'حديث العهد من - إلى',
      'الصغرى من - إلى',
      'الكبرى من - إلى',
      'الملاحظات',
    ];

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: const pw.EdgeInsets.all(20),
        build: (ctx) => pw.Directionality(
          textDirection: pw.TextDirection.rtl,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              _header(
                font,
                'كشف متابعة الحفظ والمراجعة',
                'الطالب: ${student.fullName} (${student.studentCode})  -  الحلقة: ${halaqa.name}  -  المعلم: ${teacher.fullName}',
                extra:
                    'أسبوع ${du.formatDate(weekDays.first)} - ${du.formatDate(weekDays.last)}',
              ),
              pw.SizedBox(height: 10),
              // جدول الكشف
              pw.Directionality(
                textDirection: pw.TextDirection.rtl,
                child: pw.Row(children: [
                  for (var i = 0; i < headers.length; i++)
                    _hCell(headers[i], font, w: widths[i]),
                ]),
              ),
              for (var ri = 0; ri < rows.length; ri++)
                pw.Directionality(
                  textDirection: pw.TextDirection.rtl,
                  child: pw.Row(children: [
                    for (var ci = 0; ci < rows[ri].length; ci++)
                      _cCell(
                        rows[ri][ci],
                        font,
                        w: widths[ci],
                        bg: weekDays[ri].weekday == DateTime.friday
                            ? _fridayBg
                            : (ri.isOdd ? _rowAlt : PdfColors.white),
                        fg: rows[ri][1] == 'لم يُسجَّل' && ci == 1 ? _danger : null,
                        bold: ci == 0 || weekDays[ri].weekday == DateTime.friday,
                      ),
                  ]),
                ),
              pw.SizedBox(height: 12),
              _arabic('التقرير الأسبوعي', _s(font, 12, bold: true, color: _primary),
                  align: pw.TextAlign.right),
              pw.SizedBox(height: 4),
              _summaryRow(font, report),
              pw.SizedBox(height: 8),
              _categoryTable(font, report),
              pw.Spacer(),
              _footer(font),
            ],
          ),
        ),
      ),
    );

    return doc.save();
  }

  /// إنشاء PDF لتقرير فترة (أسبوعي أو شهري) لطالب.
  static Future<Uint8List> buildPeriodReportPdf({
    required String title,
    required String periodLabel,
    required Student student,
    required Halaqa halaqa,
    required PeriodReport report,
  }) async {
    final font = await loadArabicFont();
    await loadFallbackFonts();
    final doc = pw.Document(title: title, author: 'مركز السنة');
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (ctx) => pw.Directionality(
          textDirection: pw.TextDirection.rtl,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              _header(
                font,
                title,
                'الطالب: ${student.fullName} (${student.studentCode})  -  الحلقة: ${halaqa.name}',
                extra: periodLabel,
              ),
              pw.SizedBox(height: 14),
              _summaryRow(font, report),
              pw.SizedBox(height: 14),
              _arabic('تفصيل الفئات', _s(font, 12, bold: true, color: _primary),
                  align: pw.TextAlign.right),
              pw.SizedBox(height: 4),
              _categoryTable(font, report),
              pw.SizedBox(height: 14),
              _arabic('أيام مسجلة: ${report.daysRecorded}  -  جُمع مسجلة: ${report.fridaysRecorded}',
                  _s(font, 9, color: _greyText),
                  align: pw.TextAlign.right),
              pw.Spacer(),
              _footer(font),
            ],
          ),
        ),
      ),
    );
    return doc.save();
  }

  /// إنشاء PDF لتقرير حلقة كاملة: كشف أسبوعي لكل طالب (صفحة أفقية لكل طالب).
  static Future<Uint8List> buildHalaqaWeeklyPdf({
    required Halaqa halaqa,
    required User teacher,
    required DateTime weekRef,
    required List<Student> students,
    required Map<String, List<DailyRecord>> recordsByStudent,
    required Map<String, PeriodReport> reportsByStudent,
  }) async {
    final font = await loadArabicFont();
    await loadFallbackFonts();
    final doc = pw.Document(title: 'كشف متابعة الحفظ والمراجعة - ${halaqa.name}');
    for (final st in students) {
      final recs = recordsByStudent[st.id] ?? const <DailyRecord>[];
      final report = reportsByStudent[st.id];
      if (report == null) continue;
      final bytes = await _weeklySheetPage(
        font: font,
        student: st,
        halaqa: halaqa,
        teacher: teacher,
        weekRef: weekRef,
        records: recs,
        report: report,
      );
      doc.addPage(bytes);
    }
    return doc.save();
  }

  static Future<pw.Page> _weeklySheetPage({
    required pw.Font font,
    required Student student,
    required Halaqa halaqa,
    required User teacher,
    required DateTime weekRef,
    required List<DailyRecord> records,
    required PeriodReport report,
  }) async {
    final weekDays = SessionService.weekDaysOf(weekRef);
    final byKey = {for (final r in records) r.dateKey: r};
    final rows = buildWeeklySheetRows(weekDays, byKey);
    final widths = [78.0, 105.0, 48.0, 38.0, 66.0, 66.0, 66.0, 78.0];
    final headers = [
      'اليوم والتاريخ',
      'الجديد من - إلى',
      'التقدير',
      'التكرار',
      'حديث العهد من - إلى',
      'الصغرى من - إلى',
      'الكبرى من - إلى',
      'الملاحظات',
    ];
    return pw.Page(
      pageFormat: PdfPageFormat.a4.landscape,
      margin: const pw.EdgeInsets.all(20),
      build: (ctx) => pw.Directionality(
        textDirection: pw.TextDirection.rtl,
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          children: [
            _header(
              font,
              'كشف متابعة الحفظ والمراجعة',
              'الطالب: ${student.fullName} (${student.studentCode})  -  الحلقة: ${halaqa.name}  -  المعلم: ${teacher.fullName}',
              extra: 'أسبوع ${du.formatDate(weekDays.first)} - ${du.formatDate(weekDays.last)}',
            ),
            pw.SizedBox(height: 8),
            pw.Directionality(
              textDirection: pw.TextDirection.rtl,
              child: pw.Row(children: [
                for (var i = 0; i < headers.length; i++) _hCell(headers[i], font, w: widths[i]),
              ]),
            ),
            for (var ri = 0; ri < rows.length; ri++)
              pw.Directionality(
                textDirection: pw.TextDirection.rtl,
                child: pw.Row(children: [
                  for (var ci = 0; ci < rows[ri].length; ci++)
                    _cCell(
                      rows[ri][ci],
                      font,
                      w: widths[ci],
                      bg: weekDays[ri].weekday == DateTime.friday
                          ? _fridayBg
                          : (ri.isOdd ? _rowAlt : PdfColors.white),
                      fg: rows[ri][1] == 'لم يُسجَّل' && ci == 1 ? _danger : null,
                      bold: ci == 0 || weekDays[ri].weekday == DateTime.friday,
                    ),
                ]),
              ),
            pw.SizedBox(height: 10),
            _summaryRow(font, report),
            pw.Spacer(),
            _footer(font),
          ],
        ),
      ),
    );
  }
}
