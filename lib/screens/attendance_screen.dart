import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/data_service.dart';

// شاشة الحضور السريع: الكل حاضر افتراضياً، يغير المعلم الغائب/المتأخر فقط
class AttendanceScreen extends StatefulWidget {
  final Circle circle;
  const AttendanceScreen({super.key, required this.circle});
  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final ds = DataService.instance;
  final Map<String, AttendanceStatus> statuses = {};
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    // الجميع حاضر افتراضياً
    for (final s in ds.circleStudents(widget.circle.id)) {
      statuses[s.id] = AttendanceStatus.present;
    }
  }

  String _statusLabel(AttendanceStatus s) {
    switch (s) {
      case AttendanceStatus.present: return 'حاضر';
      case AttendanceStatus.absent: return 'غائب';
      case AttendanceStatus.late: return 'متأخر';
      case AttendanceStatus.excused: return 'بعذر';
    }
  }

  Color _statusColor(AttendanceStatus s) {
    switch (s) {
      case AttendanceStatus.present: return Colors.green;
      case AttendanceStatus.absent: return Colors.red;
      case AttendanceStatus.late: return Colors.orange;
      case AttendanceStatus.excused: return Colors.blue;
    }
  }

  void _save() {
    ds.addAttendanceBatch(widget.circle.id, selectedDate, statuses);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم حفظ الحضور بنجاح'), backgroundColor: Color(0xFF0B7A5E)),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final students = ds.circleStudents(widget.circle.id);
    final presentCount = statuses.values.where((s) => s == AttendanceStatus.present).length;
    final absentCount = statuses.values.where((s) => s == AttendanceStatus.absent).length;
    final lateCount = statuses.values.where((s) => s == AttendanceStatus.late).length;

    return Scaffold(
      appBar: AppBar(
        title: Text('حضور ${widget.circle.name}'),
        backgroundColor: const Color(0xFF0B7A5E), foregroundColor: Colors.white,
      ),
      body: Column(children: [
        Container(
          padding: const EdgeInsets.all(12),
          color: Colors.grey.shade100,
          child: Row(children: [
            Expanded(child: Text('حاضر: $presentCount', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold))),
            Expanded(child: Text('غائب: $absentCount', style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold))),
            Expanded(child: Text('متأخر: $lateCount', style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold))),
          ]),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: students.length,
            itemBuilder: (ctx, i) {
              final s = students[i];
              final st = statuses[s.id]!;
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: _statusColor(st).withValues(alpha: 0.15),
                  child: Text('${i + 1}', style: TextStyle(color: _statusColor(st))),
                ),
                title: Text(s.name),
                trailing: SegmentedButton<AttendanceStatus>(
                  showSelectedIcon: false,
                  style: ButtonStyle(
                    visualDensity: VisualDensity.compact,
                    textStyle: WidgetStateProperty.all(const TextStyle(fontSize: 11)),
                  ),
                  segments: const [
                    ButtonSegment(value: AttendanceStatus.present, label: Text('ح')),
                    ButtonSegment(value: AttendanceStatus.absent, label: Text('غ')),
                    ButtonSegment(value: AttendanceStatus.late, label: Text('ت')),
                    ButtonSegment(value: AttendanceStatus.excused, label: Text('ع')),
                  ],
                  selected: {st},
                  onSelectionChanged: (v) => setState(() => statuses[s.id] = v.first),
                ),
                subtitle: Text(_statusLabel(st), style: TextStyle(color: _statusColor(st), fontSize: 11)),
              );
            },
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: SizedBox(
              width: double.infinity, height: 50,
              child: FilledButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.save),
                label: const Text('حفظ الحضور', style: TextStyle(fontSize: 17)),
                style: FilledButton.styleFrom(backgroundColor: const Color(0xFF0B7A5E)),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
