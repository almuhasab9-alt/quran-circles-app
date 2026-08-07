import 'package:shared_preferences/shared_preferences.dart';

// إعدادات قابلة للتعديل من شاشة الإعدادات
class AppSettings {
  // أوزان التقييم
  double recitationWeight;
  double revisionWeight;
  double attendanceWeight;
  double homeworkWeight;
  // خصومات الأخطاء
  double minorDeduction;
  double mediumDeduction;
  double majorDeduction;
  double selfCorrectionDeduction;
  // قواعد التنبيه
  bool ruleAbsenceEnabled;
  int absenceCount;
  int absenceDaysWindow;
  bool ruleLowAvgEnabled;
  double lowAvgThreshold;
  int lowAvgSessions;
  bool ruleDropEnabled;
  double dropThreshold;
  bool ruleMajorErrorsEnabled;
  int majorErrorsCount;
  int majorErrorsDays;
  bool ruleExcellentEnabled;
  int excellentStreakCount;
  bool ruleMissingRecordEnabled;
  bool darkMode;

  AppSettings({
    this.recitationWeight = 0.45,
    this.revisionWeight = 0.30,
    this.attendanceWeight = 0.15,
    this.homeworkWeight = 0.10,
    this.minorDeduction = 1,
    this.mediumDeduction = 3,
    this.majorDeduction = 6,
    this.selfCorrectionDeduction = 0,
    this.ruleAbsenceEnabled = true,
    this.absenceCount = 3,
    this.absenceDaysWindow = 14,
    this.ruleLowAvgEnabled = true,
    this.lowAvgThreshold = 60,
    this.lowAvgSessions = 5,
    this.ruleDropEnabled = true,
    this.dropThreshold = 20,
    this.ruleMajorErrorsEnabled = true,
    this.majorErrorsCount = 3,
    this.majorErrorsDays = 7,
    this.ruleExcellentEnabled = true,
    this.excellentStreakCount = 4,
    this.ruleMissingRecordEnabled = true,
    this.darkMode = false,
  });

  static AppSettings? _cached;
  static Future<AppSettings> load() async {
    if (_cached != null) return _cached!;
    final p = await SharedPreferences.getInstance();
    _cached = AppSettings(
      recitationWeight: p.getDouble('recitationWeight') ?? 0.45,
      revisionWeight: p.getDouble('revisionWeight') ?? 0.30,
      attendanceWeight: p.getDouble('attendanceWeight') ?? 0.15,
      homeworkWeight: p.getDouble('homeworkWeight') ?? 0.10,
      minorDeduction: p.getDouble('minorDeduction') ?? 1,
      mediumDeduction: p.getDouble('mediumDeduction') ?? 3,
      majorDeduction: p.getDouble('majorDeduction') ?? 6,
      selfCorrectionDeduction: p.getDouble('selfCorrectionDeduction') ?? 0,
      ruleAbsenceEnabled: p.getBool('ruleAbsenceEnabled') ?? true,
      absenceCount: p.getInt('absenceCount') ?? 3,
      absenceDaysWindow: p.getInt('absenceDaysWindow') ?? 14,
      ruleLowAvgEnabled: p.getBool('ruleLowAvgEnabled') ?? true,
      lowAvgThreshold: p.getDouble('lowAvgThreshold') ?? 60,
      lowAvgSessions: p.getInt('lowAvgSessions') ?? 5,
      ruleDropEnabled: p.getBool('ruleDropEnabled') ?? true,
      dropThreshold: p.getDouble('dropThreshold') ?? 20,
      ruleMajorErrorsEnabled: p.getBool('ruleMajorErrorsEnabled') ?? true,
      majorErrorsCount: p.getInt('majorErrorsCount') ?? 3,
      majorErrorsDays: p.getInt('majorErrorsDays') ?? 7,
      ruleExcellentEnabled: p.getBool('ruleExcellentEnabled') ?? true,
      excellentStreakCount: p.getInt('excellentStreakCount') ?? 4,
      ruleMissingRecordEnabled: p.getBool('ruleMissingRecordEnabled') ?? true,
      darkMode: p.getBool('darkMode') ?? false,
    );
    return _cached!;
  }

  Future<void> save() async {
    final p = await SharedPreferences.getInstance();
    await p.setDouble('recitationWeight', recitationWeight);
    await p.setDouble('revisionWeight', revisionWeight);
    await p.setDouble('attendanceWeight', attendanceWeight);
    await p.setDouble('homeworkWeight', homeworkWeight);
    await p.setDouble('minorDeduction', minorDeduction);
    await p.setDouble('mediumDeduction', mediumDeduction);
    await p.setDouble('majorDeduction', majorDeduction);
    await p.setDouble('selfCorrectionDeduction', selfCorrectionDeduction);
    await p.setBool('ruleAbsenceEnabled', ruleAbsenceEnabled);
    await p.setInt('absenceCount', absenceCount);
    await p.setInt('absenceDaysWindow', absenceDaysWindow);
    await p.setBool('ruleLowAvgEnabled', ruleLowAvgEnabled);
    await p.setDouble('lowAvgThreshold', lowAvgThreshold);
    await p.setInt('lowAvgSessions', lowAvgSessions);
    await p.setBool('ruleDropEnabled', ruleDropEnabled);
    await p.setDouble('dropThreshold', dropThreshold);
    await p.setBool('ruleMajorErrorsEnabled', ruleMajorErrorsEnabled);
    await p.setInt('majorErrorsCount', majorErrorsCount);
    await p.setInt('majorErrorsDays', majorErrorsDays);
    await p.setBool('ruleExcellentEnabled', ruleExcellentEnabled);
    await p.setInt('excellentStreakCount', excellentStreakCount);
    await p.setBool('ruleMissingRecordEnabled', ruleMissingRecordEnabled);
    await p.setBool('darkMode', darkMode);
  }

  static void invalidate() => _cached = null;
}
