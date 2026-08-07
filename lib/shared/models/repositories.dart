import '../../core/database/app_database.dart';

// واجهات المخازن — تسمح لاحقاً بإنشاء RemoteRepository دون تغيير الواجهات

abstract class IAuthRepository {
  Future<User?> signIn({required String username, required String password});
  Future<void> signOut();
  Future<User?> currentUser();
  Future<void> resetPassword(String username);
  Future<void> changePassword(String oldPassword, String newPassword);
  Future<User?> createUserByAdmin({
    required String fullName, required String username, required String role,
  });
}

abstract class IHalaqaRepository {
  Future<List<Halaqa>> getAll({bool includeInactive = false});
  Future<Halaqa?> getById(String id);
  Future<List<Halaqa>> byTeacher(String teacherId);
  Future<List<Halaqa>> bySupervisor(String supervisorId);
  Future<void> insert(HalaqasCompanion h);
  Future<void> update(HalaqasCompanion h);
  Future<void> updateEntity(Halaqa h);
  Future<void> deactivate(String id);
}

abstract class IStudentRepository {
  Future<List<Student>> getAll({bool includeInactive = false});
  Future<List<Student>> byHalaqa(String halaqaId);
  Future<Student?> getById(String id);
  Future<List<Student>> search(String query);
  Future<void> insert(StudentsCompanion s);
  Future<void> update(StudentsCompanion s);
  Future<void> updateEntity(Student s);
  Future<void> deactivate(String id);
  Future<void> transfer(String studentId, String toHalaqaId, String byUser);
}

abstract class IDailyRecordRepository {
  Future<List<DailyRecord>> all();
  Future<List<DailyRecord>> byStudent(String studentId);
  Future<List<DailyRecord>> byHalaqa(String halaqaId);
  Future<List<DailyRecord>> byHalaqaAndDate(String halaqaId, String dateKey);
  Future<DailyRecord?> byStudentAndDate(String studentId, String dateKey);
  Future<void> upsertRecord(DailyRecordsCompanion r);
  Future<void> upsertBatch(List<DailyRecordsCompanion> rs);
}

abstract class IAlertRepository {
  Future<List<Alert>> byStatus(String status);
  Future<List<Alert>> all();
  Future<void> insertMany(List<AlertsCompanion> alerts);
  Future<void> insert(AlertsCompanion a);
  Future<void> setStatus(String id, String status, {String? reviewedBy, String? reviewNote});
  Future<Set<String>> openTypesForStudent(String studentId);
}

abstract class IFollowUpRepository {
  Future<List<FollowUpPlan>> byStudent(String studentId);
  Future<List<FollowUpPlan>> active();
  Future<void> insert(FollowUpPlansCompanion p);
  Future<void> insertPlan({
    required String studentId, required String createdBy,
    required DateTime startDate, required DateTime endDate,
    required String goals, required String actions, String? notes,
  });
}

abstract class IContactRepository {
  Future<List<ContactLog>> byStudent(String studentId);
  Future<void> insert(ContactLogsCompanion c);
}

abstract class IUserRepository {
  Future<List<User>> byRole(String role);
  Future<List<User>> all();
  Future<void> insert(UsersCompanion u);
  Future<void> update(UsersCompanion u);
  Future<void> updateEntity(User u);
  Future<void> deactivate(String id);
}

abstract class IGuardianRepository {
  Future<Guardian?> getById(String id);
  Future<List<Guardian>> byIds(List<String> ids);
  Future<List<Guardian>> getAll();
  Future<void> insert(GuardiansCompanion g);
}
