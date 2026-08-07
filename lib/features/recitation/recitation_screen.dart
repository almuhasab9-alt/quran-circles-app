import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/enums.dart';
import '../../core/database/app_database.dart';
import '../../core/services/alert_engine.dart';
import '../../core/services/app_settings.dart';
import '../../core/services/evaluation_service.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/date_utils.dart';
import '../../shared/providers/providers.dart';
import '../../shared/widgets/common_widgets.dart';

class RecitationScreen extends ConsumerStatefulWidget {
  final String halaqaId;
  final String? studentId;
  const RecitationScreen({super.key, required this.halaqaId, this.studentId});

  @override
  ConsumerState<RecitationScreen> createState() => _RecitationScreenState();
}

class _RecitationScreenState extends ConsumerState<RecitationScreen> {
  Student? _student;
  DateTime _date = DateTime.now();
  int _fromSurah = 1, _fromAyah = 1, _toSurah = 1, _toAyah = 7;
  final _pagesCtrl = TextEditingController(text: '1');
  final _plannedCtrl = TextEditingController(text: '2');
  final _completedCtrl = TextEditingController(text: '2');
  int _minor = 0, _medium = 0, _major = 0, _selfCorr = 0;
  HomeworkStatus _homework = HomeworkStatus.completed;
  final _noteCtrl = TextEditingController();
  bool _useOverride = false;
  final _overrideScoreCtrl = TextEditingController();
  final _overrideReasonCtrl = TextEditingController();
  bool _saving = false;

  EvaluationResult get _result {
    final ev = ref.read(evaluationProvider).valueOrNull ??
        EvaluationService(AppSettings());
    return ev.evaluate(
      minorErrors: _minor, mediumErrors: _medium, majorErrors: _major, selfCorrections: _selfCorr,
      revisionPlannedPages: double.tryParse(_plannedCtrl.text) ?? 0,
      revisionCompletedPages: double.tryParse(_completedCtrl.text) ?? 0,
      attendance: AttendanceStatus.present, homework: _homework,
      overrideScore: _useOverride ? double.tryParse(_overrideScoreCtrl.text) : null,
    );
  }

  @override
  void initState() {
    super.initState();
    _loadDefaultStudent();
  }

  Future<void> _loadDefaultStudent() async {
    if (widget.studentId != null) {
      final students = await ref.read(studentRepoProvider).getAll();
      setState(() => _student = students.where((s) => s.id == widget.studentId).firstOrNull);
    }
  }

  @override
  void dispose() {
    for (final c in [_pagesCtrl, _plannedCtrl, _completedCtrl, _noteCtrl, _overrideScoreCtrl, _overrideReasonCtrl]) { c.dispose(); }
    super.dispose();
  }

