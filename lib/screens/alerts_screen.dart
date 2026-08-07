import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/data_service.dart';
import 'student_detail_screen.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});
  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  final ds = DataService.instance;

  String _typeLabel(AlertType t) {
    switch (t) {
      case AlertType.repeatedAbsence: return 'غياب متكرر';
      case AlertType.weakPerformance: return 'ضعف الأداء';
      case AlertType.decliningPerformance: return 'تراجع ملحوظ';
      case AlertType.none: return '';
    }
  }

  Color _typeColor(AlertType t) {
    switch (t) {
      case AlertType.repeatedAbsence: return Colors.red;
      case AlertType.weakPerformance: return Colors.orange;
      case AlertType.decliningPerformance: return Colors.deepOrange;
      case AlertType.none: return Colors.grey;
    }
  }

  IconData _typeIcon(AlertType t) {
    switch (t) {
      case AlertType.repeatedAbsence: return Icons.event_busy;
      case AlertType.weakPerformance: return Icons.trending_down;
      case AlertType.decliningPerformance: return Icons.show_chart;
      case AlertType.none: return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    final active = ds.activeAlerts();
    return Scaffold(
      appBar: AppBar(
        title: Text('التنبيهات (${active.length})'),
        backgroundColor: const Color(0xFF0B7A5E), foregroundColor: Colors.white,
      ),
      body: active.isEmpty
          ? const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.check_circle_outline, size: 64, color: Colors.green),
              SizedBox(height: 12),
              Text('لا توجد تنبيهات نشطة', style: TextStyle(fontSize: 16)),
            ]))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: active.length,
              itemBuilder: (ctx, i) {
                final a = active[i];
                final s = ds.studentById(a.studentId);
                if (s == null) return const SizedBox.shrink();
                final c = ds.circleById(s.circleId);
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _typeColor(a.type).withValues(alpha: 0.15),
                      child: Icon(_typeIcon(a.type), color: _typeColor(a.type)),
                    ),
                    title: Text(s.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${_typeLabel(a.type)}\n${a.message} • ${c?.name ?? ''}'),
                    isThreeLine: true,
                    trailing: TextButton(
                      onPressed: () {
                        setState(() {
                          final idx = ds.alerts.indexWhere((x) => x.id == a.id);
                          if (idx >= 0) {
                            ds.alerts[idx] = StudentAlert(
                              id: a.id, studentId: a.studentId, type: a.type,
                              message: a.message, date: a.date, resolved: true,
                            );
                          }
                        });
                      },
                      child: const Text('تمت المعالجة', style: TextStyle(fontSize: 12)),
                    ),
                    onTap: () => Navigator.push(ctx, MaterialPageRoute(builder: (_) => StudentDetailScreen(student: s))),
                  ),
                );
              },
            ),
    );
  }
}
