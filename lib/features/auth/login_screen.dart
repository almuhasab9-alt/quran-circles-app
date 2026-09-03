import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/providers/providers.dart';

/// شاشة تسجيل الدخول — مصادقة سحابية حقيقية (اسم مستخدم + كلمة مرور)
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});
  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final userCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool loading = false;
  bool obscure = true;
  String? error;

  @override
  void dispose() {
    userCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final u = userCtrl.text.trim();
    final p = passCtrl.text;
    if (u.isEmpty || p.isEmpty) {
      setState(() => error = 'أدخل اسم المستخدم وكلمة المرور');
      return;
    }
    setState(() { loading = true; error = null; });
    final auth = ref.read(cloudAuthProvider);
    final res = await auth.signIn(u, p);
    if (!mounted) return;
    if (res.ok && res.user != null) {
      ref.read(sessionProvider.notifier).state = AppSession(
        userId: res.user!.id,
        name: res.user!.fullName.isEmpty ? res.user!.username : res.user!.fullName,
        role: res.user!.role,
        username: res.user!.username,
        halaqaId: res.user!.halaqaId,
      );
      // مزامنة فورية بعد الدخول: تنزيل النسخة السحابية إن كان المتصفح فارغاً
      // أو كانت السحابة أحدث — حتى تظهر البيانات نفسها على أي متصفح/جهاز
      try {
        final halaqas = await ref.read(halaqaRepoProvider).getAll(includeInactive: true);
        await ref.read(cloudSyncProvider).smartSync(localIsEmpty: halaqas.isEmpty);
        ref.read(dataVersionProvider.notifier).state++;
      } catch (_) {/* لا إنترنت — نكمل محلياً */}
      // بعد المزامنة: نعكس الحساب السحابي في جدول المستخدمين المحلي
      // (حتى تعمل قوائم المعلمين وتقارير PDF بدون الحاجة لنسخة احتياطية)
      await mirrorAccountLocally(ref.read(userRepoProvider), res.user!);
      if (res.user!.isSupervisor) {
        try {
          await mirrorAccountsLocally(ref.read(userRepoProvider), await auth.listAccounts());
        } catch (_) {/* لا إنترنت */}
      }
      if (!mounted) return;
      context.go('/home');
    } else {
      setState(() { loading = false; error = res.error; });
    }
  }

  /// إنشاء حساب المشرف الافتراضي عند أول تشغيل (تنجح فقط إن كانت القاعدة فارغة)
  Future<void> _initSupervisor() async {
    setState(() { loading = true; error = null; });
    final res = await ref.read(cloudAuthProvider).ensureSupervisorExists();
    if (!mounted) return;
    setState(() => loading = false);
    if (res.ok) {
      setState(() => error = null);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('تم تجهيز حساب المشرف ✓ — سجّل دخولك بـ: admin / admin123 ثم غيّر كلمة المرور من «حسابي»'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 5),
      ));
      userCtrl.text = 'admin';
      passCtrl.text = 'admin123';
    } else {
      setState(() => error = res.error ?? 'تعذرت التهيئة');
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
                      child: Image.asset('assets/images/center_logo.jpg', height: 90),
                    ),
                    const SizedBox(height: 12),
                    const Text(AppConstants.appName,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
                    const SizedBox(height: 24),
                    TextField(
                      controller: userCtrl,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.username],
                      decoration: InputDecoration(
                        labelText: 'اسم المستخدم',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        prefixIcon: const Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: passCtrl,
                      obscureText: obscure,
                      autofillHints: const [AutofillHints.password],
                      onSubmitted: (_) => _login(),
                      decoration: InputDecoration(
                        labelText: 'كلمة المرور',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(obscure ? Icons.visibility : Icons.visibility_off),
                          onPressed: () => setState(() => obscure = !obscure),
                        ),
                      ),
                    ),
                    if (error != null) ...[
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: Text(error!, textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 13, color: Colors.red.shade800)),
                      ),
                    ],
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity, height: 48,
                      child: FilledButton.icon(
                        onPressed: loading ? null : _login,
                        icon: loading
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                            : const Icon(Icons.login),
                        label: Text(loading ? 'جاري الدخول...' : 'تسجيل الدخول', style: const TextStyle(fontSize: 16)),
                        style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // تهيئة أول حساب مشرف — تظهر فقط عندما تكون القاعدة فارغة
                    TextButton.icon(
                      onPressed: loading ? null : _initSupervisor,
                      icon: const Icon(Icons.admin_panel_settings, size: 18),
                      label: const Text('أول تشغيل؟ إنشاء حساب المشرف (admin / admin123)',
                          style: TextStyle(fontSize: 12)),
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
