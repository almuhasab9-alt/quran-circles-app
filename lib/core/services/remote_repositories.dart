import '../database/app_database.dart';
import '../../shared/models/repositories.dart';
import 'api_client.dart';

// ─── Helpers: drift data classes ←→ JSON ←→ snake_case ───

DateTime _dt(dynamic v) {
  if (v is int) return DateTime.fromMillisecondsSinceEpoch(v);
  if (v is String) return DateTime.parse(v);
  return DateTime.now();
}

Halaqa _halaqaFromJson(Map<String, dynamic> j) => Halaqa(
  id: j['id'] as String,
  name: j['name'] as String,
  level: (j['level'] ?? '') as String,
  teacherIds: (j['teacherIds'] ?? '') as String,
  supervisorId: (j['supervisorId'] ?? '') as String,
  capacity: (j['capacity'] ?? 25) as int,
  scheduleDescription: (j['scheduleDescription'] ?? '') as String,
  active: (j['active'] ?? true) as bool,
);

Student _studentFromJson(Map<String, dynamic> j) => Student(
  id: j['id'] as String,
  studentCode: j['studentCode'] as String,
  fullName: j['fullName'] as String,
  halaqaId: j['halaqaId'] as String,
  level: (j['level'] ?? '') as String,
  active: (j['active'] ?? true) as bool,
  joinDate: _dt(j['joinDate']),
  internalNotes: (j['internalNotes'] ?? '') as String,
  createdAt: _dt(j['createdAt']),
  updatedAt: _dt(j['updatedAt']),
);

DailyRecord _recordFromJson(Map<String, dynamic> j) => DailyRecord(
  id: j['id'] as String,
  studentId: j['studentId'] as String,
  halaqaId: j['halaqaId'] as String,
  teacherId: (j['teacherId'] ?? '') as String,
  date: _dt(j['date']),
  dateKey: j['dateKey'] as String,
  weekday: (j['weekday'] ?? 1) as int,
  isFriday: (j['isFriday'] ?? false) as bool,
  newFromSurah: (j['newFromSurah'] ?? 0) as int,
  newFromAyah: (j['newFromAyah'] ?? 0) as int,
  newToSurah: (j['newToSurah'] ?? 0) as int,
  newToAyah: (j['newToAyah'] ?? 0) as int,
  newPages: (j['newPages'] ?? 0) as double,
  grade: (j['grade'] ?? '') as String,
  repetition: (j['repetition'] ?? 0) as int,
  recentFromPage: (j['recentFromPage'] ?? 0) as int,
  recentToPage: (j['recentToPage'] ?? 0) as int,
  minorFromPage: (j['minorFromPage'] ?? 0) as int,
  minorToPage: (j['minorToPage'] ?? 0) as int,
  majorFromPage: (j['majorFromPage'] ?? 0) as int,
  majorToPage: (j['majorToPage'] ?? 0) as int,
  notes: (j['notes'] ?? '') as String,
  createdAt: _dt(j['createdAt']),
  updatedAt: _dt(j['updatedAt']),
);

User _userFromJson(Map<String, dynamic> j) => User(
  id: j['id'] as String,
  fullName: j['fullName'] as String,
  username: j['username'] as String,
  role: j['role'] as String,
  active: (j['active'] ?? true) as bool,
  assignedHalaqaIds: (j['assignedHalaqaIds'] ?? '') as String,
  createdAt: _dt(j['createdAt']),
  updatedAt: _dt(j['updatedAt']),
);

WeeklyPlan _planFromJson(Map<String, dynamic> j) => WeeklyPlan(
  id: j['id'] as String,
  studentId: j['studentId'] as String,
  halaqaId: j['halaqaId'] as String,
  weekStartKey: j['weekStartKey'] as String,
  requiredNewPages: (j['requiredNewPages'] ?? 0) as double,
  requiredRecentPages: (j['requiredRecentPages'] ?? 0) as double,
  requiredMinorPages: (j['requiredMinorPages'] ?? 0) as double,
  requiredMajorPages: (j['requiredMajorPages'] ?? 0) as double,
  requiredFridayPages: (j['requiredFridayPages'] ?? 0) as double,
  createdAt: _dt(j['createdAt']),
  updatedAt: _dt(j['updatedAt']),
);

StudentTransfer _transferFromJson(Map<String, dynamic> j) => StudentTransfer(
  id: j['id'] as String,
  studentId: j['studentId'] as String,
  fromHalaqaId: j['fromHalaqaId'] as String,
  toHalaqaId: j['toHalaqaId'] as String,
  transferredAt: _dt(j['transferredAt']),
  byUser: (j['byUser'] ?? '') as String,
);

