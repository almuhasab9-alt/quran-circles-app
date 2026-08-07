import 'dart:math';
import '../models/models.dart';

// خدمة البيانات المحلية (تخزين في الذاكرة + SharedPreferences للجلسة)
class DataService {
  static final DataService instance = DataService._();
  DataService._();

  final List<Circle> circles = [];
  final List<Student> students = [];
  final List<AppUser> teachers = [];
  final List<AppUser> supervisors = [];
  final List<AttendanceRecord> attendance = [];
  final List<RecitationRecord> recitations = [];
  final List<StudentAlert> alerts = [];
  final List<FollowUpPlan> followUpPlans = [];
  final List<CommunicationLog> commLogs = [];

  bool seeded = false;

  static const levels = [
    'تمارين النطق', 'التأسيسية', 'المتوسطة', 'المتقدمة', 'حلقة الإتقان'
  ];

  static const teacherNames = [
    'أ. عبدالله الحربي', 'أ. محمد العتيبي', 'أ. خالد الشمري', 'أ. سعد القحطاني',
    'أ. فهد الدوسري', 'أ. عمر الغامدي', 'أ. يوسف المطيري', 'أ. إبراهيم الزهراني',
    'أ. سلطان العنزي', 'أ. ناصر البقمي',
  ];

  static const firstNames = [
    'أحمد', 'محمد', 'عبدالله', 'عبدالرحمن', 'خالد', 'سعد', 'فهد', 'عمر',
    'يوسف', 'إبراهيم', 'سلطان', 'ناصر', 'علي', 'حسن', 'طارق', 'زياد',
    'ماجد', 'بدر', 'رakan', 'فيصل', 'تركي', 'سالم', 'مشعل', 'راشد',
    'هاني', 'وليد', 'أنس', 'حمza', 'عمار', 'بلال',
  ];

  static const lastNames = [
    'الحربي', 'العتيبي', 'الشمري', 'القحطاني', 'الدوسري', 'الغامدي',
    'المطيري', 'الزهراني', 'العنزي', 'البقمي', 'السبيعي', 'الجهني',
  ];

  static const surahs = [
    'الفاتحة', 'البقرة', 'آل عمران', 'النساء', 'المائدة', 'الأنعام',
    'يس', 'الصافات', 'الفتح', 'الرحمن', 'الواقعة', 'الملك', 'القلم',
    'الحاقة', 'المعارج', 'نوح', 'الجن', 'المزمل', 'المدثر', 'القيامة',
    'الإنسان', 'المرسلات', 'النبأ', 'النازعات', 'عبس', 'التكوير',
    'الانفطار', 'المطففين', 'الانشقاق', 'البروج', 'الطارق', 'الأعلى',
    'الغاشية', 'الفجر', 'البلد', 'الشمس', 'الليل', 'الضحى', 'الشرح',
    'التين', 'العلق', 'القدر', 'البينة', 'الزلزلة', 'العاديات',
    'القارعة', 'التكاثر', 'العصر', 'الهمزة', 'الفيل', 'قريش',
    'الماعون', 'الكوثر', 'الكافرون', 'النصر', 'المسد', 'الإخلاص',
    'الفلق', 'الناس',
  ];

