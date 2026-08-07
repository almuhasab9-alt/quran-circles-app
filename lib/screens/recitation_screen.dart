import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/data_service.dart';

// شاشة التسميع: اختيار طالب ثم تسجيل الحفظ والمراجعة والأخطاء والواجب
class RecitationScreen extends StatefulWidget {
  final Circle circle;
  const RecitationScreen({super.key, required this.circle});
  @override
  State<RecitationScreen> createState() => _RecitationScreenState();
}

class _RecitationScreenState extends State<RecitationScreen> {
  final ds = DataService.instance;
  final newMemCtrl = TextEditingController();
  final reviewCtrl = TextEditingController();
  final notesCtrl = TextEditingController();
  Student? selected;
  int light = 0, medium = 0, major = 0;
  bool homework = true;

  double get score {
    final s = 10 - light * 0.5 - medium * 1.0 - major * 2.0;
    return s < 0 ? 0 : s;
  }

  void _save() {
    if (selected == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('اختر الطالب أولاً')));
      return;
    }
    ds.addRecitation(RecitationRecord(
      id: 'RM${ds.recitations.length + 1}',
      studentId: selected!.id, circleId: widget.circle.id, date: DateTime.now(),
      newMemorization: newMemCtrl.text.trim().isEmpty ? '—' : newMemCtrl.text.trim(),
      review: reviewCtrl.text.trim().isEmpty ? '—' : reviewCtrl.text.trim(),
      lightErrors: light, mediumErrors: medium, majorErrors: major,
      homeworkDone: homework, notes: notesCtrl.text.trim(),
    ));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تم حفظ تسميع ${selected!.name} (${score.toStringAsFixed(1)}/10)'),
          backgroundColor: const Color(0xFF0B7A5E)),
    );
    setState(() {
      selected = null;
      newMemCtrl.clear(); reviewCtrl.clear(); notesCtrl.clear();
      light = 0; medium = 0; major = 0; homework = true;
    });
  }

  Widget _counter(String label, int value, void Function(int) onChanged, Color color) {
    return Column(children: [
      Text(label, style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.bold)),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        IconButton(icon: const Icon(Icons.remove_circle_outline), onPressed: value > 0 ? () => setState(() => onChanged(value - 1)) : null),
        Text('$value', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: () => setState(() => onChanged(value + 1))),
      ]),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final students = ds.circleStudents(widget.circle.id);
    return Scaffold(
      appBar: AppBar(
        title: Text('تسميع ${widget.circle.name}'),
        backgroundColor: const Color(0xFF0B7A5E), foregroundColor: Colors.white,
      ),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        DropdownButtonFormField<Student>(
          initialValue: selected,
          decoration: InputDecoration(
            labelText: 'اختر الطالب',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            prefixIcon: const Icon(Icons.person_search),
          ),
          items: students.map((s) => DropdownMenuItem(value: s, child: Text(s.name))).toList(),
          onChanged: (v) => setState(() => selected = v),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: newMemCtrl,
          decoration: InputDecoration(
            labelText: 'الحفظ الجديد (مثال: سورة الملك 1-10)',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            prefixIcon: const Icon(Icons.menu_book),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: reviewCtrl,
          decoration: InputDecoration(
            labelText: 'المراجعة (مثال: سورة الواقعة)',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            prefixIcon: const Icon(Icons.replay),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(children: [
              Expanded(child: _counter('أخطاء خفيفة', light, (v) => light = v, Colors.green)),
              Expanded(child: _counter('متوسطة', medium, (v) => medium = v, Colors.orange)),
              Expanded(child: _counter('كبيرة', major, (v) => major = v, Colors.red)),
            ]),
          ),
        ),
        const SizedBox(height: 8),
        SwitchListTile(
          title: const Text('أنجز الواجب'),
          value: homework,
          activeThumbColor: const Color(0xFF0B7A5E),
          onChanged: (v) => setState(() => homework = v),
        ),
        TextField(
          controller: notesCtrl,
          decoration: InputDecoration(
            labelText: 'ملاحظات (اختياري)',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          color: const Color(0xFF0B7A5E).withValues(alpha: 0.08),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text('درجة التسميع:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text('${score.toStringAsFixed(1)} / 10',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,
                      color: score >= 7.5 ? Colors.green : score >= 5 ? Colors.orange : Colors.red)),
            ]),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity, height: 50,
          child: FilledButton.icon(
            onPressed: _save,
            icon: const Icon(Icons.save),
            label: const Text('حفظ التسميع', style: TextStyle(fontSize: 17)),
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFF0B7A5E)),
          ),
        ),
      ]),
    );
  }
}
