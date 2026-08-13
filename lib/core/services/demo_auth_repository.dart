import '../database/app_database.dart';
import '../../shared/models/repositories.dart';

// مصادقة تجريبية فقط — بدون أي أمان حقيقي
class DemoAuthRepository implements IAuthRepository {
  final AppDatabase db;
  User? _current;
  DemoAuthRepository(this.db);

  Future<List<User>> demoUsersByRole(String role) =>
      (db.select(db.users)..where((u) => u.role.equals(role) & u.active.equals(true))).get();

  // دخول تجريبي: يختار المستخدم حساباً جاهزاً، لا توجد كلمة مرور
  Future<User?> demoSignIn(String userId) async {
    _current = await (db.select(db.users)..where((u) => u.id.equals(userId))).getSingleOrNull();
    return _current;
  }

  @override
  Future<User?> currentUser() async => _current;

  @override
  Future<void> signOut() async => _current = null;

  @override
  Future<User?> signIn({required String username, required String password}) =>
      throw UnimplementedError('تسجيل الدخول الآمن لم يتم تفعيله بعد');
}
