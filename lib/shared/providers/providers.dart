import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/database/app_database.dart';
import '../../core/services/demo_seed_service.dart';
import '../../core/services/local_repositories.dart';
import '../../core/services/report_service.dart';
import '../../core/services/session_service.dart';
import '../../core/services/transfer_service.dart';
import '../models/repositories.dart';

final dbProvider = Provider<AppDatabase>((ref) => AppDatabase());

final seedServiceProvider = Provider<DemoSeedService>((ref) => DemoSeedService(ref.watch(dbProvider)));

final sessionServiceProvider = Provider<SessionService>((ref) => SessionService(ref.watch(dbProvider)));
final reportServiceProvider = Provider<ReportService>((ref) => ReportService(ref.watch(dbProvider)));
final transferServiceProvider = Provider<TransferService>((ref) => TransferService(ref.watch(dbProvider)));

final halaqaRepoProvider = Provider<IHalaqaRepository>((ref) => LocalHalaqaRepository(ref.watch(dbProvider)));
final studentRepoProvider = Provider<IStudentRepository>((ref) => LocalStudentRepository(ref.watch(dbProvider)));
final recordRepoProvider = Provider<IDailyRecordRepository>((ref) => LocalDailyRecordRepository(ref.watch(dbProvider)));
final userRepoProvider = Provider<IUserRepository>((ref) => LocalUserRepository(ref.watch(dbProvider)));

// جلسة المستخدم التجريبي
class DemoSession {
  final String userId;
  final String name;
  final String role; // supervisor | teacher
  const DemoSession({required this.userId, required this.name, required this.role});
  bool get isSupervisor => role == 'supervisor';
  bool get isTeacher => role == 'teacher';
}

final sessionProvider = StateProvider<DemoSession?>((ref) => null);

// محفز تحديث عام — يزيد عند أي تغيير في البيانات لإعادة جلب القوائم
final dataVersionProvider = StateProvider<int>((ref) => 0);

void bumpDataVersion(WidgetRef ref) =>
    ref.read(dataVersionProvider.notifier).state++;

/// الوضع الداكن — محفوظ محلياً عبر SharedPreferences
class DarkModeNotifier extends StateNotifier<bool> {
  DarkModeNotifier() : super(false) {
    SharedPreferences.getInstance().then((p) {
      state = p.getBool('dark_mode') ?? false;
    });
  }
  Future<void> set(bool v) async {
    state = v;
    final p = await SharedPreferences.getInstance();
    await p.setBool('dark_mode', v);
  }
}

final darkModeProvider = StateNotifierProvider<DarkModeNotifier, bool>((ref) => DarkModeNotifier());

// مزودات البيانات
final halaqasProvider = FutureProvider<List<Halaqa>>((ref) async {
  ref.watch(dataVersionProvider);
  return ref.watch(halaqaRepoProvider).getAll();
});

final studentsProvider = FutureProvider<List<Student>>((ref) async {
  ref.watch(dataVersionProvider);
  return ref.watch(studentRepoProvider).getAll();
});

final allRecordsProvider = FutureProvider<List<DailyRecord>>((ref) async {
  ref.watch(dataVersionProvider);
  return ref.watch(recordRepoProvider).all();
});

final usersProvider = FutureProvider<List<User>>((ref) async {
  ref.watch(dataVersionProvider);
  return ref.watch(userRepoProvider).all();
});
