import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/data_service.dart';
import 'attendance_screen.dart';
import 'recitation_screen.dart';
import 'student_detail_screen.dart';

class CircleDetailScreen extends StatelessWidget {
  final Circle circle;
  const CircleDetailScreen({super.key, required this.circle});

  @override
  Widget build(BuildContext context) {
    final ds = DataService.instance;
    final students = ds.circleStudents(circle.id);
    final attRate = ds.circleAttendanceRate(circle.id);
    final recAvg = ds.circleRecitationAvg(circle.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(circle.name),
        backgroundColor: const Color(0xFF0B7A5E), foregroundColor: Colors.white,
      ),
      body: Column(children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          color: const Color(0xFF0B7A5E).withValues(alpha: 0.08),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('المستوى: ${circle.level}'),
            Text('المعلم: ${circle.teacherName}'),
            Text('المواعيد: ${circle.schedule}'),
            Text('نسبة الحضور: ${attRate.toStringAsFixed(1)}% • متوسط التسميع: ${recAvg.toStringAsFixed(1)}/10'),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(children: [
            Expanded(
              child: FilledButton.icon(
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => AttendanceScreen(circle: circle))),
                icon: const Icon(Icons.how_to_reg),
                label: const Text('تسجيل الحضور'),
                style: FilledButton.styleFrom(backgroundColor: const Color(0xFF0B7A5E)),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: FilledButton.icon(
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => RecitationScreen(circle: circle))),
                icon: const Icon(Icons.menu_book),
                label: const Text('تسجيل التسميع'),
                style: FilledButton.styleFrom(backgroundColor: const Color(0xFFC9A227)),
              ),
            ),
          ]),
        ),
        const Divider(),
        Expanded(
          child: ListView.builder(
            itemCount: students.length,
            itemBuilder: (ctx, i) {
              final s = students[i];
              final ev = ds.evaluateStudent(s.id);
              final hasAlert = ds.alerts.any((a) => a.studentId == s.id && !a.resolved);
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: hasAlert ? Colors.orange : const Color(0xFF0B7A5E).withValues(alpha: 0.2),
                  child: hasAlert
                      ? const Icon(Icons.warning_amber, color: Colors.white, size: 20)
                      : Text(s.name.characters.first, style: const TextStyle(color: Color(0xFF0B7A5E))),
                ),
                title: Text(s.name),
                subtitle: Text('العمر: ${s.age} • الأجزاء: ${s.memorizedJuz}'),
                trailing: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Text(ev.finalScore.toStringAsFixed(1), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(ev.grade, style: TextStyle(fontSize: 11, color: ev.finalScore >= 7.5 ? Colors.green : ev.finalScore >= 5 ? Colors.orange : Colors.red)),
                ]),
                onTap: () => Navigator.push(ctx, MaterialPageRoute(builder: (_) => StudentDetailScreen(student: s))),
              );
            },
          ),
        ),
      ]),
    );
  }
}