// ─── Remote Repositories ───

class RemoteHalaqaRepository implements IHalaqaRepository {
  final ApiClient api;
  RemoteHalaqaRepository(this.api);

  @override
  Future<List<Halaqa>> getAll({bool includeInactive = false}) async {
    final list = await api.getList('/api/halaqas',
        query: includeInactive ? {'includeInactive': 'true'} : null);
    return list.map(_halaqaFromJson).toList();
  }

  @override
  Future<Halaqa?> getById(String id) async {
    final j = await api.getOne('/api/halaqas/$id');
    return j != null ? _halaqaFromJson(j) : null;
  }

  @override
  Future<List<Halaqa>> byTeacher(String teacherId) async {
    final list = await api.getList('/api/halaqas/by-teacher/$teacherId');
    return list.map(_halaqaFromJson).toList();
  }

  @override
  Future<List<Halaqa>> bySupervisor(String supervisorId) async {
    final list = await api.getList('/api/halaqas/by-supervisor/$supervisorId');
    return list.map(_halaqaFromJson).toList();
  }

  @override
  Future<void> insert(HalaqasCompanion h) async {
    await api.post('/api/halaqas', _halaqaToJson(h));
  }

  @override
  Future<void> update(HalaqasCompanion h) async {
    await api.put('/api/halaqas/${h.id.value}', _halaqaToJson(h));
  }

  @override
  Future<void> deactivate(String id) async {
    await api.delete('/api/halaqas/$id');
  }

  Map<String, dynamic> _halaqaToJson(HalaqasCompanion h) {
    final j = <String, dynamic>{};
    if (h.id.present) j['id'] = h.id.value;
    if (h.name.present) j['name'] = h.name.value;
    if (h.level.present) j['level'] = h.level.value;
    if (h.teacherIds.present) j['teacherIds'] = h.teacherIds.value;
    if (h.supervisorId.present) j['supervisorId'] = h.supervisorId.value;
    if (h.capacity.present) j['capacity'] = h.capacity.value;
    if (h.scheduleDescription.present) j['scheduleDescription'] = h.scheduleDescription.value;
    if (h.active.present) j['active'] = h.active.value;
    return j;
  }
}

class RemoteStudentRepository implements IStudentRepository {
  final ApiClient api;
  RemoteStudentRepository(this.api);

  @override
  Future<List<Student>> getAll({bool includeInactive = false}) async {
    final list = await api.getList('/api/students',
        query: includeInactive ? {'includeInactive': 'true'} : null);
    return list.map(_studentFromJson).toList();
  }

  @override
  Future<List<Student>> byHalaqa(String halaqaId) async {
    final list = await api.getList('/api/students', query: {'halaqaId': halaqaId});
    return list.map(_studentFromJson).toList();
  }

  @override
  Future<Student?> getById(String id) async {
    final j = await api.getOne('/api/students/$id');
    return j != null ? _studentFromJson(j) : null;
  }

  @override
  Future<List<Student>> search(String query) async {
    final list = await api.getList('/api/students', query: {'q': query});
    return list.map(_studentFromJson).toList();
  }

  @override
  Future<void> insert(StudentsCompanion s) async {
    await api.post('/api/students', _studentToJson(s));
  }

  @override
  Future<void> update(StudentsCompanion s) async {
    await api.put('/api/students/${s.id.value}', _studentToJson(s));
  }

  @override
  Future<void> deactivate(String id) async {
    await api.delete('/api/students/$id');
  }

  Map<String, dynamic> _studentToJson(StudentsCompanion s) {
    final j = <String, dynamic>{};
    if (s.id.present) j['id'] = s.id.value;
    if (s.studentCode.present) j['studentCode'] = s.studentCode.value;
    if (s.fullName.present) j['fullName'] = s.fullName.value;
    if (s.halaqaId.present) j['halaqaId'] = s.halaqaId.value;
    if (s.level.present) j['level'] = s.level.value;
    if (s.active.present) j['active'] = s.active.value;
    if (s.joinDate.present) j['joinDate'] = s.joinDate.value.millisecondsSinceEpoch;
    if (s.internalNotes.present) j['internalNotes'] = s.internalNotes.value;
    return j;
  }
}

class RemoteDailyRecordRepository implements IDailyRecordRepository {
  final ApiClient api;
  RemoteDailyRecordRepository(this.api);

  @override
  Future<List<DailyRecord>> all() async {
    final list = await api.getList('/api/daily-records');
    return list.map(_recordFromJson).toList();
  }

  @override
  Future<List<DailyRecord>> byStudent(String studentId) async {
    final list = await api.getList('/api/daily-records', query: {'studentId': studentId});
    return list.map(_recordFromJson).toList();
  }

