import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/models.dart';
import '../services/data_service.dart';

class StudentDetailScreen extends StatefulWidget {
  final Student student;
  const StudentDetailScreen({super.key, required this.student});
  @override
  State<StudentDetailScreen> createState() => _StudentDetailScreenState();
}

class _StudentDetailScreenState extends State<StudentDetailScreen> {
  final ds = DataService.instance;

  Future<void> _call() async {
    final uri = Uri.parse('tel:${widget.student.parentPhone}');
    if (await canLaunchUrl(uri)) launchUrl(uri);
    _logComm('اتصال');
  }

  Future<void> _whatsapp() async {
    final phone = widget.student.parentPhone.replaceAll(RegExp(r'[^0-9]'), '');
    final intl = phone.startsWith('0') ? '967${phone.substring(1)}' : phone;
    final msg = Uri.encodeComponent(
        'السلام عليكم ورحمة الله، معكم إدارة مركز السنة للعلوم الشرعية - شبوة عتق، بخصوص الطالب ${widget.student.name}');
    final uri = Uri.parse('https://wa.me/$intl?text=$msg');
    if (await canLaunchUrl(uri)) launchUrl(uri, mode: LaunchMode.externalApplication);
    _logComm('واتساب');
  }

  void _copyPhone() {
    Clipboard.setData(ClipboardData(text: widget.student.parentPhone));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم نسخ الرقم')));
  }

  void _copyMessage() {
    final msg =
        'السلام عليكم ورحمة الله وبركاته\nولي أمر الطالب: ${widget.student.name}\nنود إفادتكم بمستوى الطالب في حلقة ${ds.circleById(widget.student.circleId)?.name ?? ''}.\nمركز السنة للعلوم الشرعية - شبوة عتق';
    Clipboard.setData(ClipboardData(text: msg));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم نسخ الرسالة المقترحة')));
    _logComm('نسخ رسالة');
  }

  void _logComm(String method) {
    final resultCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('سجل نتيجة التواصل ($method)'),
        content: TextField(
          controller: resultCtrl,
          decoration: const InputDecoration(labelText: 'النتيجة / الملاحظات', hintText: 'مثال: تم التواصل ووعد بالانتظام'),
          maxLines: 2,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('تخطي')),
          FilledButton(
            onPressed: () {
              setState(() {
                ds.addCommLog(CommunicationLog(
                  id: 'CL${ds.commLogs.length + 1}',
                  studentId: widget.student.id, method: method,
                  result: resultCtrl.text.trim().isEmpty ? 'تم التواصل' : resultCtrl.text.trim(),
                  date: DateTime.now(), byUser: 'المستخدم الحالي',
                ));
              });
              Navigator.pop(ctx);
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }

  void _addFollowUpPlan() {
    final planCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('خطة متابعة جديدة'),
        content: TextField(
          controller: planCtrl, maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'تفاصيل الخطة',
            hintText: 'مثال: مراجعة يومية مع المعلم + تواصل أسبوعي مع ولي الأمر',
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          FilledButton(
            onPressed: () {
              if (planCtrl.text.trim().isEmpty) return;
              setState(() {
                ds.addFollowUpPlan(FollowUpPlan(
                  id: 'FP${ds.followUpPlans.length + 1}',
                  studentId: widget.student.id, createdBy: 'المشرف',
                  plan: planCtrl.text.trim(), startDate: DateTime.now(),
                ));
              });
              Navigator.pop(ctx);
            },
            child: const Text('حفظ الخطة'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.student;
    final ev = ds.evaluateStudent(s.id);
    final circle = ds.circleById(s.circleId);
    final stRec = ds.recitations.where((r) => r.studentId == s.id).toList()
      ..sort((a, b) => a.date.compareTo(b.date));
    final stAtt = ds.attendance.where((a) => a.studentId == s.id).toList();
    final absent = stAtt.where((a) => a.status == AttendanceStatus.absent).length;
    final logs = ds.studentCommLogs(s.id);
    final plans = ds.studentPlans(s.id);
    final studentAlerts = ds.alerts.where((a) => a.studentId == s.id && !a.resolved).toList();

    // آخر 10 تسميعات للرسم
    final last10 = stRec.length > 10 ? stRec.sublist(stRec.length - 10) : stRec;

    return Scaffold(
      appBar: AppBar(
        title: Text(s.name),
        backgroundColor: const Color(0xFF0B7A5E), foregroundColor: Colors.white,
      ),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        // بطاقة المعلومات
        Card(child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              CircleAvatar(
                radius: 28, backgroundColor: const Color(0xFF0B7A5E),
                child: Text(s.name.characters.first, style: const TextStyle(color: Colors.white, fontSize: 22)),
              ),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(s.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('${circle?.name ?? ''} • ${s.level}'),
                Text('العمر: ${s.age} سنة • محفوظ: ${s.memorizedJuz} جزء'),
              ])),
            ]),
          ]),
        )),

