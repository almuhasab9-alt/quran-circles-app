import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/providers/providers.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});
  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1400))
    ..forward();

  @override
  void initState() {
    super.initState();
    _boot();
  }

  /// استعادة الجلسة المحفوظة — إن وجدت ندخل مباشرة، وإلا شاشة الدخول
  Future<void> _boot() async {
    final delay = Future.delayed(const Duration(milliseconds: 2000));
    final user = await ref.read(cloudAuthProvider).restoreSession();
    await delay;
    if (!mounted) return;
    if (user != null && user.active) {
      ref.read(sessionProvider.notifier).state = AppSession(
        userId: user.id,
        name: user.fullName.isEmpty ? user.username : user.fullName,
        role: user.role,
        username: user.username,
        halaqaId: user.halaqaId,
      );
      context.go('/home');
    } else {
      context.go('/login');
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    final scale = Tween(begin: 0.8, end: 1.0).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack));
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.secondary],
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: fade,
            child: ScaleTransition(
              scale: scale,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Container(
                  width: 140, height: 140,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 20, spreadRadius: 2)],
                  ),
                  padding: const EdgeInsets.all(12),
                  child: ClipOval(child: Image.asset('assets/images/center_logo.png', fit: BoxFit.cover)),
                ),
                const SizedBox(height: 24),
                const Text(AppConstants.centerName,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text('نظام متابعة حلقات القرآن الكريم',
                    style: TextStyle(color: Colors.white70, fontSize: 15)),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
