import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/data_service.dart';
import 'circle_detail_screen.dart';

class CirclesScreen extends StatefulWidget {
  const CirclesScreen({super.key});
  @override
  State<CirclesScreen> createState() => _CirclesScreenState();
}

class _CirclesScreenState extends State<CirclesScreen> {
  final ds = DataService.instance;

  void _addCircleDialog() {
    final nameCtrl = TextEditingController();
    String level = DataService.levels.first;
    AppUser teacher = ds.teachers.first;
    AppUser supervisor = ds.supervisors.first;
    final scheduleCtrl = TextEditingController(text: 'السبت والاثنين والأربعاء - بعد العصر');

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(builder: (ctx, setD) {
        return AlertDialog(
          title: const Text('إضافة حلقة جديدة'),
          content: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'اسم الحلقة')),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: level,
                decoration: const InputDecoration(labelText: 'المستوى'),
                items: DataService.levels.map((l) => DropdownMenuItem(value: l, child: Text(l))).toList(),
                onChanged: (v) => setD(() => level = v!),
              ),
              DropdownButtonFormField<AppUser>(
                initialValue: teacher,
                decoration: const InputDecoration(labelText: 'المعلم'),
                items: ds.teachers.map((t) => DropdownMenuItem(value: t, child: Text(t.name))).toList(),
                onChanged: (v) => setD(() => teacher = v!),
              ),
              DropdownButtonFormField<AppUser>(
                initialValue: supervisor,
                decoration: const InputDecoration(labelText: 'المشرف'),
                items: ds.supervisors.map((s) => DropdownMenuItem(value: s, child: Text(s.name))).toList(),
                onChanged: (v) => setD(() => supervisor = v!),
              ),
              TextField(controller: scheduleCtrl, decoration: const InputDecoration(labelText: 'المواعيد')),
            ]),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
            FilledButton(
              onPressed: () {
                if (nameCtrl.text.trim().isEmpty) return;
                setState(() {
                  ds.circles.add(Circle(
                    id: 'C${ds.circles.length + 1}',
                    name: nameCtrl.text.trim(),
                    teacherId: teacher.id, teacherName: teacher.name,
                    supervisorId: supervisor.id,
                    level: level, schedule: scheduleCtrl.text.trim(),
                  ));
                });
                Navigator.pop(ctx);
              },
              child: const Text('إضافة'),
            ),
          ],
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الحلقات'),
        backgroundColor: const Color(0xFF0B7A5E), foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addCircleDialog,
        backgroundColor: const Color(0xFF0B7A5E),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('حلقة', style: TextStyle(color: Colors.white)),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: ds.circles.length,
        itemBuilder: (ctx, i) {
          final c = ds.circles[i];
          final studentsCount = ds.circleStudents(c.id).length;
          final attRate = ds.circleAttendanceRate(c.id);
          final recAvg = ds.circleRecitationAvg(c.id);
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: const Color(0xFF0B7A5E),
                child: Text('${i + 1}', style: const TextStyle(color: Colors.white)),
              ),
              title: Text(c.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${c.level} • ${c.teacherName}\n$circleStudentsLabel: $studentsCount • حضور ${attRate.toStringAsFixed(0)}% • تسميع ${recAvg.toStringAsFixed(1)}/10'),
              isThreeLine: true,
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => Navigator.push(ctx, MaterialPageRoute(builder: (_) => CircleDetailScreen(circle: c))),
            ),
          );
        },
      ),
    );
  }

  String get circleStudentsLabel => 'الطلاب';
}
