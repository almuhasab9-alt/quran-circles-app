// Data models for Quran Circles Management App

enum UserRole { admin, supervisor, teacher }

class AppUser {
  final String id;
  final String name;
  final UserRole role;
  AppUser({required this.id, required this.name, required this.role});
  String get roleName {
    switch (role) {
      case UserRole.admin: return 'مدير';
      case UserRole.supervisor: return 'مشرف';
      case UserRole.teacher: return 'معلم';
    }
  }
}

class Circle {
  final String id;
  final String name;
  final String teacherId;
  final String teacherName;
  final String supervisorId;
  final String level; // تمارين النطق، التأسيسية، المتوسطة، المتقدمة، حلقة الإتقان
  final String schedule;
  Circle({
    required this.id, required this.name, required this.teacherId,
    required this.teacherName, required this.supervisorId,
    required this.level, required this.schedule,
  });
}

class Student {
  final String id;
  final String name;
  final int age;
  final String circleId;
  final String parentName;
  final String parentPhone;
  final int memorizedJuz; // عدد الأجزاء المحفوظة (0-30)
  final String level;
  final DateTime joinDate;
  Student({
    required this.id, required this.name, required this.age,
    required this.circleId, required this.parentName,
    required this.parentPhone, this.memorizedJuz = 0,
    required this.level, required this.joinDate,
  });
}

enum AttendanceStatus { present, absent, late, excused }

class AttendanceRecord {
  final String id;
  final String studentId;
  final String circleId;
  final DateTime date;
  final AttendanceStatus status;
  AttendanceRecord({
    required this.id, required this.studentId, required this.circleId,
    required this.date, required this.status,
  });
}

class RecitationRecord {
  final String id;
  final String studentId;
  final String circleId;
  final DateTime date;
  final String newMemorization; // الحفظ الجديد
  final String review; // المراجعة
  final int lightErrors; // أخطاء خفيفة
  final int mediumErrors; // أخطاء متوسطة
  final int majorErrors; // أخطاء كبيرة
  final bool homeworkDone; // الواجب
  final String notes;

  RecitationRecord({
    required this.id, required this.studentId, required this.circleId,
    required this.date, required this.newMemorization, required this.review,
    required this.lightErrors, required this.mediumErrors,
    required this.majorErrors, required this.homeworkDone, this.notes = '',
  });

  // جودة التسميع: تبدأ من 10، خفيفة -0.5، متوسطة -1، كبيرة -2
  double get recitationScore {
    double s = 10 - lightErrors * 0.5 - mediumErrors * 1.0 - majorErrors * 2.0;
    return s < 0 ? 0 : s;
  }

  double get reviewScore {
    // المراجعة تقاس بعدد الأخطاء أيضاً بشكل أخف
    double s = 10 - lightErrors * 0.25 - mediumErrors * 0.5 - majorErrors * 1.0;
    return s < 0 ? 0 : s;
  }

  double get homeworkScore => homeworkDone ? 10 : 0;
}

// التقييم النهائي: التسميع 45% + المراجعة 30% + الحضور 15% + الواجب 10%
class StudentEvaluation {
  final double recitation; // /10
  final double review;
  final double attendance;
  final double homework;
  StudentEvaluation({
    required this.recitation, required this.review,
    required this.attendance, required this.homework,
  });
  double get finalScore =>
      recitation * 0.45 + review * 0.30 + attendance * 0.15 + homework * 0.10;

  String get grade {
    if (finalScore >= 9) return 'ممتاز';
    if (finalScore >= 7.5) return 'جيد جداً';
    if (finalScore >= 6) return 'جيد';
    if (finalScore >= 5) return 'مقبول';
    return 'ضعيف';
  }
}

enum AlertType { repeatedAbsence, weakPerformance, decliningPerformance, none }

class StudentAlert {
  final String id;
  final String studentId;
  final AlertType type;
  final String message;
  final DateTime date;
  final bool resolved;
  StudentAlert({
    required this.id, required this.studentId, required this.type,
    required this.message, required this.date, this.resolved = false,
  });
}

class FollowUpPlan {
  final String id;
  final String studentId;
  final String createdBy; // المشرف
  final String plan;
  final DateTime startDate;
  final DateTime? endDate;
  final String status; // نشطة، مكتملة
  FollowUpPlan({
    required this.id, required this.studentId, required this.createdBy,
    required this.plan, required this.startDate, this.endDate,
    this.status = 'نشطة',
  });
}

class CommunicationLog {
  final String id;
  final String studentId;
  final String method; // اتصال، واتساب، رسالة
  final String result;
  final DateTime date;
  final String byUser;
  CommunicationLog({
    required this.id, required this.studentId, required this.method,
    required this.result, required this.date, required this.byUser,
  });
}