  @override
  Future<List<DailyRecord>> byHalaqa(String halaqaId) async {
    final list = await api.getList('/api/daily-records', query: {'halaqaId': halaqaId});
    return list.map(_recordFromJson).toList();
  }

  @override
  Future<List<DailyRecord>> byHalaqaAndDate(String halaqaId, String dateKey) async {
    final list = await api.getList('/api/daily-records',
        query: {'halaqaId': halaqaId, 'dateKey': dateKey});
    return list.map(_recordFromJson).toList();
  }

  @override
  Future<DailyRecord?> byStudentAndDate(String studentId, String dateKey) async {
    final j = await api.getOne('/api/daily-records',
        query: {'studentId': studentId, 'dateKey': dateKey});
    return j != null ? _recordFromJson(j) : null;
  }

  @override
  Future<List<DailyRecord>> inRange(String studentId, DateTime from, DateTime to) async {
    String fmt(DateTime d) =>
        '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
    final list = await api.getList('/api/daily-records',
        query: {'studentId': studentId, 'from': fmt(from), 'to': fmt(to)});
    return list.map(_recordFromJson).toList();
  }

  @override
  Future<void> upsertPayload(Map<String, dynamic> payload) async {
    await api.post('/api/daily-records', payload);
  }
}

class RemoteUserRepository implements IUserRepository {
  final ApiClient api;
  RemoteUserRepository(this.api);

  @override
  Future<List<User>> byRole(String role) async {
    final list = await api.getList('/api/users', query: {'role': role});
    return list.map(_userFromJson).toList();
  }

  @override
  Future<List<User>> all() async {
    final list = await api.getList('/api/users');
    return list.map(_userFromJson).toList();
  }

  @override
  Future<User?> getById(String id) async {
    final j = await api.getOne('/api/users/$id');
    return j != null ? _userFromJson(j) : null;
  }
}

// ─── Remote WeeklyPlan Repository ───

class RemoteWeeklyPlanRepository {
  final ApiClient api;
  RemoteWeeklyPlanRepository(this.api);

  Future<List<WeeklyPlan>> byStudent(String studentId) async {
    final list = await api.getList('/api/weekly-plans', query: {'studentId': studentId});
    return list.map(_planFromJson).toList();
  }

  Future<List<WeeklyPlan>> byHalaqa(String halaqaId) async {
    final list = await api.getList('/api/weekly-plans', query: {'halaqaId': halaqaId});
    return list.map(_planFromJson).toList();
  }

  Future<void> insert(WeeklyPlansCompanion p) async {
    await api.post('/api/weekly-plans', _planToJson(p));
  }

  Map<String, dynamic> _planToJson(WeeklyPlansCompanion p) {
    final j = <String, dynamic>{};
    if (p.id.present) j['id'] = p.id.value;
    if (p.studentId.present) j['studentId'] = p.studentId.value;
    if (p.halaqaId.present) j['halaqaId'] = p.halaqaId.value;
    if (p.weekStartKey.present) j['weekStartKey'] = p.weekStartKey.value;
    if (p.requiredNewPages.present) j['requiredNewPages'] = p.requiredNewPages.value;
    if (p.requiredRecentPages.present) j['requiredRecentPages'] = p.requiredRecentPages.value;
    if (p.requiredMinorPages.present) j['requiredMinorPages'] = p.requiredMinorPages.value;
    if (p.requiredMajorPages.present) j['requiredMajorPages'] = p.requiredMajorPages.value;
    if (p.requiredFridayPages.present) j['requiredFridayPages'] = p.requiredFridayPages.value;
    return j;
  }
}

// ─── Remote StudentTransfer Repository ───

class RemoteStudentTransferRepository {
  final ApiClient api;
  RemoteStudentTransferRepository(this.api);

  Future<List<StudentTransfer>> historyOf(String studentId) async {
    final list = await api.getList('/api/student-transfers', query: {'studentId': studentId});
    return list.map(_transferFromJson).toList();
  }

  Future<Map<String, dynamic>> transferStudent({
    required String studentId,
    required String toHalaqaId,
    required String byUserId,
  }) async {
    return api.post('/api/transfer-student', {
      'studentId': studentId,
      'toHalaqaId': toHalaqaId,
      'byUserId': byUserId,
    });
  }
}

// ─── Remote Seed Service ───

class RemoteSeedService {
  final ApiClient api;
  RemoteSeedService(this.api);

  Future<void> seed() async {
    await api.post('/api/seed', {});
  }

  Future<void> wipe() async {
    await api.post('/api/wipe', {});
  }
}
