import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/database/app_database.dart';
import '../../core/services/alert_engine.dart';
import '../../core/services/app_settings.dart';
import '../../core/services/demo_seed_service.dart';
import '../../core/services/evaluation_service.dart';
import '../../core/services/local_repositories.dart';
import '../../core/services/report_service.dart';
import '../models/repositories.dart';

final dbProvider = Provider<AppDatabase>((ref) => AppDatabase());

final settingsProvider = FutureProvider<AppSettings>((ref) => AppSettings.load());

final evaluationProvider = FutureProvider<EvaluationService>((ref) async {
  final s = await ref.watch(settingsProvider.future);
  return EvaluationService(s);
});

final alertEngineProvider = FutureProvider<AlertEngine>((ref) async {
  final s = await ref.watch(settingsProvider.future);
  return AlertEngine(s);
});

final seedServiceProvider = Provider<DemoSeedService>((ref) => DemoSeedService(ref.watch(dbProvider)));

final halaqaRepoProvider = Provider<IHalaqaRepository>((ref) => LocalHalaqaRepository(ref.watch(dbProvider)));
final studentRepoProvider = Provider<IStudentRepository>((ref) => LocalStudentRepository(ref.watch(dbProvider)));
final recordRepoProvider = Provider<IDailyRecordRepository>((ref) => LocalDailyRecordRepository(ref.watch(dbProvider)));
final alertRepoProvider = Provider<IAlertRepository>((ref) => LocalAlertRepository(ref.watch(dbProvider)));
final followUpRepoProvider = Provider<IFollowUpRepository>((ref) => LocalFollowUpRepository(ref.watch(dbProvider)));
final contactRepoProvider = Provider<IContactRepository>((ref) => LocalContactRepository(ref.watch(dbProvider)));
final userRepoProvider = Provider<IUserRepository>((ref) => LocalUserRepository(ref.watch(dbProvider)));
final guardianRepoProvider = Provider<IGuardianRepository>((ref) => LocalGuardianRepository(ref.watch(dbProvider)));

final reportServiceProvider = Provider<ReportService>((ref) => ReportService(ref.watch(dbProvider)));

// جلسة المستخدم التجريبي
class DemoSession {
  final String userId;
  final String name;
  final String role; // admin | supervisor | teacher
  const DemoSession({required this.userId, required this.name, required this.role});
}

final sessionProvider = StateProvider<DemoSession?>((ref) => null);

// محفز تحديث عام — يزيد عند أي تغيير في البيانات لإعادة جلب القوائم
final dataVersionProvider = StateProvider<int>((ref) => 0);

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

final allAlertsProvider = FutureProvider<List<Alert>>((ref) async {
  ref.watch(dataVersionProvider);
  return ref.watch(alertRepoProvider).all();
});

final usersProvider = FutureProvider<List<User>>((ref) async {
  ref.watch(dataVersionProvider);
  return ref.watch(userRepoProvider).all();
});
