import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/providers/providers.dart';

/// شاشة حسابي — للمشرف فقط: تغيير اسم المستخدم وكلمة المرور
/// (يتطلب إدخال كلمة المرور الحالية — التغيير يُحفظ في السحابة)
class MyAccountScreen extends ConsumerStatefulWidget {
  const MyAccountScreen({super.key});
  @override
  ConsumerState<MyAccountScreen> createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends ConsumerState<MyAccountScreen> {
  final currentPassCtrl = TextEditingController();
  final newUserCtrl = TextEditingController();
  final newPassCtrl = TextEditingController();
  final confirmPassCtrl = TextEditingController();
  bool loading = false;
  bool obscure = true;

  @override
  void dispose() {
    currentPassCtrl.dispose();
    newUserCtrl.dispose();
    newPassCtrl.dispose();
    confirmPassCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final session = ref.read(sessionProvider);
    if (session == null) return;
    final currentPass = currentPassCtrl.text;
    final newUser = newUserCtrl.text.trim();
    final newPass = newPassCtrl.text;

    if (currentPass.isEmpty) {
      _toast('أدخل كلمة المرور الحالية للتأكيد', error: true);
      return;
    }
    if (newUser.isEmpty && newPass.isEmpty) {
      _toast('أدخل اسم مستخدم جديد أو كلمة مرور جديدة', error: true);
      return;
    }
    if (newPass.isNotEmpty) {
      if (newPass.length < 6) {
        _toast('كلمة المرور الجديدة 6 أحرف على الأقل', error: true);
        return;
      }
      if (newPass != confirmPassCtrl.text) {
        _toast('تأكيد كلمة المرور غير مطابق', error: true);
        return;
      }
    }

    setState(() => loading = true);
    final res = await ref.read(cloudAuthProvider).updateAccount(
          session.userId,
          currentPassword: currentPass,
          newUsername: newUser.isNotEmpty ? newUser : null,
          newPassword: newPass.isNotEmpty ? newPass : null,
        );
    if (!mounted) return;
    setState(() => loading = false);
    if (res.ok && res.user != null) {
      // تحديث الجلسة بالاسم الجديد
      ref.read(sessionProvider.notifier).state = AppSession(
        userId: res.user!.id,
        name: res.user!.fullName.isEmpty ? res.user!.username : res.user!.fullName,
        role: res.user!.role,
        username: res.user!.username,
        halaqaId: res.user!.halaqaId,
      );
      currentPassCtrl.clear(); newUserCtrl.clear(); newPassCtrl.clear(); confirmPassCtrl.clear();
      _toast('تم حفظ التغييرات في السحابة بنجاح');
    } else {
      _toast(res.error ?? 'فشل الحفظ', error: true);
    }
  }

  void _toast(String msg, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: error ? AppColors.danger : AppColors.success,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('حسابي')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Card(child: ListTile(
          leading: const CircleAvatar(backgroundColor: AppColors.primary,
              child: Icon(Icons.admin_panel_settings, color: Colors.white)),
          title: Text(session?.name ?? ''),
          subtitle: Text('@${session?.username ?? ''} • مشرف'),
        )),
        const SizedBox(height: 16),
        const Text('تغيير بيانات الدخول', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 4),
        const Text('التغييرات تُحفظ مشفرة في قاعدة البيانات السحابية',
            style: TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 16),
        TextField(
          controller: currentPassCtrl, obscureText: obscure,
          decoration: InputDecoration(
            labelText: 'كلمة المرور الحالية (مطلوبة)',
            prefixIcon: const Icon(Icons.lock_outline),
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(icon: Icon(obscure ? Icons.visibility : Icons.visibility_off),
                onPressed: () => setState(() => obscure = !obscure)),
          ),
        ),
        const Divider(height: 32),
        TextField(
          controller: newUserCtrl,
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9._-]'))],
          decoration: const InputDecoration(
            labelText: 'اسم المستخدم الجديد (اختياري)',
            helperText: 'أحرف إنجليزية وأرقام فقط — اتركه فارغاً للإبقاء',
            prefixIcon: Icon(Icons.person),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: newPassCtrl, obscureText: obscure,
          decoration: const InputDecoration(
            labelText: 'كلمة المرور الجديدة (اختياري)',
            helperText: '6 أحرف على الأقل — اتركها فارغة للإبقاء',
            prefixIcon: Icon(Icons.lock),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: confirmPassCtrl, obscureText: obscure,
          decoration: const InputDecoration(
            labelText: 'تأكيد كلمة المرور الجديدة',
            prefixIcon: Icon(Icons.lock_reset),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 48,
          child: FilledButton.icon(
            onPressed: loading ? null : _save,
            icon: loading
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Icon(Icons.cloud_done),
            label: Text(loading ? 'جاري الحفظ...' : 'حفظ التغييرات'),
            style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
          ),
        ),
      ]),
    );
  }
}
