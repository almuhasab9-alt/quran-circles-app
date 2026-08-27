import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';
import '../../core/services/api_client.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/providers/providers.dart';

class DemoLoginScreen extends ConsumerStatefulWidget {
  const DemoLoginScreen({super.key});
  @override
  ConsumerState<DemoLoginScreen> createState() => _DemoLoginScreenState();
}

class _DemoLoginScreenState extends ConsumerState<DemoLoginScreen> {
  final usernameCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  bool loading = false;
  String? errorText;

  @override
  void dispose() {
    usernameCtrl.dispose();
    passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final username = usernameCtrl.text.trim();
    final password = passwordCtrl.text;
    if (username.isEmpty || password.isEmpty) {
      setState(() => errorText = 'أدخل اسم المستخدم وكلمة المرور');
      return;
    }
    setState(() { loading = true; errorText = null; });
    try {
      final api = ref.read(apiClientProvider);
      final result = await api.login(username, password);
      ApiClient.authToken = result['token'] as String;
      final user = result['user'] as Map<String, dynamic>;
      final session = DemoSession(
        userId: (user['id'] ?? '') as String,
        name: (user['fullName'] ?? username) as String,
        role: (user['role'] ?? 'teacher') as String,
      );
      ref.read(sessionProvider.notifier).state = session;
      // حفظ الجلسة محلياً — لا يُطلب تسجيل الدخول عند كل تشغيل
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('authToken', ApiClient.authToken!);
        await prefs.setString('sessionUserId', session.userId);
        await prefs.setString('sessionName', session.name);
        await prefs.setString('sessionRole', session.role);
      } catch (_) {/* التخزين غير متاح */}
      if (!mounted) return;
      context.go('/home');
    } catch (e) {
      if (!mounted) return;
      setState(() {
        loading = false;
        errorText = e.toString().replaceAll('ApiException: ', '');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.secondary],
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset('assets/images/center_logo.png', height: 90),
                    ),
                    const SizedBox(height: 12),
                    const Text(AppConstants.appName,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
                    const SizedBox(height: 20),
                    TextField(
                      controller: usernameCtrl,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: 'اسم المستخدم',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        prefixIcon: const Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: passwordCtrl,
                      obscureText: true,
                      onSubmitted: (_) => _login(),
                      decoration: InputDecoration(
                        labelText: 'كلمة المرور',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        prefixIcon: const Icon(Icons.lock),
                      ),
                    ),
                    if (errorText != null) ...[
                      const SizedBox(height: 10),
                      Text(
                        errorText!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red, fontSize: 13),
                      ),
                    ],
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity, height: 48,
                      child: FilledButton.icon(
                        onPressed: loading ? null : _login,
                        icon: loading
                            ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                            : const Icon(Icons.login),
                        label: const Text('تسجيل الدخول', style: TextStyle(fontSize: 16)),
                        style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade50,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.amber.shade300),
                      ),
                      child: const Text(
                        'يتم تسجيل الدخول عبر الخادم السحابي (quran-auth-api).',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, color: Colors.black87),
                      ),
                    ),
                  ]),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
