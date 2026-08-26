import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/accounts_repository.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/providers/providers.dart';

/// شاشة إدارة حسابات الدخول — تظهر للمشرف فقط.
/// تغيير كلمة المرور / اسم المستخدم / الاسم الكامل / تفعيل وتعطيل الحسابات.
class AccountsScreen extends ConsumerStatefulWidget {
  const AccountsScreen({super.key});

  @override
  ConsumerState<AccountsScreen> createState() => _AccountsScreenState();
}

class _AccountsScreenState extends ConsumerState<AccountsScreen> {
  List<AccountInfo>? _accounts;
  String? _error;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final list = await ref.read(accountsRepositoryProvider).list();
      if (!mounted) return;
      setState(() {
        _accounts = list;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = _msg(e);
        _loading = false;
      });
    }
  }

  String _msg(Object e) => e.toString().replaceAll('ApiException: ', '');

  void _toast(String msg, {bool error = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: error ? Colors.red : Colors.green,
    ));
  }

  Future<bool> _run(Future<void> Function() action) async {
    try {
      await action();
      if (mounted) await _load();
      return true;
    } catch (e) {
      _toast(_msg(e), error: true);
      return false;
    }
  }

  // ─── تغيير كلمة المرور ───
  Future<void> _changePassword(AccountInfo acc) async {
    final self = acc.id == ref.read(sessionProvider)?.userId;
    final pwCtrl = TextEditingController();
    final curCtrl = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('تغيير كلمة المرور — ${acc.fullName}'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          if (self) ...[
            TextField(
              controller: curCtrl,
              obscureText: true,
              decoration: const InputDecoration(
                  labelText: 'كلمة المرور الحالية', prefixIcon: Icon(Icons.lock_outline)),
            ),
            const SizedBox(height: 8),
          ],
          TextField(
            controller: pwCtrl,
            obscureText: true,
            decoration: const InputDecoration(
                labelText: 'كلمة المرور الجديدة (6 أحرف على الأقل)',
                prefixIcon: Icon(Icons.password)),
          ),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('إلغاء')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('حفظ')),
        ],
      ),
    );
    if (ok != true) return;
    final newPw = pwCtrl.text.trim();
    if (newPw.length < 6) {
      _toast('كلمة المرور يجب أن تكون 6 أحرف على الأقل', error: true);
      return;
    }
    final success = await _run(() => ref
        .read(accountsRepositoryProvider)
        .changePassword(acc.id, newPw,
            currentPassword: self ? curCtrl.text : null));
    if (success && mounted) _toast('تم تغيير كلمة المرور');
  }

  // ─── تغيير اسم المستخدم ───
  Future<void> _changeUsername(AccountInfo acc) async {
    final self = acc.id == ref.read(sessionProvider)?.userId;
    final unCtrl = TextEditingController(text: acc.username);
    final curCtrl = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('تغيير اسم المستخدم — ${acc.fullName}'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(
            controller: unCtrl,
            decoration: const InputDecoration(
                labelText: 'اسم المستخدم الجديد', prefixIcon: Icon(Icons.person_outline)),
          ),
          if (self) ...[
            const SizedBox(height: 8),
            TextField(
              controller: curCtrl,
              obscureText: true,
              decoration: const InputDecoration(
                  labelText: 'كلمة المرور الحالية', prefixIcon: Icon(Icons.lock_outline)),
            ),
          ],
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('إلغاء')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('حفظ')),
        ],
      ),
    );
    if (ok != true) return;
    final newU = unCtrl.text.trim();
    if (newU.isEmpty) {
      _toast('اسم المستخدم لا يمكن أن يكون فارغاً', error: true);
      return;
    }
    final success = await _run(() => ref
        .read(accountsRepositoryProvider)
        .changeUsername(acc.id, newU,
            currentPassword: self ? curCtrl.text : null));
    if (success && mounted) _toast('تم تغيير اسم المستخدم');
  }

  // ─── تغيير الاسم الكامل ───
  Future<void> _changeFullName(AccountInfo acc) async {
    final nameCtrl = TextEditingController(text: acc.fullName);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('تغيير الاسم الكامل'),
        content: TextField(
          controller: nameCtrl,
          decoration: const InputDecoration(
              labelText: 'الاسم الكامل', prefixIcon: Icon(Icons.badge_outlined)),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('إلغاء')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('حفظ')),
        ],
      ),
    );
    if (ok != true) return;
    final newName = nameCtrl.text.trim();
    if (newName.isEmpty) {
      _toast('الاسم لا يمكن أن يكون فارغاً', error: true);
      return;
    }
    final success = await _run(
        () => ref.read(accountsRepositoryProvider).changeFullName(acc.id, newName));
    if (success && mounted) _toast('تم تحديث الاسم الكامل');
  }

  // ─── تفعيل / تعطيل حساب ───
  Future<void> _toggleActive(AccountInfo acc) async {
    final target = !acc.active;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(target ? 'تفعيل الحساب' : 'تعطيل الحساب'),
        content: Text(target
            ? 'سيتمكن "${acc.fullName}" من تسجيل الدخول بعد التفعيل.'
            : 'لن يتمكن "${acc.fullName}" من تسجيل الدخول بعد التعطيل. هل أنت متأكد؟'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('إلغاء')),
          FilledButton(
            style: FilledButton.styleFrom(
                backgroundColor: target ? AppColors.success : AppColors.danger),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(target ? 'تفعيل' : 'تعطيل'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    final success = await _run(
        () => ref.read(accountsRepositoryProvider).setActive(acc.id, target));
    if (success && mounted) _toast(target ? 'تم تفعيل الحساب' : 'تم تعطيل الحساب');
  }

  // ─── إضافة معلم جديد ───
  Future<void> _addTeacher() async {
    final unCtrl = TextEditingController();
    final pwCtrl = TextEditingController();
    final nameCtrl = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('إضافة معلم جديد'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(
            controller: nameCtrl,
            decoration: const InputDecoration(
                labelText: 'الاسم الكامل', prefixIcon: Icon(Icons.badge_outlined)),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: unCtrl,
            decoration: const InputDecoration(
                labelText: 'اسم المستخدم', prefixIcon: Icon(Icons.person_outline)),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: pwCtrl,
            obscureText: true,
            decoration: const InputDecoration(
                labelText: 'كلمة المرور (6 أحرف على الأقل)',
                prefixIcon: Icon(Icons.password)),
          ),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('إلغاء')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('إضافة')),
        ],
      ),
    );
    if (ok != true) return;
    final uname = unCtrl.text.trim();
    final pw = pwCtrl.text.trim();
    final fullName = nameCtrl.text.trim();
    if (uname.isEmpty || fullName.isEmpty) {
      _toast('أدخل الاسم الكامل واسم المستخدم', error: true);
      return;
    }
    if (pw.length < 6) {
      _toast('كلمة المرور يجب أن تكون 6 أحرف على الأقل', error: true);
      return;
    }
    final success = await _run(() => ref
        .read(accountsRepositoryProvider)
        .createTeacher(uname, pw, fullName));
    if (success && mounted) _toast('تم إنشاء حساب المعلم: $fullName');
  }

  // ─── لوحة التعديل لكل حساب ───
  void _showAccountActions(AccountInfo acc) {
    final self = acc.id == ref.read(sessionProvider)?.userId;
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          ListTile(
            title: Text(acc.fullName, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('@${acc.username} — ${acc.isSupervisor ? 'مشرف' : 'معلم'}'),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.password),
            title: const Text('تغيير كلمة المرور'),
            onTap: () {
              Navigator.pop(ctx);
              _changePassword(acc);
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('تغيير اسم المستخدم'),
            onTap: () {
              Navigator.pop(ctx);
              _changeUsername(acc);
            },
          ),
          ListTile(
            leading: const Icon(Icons.badge_outlined),
            title: const Text('تغيير الاسم الكامل'),
            onTap: () {
              Navigator.pop(ctx);
              _changeFullName(acc);
            },
          ),
          if (!self && !acc.isSupervisor)
            ListTile(
              leading: Icon(acc.active ? Icons.block : Icons.check_circle_outline,
                  color: acc.active ? AppColors.danger : AppColors.success),
              title: Text(acc.active ? 'تعطيل الحساب' : 'تفعيل الحساب'),
              onTap: () {
                Navigator.pop(ctx);
                _toggleActive(acc);
              },
            ),
          if (self)
            const Padding(
              padding: EdgeInsets.all(12),
              child: Text('تغيير بياناتك يتطلب إدخال كلمة المرور الحالية (حماية أمنية).',
                  style: TextStyle(fontSize: 12, color: Colors.black54)),
            ),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionProvider);
    final isSupervisor = session?.isSupervisor ?? false;

    return Scaffold(
      appBar: AppBar(title: const Text('إدارة الحسابات')),
      body: !isSupervisor
          ? const Center(
              child: Text('غير مصرح — هذه الصفحة للمشرف فقط',
                  style: TextStyle(color: Colors.red)))
          : _loading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.cloud_off, size: 48, color: Colors.grey),
                          const SizedBox(height: 12),
                          Text(_error!, textAlign: TextAlign.center),
                          const SizedBox(height: 12),
                          FilledButton.icon(
                            onPressed: _load,
                            icon: const Icon(Icons.refresh),
                            label: const Text('إعادة المحاولة'),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _load,
                      child: ListView(
                        padding: const EdgeInsets.only(bottom: 16),
                        children: [
                          // زر إضافة معلم
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: FilledButton.icon(
                              onPressed: _addTeacher,
                              icon: const Icon(Icons.person_add),
                              label: const Text('إضافة معلم جديد'),
                              style: FilledButton.styleFrom(
                                  backgroundColor: AppColors.secondary),
                            ),
                          ),
                          ...(_accounts ?? []).map((acc) => ListTile(
                                leading: CircleAvatar(
                                  backgroundColor:
                                      acc.isSupervisor ? AppColors.gold : AppColors.primary,
                                  child: Text(
                                    acc.fullName.isEmpty
                                        ? '؟'
                                        : acc.fullName.substring(0, 1),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                title: Text(acc.fullName,
                                    style: const TextStyle(fontWeight: FontWeight.w600)),
                                subtitle: Text(
                                  '@${acc.username} · ${acc.isSupervisor ? 'مشرف' : 'معلم'}'
                                  '${acc.active ? '' : ' · معطل'}',
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.edit_outlined),
                                  tooltip: 'إدارة الحساب',
                                  onPressed: () => _showAccountActions(acc),
                                ),
                                onTap: () => _showAccountActions(acc),
                              )),
                        ],
                      ),
                    ),
    );
  }
}
