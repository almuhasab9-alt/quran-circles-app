import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/attendance/attendance_screen.dart';
import '../../features/dashboard/dashboard_screen.dart';
import '../../features/demo_auth/demo_login_screen.dart';
import '../../features/follow_up/alerts_screen.dart';
import '../../features/halaqas/halaqa_detail_screen.dart';
import '../../features/halaqas/halaqas_screen.dart';
import '../../features/recitation/recitation_screen.dart';
import '../../features/reports/reports_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/staff/staff_screen.dart';
import '../../features/students/student_detail_screen.dart';
import '../../features/students/students_screen.dart';
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
          GoRoute(path: '/home/staff', builder: (_, __) => const StaffScreen()),
          GoRoute(path: '/home/alerts', builder: (_, __) => const AlertsScreen()),
          GoRoute(path: '/home/reports', builder: (_, __) => const ReportsScreen()),
          GoRoute(path: '/home/settings', builder: (_, __) => const SettingsScreen()),
        ],
      ),
      GoRoute(path: '/halaqa/:id', parentNavigatorKey: _rootKey,
          builder: (_, st) => HalaqaDetailScreen(halaqaId: st.pathParameters['id']!)),
      GoRoute(path: '/halaqa/:id/attendance', parentNavigatorKey: _rootKey,
          builder: (_, st) => AttendanceScreen(halaqaId: st.pathParameters['id']!)),
      GoRoute(path: '/halaqa/:id/recitation', parentNavigatorKey: _rootKey,
          builder: (_, st) => RecitationScreen(
              halaqaId: st.pathParameters['id']!,
              studentId: st.uri.queryParameters['student'])),
      GoRoute(path: '/student/:id', parentNavigatorKey: _rootKey,
          builder: (_, st) => StudentDetailScreen(studentId: st.pathParameters['id']!)),
    ],
  );
});

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
    } else if (location.contains('alerts')) {
      index = 3;
    } else if (location.contains('reports')) {
      index = 4;
    }
    return Scaffold(
      body: Column(children: [
        const SafeArea(bottom: false, child: DemoBadge()),
        Expanded(child: child),
      ]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) {
          switch (i) {
            case 0: context.go('/home');
            case 1: context.go('/home/students');
            case 2: context.go('/home/halaqas');
            case 3: context.go('/home/alerts');
            case 4: context.go('/home/reports');
          }
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard), label: 'الرئيسية'),
          NavigationDestination(icon: Icon(Icons.people), label: 'الطلاب'),
          NavigationDestination(icon: Icon(Icons.groups), label: 'الحلقات'),
          NavigationDestination(icon: Icon(Icons.notifications), label: 'التنبيهات'),
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
              Text(session.role == 'admin' ? 'مدير' : session.role == 'supervisor' ? 'مشرف' : 'معلم',
                  style: const TextStyle(color: Colors.white70)),
            ]),
          ),
          ListTile(leading: const Icon(Icons.people), title: const Text('الطلاب'), onTap: () { Navigator.pop(context); context.go('/home/students'); }),
          ListTile(leading: const Icon(Icons.groups), title: const Text('الحلقات'), onTap: () { Navigator.pop(context); context.go('/home/halaqas'); }),
          if (session.role != 'teacher')
            ListTile(leading: const Icon(Icons.badge), title: const Text('الموظفون'), onTap: () { Navigator.pop(context); context.go('/home/staff'); }),
          ListTile(leading: const Icon(Icons.notifications), title: const Text('التنبيهات'), onTap: () { Navigator.pop(context); context.go('/home/alerts'); }),
          ListTile(leading: const Icon(Icons.assessment), title: const Text('التقارير'), onTap: () { Navigator.pop(context); context.go('/home/reports'); }),
          const Divider(),
          ListTile(leading: const Icon(Icons.settings), title: const Text('الإعدادات'), onTap: () { Navigator.pop(context); context.go('/home/settings'); }),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('تسجيل الخروج', style: TextStyle(color: Colors.red)),
            onTap: () {
              ref.read(sessionProvider.notifier).state = null;
              context.go('/login');
            },
          ),
        ]),
      ),
    );
  }
}
