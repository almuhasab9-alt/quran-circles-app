import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/data_service.dart';
import 'student_detail_screen.dart';

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({super.key});
  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  final ds = DataService.instance;
  String query = '';
  String? filterCircleId;

  void _studentDialog({Student? existing}) {
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    final ageCtrl = TextEditingController(text: existing?.age.toString() ?? '');
    final parentNameCtrl = TextEditingController(text: existing?.parentName ?? '');
    final parentPhoneCtrl = TextEditingController(text: existing?.parentPhone ?? '');
    final juzCtrl = TextEditingController(text: existing?.memorizedJuz.toString() ?? '0');
    Circle circle = existing != null
        ? ds.circleById(existing.circleId) ?? ds.circles.first
        : ds.circles.first;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(builder: (ctx, setD) {
        return AlertDialog(
          title: Text(existing == null ? 'إضافة طالب' : 'تعديل طالب'),
          content: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'اسم الطالب')),
              TextField(controller: ageCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'العمر')),
              TextField(controller: parentNameCtrl, decoration: const InputDecoration(labelText: 'اسم ولي الأمر')),
              TextField(controller: parentPhoneCtrl, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'هاتف ولي الأمر')),
              TextField(controller: juzCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'عدد الأجزاء المحفوظة')),
              const SizedBox(height: 8),
              DropdownButtonFormField<Circle>(
                initialValue: circle,
                decoration: const InputDecoration(labelText: 'الحلقة'),
                items: ds.circles.map((c) => DropdownMenuItem(value: c, child: Text(c.name))).toList(),
                onChanged: (v) => setD(() => circle = v!),
              ),
            ]),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
            FilledButton(
              onPressed: () {
                if (nameCtrl.text.trim().isEmpty) return;
                final s = Student(
                  id: existing?.id ?? 'ST${ds.students.length + 1}',
                  name: nameCtrl.text.trim(),
                  age: int.tryParse(ageCtrl.text) ?? 10,
                  circleId: circle.id,
                  parentName: parentNameCtrl.text.trim(),
                  parentPhone: parentPhoneCtrl.text.trim(),
                  memorizedJuz: int.tryParse(juzCtrl.text) ?? 0,
                  level: circle.level,
                  joinDate: existing?.joinDate ?? DateTime.now(),
                );
                setState(() {
                  if (existing == null) { ds.addStudent(s); } else { ds.updateStudent(s); }
                });
                Navigator.pop(ctx);
              },
              child: const Text('حفظ'),
            ),
          ],
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    var list = ds.students;
    if (filterCircleId != null) list = list.where((s) => s.circleId == filterCircleId).toList();
    if (query.isNotEmpty) list = list.where((s) => s.name.contains(query)).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('الطلاب'),
        backgroundColor: const Color(0xFF0B7A5E), foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _studentDialog(),
        backgroundColor: const Color(0xFF0B7A5E),
        child: const Icon(Icons.person_add, color: Colors.white),
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(children: [
            Expanded(
              child: TextField(
                onChanged: (v) => setState(() => query = v),
                decoration: InputDecoration(
                  hintText: 'بحث عن طالب...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                ),
              ),
            ),
            const SizedBox(width: 8),
            DropdownButton<String?>(
              value: filterCircleId,
              hint: const Text('كل الحلقات'),
              items: [
                const DropdownMenuItem(value: null, child: Text('الكل')),
                ...ds.circles.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))),
              ],
              onChanged: (v) => setState(() => filterCircleId = v),
            ),
          ]),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: list.length,
            itemBuilder: (ctx, i) {
              final s = list[i];
              final c = ds.circleById(s.circleId);
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: const Color(0xFF0B7A5E).withValues(alpha: 0.15),
                  child: Text('${i + 1}', style: const TextStyle(color: Color(0xFF0B7A5E), fontSize: 13)),
                ),
                title: Text(s.name),
                subtitle: Text('${c?.name ?? ''} • ولي الأمر: ${s.parentName}'),
                trailing: IconButton(
                  icon: const Icon(Icons.edit, size: 20),
                  onPressed: () => _studentDialog(existing: s),
                ),
                onTap: () => Navigator.push(ctx, MaterialPageRoute(builder: (_) => StudentDetailScreen(student: s))),
              );
            },
          ),
        ),
      ]),
    );
  }
}
