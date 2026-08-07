import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/data_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  UserRole selectedRole = UserRole.admin;
  final nameCtrl = TextEditingController(text: 'مدير المركز');

  @override
  void initState() {
    super.initState();
    DataService.instance.seed();
  }

  void _login() {
    final user = AppUser(
      id: 'U1',
      name: nameCtrl.text.trim().isEmpty ? 'مستخدم تجريبي' : nameCtrl.text.trim(),
      role: selectedRole,
    );
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => HomeScreen(user: user)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0B7A5E), Color(0xFF0D9B78), Color(0xFFC9A227)],
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Card(
                elevation: 12,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset('assets/images/logo.png', height: 110),
                      ),
                      const SizedBox(height: 16),
                      const Text('مركز السنة للعلوم الشرعية',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0B7A5E))),
                      const Text('وتأهيل الدعاة - شبوة عتق',
                          style: TextStyle(fontSize: 14, color: Colors.black54)),
                      const Divider(height: 28),
                      const Text('نظام إدارة حلقات القرآن الكريم',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 20),
                      TextField(
                        controller: nameCtrl,
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                          labelText: 'الاسم',
                          prefixIcon: const Icon(Icons.person),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Align(
                        alignment: Alignment.centerRight,
                        child: Text('اختر الدور (وضع تجريبي):',
                            style: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                      const SizedBox(height: 8),
                      SegmentedButton<UserRole>(
                        segments: const [
                          ButtonSegment(value: UserRole.admin, label: Text('مدير'), icon: Icon(Icons.manage_accounts)),
                          ButtonSegment(value: UserRole.supervisor, label: Text('مشرف'), icon: Icon(Icons.supervisor_account)),
                          ButtonSegment(value: UserRole.teacher, label: Text('معلم'), icon: Icon(Icons.school)),
                        ],
                        selected: {selectedRole},
                        onSelectionChanged: (s) => setState(() => selectedRole = s.first),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity, height: 50,
                        child: FilledButton.icon(
                          onPressed: _login,
                          icon: const Icon(Icons.login),
                          label: const Text('دخول', style: TextStyle(fontSize: 18)),
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF0B7A5E),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text('وضع تجريبي - لا يتطلب كلمة مرور',
                          style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