  void seed() {
    if (seeded) return;
    seeded = true;
    final rnd = Random(42);

    // 10 معلمين ومشرفين
    for (int i = 0; i < 10; i++) {
      teachers.add(AppUser(id: 'T${i + 1}', name: teacherNames[i], role: UserRole.teacher));
    }
    supervisors.add(AppUser(id: 'S1', name: 'أ. عبدالعزيز الرشيدي', role: UserRole.supervisor));
    supervisors.add(AppUser(id: 'S2', name: 'أ. منصور الحارثي', role: UserRole.supervisor));

    // 10 حلقات
    final circleNames = [
      'حلقة النور', 'حلقة الفرقان', 'حلقة الإخلاص', 'حلقة التقوى', 'حلقة الهدى',
      'حلقة الصديق', 'حلقة الفاروق', 'حلقة ذي النورين', 'حلقة سيف الله', 'حلقة الإتقان',
    ];
    for (int i = 0; i < 10; i++) {
      circles.add(Circle(
        id: 'C${i + 1}',
        name: circleNames[i],
        teacherId: 'T${i + 1}',
        teacherName: teacherNames[i],
        supervisorId: i < 5 ? 'S1' : 'S2',
        level: levels[i % levels.length],
        schedule: i % 2 == 0 ? 'السبت والاثنين والأربعاء - بعد العصر' : 'الأحد والثلاثاء والخميس - بعد المغرب',
      ));
    }

    // 200 طالب (20 لكل حلقة)
    int sid = 0;
    for (final c in circles) {
      for (int j = 0; j < 20; j++) {
        sid++;
        final fn = firstNames[rnd.nextInt(firstNames.length)];
        final ln = lastNames[rnd.nextInt(lastNames.length)];
        students.add(Student(
          id: 'ST$sid',
          name: '$fn $ln',
          age: 7 + rnd.nextInt(12),
          circleId: c.id,
          parentName: 'أبو $fn ${lastNames[rnd.nextInt(lastNames.length)]}',
          parentPhone: '05${rnd.nextInt(10)}${1000000 + rnd.nextInt(9000000)}',
          memorizedJuz: rnd.nextInt(31),
          level: c.level,
          joinDate: DateTime.now().subtract(Duration(days: 30 + rnd.nextInt(700))),
        ));
      }
    }

    // 12 أسبوعاً من السجلات (3 جلسات أسبوعياً = 36 جلسة)
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    int aid = 0, rid = 0;
    for (int week = 0; week < 12; week++) {
      for (int session = 0; session < 3; session++) {
        final date = today.subtract(Duration(days: (11 - week) * 7 + (2 - session) * 2));
        for (final c in circles) {
          for (final st in students.where((s) => s.circleId == c.id)) {
            // الحضور: 85% حاضر، 8% غائب، 5% متأخر، 2% بعذر
            final r = rnd.nextDouble();
            final status = r < 0.85
                ? AttendanceStatus.present
                : r < 0.93
                    ? AttendanceStatus.absent
                    : r < 0.98
                        ? AttendanceStatus.late
                        : AttendanceStatus.excused;
            attendance.add(AttendanceRecord(
              id: 'A${++aid}', studentId: st.id, circleId: c.id,
              date: date, status: status,
            ));
            if (status == AttendanceStatus.present || status == AttendanceStatus.late) {
              final s1 = surahs[rnd.nextInt(surahs.length)];
              final s2 = surahs[rnd.nextInt(surahs.length)];
              recitations.add(RecitationRecord(
                id: 'R${++rid}', studentId: st.id, circleId: c.id, date: date,
                newMemorization: 'سورة $s1 - الآيات ${1 + rnd.nextInt(10)}-${5 + rnd.nextInt(15)}',
                review: 'سورة $s2',
                lightErrors: rnd.nextInt(4),
                mediumErrors: rnd.nextInt(10) < 4 ? rnd.nextInt(3) : 0,
                majorErrors: rnd.nextInt(15) < 2 ? 1 : 0,
                homeworkDone: rnd.nextDouble() < 0.8,
                notes: rnd.nextDouble() < 0.15 ? 'يحتاج مراجعة التجويد' : '',
              ));
            }
          }
        }
      }
    }

    generateAlerts();
  }

  // توليد التنبيهات: غياب متكرر، ضعف الأداء، تراجع ملحوظ
  void generateAlerts() {
    alerts.clear();
    int alid = 0;
    for (final st in students) {
      final stAtt = attendance.where((a) => a.studentId == st.id).toList();
      if (stAtt.isEmpty) continue;
      final absentCount = stAtt.where((a) => a.status == AttendanceStatus.absent).length;
      final absentRate = absentCount / stAtt.length;

      if (absentRate > 0.2) {
        alerts.add(StudentAlert(
          id: 'AL${++alid}', studentId: st.id, type: AlertType.repeatedAbsence,
          message: 'غياب متكرر: ${(absentRate * 100).toStringAsFixed(0)}% من الجلسات',
          date: DateTime.now(),
        ));
        continue;
      }
      final stRec = recitations.where((r) => r.studentId == st.id).toList();
      if (stRec.length >= 4) {
        final avg = stRec.map((r) => r.recitationScore).reduce((a, b) => a + b) / stRec.length;
        if (avg < 5.5) {
          alerts.add(StudentAlert(
            id: 'AL${++alid}', studentId: st.id, type: AlertType.weakPerformance,
            message: 'ضعف في متوسط التسميع: ${avg.toStringAsFixed(1)}/10',
            date: DateTime.now(),
          ));
          continue;
        }
        // تراجع: آخر 5 مقارنة بالسابق
        stRec.sort((a, b) => a.date.compareTo(b.date));
        if (stRec.length >= 10) {
          final recent = stRec.sublist(stRec.length - 5);
          final older = stRec.sublist(stRec.length - 10, stRec.length - 5);
          final recentAvg = recent.map((r) => r.recitationScore).reduce((a, b) => a + b) / 5;
          final olderAvg = older.map((r) => r.recitationScore).reduce((a, b) => a + b) / 5;
          if (olderAvg - recentAvg >= 2.0) {
            alerts.add(StudentAlert(
              id: 'AL${++alid}', studentId: st.id, type: AlertType.decliningPerformance,
              message: 'تراجع ملحوظ: من ${olderAvg.toStringAsFixed(1)} إلى ${recentAvg.toStringAsFixed(1)}',
              date: DateTime.now(),
            ));
          }
        }
      }
    }
  }

