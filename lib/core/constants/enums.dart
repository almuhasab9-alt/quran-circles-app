enum UserRole { admin, supervisor, teacher }

enum AttendanceStatus { present, late, excusedAbsence, unexcusedAbsence }

enum HomeworkStatus { completed, partial, notCompleted }

enum PerformanceLevel { excellent, veryGood, good, improve, followUp }

enum AlertType {
  repeatedUnexcusedAbsence,
  lowAverage,
  performanceDrop,
  frequentMajorErrors,
  excellentStreak,
  missingRecord,
}

enum AlertSeverity { normal, important, urgent }

extension AlertSeverityAr on AlertSeverity {
  String get ar => switch (this) {
    AlertSeverity.normal => 'عادي',
    AlertSeverity.important => 'مهم',
    AlertSeverity.urgent => 'عاجل',
  };
}

extension PreferredContactAr on PreferredContact {
  String get ar => switch (this) {
    PreferredContact.call => 'اتصال',
    PreferredContact.sms => 'رسالة نصية',
    PreferredContact.whatsapp => 'واتساب',
  };
}
enum AlertStatus { draft, pendingReview, approved, closed }

enum ContactChannel { call, sms, whatsapp }
enum PreferredContact { call, sms, whatsapp }

enum FollowUpStatus { active, completed, cancelled }

extension UserRoleAr on UserRole {
  String get ar => switch (this) {
    UserRole.admin => 'مدير',
    UserRole.supervisor => 'مشرف',
    UserRole.teacher => 'معلم',
  };
}

extension AttendanceStatusAr on AttendanceStatus {
  String get ar => switch (this) {
    AttendanceStatus.present => 'حاضر',
    AttendanceStatus.late => 'متأخر',
    AttendanceStatus.excusedAbsence => 'غائب بعذر',
    AttendanceStatus.unexcusedAbsence => 'غائب بلا عذر',
  };
}

extension HomeworkStatusAr on HomeworkStatus {
  String get ar => switch (this) {
    HomeworkStatus.completed => 'مكتمل',
    HomeworkStatus.partial => 'جزئي',
    HomeworkStatus.notCompleted => 'غير مكتمل',
  };
}

extension PerformanceLevelAr on PerformanceLevel {
  String get ar => switch (this) {
    PerformanceLevel.excellent => 'متقن',
    PerformanceLevel.veryGood => 'جيد جداً',
    PerformanceLevel.good => 'جيد',
    PerformanceLevel.improve => 'يحتاج تحسيناً',
    PerformanceLevel.followUp => 'يحتاج متابعة',
  };
}

extension AlertTypeAr on AlertType {
  String get ar => switch (this) {
    AlertType.repeatedUnexcusedAbsence => 'غياب متكرر بلا عذر',
    AlertType.lowAverage => 'متوسط منخفض',
    AlertType.performanceDrop => 'تراجع ملحوظ',
    AlertType.frequentMajorErrors => 'أخطاء كبيرة متكررة',
    AlertType.excellentStreak => 'تميز متواصل',
    AlertType.missingRecord => 'سجل مفقود',
  };
}

extension ContactChannelAr on ContactChannel {
  String get ar => switch (this) {
    ContactChannel.call => 'اتصال',
    ContactChannel.sms => 'رسالة نصية',
    ContactChannel.whatsapp => 'واتساب',
  };
}
