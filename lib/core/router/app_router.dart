import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/services/api_client.dart';
import '../../core/services/backup_service.dart';
import '../../features/accounts/accounts_screen.dart';
import '../../features/dashboard/dashboard_screen.dart';
import '../../features/demo_auth/demo_login_screen.dart';
import '../../features/halaqas/halaqa_detail_screen.dart';
import '../../features/halaqas/halaqas_screen.dart';
import '../../features/reports/reports_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/students/student_detail_screen.dart';
import '../../features/students/students_screen.dart';
import '../../features/teacher/daily_entry_screen.dart';
import '../../features/teacher/weekly_sheet_screen.dart';
import '../../shared/providers/providers.dart';
import '../../shared/widgets/common_widgets.dart';

final _rootKey = GlobalKey<NavigatorState>();
final _shellKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootKey,
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (_, __) => const SplashScreen()),
      GoRoute(path: '/login', builder: (_, __) => const DemoLoginScreen()),
      ShellRoute(
        navigatorKey: _shellKey,
        builder: (_, __, child) => HomeShell(child: child),
        routes: [
          GoRoute(path: '/home', builder: (_, __) => const DashboardScreen()),
          GoRoute(path: '/home/halaqas', builder: (_, __) => const HalaqasScreen()),
          GoRoute(path: '/home/students', builder: (_, __) => const StudentsScreen()),
          GoRoute(path: '/home/reports', builder: (_, __) => const ReportsScreen()),
          GoRoute(path: '/home/settings', builder: (_, __) => const SettingsScreen()),
          GoRoute(path: '/home/accounts', builder: (_, __) => const AccountsScreen()),
        ],
      ),
      GoRoute(path: '/halaqa/:id', parentNavigatorKey: _rootKey,
          builder: (_, st) => HalaqaDetailScreen(halaqaId: st.pathParameters['id']!)),
      // كشف المتابعة الأسبوعي (يطابق الكشف الورقي)
      GoRoute(path: '/halaqa/:id/sheet', parentNavigatorKey: _rootKey,
          builder: (_, st) => WeeklySheetScreen(
              halaqaId: st.pathParameters['id']!,
              studentId: st.uri.queryParameters['student'])),
      // التسجيل اليومي للمعلم
      GoRoute(path: '/halaqa/:id/entry', parentNavigatorKey: _rootKey,
          builder: (_, st) => DailyEntryScreen(
              halaqaId: st.pathParameters['id']!,
              studentId: st.uri.queryParameters['student'])),
      GoRoute(path: '/student/:id', parentNavigatorKey: _rootKey,
          builder: (_, st) => StudentDetailScreen(studentId: st.pathParameters['id']!)),
    ],
  );
});

/// شريط تنبيه تلقائي: يظهر أعلى الشاشة إذا مرّ وقت النسخ الاحتياطي
/// دون أن يقوم المعلم/المشرف بالنسخ، ويشغّل النسخ الآلي عند الحاجة.
class _BackupReminderBanner extends ConsumerStatefulWidget {
  const _BackupReminderBanner();

  @override
  ConsumerState<_BackupReminderBanner> createState() =>
      _BackupReminderBannerState();
}

class _BackupReminderBannerState extends ConsumerState<_BackupReminderBanner> {
  bool _dismissed = false;
  bool _autoRan = false;
  bool _exporting = false;

