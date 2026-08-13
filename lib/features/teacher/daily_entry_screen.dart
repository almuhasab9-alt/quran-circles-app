import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/enums.dart';
import '../../core/database/app_database.dart';
import '../../core/services/quran_meta.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/date_utils.dart' as du;
import '../../shared/providers/providers.dart';
import '../../shared/widgets/common_widgets.dart';

/// نموذج التسجيل اليومي للمعلم — يطابق أعمدة كشف «متابعة ربط الأخ القرآني».
class DailyEntryScreen extends ConsumerStatefulWidget {
  final String halaqaId;
  final String? studentId;
  const DailyEntryScreen({super.key, required this.halaqaId, this.studentId});

  @override
  ConsumerState<DailyEntryScreen> createState() => _DailyEntryScreenState();
}

class _DailyEntryScreenState extends ConsumerState<DailyEntryScreen> {
  Student? _student;
  DateTime _date = DateTime.now();
  bool _saving = false;
  String? _error;

  // الجديد
  int _newFromSurah = 1, _newFromAyah = 1, _newToSurah = 1, _newToAyah = 7;
  EvaluationGrade? _grade = EvaluationGrade.good;
  final _repCtrl = TextEditingController(text: '5');
  // المراجعات بالصفحات
  final _recentFrom = TextEditingController();
  final _recentTo = TextEditingController();
  final _minorFrom = TextEditingController();
  final _minorTo = TextEditingController();
  final _majorFrom = TextEditingController();
  final _majorTo = TextEditingController();
  final _notesCtrl = TextEditingController();

  bool get _isFriday => _date.weekday == DateTime.friday;

  @override
  void initState() {
    super.initState();
    _loadStudent();
  }

  Future<void> _loadStudent() async {
    final students = await ref.read(studentRepoProvider).byHalaqa(widget.halaqaId);
    if (!mounted) return;
    setState(() {
      _student = widget.studentId != null
          ? students.where((s) => s.id == widget.studentId).firstOrNull ?? students.firstOrNull
          : students.firstOrNull;
    });
  }

  double get _computedPages {
    if (!QuranMeta.isValidAyah(_newFromSurah, _newFromAyah) ||
        !QuranMeta.isValidAyah(_newToSurah, _newToAyah)) {
      return 0;
    }
    if (_newToSurah * 10000 + _newToAyah < _newFromSurah * 10000 + _newFromAyah) {
      return 0;
    }
    return QuranMeta.rangeInPages((_newFromSurah, _newFromAyah), (_newToSurah, _newToAyah));
  }

