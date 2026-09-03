import '../../core/database/app_database.dart';

// واجهات المخازن — تسمح لاحقاً بإنشاء RemoteRepository دون تغيير الواجهات

abstract class IAuthRepository {
  Future<User?> signIn({required String username, required String password});
  Future<void> signOut();
  Future<User?> currentUser();
}

abstract class IHalaqaRepository {
  Future<List<Halaqa>> getAll({bool includeInactive = false});
  Future<Halaqa?> getById(String id);
  Future<List<Halaqa>> byTeacher(String teacherId);
  Future<List<Halaqa>> bySupervisor(String supervisorId);
  Future<void> insert(HalaqasCompanion h);
  Future<void> update(HalaqasCompanion h);
  Future<void> deactivate(String id);
}

abstract class IStudentRepository {
  Future<List<Student>> getAll({bool includeInactive = false});
  Future<List<Student>> byHalaqa(String halaqaId);
  Future<Student?> getById(String id);
  Future<List<Student>> search(String query);
  Future<void> insert(StudentsCompanion s);
  Future<void> update(StudentsCompanion s);
  Future<void> deactivate(String id);
}

abstract class IDailyRecordRepository {
  Future<List<DailyRecord>> all();
  Future<List<DailyRecord>> byStudent(String studentId);
  Future<List<DailyRecord>> byHalaqa(String halaqaId);
  Future<List<DailyRecord>> byHalaqaAndDate(String halaqaId, String dateKey);
  Future<DailyRecord?> byStudentAndDate(String studentId, String dateKey);
}

abstract class IUserRepository {
  Future<List<User>> byRole(String role);
  Future<List<User>> all();
  Future<User?> getById(String id);
  Future<void> upsert({
    required String id,
    required String fullName,
    required String username,
    required String role,
    bool active,
    String assignedHalaqaIds,
  });
}
