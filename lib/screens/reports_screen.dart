import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import '../models/models.dart';
import '../services/data_service.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});
  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final ds = DataService.instance;
  String period = 'أسبوعي';
  Circle? selectedCircle;

  String _buildStudentReport(Student s) {
    final ev = ds.evaluateStudent(s.id);
    final c = ds.circleById(s.circleId);
    final now = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return '''
تقرير الطالب - مركز السنة للعلوم الشرعية
التاريخ: $now
الطالب: ${s.name}
الحلقة: ${c?.name ?? ''} (${c?.teacherName ?? ''})
العمر: ${s.age} سنة | الأجزاء المحفوظة: ${s.memorizedJuz}
---
التسميع (45%): ${ev.recitation.toStringAsFixed(1)}/10
المراجعة (30%): ${ev.review.toStringAsFixed(1)}/10
الحضور (15%): ${ev.attendance.toStringAsFixed(1)}/10
الواجب (10%): ${ev.homework.toStringAsFixed(1)}/10
---
النتيجة النهائية: ${ev.finalScore.toStringAsFixed(2)}/10 (${ev.grade})
''';
  }

  String _buildCircleReport(Circle c) {
    final students = ds.circleStudents(c.id);
    final attRate = ds.circleAttendanceRate(c.id);
    final recAvg = ds.circleRecitationAvg(c.id);
    final now = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final sb = StringBuffer('''
تقرير الحلقة ($period) - مركز السنة للعلوم الشرعية
التاريخ: $now
الحلقة: ${c.name} | المستوى: ${c.level}
المعلم: ${c.teacherName}
عدد الطلاب: ${students.length}
نسبة الحضور: ${attRate.toStringAsFixed(1)}%
متوسط التسميع: ${recAvg.toStringAsFixed(1)}/10
---
تفاصيل الطلاب:
''');
    for (final s in students) {
      final ev = ds.evaluateStudent(s.id);
      sb.writeln('${s.name}: ${ev.finalScore.toStringAsFixed(1)}/10 (${ev.grade})');
    }
    return sb.toString();
  }

  String _buildCenterReport() {
    final now = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final sb = StringBuffer('''
التقرير العام للمركز ($period)
التاريخ: $now
عدد الحلقات: ${ds.circles.length}
عدد الطلاب: ${ds.students.length}
التنبيهات النشطة: ${ds.activeAlerts().length}
---
أداء الحلقات:
''');
    for (final c in ds.circles) {
      sb.writeln('${c.name}: حضور ${ds.circleAttendanceRate(c.id).toStringAsFixed(0)}% | تسميع ${ds.circleRecitationAvg(c.id).toStringAsFixed(1)}/10');
    }
    return sb.toString();
  }

  String _buildCsv() {
    final sb = StringBuffer('الطالب,الحلقة,التسميع,المراجعة,الحضور,الواجب,النهائي,التقدير\n');
    final list = selectedCircle != null ? ds.circleStudents(selectedCircle!.id) : ds.students;
    for (final s in list) {
      final ev = ds.evaluateStudent(s.id);
      final c = ds.circleById(s.circleId);
      sb.writeln('${s.name},${c?.name ?? ''},${ev.recitation.toStringAsFixed(1)},${ev.review.toStringAsFixed(1)},${ev.attendance.toStringAsFixed(1)},${ev.homework.toStringAsFixed(1)},${ev.finalScore.toStringAsFixed(2)},${ev.grade}');
    }
    return sb.toString();
  }

  void _exportCsv() {
    final csv = _buildCsv();
    Clipboard.setData(ClipboardData(text: csv));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم نسخ تقرير CSV إلى الحافظة'), backgroundColor: Color(0xFF0B7A5E)),
    );
  }

  void _shareReport(String text) {
    Share.share(text, subject: 'تقرير مركز السنة للعلوم الشرعية');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('التقارير'),
        backgroundColor: const Color(0xFF0B7A5E), foregroundColor: Colors.white,
      ),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        // اختيار الفترة
        SegmentedButton<String>(
          segments: const [
            ButtonSegment(value: 'أسبوعي', label: Text('أسبوعي'), icon: Icon(Icons.date_range)),
            ButtonSegment(value: 'شهري', label: Text('شهري'), icon: Icon(Icons.calendar_month)),
          ],
          selected: {period},
          onSelectionChanged: (s) => setState(() => period = s.first),
        ),
        const SizedBox(height: 16),

        // تصدير CSV
        Card(child: ListTile(
          leading: const Icon(Icons.file_download, color: Color(0xFF0B7A5E)),
          title: const Text('تصدير CSV'),
          subtitle: Text(selectedCircle == null ? 'جميع الطلاب' : 'طلاب ${selectedCircle!.name}'),
          trailing: FilledButton(
            onPressed: _exportCsv,
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFF0B7A5E)),
            child: const Text('تصدير'),
          ),
        )),

        // تقرير المركز
        Card(child: ListTile(
          leading: const Icon(Icons.business, color: Color(0xFF0B7A5E)),
          title: Text('تقرير المركز ($period)'),
          subtitle: const Text('ملخص أداء جميع الحلقات'),
          trailing: const Icon(Icons.share),
          onTap: () => _shareReport(_buildCenterReport()),
        )),

        const Divider(height: 24),
        const Text('تقارير الحلقات:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),

        // فلتر الحلقات
        DropdownButtonFormField<Circle?>(
          initialValue: selectedCircle,
          decoration: InputDecoration(
            labelText: 'اختر الحلقة',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          items: [
            const DropdownMenuItem(value: null, child: Text('كل الحلقات')),
            ...ds.circles.map((c) => DropdownMenuItem(value: c, child: Text(c.name))),
          ],
          onChanged: (v) => setState(() => selectedCircle = v),
        ),
        const SizedBox(height: 12),

        if (selectedCircle != null)
          Card(child: ListTile(
            leading: const Icon(Icons.groups, color: Color(0xFFC9A227)),
            title: Text('تقرير ${selectedCircle!.name} ($period)'),
            subtitle: Text('المعلم: ${selectedCircle!.teacherName}'),
            trailing: const Icon(Icons.share),
            onTap: () => _shareReport(_buildCircleReport(selectedCircle!)),
          )),

        if (selectedCircle == null)
          for (final c in ds.circles)
            Card(child: ListTile(
              leading: const Icon(Icons.groups, color: Color(0xFFC9A227)),
              title: Text(c.name),
              subtitle: Text('حضور ${ds.circleAttendanceRate(c.id).toStringAsFixed(0)}% • تسميع ${ds.circleRecitationAvg(c.id).toStringAsFixed(1)}/10'),
              trailing: const Icon(Icons.share),
              onTap: () => _shareReport(_buildCircleReport(c)),
            )),

        const Divider(height: 24),
        const Text('تقارير الطلاب:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),

        for (final s in (selectedCircle != null ? ds.circleStudents(selectedCircle!.id).take(5) : ds.students.take(10)))
          Card(child: ListTile(
            leading: const Icon(Icons.person, color: Color(0xFF0B7A5E)),
            title: Text(s.name),
            subtitle: Text('${ds.circleById(s.circleId)?.name ?? ''} • ${ds.evaluateStudent(s.id).grade}'),
            trailing: const Icon(Icons.share),
            onTap: () => _shareReport(_buildStudentReport(s)),
          )),

        if (selectedCircle == null)
          const Padding(
            padding: EdgeInsets.all(8),
            child: Text('(عرض أول 10 طلاب فقط - اختر حلقة لعرض جميع طلابها)',
                style: TextStyle(fontSize: 12, color: Colors.grey), textAlign: TextAlign.center),
          ),
        const SizedBox(height: 30),
      ]),
    );
  }
}