  Future<void> _save() async {
    final session = ref.read(sessionProvider);
    if (_student == null || session == null) return;
    setState(() { _saving = true; _error = null; });

    final svc = ref.read(sessionServiceProvider);
    final result = await svc.saveDailyRecord(
      studentId: _student!.id,
      halaqaId: widget.halaqaId,
      teacherId: session.userId,
      date: _date,
      newFromSurah: _newFromSurah, newFromAyah: _newFromAyah,
      newToSurah: _newToSurah, newToAyah: _newToAyah,
      grade: _isFriday ? null : _grade,
      repetition: int.tryParse(_repCtrl.text) ?? 0,
      recentFromPage: int.tryParse(_recentFrom.text) ?? 0,
      recentToPage: int.tryParse(_recentTo.text) ?? 0,
      minorFromPage: int.tryParse(_minorFrom.text) ?? 0,
      minorToPage: int.tryParse(_minorTo.text) ?? 0,
      majorFromPage: int.tryParse(_majorFrom.text) ?? 0,
      majorToPage: int.tryParse(_majorTo.text) ?? 0,
      notes: _notesCtrl.text.trim(),
    );

    if (!mounted) return;
    setState(() => _saving = false);
    if (result.ok) {
      bumpDataVersion(ref);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('تم حفظ سجل ${_student!.fullName} ليوم ${_date.weekdayAr} ${du.dateKeyOf(_date)}'),
        backgroundColor: AppColors.success,
      ));
      Navigator.pop(context);
    } else {
      setState(() => _error = result.error);
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now().subtract(const Duration(days: 60)),
      lastDate: DateTime.now(),
      locale: const Locale('ar'),
    );
    if (picked != null) setState(() => _date = picked);
  }

  @override
  void dispose() {
    _repCtrl.dispose(); _recentFrom.dispose(); _recentTo.dispose();
    _minorFrom.dispose(); _minorTo.dispose(); _majorFrom.dispose();
    _majorTo.dispose(); _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final studentsAsync = ref.watch(studentsProvider);
    final halaqaStudents = (studentsAsync.value ?? []).where((s) => s.halaqaId == widget.halaqaId).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('تسجيل التسميع اليومي')),
      body: halaqaStudents.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView(padding: const EdgeInsets.all(16), children: [
              // الطالب والتاريخ
              DropdownButtonFormField<Student>(
                initialValue: halaqaStudents.contains(_student) ? _student : halaqaStudents.first,
                isExpanded: true,
                decoration: const InputDecoration(labelText: 'الطالب', border: OutlineInputBorder(), prefixIcon: Icon(Icons.person)),
                items: halaqaStudents.map((s) => DropdownMenuItem(value: s, child: Text('${s.fullName} (${s.studentCode})', overflow: TextOverflow.ellipsis))).toList(),
                onChanged: (v) => setState(() => _student = v),
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: _pickDate,
                child: InputDecorator(
                  decoration: const InputDecoration(labelText: 'اليوم والتاريخ', border: OutlineInputBorder(), prefixIcon: Icon(Icons.calendar_today)),
                  child: Row(children: [
                    Text('${_date.weekdayAr} — ${du.formatDate(_date)}', style: const TextStyle(fontSize: 16)),
                    const Spacer(),
                    if (_isFriday)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: AppColors.gold.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
                        child: const Text('ربط الجمعة', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                  ]),
                ),
              ),

              if (_error != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.danger.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.danger),
                  ),
                  child: Row(children: [
                    const Icon(Icons.block, color: AppColors.danger),
                    const SizedBox(width: 8),
                    Expanded(child: Text(_error!, style: const TextStyle(color: AppColors.danger, fontWeight: FontWeight.bold))),
                  ]),
                ),
              ],

              const SizedBox(height: 16),

              if (!_isFriday) ...[
                _sectionTitle('الجديد (من آية إلى آية)', Icons.auto_stories),
                _surahAyahRow(
                  label: 'من',
                  surah: _newFromSurah, ayah: _newFromAyah,
                  onSurah: (v) => setState(() { _newFromSurah = v; _newFromAyah = 1; }),
                  onAyah: (v) => setState(() => _newFromAyah = v),
                ),
                const SizedBox(height: 8),
                _surahAyahRow(
                  label: 'إلى',
                  surah: _newToSurah, ayah: _newToAyah,
                  onSurah: (v) => setState(() { _newToSurah = v; _newToAyah = 1; }),
                  onAyah: (v) => setState(() => _newToAyah = v),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(children: [
                    const Icon(Icons.calculate, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Expanded(child: Text(
                      _computedPages > 0
                          ? 'مقدار الجديد: ${_computedPages.toStringAsFixed(2)} صفحة (${QuranMeta.describeRange((_newFromSurah, _newFromAyah), (_newToSurah, _newToAyah))})'
                          : 'أدخل نطاقاً صحيحاً لحساب الصفحات',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                    )),
                  ]),
                ),
                const SizedBox(height: 12),
                // التقدير
                _sectionTitle('التقدير', Icons.grade),
                Wrap(spacing: 8, children: [
                  for (final g in EvaluationGrade.values)
                    ChoiceChip(
                      label: Text(g.ar),
                      selected: _grade == g,
                      selectedColor: gradeColor(g.name).withValues(alpha: 0.2),
                      labelStyle: TextStyle(
                        color: _grade == g ? gradeColor(g.name) : Colors.black87,
                        fontWeight: _grade == g ? FontWeight.bold : FontWeight.normal,
                      ),
                      onSelected: (_) => setState(() => _grade = g),
                    ),
                ]),
                const SizedBox(height: 12),
                TextField(
                  controller: _repCtrl, keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'التكرار (عدد مرات تكرار الجديد)',
                    border: OutlineInputBorder(), prefixIcon: Icon(Icons.repeat),
                  ),
                ),
                const SizedBox(height: 16),
              ] else ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: AppColors.gold.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(children: [
                    Icon(Icons.info_outline, color: AppColors.primary),
                    SizedBox(width: 8),
                    Expanded(child: Text('يوم الجمعة مخصص للربط (المراجعة) فقط — بدون جديد وبدون تقدير.', style: TextStyle(fontWeight: FontWeight.bold))),
                  ]),
                ),
              ],

              // المراجعات بالصفحات
              _sectionTitle(_isFriday ? 'ربط الجمعة (صفحات المراجعة)' : 'المراجعات (من صفحة إلى صفحة)', Icons.menu_book),
              _pageRangeRow('حديث العهد', _recentFrom, _recentTo),
              const SizedBox(height: 8),
              _pageRangeRow('المراجعة الصغرى', _minorFrom, _minorTo),
              const SizedBox(height: 8),
              _pageRangeRow('المراجعة الكبرى', _majorFrom, _majorTo),
              const SizedBox(height: 12),

              TextField(
                controller: _notesCtrl, maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'الملاحظات',
                  border: OutlineInputBorder(), prefixIcon: Icon(Icons.note_alt),
                ),
              ),
              const SizedBox(height: 20),

              SizedBox(
                height: 50,
                child: FilledButton.icon(
                  onPressed: _saving ? null : _save,
                  icon: _saving ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.save),
                  label: Text(_saving ? 'جارٍ الحفظ...' : 'حفظ السجل', style: const TextStyle(fontSize: 16)),
                  style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
                ),
              ),
              const SizedBox(height: 30),
            ]),
    );
  }

  Widget _sectionTitle(String t, IconData icon) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(children: [
      Icon(icon, size: 18, color: AppColors.primary),
      const SizedBox(width: 6),
      Text(t, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.primary)),
    ]),
  );

  Widget _surahAyahRow({
    required String label, required int surah, required int ayah,
    required ValueChanged<int> onSurah, required ValueChanged<int> onAyah,
  }) {
    final maxAyah = QuranMeta.isValidSurah(surah) ? _ayahCountOf(surah) : 7;
    return Row(children: [
      SizedBox(width: 34, child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold))),
      Expanded(flex: 3, child: DropdownButtonFormField<int>(
        initialValue: surah, isExpanded: true,
        decoration: const InputDecoration(labelText: 'السورة', border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4)),
        items: [for (int i = 1; i <= 114; i++) DropdownMenuItem(value: i, child: Text('$i. ${QuranMeta.surahName(i)}', overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13)))],
        onChanged: (v) { if (v != null) onSurah(v); },
      )),
      const SizedBox(width: 8),
      Expanded(flex: 2, child: DropdownButtonFormField<int>(
        initialValue: ayah.clamp(1, maxAyah), isExpanded: true,
        decoration: const InputDecoration(labelText: 'الآية', border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4)),
        items: [for (int i = 1; i <= maxAyah; i++) DropdownMenuItem(value: i, child: Text('$i', style: const TextStyle(fontSize: 13)))],
        onChanged: (v) { if (v != null) onAyah(v); },
      )),
    ]);
  }

  int _ayahCountOf(int surah) {
    // نستخدم isValidAyah للعثور على الحد الأقصى — أبسط: نقرأ من QuranMetaData عبر QuranMeta
    int a = 1;
    while (QuranMeta.isValidAyah(surah, a + 1)) { a++; }
    return a;
  }

  Widget _pageRangeRow(String label, TextEditingController from, TextEditingController to) {
    return Row(children: [
      SizedBox(width: 100, child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
      Expanded(child: TextField(
        controller: from, keyboardType: TextInputType.number,
        decoration: const InputDecoration(labelText: 'من صفحة', border: OutlineInputBorder(), isDense: true),
        onChanged: (_) => setState(() {}),
      )),
      const SizedBox(width: 8),
      Expanded(child: TextField(
        controller: to, keyboardType: TextInputType.number,
        decoration: const InputDecoration(labelText: 'إلى صفحة', border: OutlineInputBorder(), isDense: true),
        onChanged: (_) => setState(() {}),
      )),
      const SizedBox(width: 8),
      Builder(builder: (_) {
        final f = int.tryParse(from.text) ?? 0;
        final t = int.tryParse(to.text) ?? 0;
        final n = (f > 0 && t >= f) ? t - f + 1 : 0;
        return Text(n > 0 ? '$n ص' : '—', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary));
      }),
    ]);
  }
}
