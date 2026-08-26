import '../../core/services/accounts_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/database/app_database.dart';
import '../../core/services/api_client.dart';
import '../../core/services/backup_service.dart';
import '../../core/services/backup_ui_service.dart';
import '../../core/services/remote_repositories.dart';
import '../../core/services/report_service.dart';
import '../../core/services/session_service.dart';
import '../../core/services/transfer_service.dart';
import '../models/repositories.dart';

// ─── قاعدة البيانات المحلية (تُستخدم للنسخ الاحتياطي والتقارير) ───
final dbProvider = Provider<AppDatabase>((ref) => AppDatabase());

// ─── عميل API السحابي ───
final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

// ─── مستودع حسابات الدخول (إدارة الحسابات — للمشرف) ───
final accountsRepositoryProvider =
    Provider<AccountsRepository>((ref) => AccountsRepository(ref.watch(apiClientProvider)));

// ─── مزودات الخدمات (محلية مؤقتاً) ───
final sessionServiceProvider = Provider<SessionService>((ref) => SessionService(ref.watch(dbProvider)));
final reportServiceProvider = Provider<ReportService>((ref) => ReportService(ref.watch(dbProvider)));
final transferServiceProvider = Provider<TransferService>((ref) => TransferService(ref.watch(dbProvider)));
final backupServiceProvider = Provider<BackupService>((ref) => BackupService(ref.watch(dbProvider)));
final backupUiServiceProvider = Provider<BackupUiService>((ref) => BackupUiService(ref.watch(backupServiceProvider)));

// ─── المستودعات البعيدة (D1 عبر Cloudflare Worker) ───
final halaqaRepoProvider = Provider<IHalaqaRepository>((ref) => RemoteHalaqaRepository(ref.watch(apiClientProvider)));
final studentRepoProvider = Provider<IStudentRepository>((ref) => RemoteStudentRepository(ref.watch(apiClientProvider)));
final recordRepoProvider = Provider<IDailyRecordRepository>((ref) => RemoteDailyRecordRepository(ref.watch(apiClientProvider)));
final userRepoProvider = Provider<IUserRepository>((ref) => RemoteUserRepository(ref.watch(apiClientProvider)));
final weeklyPlanRepoProvider = Provider<RemoteWeeklyPlanRepository>((ref) => RemoteWeeklyPlanRepository(ref.watch(apiClientProvider)));
final studentTransferRepoProvider = Provider<RemoteStudentTransferRepository>((ref) => RemoteStudentTransferRepository(ref.watch(apiClientProvider)));

// ─── خدمة الزرع البعيدة ───
final seedServiceProvider = Provider<RemoteSeedService>((ref) => RemoteSeedService(ref.watch(apiClientProvider)));

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
