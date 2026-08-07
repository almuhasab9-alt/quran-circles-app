import 'package:drift/drift.dart';
import 'package:csv/csv.dart';
import '../database/app_database.dart';
import '../utils/date_utils.dart' as du;

// خدمة التقارير — قابلة لإضافة PDF لاحقاً
class ReportService {
  final AppDatabase db;
  DateTime? lastGeneratedAt;
  ReportService(this.db);

  Future<String> studentReport(Student s) async {
    final h = await (db.select(db.halaqas)..where((x) => x.id.equals(s.halaqaId))).getSingleOrNull();
    final recs = await (db.select(db.dailyRecords)..where((r) => r.studentId.equals(s.id))).get();
    lastGeneratedAt = DateTime.now();
    final present = recs.where((r) => r.attendance == 'present' || r.attendance == 'late').length;
    final attRate = recs.isEmpty ? 0.0 : present / recs.length * 100;
    final avg = recs.isEmpty ? 0.0 : recs.map((r) => r.finalScore).reduce((a, b) => a + b) / recs.length;
    final now = du.formatDate(DateTime.now());
    return '''
تقرير الطالب - مركز السنة للعلوم الشرعية وتأهيل الدعاة
التاريخ: $now
الطالب: ${s.fullName} (${s.studentCode})
الحلقة: ${h?.name ?? ''}
الانضمام: ${du.formatDate(s.joinDate)}
---
نسبة الحضور: ${attRate.toStringAsFixed(1)}%
متوسط التقييم النهائي: ${avg.toStringAsFixed(1)}/100
عدد الجلسات المسجلة: ${recs.length}
---
آخر 5 سجلات:
${recs.reversed.take(5).map((r) => '${r.dateKey}: ${r.finalScore.toStringAsFixed(1)}').join('\n')}
''';
  }

  Future<String> halaqaReport(Halaqa h) async {
    final students = await (db.select(db.students)..where((s) => s.halaqaId.equals(h.id) & s.active.equals(true))).get();
    final recs = await (db.select(db.dailyRecords)..where((r) => r.halaqaId.equals(h.id))).get();
    lastGeneratedAt = DateTime.now();
    final present = recs.where((r) => r.attendance == 'present' || r.attendance == 'late').length;
    final attRate = recs.isEmpty ? 0.0 : present / recs.length * 100;
    final avg = recs.isEmpty ? 0.0 : recs.map((r) => r.finalScore).reduce((a, b) => a + b) / recs.length;
    final sb = StringBuffer('''
تقرير الحلقة - مركز السنة للعلوم الشرعية وتأهيل الدعاة
التاريخ: ${du.formatDate(DateTime.now())}
الحلقة: ${h.name} | المستوى: ${h.level}
عدد الطلاب: ${students.length}
نسبة الحضور: ${attRate.toStringAsFixed(1)}%
متوسط التقييم: ${avg.toStringAsFixed(1)}/100
---
الطلاب:
''');
    for (final s in students) {
      final srecs = recs.where((r) => r.studentId == s.id).toList();
      final savg = srecs.isEmpty ? 0.0 : srecs.map((r) => r.finalScore).reduce((a, b) => a + b) / srecs.length;
      sb.writeln('${s.fullName}: ${savg.toStringAsFixed(1)}');
    }
    return sb.toString();
  }

  Future<String> centerReport() async {
    final halaqas = await db.select(db.halaqas).get();
    final students = await (db.select(db.students)..where((s) => s.active.equals(true))).get();
    final recs = await db.select(db.dailyRecords).get();
    final alerts = await (db.select(db.alerts)..where((a) => a.status.isNotIn(['closed']))).get();
    lastGeneratedAt = DateTime.now();
    final present = recs.where((r) => r.attendance == 'present' || r.attendance == 'late').length;
    final attRate = recs.isEmpty ? 0.0 : present / recs.length * 100;
    final avg = recs.isEmpty ? 0.0 : recs.map((r) => r.finalScore).reduce((a, b) => a + b) / recs.length;
    final sb = StringBuffer('''
التقرير العام للمركز - مركز السنة للعلوم الشرعية وتأهيل الدعاة
التاريخ: ${du.formatDate(DateTime.now())}
عدد الحلقات: ${halaqas.length}
عدد الطلاب النشطين: ${students.length}
نسبة الحضور العامة: ${attRate.toStringAsFixed(1)}%
متوسط التقييم العام: ${avg.toStringAsFixed(1)}/100
التنبيهات المفتوحة: ${alerts.length}
---
أداء الحلقات:
''');
    for (final h in halaqas) {
      final hrecs = recs.where((r) => r.halaqaId == h.id).toList();
      final hpresent = hrecs.where((r) => r.attendance == 'present' || r.attendance == 'late').length;
      final hrate = hrecs.isEmpty ? 0.0 : hpresent / hrecs.length * 100;
      final havg = hrecs.isEmpty ? 0.0 : hrecs.map((r) => r.finalScore).reduce((a, b) => a + b) / hrecs.length;
      sb.writeln('${h.name}: حضور ${hrate.toStringAsFixed(0)}% | تقييم ${havg.toStringAsFixed(1)}');
    }
    return sb.toString();
  }

  Future<String> csvExport({String? halaqaId}) async {
    final students = halaqaId != null
        ? await (db.select(db.students)..where((s) => s.halaqaId.equals(halaqaId) & s.active.equals(true))).get()
        : await (db.select(db.students)..where((s) => s.active.equals(true))).get();
    final recs = await db.select(db.dailyRecords).get();
    final halaqas = await db.select(db.halaqas).get();
    final hMap = {for (final h in halaqas) h.id: h.name};
    lastGeneratedAt = DateTime.now();
    final rows = <List<dynamic>>[
      ['الكود', 'الطالب', 'الحلقة', 'نسبة الحضور %', 'متوسط التقييم', 'عدد الجلسات'],
    ];
    for (final s in students) {
      final srecs = recs.where((r) => r.studentId == s.id).toList();
      final present = srecs.where((r) => r.attendance == 'present' || r.attendance == 'late').length;
      final attRate = srecs.isEmpty ? 0.0 : present / srecs.length * 100;
      final avg = srecs.isEmpty ? 0.0 : srecs.map((r) => r.finalScore).reduce((a, b) => a + b) / srecs.length;
      rows.add([s.studentCode, s.fullName, hMap[s.halaqaId] ?? '', attRate.toStringAsFixed(1), avg.toStringAsFixed(1), srecs.length]);
    }
    return const ListToCsvConverter().convert(rows);
  }
}
