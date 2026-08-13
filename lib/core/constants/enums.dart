// الأدوار: مشرف (يرى كل شيء) ومعلم (يرى حلقته فقط)
enum UserRole { supervisor, teacher }

/// التقدير: 4 خيارات فقط بدون درجات أو عدّ أخطاء
enum EvaluationGrade { excellent, veryGood, good, repeat }

extension UserRoleAr on UserRole {
  String get ar => switch (this) {
    UserRole.supervisor => 'مشرف',
    UserRole.teacher => 'معلم',
  };
}

extension EvaluationGradeAr on EvaluationGrade {
  String get ar => switch (this) {
    EvaluationGrade.excellent => 'ممتاز',
    EvaluationGrade.veryGood => 'جيد جداً',
    EvaluationGrade.good => 'جيد',
    EvaluationGrade.repeat => 'إعادة',
  };

  /// ترتيب رقمي للمقارنات والتقرير الأسبوعي
  int get rank => switch (this) {
    EvaluationGrade.excellent => 4,
    EvaluationGrade.veryGood => 3,
    EvaluationGrade.good => 2,
    EvaluationGrade.repeat => 1,
  };

  static EvaluationGrade? fromName(String? name) {
    if (name == null || name.isEmpty) return null;
    for (final g in EvaluationGrade.values) {
      if (g.name == name) return g;
    }
    return null;
  }
}

/// أيام عمل الحلقة: السبت..الجمعة (weekday: السبت=6 ... الجمعة=5)
extension WeekdayAr on DateTime {
  String get weekdayAr => switch (weekday) {
    DateTime.saturday => 'السبت',
    DateTime.sunday => 'الأحد',
    DateTime.monday => 'الاثنين',
    DateTime.tuesday => 'الثلاثاء',
    DateTime.wednesday => 'الأربعاء',
    DateTime.thursday => 'الخميس',
    DateTime.friday => 'الجمعة',
    _ => '',
  };

  bool get isFriday => weekday == DateTime.friday;
}
