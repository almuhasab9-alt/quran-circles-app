import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/cloud_auth_service.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/providers/providers.dart';
import '../../shared/widgets/common_widgets.dart';

/// مزود قائمة الحسابات السحابية
final cloudAccountsProvider = FutureProvider<List<CloudAccount>>((ref) async {
  ref.watch(dataVersionProvider);
  final accounts = await ref.watch(cloudAuthProvider).listAccounts();
  // مرآة الحسابات في جدول المستخدمين المحلي حتى تظهر أسماء المعلمين
  // في نموذج الحلقة وتفاصيلها وتقارير PDF
  await mirrorAccountsLocally(ref.read(userRepoProvider), accounts);
  return accounts;
});

/// شاشة إدارة الحسابات — للمشرف فقط:
/// إنشاء حسابات المعلمين (اسم مستخدم + كلمة مرور) وربطهم بالحلقات.
class AccountsScreen extends ConsumerWidget {
  const AccountsScreen({super.key});

  void _toast(BuildContext context, String msg, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: error ? AppColors.danger : AppColors.success,
    ));
  }

  // ---------- إنشاء/تعديل حساب معلم ----------
  Future<void> _teacherDialog(BuildContext context, WidgetRef ref, {CloudAccount? existing}) async {
    final halaqas = await ref.read(halaqaRepoProvider).getAll();
    if (!context.mounted) return;
    final nameCtrl = TextEditingController(text: existing?.fullName ?? '');
    final userCtrl = TextEditingController(text: existing?.username ?? '');
    final passCtrl = TextEditingController();
    String? halaqaId = existing?.halaqaId.isNotEmpty == true ? existing!.halaqaId : null;
    bool obscure = true;

    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(builder: (ctx, setD) => AlertDialog(
        title: Text(existing == null ? 'إضافة معلم جديد' : 'تعديل بيانات المعلم'),
        content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'اسم المعلم الكامل', prefixIcon: Icon(Icons.badge))),
          const SizedBox(height: 10),
          TextField(controller: userCtrl,
              enabled: existing == null,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9._-]'))],
              decoration: InputDecoration(
                labelText: 'اسم المستخدم (إنجليزي)',
                prefixIcon: const Icon(Icons.person),
                helperText: existing == null ? 'أحرف إنجليزية وأرقام فقط' : 'لا يمكن تغييره',
              )),
          const SizedBox(height: 10),
          TextField(controller: passCtrl, obscureText: obscure,
              decoration: InputDecoration(
                labelText: existing == null ? 'كلمة المرور' : 'كلمة مرور جديدة (اتركها فارغة للإبقاء)',
                prefixIcon: const Icon(Icons.lock),
                helperText: '6 أحرف على الأقل',
                suffixIcon: IconButton(icon: Icon(obscure ? Icons.visibility : Icons.visibility_off),
                    onPressed: () => setD(() => obscure = !obscure)),
              )),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            initialValue: halaqaId, isExpanded: true,
            decoration: const InputDecoration(labelText: 'الحلقة المرتبطة', prefixIcon: Icon(Icons.groups)),
            items: [
              const DropdownMenuItem(value: null, child: Text('— بدون حلقة —')),
              ...halaqas.where((h) => h.active).map((h) =>
                  DropdownMenuItem(value: h.id, child: Text(h.name, overflow: TextOverflow.ellipsis))),
            ],
            onChanged: (v) => setD(() => halaqaId = v),
          ),
        ])),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('إلغاء')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('حفظ')),
        ],
      )),
    );

    final name = nameCtrl.text.trim();
    final username = userCtrl.text.trim();
    final password = passCtrl.text;
    nameCtrl.dispose(); userCtrl.dispose(); passCtrl.dispose();
    if (saved != true) return;

    final auth = ref.read(cloudAuthProvider);
    if (existing == null) {
      if (name.isEmpty || username.isEmpty || password.length < 6) {
        if (context.mounted) _toast(context, 'أكمل البيانات: الاسم واسم المستخدم وكلمة مرور 6 أحرف على الأقل', error: true);
        return;
      }
      final res = await auth.createTeacher(
          username: username, password: password, fullName: name, halaqaId: halaqaId ?? '');
      if (!context.mounted) return;
      if (res.ok) {
        bumpDataVersion(ref);
        // عرض بيانات الدخول للمشرف لينقلها للمعلم
        showDialog(context: context, builder: (ctx) => AlertDialog(
          icon: const Icon(Icons.check_circle, color: AppColors.success, size: 40),
          title: const Text('تم إنشاء حساب المعلم'),
          content: SelectableText('سلّم هذه البيانات للمعلم:\n\nاسم المستخدم: $username\nكلمة المرور: $password',
              style: const TextStyle(fontSize: 15, height: 1.8)),
          actions: [
            TextButton.icon(
              icon: const Icon(Icons.copy),
              label: const Text('نسخ'),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: 'اسم المستخدم: $username\nكلمة المرور: $password'));
                Navigator.pop(ctx);
              },
            ),
            FilledButton(onPressed: () => Navigator.pop(ctx), child: const Text('تم')),
          ],
        ));
      } else {
        _toast(context, res.error ?? 'فشل إنشاء الحساب', error: true);
      }
    } else {
      final res = await auth.updateAccount(existing.id,
          fullName: name,
          halaqaId: halaqaId ?? '',
          newPassword: password.isNotEmpty ? password : null);
      if (!context.mounted) return;
      if (res.ok) {
        bumpDataVersion(ref);
        _toast(context, 'تم تحديث بيانات المعلم${password.isNotEmpty ? ' وكلمة المرور' : ''}');
      } else {
        _toast(context, res.error ?? 'فشل التعديل', error: true);
      }
    }
  }

  // ---------- حذف معلم ----------
  Future<void> _deleteTeacher(BuildContext context, WidgetRef ref, CloudAccount acc) async {
    final ok = await showDialog<bool>(context: context, builder: (ctx) => AlertDialog(
      title: Text('حذف حساب ${acc.fullName}'),
      content: const Text('سيفقد المعلم القدرة على تسجيل الدخول. بيانات الحلقة والطلاب لن تُحذف.'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('إلغاء')),
        FilledButton(style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true), child: const Text('حذف')),
      ],
    ));
    if (ok != true) return;
    final res = await ref.read(cloudAuthProvider).deleteTeacher(acc.id);
    if (!context.mounted) return;
    if (res.ok) {
      // تعطيل المرآة المحلية حتى يختفي من قائمة المعلمين (السجلات القديمة تبقى)
      await ref.read(userRepoProvider).upsert(
            id: acc.id,
            fullName: acc.fullName,
            username: acc.username,
            role: acc.role,
            active: false,
            assignedHalaqaIds: acc.halaqaId,
          );
      if (!context.mounted) return;
      bumpDataVersion(ref);
      _toast(context, 'تم حذف الحساب');
    } else {
      _toast(context, res.error ?? 'فشل الحذف', error: true);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountsAsync = ref.watch(cloudAccountsProvider);
    final halaqasAsync = ref.watch(halaqasProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('حسابات المعلمين')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _teacherDialog(context, ref),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.person_add, color: Colors.white),
        label: const Text('معلم جديد', style: TextStyle(color: Colors.white)),
      ),
      body: accountsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => ErrorState(message: 'تعذر جلب الحسابات من السحابة\n$e'),
        data: (accounts) {
          final teachers = accounts.where((a) => a.isTeacher).toList();
          final halaqas = halaqasAsync.value ?? [];
          String halaqaName(String id) =>
              halaqas.where((h) => h.id == id).map((h) => h.name).firstOrNull ?? '— بدون حلقة —';
          if (teachers.isEmpty) {
            return const EmptyState(icon: Icons.person_off, message: 'لا توجد حسابات معلمين بعد\nاضغط «معلم جديد» لإنشاء أول حساب');
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: teachers.length,
            itemBuilder: (_, i) {
              final t = teachers[i];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: t.active ? AppColors.primary : Colors.grey,
                    child: const Icon(Icons.school, color: Colors.white),
                  ),
                  title: Text(t.fullName.isEmpty ? t.username : t.fullName,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('@${t.username} • ${halaqaName(t.halaqaId)}'),
                  trailing: PopupMenuButton<String>(
                    onSelected: (v) {
                      if (v == 'edit') _teacherDialog(context, ref, existing: t);
                      if (v == 'delete') _deleteTeacher(context, ref, t);
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: 'edit', child: ListTile(leading: Icon(Icons.edit), title: Text('تعديل / كلمة مرور'))),
                      PopupMenuItem(value: 'delete', child: ListTile(leading: Icon(Icons.delete, color: Colors.red), title: Text('حذف الحساب'))),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