  StudentEvaluation evaluateStudent(String studentId) {
    final rec = recitations.where((r) => r.studentId == studentId).toList();
    final att = attendance.where((a) => a.studentId == studentId).toList();
    double recScore = 0, revScore = 0, hwScore = 0, attScore = 0;
    if (rec.isNotEmpty) {
      recScore = rec.map((r) => r.recitationScore).reduce((a, b) => a + b) / rec.length;
      revScore = rec.map((r) => r.reviewScore).reduce((a, b) => a + b) / rec.length;
      hwScore = rec.map((r) => r.homeworkScore).reduce((a, b) => a + b) / rec.length;
    }
    if (att.isNotEmpty) {
      final present = att.where((a) => a.status == AttendanceStatus.present || a.status == AttendanceStatus.late).length;
      attScore = present / att.length * 10;
    }
    return StudentEvaluation(recitation: recScore, review: revScore, attendance: attScore, homework: hwScore);
  }

  double circleAttendanceRate(String circleId) {
    final att = attendance.where((a) => a.circleId == circleId).toList();
    if (att.isEmpty) return 0;
    final present = att.where((a) => a.status == AttendanceStatus.present || a.status == AttendanceStatus.late).length;
    return present / att.length * 100;
  }

  double circleRecitationAvg(String circleId) {
    final rec = recitations.where((r) => r.circleId == circleId).toList();
    if (rec.isEmpty) return 0;
    return rec.map((r) => r.recitationScore).reduce((a, b) => a + b) / rec.length;
  }

  List<Student> circleStudents(String circleId) =>
      students.where((s) => s.circleId == circleId).toList();

  Circle? circleById(String id) {
    for (final c in circles) { if (c.id == id) return c; }
    return null;
  }

  Student? studentById(String id) {
    for (final s in students) { if (s.id == id) return s; }
    return null;
  }

  void addAttendanceBatch(String circleId, DateTime date, Map<String, AttendanceStatus> statuses) {
    attendance.removeWhere((a) =>
        a.circleId == circleId &&
        a.date.year == date.year && a.date.month == date.month && a.date.day == date.day);
    int n = attendance.length;
    statuses.forEach((sid, status) {
      attendance.add(AttendanceRecord(
        id: 'AM${++n}', studentId: sid, circleId: circleId, date: date, status: status,
      ));
    });
    generateAlerts();
  }

  void addRecitation(RecitationRecord r) {
    recitations.add(r);
    generateAlerts();
  }

  void addStudent(Student s) => students.add(s);

  void updateStudent(Student updated) {
    final i = students.indexWhere((s) => s.id == updated.id);
    if (i >= 0) students[i] = updated;
  }

  void addFollowUpPlan(FollowUpPlan p) => followUpPlans.add(p);
  void addCommLog(CommunicationLog l) => commLogs.add(l);

  List<CommunicationLog> studentCommLogs(String sid) =>
      commLogs.where((l) => l.studentId == sid).toList()
        ..sort((a, b) => b.date.compareTo(a.date));

  List<FollowUpPlan> studentPlans(String sid) =>
      followUpPlans.where((p) => p.studentId == sid).toList();

  List<StudentAlert> activeAlerts() => alerts.where((a) => !a.resolved).toList();
}
