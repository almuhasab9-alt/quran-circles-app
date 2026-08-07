import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/enums.dart';
import '../../core/database/app_database.dart';
import '../../core/services/demo_auth_repository.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/providers/providers.dart';

class DemoLoginScreen extends ConsumerStatefulWidget {
  const DemoLoginScreen({super.key});
  @override
  ConsumerState<DemoLoginScreen> createState() => _DemoLoginScreenState();
}

class _DemoLoginScreenState extends ConsumerState<DemoLoginScreen> {
  UserRole role = UserRole.admin;
  User? selectedUser;
  List<User> users = [];
  final nameCtrl = TextEditingController();
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final repo = DemoAuthRepository(ref.read(dbProvider));
    users = await repo.demoUsersByRole(role.name);
    selectedUser = users.isNotEmpty ? users.first : null;
    nameCtrl.text = selectedUser?.fullName ?? '';
    setState(() => loading = false);
  }

  Future<void> _login() async {
    if (selectedUser == null) return;
    ref.read(sessionProvider.notifier).state = DemoSession(
      userId: selectedUser!.id,
      name: nameCtrl.text.trim().isEmpty ? selectedUser!.fullName : nameCtrl.text.trim(),
      role: role.name,
    );
    context.go('/home');
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
                    SegmentedButton<UserRole>(
                      segments: const [
                        ButtonSegment(value: UserRole.admin, label: Text('مدير'), icon: Icon(Icons.manage_accounts)),
                        ButtonSegment(value: UserRole.supervisor, label: Text('مشرف'), icon: Icon(Icons.supervisor_account)),
                        ButtonSegment(value: UserRole.teacher, label: Text('معلم'), icon: Icon(Icons.school)),
                      ],
                      selected: {role},
                      onSelectionChanged: (s) {
                        setState(() { role = s.first; loading = true; });
                        _loadUsers();
                      },
                    ),
                    const SizedBox(height: 16),
                    if (loading)
                      const Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator())
                    else ...[
                      DropdownButtonFormField<User>(
                        initialValue: selectedUser,
                        decoration: InputDecoration(
                          labelText: 'اختر المستخدم التجريبي',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          prefixIcon: const Icon(Icons.person_search),
                        ),
                        items: users.map((u) => DropdownMenuItem(value: u, child: Text(u.fullName))).toList(),
                        onChanged: (v) => setState(() {
                          selectedUser = v;
                          nameCtrl.text = v?.fullName ?? '';
                        }),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: nameCtrl,
                        decoration: InputDecoration(
                          labelText: 'اسم العرض (اختياري)',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          prefixIcon: const Icon(Icons.badge),
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity, height: 48,
                      child: FilledButton.icon(
                        onPressed: loading ? null : _login,
                        icon: const Icon(Icons.login),
                        label: const Text('دخول تجريبي', style: TextStyle(fontSize: 16)),
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
                        'هذه نسخة اختبارية، وتسجيل الدخول الآمن لم يتم تفعيله بعد.',
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