        // التنبيهات
        if (studentAlerts.isNotEmpty)
          Card(
            color: Colors.orange.shade50,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Row(children: [
                  Icon(Icons.warning_amber, color: Colors.orange),
                  SizedBox(width: 8),
                  Text('تنبيهات', style: TextStyle(fontWeight: FontWeight.bold)),
                ]),
                for (final a in studentAlerts)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text('• ${a.message}', style: const TextStyle(fontSize: 13)),
                  ),
              ]),
            ),
          ),

        // التقييم
        Card(child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text('التقييم النهائي', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Column(children: [
                Text(ev.finalScore.toStringAsFixed(2), style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF0B7A5E))),
                Text(ev.grade, style: TextStyle(color: ev.finalScore >= 7.5 ? Colors.green : ev.finalScore >= 5 ? Colors.orange : Colors.red, fontWeight: FontWeight.bold)),
              ]),
            ]),
            const Divider(),
            _evalRow('التسميع (45%)', ev.recitation),
            _evalRow('المراجعة (30%)', ev.review),
            _evalRow('الحضور (15%)', ev.attendance),
            _evalRow('الواجب (10%)', ev.homework),
            const Divider(),
            Text('إجمالي الغياب: $absent من ${stAtt.length} جلسة', style: const TextStyle(fontSize: 13)),
          ]),
        )),

        // منحنى التسميع
        if (last10.isNotEmpty)
          Card(child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('تطور درجات التسميع', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              SizedBox(
                height: 150,
                child: LineChart(LineChartData(
                  minY: 0, maxY: 10,
                  titlesData: const FlTitlesData(
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  lineBarsData: [LineChartBarData(
                    spots: [for (int i = 0; i < last10.length; i++) FlSpot(i.toDouble(), last10[i].recitationScore)],
                    isCurved: true, color: const Color(0xFF0B7A5E), barWidth: 3,
                    dotData: const FlDotData(show: true),
                  )],
                )),
              ),
            ]),
          )),

        // التواصل مع ولي الأمر
        Card(child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('التواصل مع ولي الأمر', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('${s.parentName} • ${s.parentPhone}', style: const TextStyle(fontSize: 13)),
            const SizedBox(height: 10),
            Wrap(spacing: 8, runSpacing: 8, children: [
              _actionBtn(Icons.phone, 'اتصال', Colors.green, _call),
              _actionBtn(Icons.chat, 'واتساب', const Color(0xFF25D366), _whatsapp),
              _actionBtn(Icons.copy, 'نسخ الرقم', Colors.blue, _copyPhone),
              _actionBtn(Icons.message, 'نسخ رسالة', Colors.purple, _copyMessage),
            ]),
          ]),
        )),

        // خطط المتابعة
        Card(child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text('خطط المتابعة', style: TextStyle(fontWeight: FontWeight.bold)),
              TextButton.icon(onPressed: _addFollowUpPlan, icon: const Icon(Icons.add), label: const Text('خطة جديدة')),
            ]),
            if (plans.isEmpty) const Text('لا توجد خطط متابعة', style: TextStyle(color: Colors.grey, fontSize: 13)),
            for (final p in plans)
              ListTile(
                dense: true, contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.assignment, color: Color(0xFF0B7A5E)),
                title: Text(p.plan, style: const TextStyle(fontSize: 13)),
                subtitle: Text('${p.status} • ${p.startDate.toString().substring(0, 10)}', style: const TextStyle(fontSize: 11)),
              ),
          ]),
        )),

        // سجل التواصل
        Card(child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('سجل التواصل', style: TextStyle(fontWeight: FontWeight.bold)),
            if (logs.isEmpty) const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text('لا يوجد سجل تواصل', style: TextStyle(color: Colors.grey, fontSize: 13)),
            ),
            for (final l in logs)
              ListTile(
                dense: true, contentPadding: EdgeInsets.zero,
                leading: Icon(l.method == 'اتصال' ? Icons.phone : l.method == 'واتساب' ? Icons.chat : Icons.message,
                    size: 20, color: const Color(0xFF0B7A5E)),
                title: Text('${l.method} - ${l.result}', style: const TextStyle(fontSize: 13)),
                subtitle: Text(l.date.toString().substring(0, 16), style: const TextStyle(fontSize: 11)),
              ),
          ]),
        )),
        const SizedBox(height: 30),
      ]),
    );
  }

  Widget _evalRow(String label, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(children: [
        SizedBox(width: 110, child: Text(label, style: const TextStyle(fontSize: 13))),
        Expanded(
          child: LinearProgressIndicator(
            value: value / 10, minHeight: 10,
            backgroundColor: Colors.grey.shade200,
            color: value >= 7.5 ? Colors.green : value >= 5 ? Colors.orange : Colors.red,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        const SizedBox(width: 8),
        Text(value.toStringAsFixed(1), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
      ]),
    );
  }

  Widget _actionBtn(IconData icon, String label, Color color, VoidCallback onTap) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: Text(label, style: const TextStyle(fontSize: 12)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color, foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }
}