  @override
  void initState() {
    super.initState();
    // النسخ الاحتياطي الآلي عند حلول وقته (مرة واحدة لكل جلسة)
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeAutoBackup());
  }

  Future<void> _maybeAutoBackup() async {
    if (_autoRan) return;
    _autoRan = true;
    final session = ref.read(sessionProvider);
    final teacherId = session != null && session.isTeacher ? session.userId : null;
    try {
      final msg = await ref
          .read(backupUiServiceProvider)
          .runAutoBackupIfDue(teacherId: teacherId);
      await ref.read(backupSettingsProvider.notifier).reload();
      if (msg != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg), backgroundColor: const Color(0xFF0B5E48)),
        );
      }
    } catch (_) {/* تجاهل — لا نعطل التطبيق */}
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(backupSettingsProvider);
    if (_dismissed || !settings.isOverdue) return const SizedBox.shrink();

    final periodText = settings.reminder == BackupReminder.daily ? 'يومي' : 'أسبوعي';
    final lastText = settings.lastBackupAt == null
        ? 'لم يتم إنشاء أي نسخة بعد'
        : 'آخر نسخة: ${settings.lastBackupAt!.toIso8601String().substring(0, 10)}';

    return Material(
      color: const Color(0xFFFFF3E0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xFFE65100), width: 1)),
        ),
        child: Row(children: [
          const Icon(Icons.backup_outlined, color: Color(0xFFE65100), size: 22),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'حان وقت النسخ الاحتياطي ($periodText) — $lastText',
              style: const TextStyle(fontSize: 12, color: Color(0xFF6D4C00)),
            ),
          ),
          TextButton.icon(
            onPressed: _exporting
                ? null
                : () async {
                    setState(() => _exporting = true);
                    final messenger = ScaffoldMessenger.of(context);
                    final session = ref.read(sessionProvider);
                    final teacherId =
                        session != null && session.isTeacher ? session.userId : null;
                    final name = await ref
                        .read(backupUiServiceProvider)
                        .exportAndDeliver(teacherId: teacherId);
                    await ref.read(backupSettingsProvider.notifier).reload();
                    if (!mounted) return;
                    setState(() => _exporting = false);
                    if (name != null) {
                      messenger.showSnackBar(
                        SnackBar(content: Text('تم إنشاء النسخة الاحتياطية: $name')),
                      );
                    }
                  },
            icon: _exporting
                ? const SizedBox(
                    width: 14, height: 14,
                    child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.download, size: 18),
            label: const Text('نسخ الآن', style: TextStyle(fontSize: 12)),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 18),
            tooltip: 'إخفاء',
            onPressed: () => setState(() => _dismissed = true),
          ),
        ]),
      ),
    );
  }
}

class HomeShell extends ConsumerWidget {
  final Widget child;
  const HomeShell({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);
    if (session == null) {
      // لم يسجل دخول — أعد التوجيه
      WidgetsBinding.instance.addPostFrameCallback((_) => context.go('/login'));
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final location = GoRouterState.of(context).uri.path;
    int index = 0;
    if (location.contains('students')) {
      index = 1;
    } else if (location.contains('halaqas')) {
      index = 2;
    } else if (location.contains('reports')) {
      index = 3;
    }
    return Scaffold(
      body: Column(children: [
        const SafeArea(bottom: false, child: DemoBadge()),
        const _BackupReminderBanner(),
        Expanded(child: child),
      ]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) {
          switch (i) {
            case 0: context.go('/home');
            case 1: context.go('/home/students');
            case 2: context.go('/home/halaqas');
            case 3: context.go('/home/reports');
          }
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard), label: 'الرئيسية'),
          NavigationDestination(icon: Icon(Icons.people), label: 'الطلاب'),
          NavigationDestination(icon: Icon(Icons.groups), label: 'الحلقات'),
          NavigationDestination(icon: Icon(Icons.assessment), label: 'التقارير'),
        ],
      ),
      drawer: Drawer(
        child: ListView(children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Color(0xFF0B5E48)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const CircleAvatar(radius: 28, backgroundColor: Colors.white,
                  child: Image(image: AssetImage('assets/images/center_logo.png'), width: 48)),
              const SizedBox(height: 8),
              Text(session.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              Text(session.isSupervisor ? 'مشرف' : 'معلم',
                  style: const TextStyle(color: Colors.white70)),
            ]),
          ),
          ListTile(leading: const Icon(Icons.people), title: const Text('الطلاب'), onTap: () { Navigator.pop(context); context.go('/home/students'); }),
          ListTile(leading: const Icon(Icons.groups), title: const Text('الحلقات'), onTap: () { Navigator.pop(context); context.go('/home/halaqas'); }),
          ListTile(leading: const Icon(Icons.assessment), title: const Text('التقارير'), onTap: () { Navigator.pop(context); context.go('/home/reports'); }),
          const Divider(),
          ListTile(leading: const Icon(Icons.settings), title: const Text('الإعدادات'), onTap: () { Navigator.pop(context); context.go('/home/settings'); }),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('تسجيل الخروج', style: TextStyle(color: Colors.red)),
            onTap: () async {
              ref.read(sessionProvider.notifier).state = null;
              ApiClient.authToken = null;
              // مسح الجلسة المحفوظة حتى لا تُستعاد عند التشغيل التالي
              try {
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('authToken');
                await prefs.remove('sessionUserId');
                await prefs.remove('sessionName');
                await prefs.remove('sessionRole');
              } catch (_) {/* تجاهل */}
              if (context.mounted) context.go('/login');
            },
          ),
        ]),
      ),
    );
  }
}