  Future<void> _save() async {
    if (_student == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('الرجاء اختيار الطالب أولاً')));
      return;
    }
    if (_useOverride && _overrideReasonCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.red, content: Text('سبب تعديل الدرجة إلزامي')));
      return;
    }
    setState(() => _saving = true);
    final session = ref.read(sessionProvider);
    final r = _result;
    final now = DateTime.now();
    final record = DailyRecordsCompanion(
      id: drift.Value(const Uuid().v4()),
      studentId: drift.Value(_student!.id),
      halaqaId: drift.Value(widget.halaqaId),
      teacherId: drift.Value(session?.userId ?? 'demo'),
      date: drift.Value(_date),
      dateKey: drift.Value(dateKeyOf(_date)),
      attendance: const drift.Value('present'),
      fromSurah: drift.Value(AppConstants.surahs[_fromSurah - 1]), fromAyah: drift.Value(_fromAyah),
      toSurah: drift.Value(AppConstants.surahs[_toSurah - 1]), toAyah: drift.Value(_toAyah),
      estimatedPages: drift.Value(double.tryParse(_pagesCtrl.text) ?? 0),
      revisionPlannedPages: drift.Value(double.tryParse(_plannedCtrl.text) ?? 0),
      revisionCompletedPages: drift.Value(double.tryParse(_completedCtrl.text) ?? 0),
      revisionScore: drift.Value(r.revisionScore),
      minorErrors: drift.Value(_minor), mediumErrors: drift.Value(_medium),
      majorErrors: drift.Value(_major), selfCorrections: drift.Value(_selfCorr),
      automaticScore: drift.Value(r.finalScore),
      overrideScore: _useOverride ? drift.Value(double.tryParse(_overrideScoreCtrl.text)) : const drift.Value(null),
      overrideReason: _useOverride ? drift.Value(_overrideReasonCtrl.text.trim()) : const drift.Value(null),
      homeworkStatus: drift.Value(_homework.name),
      homeworkScore: drift.Value(r.homeworkScore),
      finalScore: drift.Value(r.finalScore),
      level: drift.Value(r.level.name),
      internalNote: drift.Value(_noteCtrl.text.trim()),
      needsFollowUp: drift.Value(r.level == PerformanceLevel.followUp),
      createdAt: drift.Value(now), updatedAt: drift.Value(now),
    );
    try {
      final recordRepo = ref.read(recordRepoProvider);
      await recordRepo.upsertRecord(record);
      // Run AlertEngine
      final engine = ref.read(alertEngineProvider).valueOrNull ?? AlertEngine(AppSettings());
      final alertRepo = ref.read(alertRepoProvider);
      final records = await recordRepo.byStudent(_student!.id);
      final lites = records.map((e) => DailyRecordLite(
            studentId: e.studentId, halaqaId: e.halaqaId, date: e.date,
            attendance: e.attendance, finalScore: e.finalScore,
            majorErrors: e.majorErrors, hasRecitation: true)).toList()
        ..sort((a, b) => a.date.compareTo(b.date));
      final openTypes = await alertRepo.openTypesForStudent(_student!.id);
      final openTypeEnums = openTypes.map((t) => AlertType.values.where((x) => x.name == t).firstOrNull).whereType<AlertType>().toSet();
      final drafts = engine.evaluate(studentId: _student!.id, halaqaId: widget.halaqaId,
          records: lites, openTypes: openTypeEnums, now: now);
      for (final d in drafts) {
        await alertRepo.insert(AlertsCompanion(
          id: drift.Value(const Uuid().v4()),
          studentId: drift.Value(d.studentId), halaqaId: drift.Value(d.halaqaId),
          type: drift.Value(d.type.name), severity: drift.Value(d.severity.name),
          message: drift.Value(d.message), status: const drift.Value('pendingReview'),
          createdBy: drift.Value(session?.userId ?? 'system'),
          createdAt: drift.Value(now),
        ));
      }
      ref.read(dataVersionProvider.notifier).state++;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: AppColors.success,
            content: Text('تم حفظ التسميع — الدرجة ${r.finalScore.toStringAsFixed(0)} (${levelAr(r.level.name)})${drafts.isNotEmpty ? ' — ${drafts.length} تنبيه جديد' : ''}')));
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: AppColors.danger, content: Text('خطأ في الحفظ: $e')));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Widget _counter(String label, int value, void Function(int) onChanged, Color color) {
    return Column(children: [
      Text(label, style: const TextStyle(fontSize: 12)),
      Row(mainAxisSize: MainAxisSize.min, children: [
        IconButton(icon: Icon(Icons.remove_circle_outline, color: color), onPressed: () => setState(() => onChanged(value > 0 ? value - 1 : 0))),
        Text('$value', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
        IconButton(icon: Icon(Icons.add_circle_outline, color: color), onPressed: () => setState(() => onChanged(value + 1))),
      ]),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final studentsAsync = ref.watch(studentsProvider);
    final r = _result;
    return Scaffold(
      appBar: AppBar(title: const Text('تسجيل التسميع')),
      body: studentsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => ErrorState(message: '$e'),
        data: (all) {
          final students = all.where((s) => s.halaqaId == widget.halaqaId && s.active).toList();
          if (students.isEmpty) return const EmptyState(message: 'لا يوجد طلاب نشطون في هذه الحلقة');
          return ListView(padding: const EdgeInsets.all(16), children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'الطالب', border: OutlineInputBorder()),
              initialValue: _student?.id,
              items: students.map((s) => DropdownMenuItem(value: s.id, child: Text('${s.fullName} (${s.studentCode})'))).toList(),
              onChanged: (v) => setState(() => _student = students.firstWhere((s) => s.id == v)),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              icon: const Icon(Icons.calendar_today),
              label: Text('التاريخ: ${formatDateAr(_date)}'),
              onPressed: () async {
                final d = await showDatePicker(context: context, initialDate: _date,
                    firstDate: DateTime(2024), lastDate: DateTime.now().add(const Duration(days: 1)), locale: const Locale('ar'));
                if (d != null) setState(() => _date = d);
              },
            ),
            const SizedBox(height: 16),
            const Text('الحفظ الجديد', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(child: _surahDropdown('من سورة', _fromSurah, (v) => setState(() => _fromSurah = v))),
              const SizedBox(width: 8),
              Expanded(child: _ayahField('من آية', _fromAyah, (v) => _fromAyah = v)),
            ]),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(child: _surahDropdown('إلى سورة', _toSurah, (v) => setState(() => _toSurah = v))),
              const SizedBox(width: 8),
              Expanded(child: _ayahField('إلى آية', _toAyah, (v) => _toAyah = v)),
            ]),
            const SizedBox(height: 8),
            TextField(controller: _pagesCtrl, keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
                decoration: const InputDecoration(labelText: 'عدد الصفحات التقديري', border: OutlineInputBorder()),
                onChanged: (_) => setState(() {})),
            const SizedBox(height: 16),
            const Text('المراجعة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(child: TextField(controller: _plannedCtrl, keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
                  decoration: const InputDecoration(labelText: 'المخطط (صفحات)', border: OutlineInputBorder()),
                  onChanged: (_) => setState(() {}))),
              const SizedBox(width: 8),
              Expanded(child: TextField(controller: _completedCtrl, keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
                  decoration: const InputDecoration(labelText: 'المنجز (صفحات)', border: OutlineInputBorder()),
                  onChanged: (_) => setState(() {}))),
            ]),
            const SizedBox(height: 16),
            const Text('أخطاء التسميع', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              _counter('خفيفة', _minor, (v) => _minor = v, AppColors.warning),
              _counter('متوسطة', _medium, (v) => _medium = v, Colors.deepOrange),
              _counter('كبيرة', _major, (v) => _major = v, AppColors.danger),
              _counter('تصحيح ذاتي', _selfCorr, (v) => _selfCorr = v, AppColors.success),
            ]),
            const SizedBox(height: 16),
            const Text('الواجب', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            SegmentedButton<HomeworkStatus>(
              segments: HomeworkStatus.values.map((s) => ButtonSegment(value: s, label: Text(s.ar))).toList(),
              selected: {_homework},
              onSelectionChanged: (v) => setState(() => _homework = v.first),
            ),
            const SizedBox(height: 16),
            Card(
              color: levelColor(r.level.name).withValues(alpha: 0.12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(children: [
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text('الدرجة: ${r.finalScore.toStringAsFixed(1)}',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: levelColor(r.level.name))),
                    if (_useOverride) ...[const SizedBox(width: 8), const Icon(Icons.edit, size: 18), const Text('معدّلة يدوياً')],
                  ]),
                  Text('المستوى: ${levelAr(r.level.name)}',
                      style: TextStyle(fontSize: 16, color: levelColor(r.level.name))),
                  const SizedBox(height: 4),
                  Text('تسميع ${r.recitationScore.toStringAsFixed(0)} • مراجعة ${r.revisionScore.toStringAsFixed(0)} • واجب ${r.homeworkScore.toStringAsFixed(0)}',
                      style: const TextStyle(fontSize: 12)),
                ]),
              ),
            ),
            SwitchListTile(
              title: const Text('تعديل الدرجة يدوياً'),
              value: _useOverride,
              onChanged: (v) => setState(() => _useOverride = v),
            ),
            if (_useOverride) ...[
              TextField(controller: _overrideScoreCtrl, keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
                  decoration: const InputDecoration(labelText: 'الدرجة المعدلة (0-100)', border: OutlineInputBorder()),
                  onChanged: (_) => setState(() {})),
              const SizedBox(height: 8),
              TextField(controller: _overrideReasonCtrl,
                  decoration: const InputDecoration(labelText: 'سبب التعديل (إلزامي) *', border: OutlineInputBorder()),
                  maxLines: 2),
            ],
            const SizedBox(height: 8),
            TextField(controller: _noteCtrl,
                decoration: const InputDecoration(labelText: 'ملاحظة داخلية', border: OutlineInputBorder()),
                maxLines: 2),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _saving ? null : _save,
              icon: _saving ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.save),
              label: const Text('حفظ التسميع'),
              style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(50)),
            ),
          ]);
        },
      ),
    );
  }

  Widget _surahDropdown(String label, int value, void Function(int) onChanged) {
    return DropdownButtonFormField<int>(
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      initialValue: value, isExpanded: true,
      items: List.generate(114, (i) => DropdownMenuItem(value: i + 1,
          child: Text('${i + 1}. ${AppConstants.surahs[i]}', overflow: TextOverflow.ellipsis))),
      onChanged: (v) { if (v != null) onChanged(v); },
    );
  }

  Widget _ayahField(String label, int value, void Function(int) onChanged) {
    final ctrl = TextEditingController(text: '$value');
    return TextField(controller: ctrl, keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
        onChanged: (v) { final n = int.tryParse(v); if (n != null && n > 0) onChanged(n); });
  }
}
