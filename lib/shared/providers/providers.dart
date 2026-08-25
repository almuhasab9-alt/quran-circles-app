import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/database/app_database.dart';
import '../../core/services/backup_service.dart';
import '../../core/services/backup_ui_service.dart';
import '../../core/services/cloud_auth_service.dart';
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
final backupServiceProvider = Provider<BackupService>((ref) => BackupService(ref.watch(dbProvider)));
final backupUiServiceProvider = Provider<BackupUiService>((ref) => BackupUiService(ref.watch(backupServiceProvider)));

final halaqaRepoProvider = Provider<IHalaqaRepository>((ref) => LocalHalaqaRepository(ref.watch(dbProvider)));
final studentRepoProvider = Provider<IStudentRepository>((ref) => LocalStudentRepository(ref.watch(dbProvider)));
final recordRepoProvider = Provider<IDailyRecordRepository>((ref) => LocalDailyRecordRepository(ref.watch(dbProvider)));
final userRepoProvider = Provider<IUserRepository>((ref) => LocalUserRepository(ref.watch(dbProvider)));

// جلسة المستخدم — مرتبطة بحساب سحابي محمي بكلمة مرور
class AppSession {
  final String userId;
  final String name;
  final String role; // supervisor | teacher
  final String username;
  const AppSession({required this.userId, required this.name, required this.role, this.username = ''});
  bool get isSupervisor => role == 'supervisor';
  bool get isTeacher => role == 'teacher';
}

final sessionProvider = StateProvider<AppSession?>((ref) => null);

// خدمة المصادقة السحابية (Cloudflare D1 — كلمات المرور مشفرة)
final cloudAuthProvider = Provider<CloudAuthService>((ref) => CloudAuthService());

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

// ---------- إعدادات النسخ الاحتياطي ----------

/// إعدادات النسخ الاحتياطي (تذكير يومي/أسبوعي + نسخ آلي + آخر وقت نسخ).
class BackupSettingsNotifier extends StateNotifier<BackupSettings> {
  final BackupService service;
  BackupSettingsNotifier(this.service) : super(const BackupSettings()) {
    service.loadSettings().then((s) => state = s);
  }

  Future<void> setReminder(BackupReminder r) async {
    state = state.copyWith(reminder: r);
    await service.saveReminder(r);
  }

  Future<void> setAutoBackup(bool v) async {
    state = state.copyWith(autoBackup: v);
    await service.saveAutoBackupEnabled(v);
  }

  Future<void> markDone() async {
    final now = DateTime.now();
    state = state.copyWith(lastBackupAt: now);
    await service.markBackupDone(now);
  }

  Future<void> reload() async {
    state = await service.loadSettings();
  }
}

final backupSettingsProvider =
    StateNotifierProvider<BackupSettingsNotifier, BackupSettings>(
        (ref) => BackupSettingsNotifier(ref.watch(backupServiceProvider)));

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
