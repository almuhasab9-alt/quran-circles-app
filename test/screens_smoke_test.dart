// اختبار دخان: يضخ كل شاشات الصدفة (الرئيسية/الطلاب/الحلقات/التقارير/الإعدادات/الحسابات)
// ببيانات حقيقية الشكل — لالتقاط أي استثناء أثناء البناء (سبب الشاشة الرمادية).
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:quran_center/core/database/app_database.dart';
import 'package:quran_center/core/router/app_router.dart';
import 'package:quran_center/features/dashboard/dashboard_screen.dart';
import 'package:quran_center/features/halaqas/halaqas_screen.dart';
import 'package:quran_center/features/reports/reports_screen.dart';
import 'package:quran_center/features/settings/settings_screen.dart';
import 'package:quran_center/features/students/students_screen.dart';
import 'package:quran_center/shared/providers/providers.dart';

Halaqa _h(String id, String name, String teacherIds) => Halaqa(
      id: id,
      name: name,
      level: 'التمهيدي',
      teacherIds: teacherIds,
      supervisorId: 'sup-1',
      capacity: 20,
      scheduleDescription: 'السبت-الأربعاء',
      active: true,
    );

Student _s(String id, String code, String name, String halaqaId) => Student(
      id: id,
      studentCode: code,
      fullName: name,
      halaqaId: halaqaId,
      level: 'التمهيدي',
      active: true,
      joinDate: DateTime(2026, 6, 1),
      internalNotes: '',
      createdAt: DateTime(2026, 6, 1),
      updatedAt: DateTime(2026, 6, 1),
    );

/// إحصاءات مطابقة لرد الخادم الفعلي (بما فيها قيم أسبوعية سالبة)
DashboardStats _realStats() => DashboardStats(
      todayRecordCount: 0,
      halaqaIdsWithRecordsToday: {},
      totalNewPages: 938.5,
      repeatStudentCount: 296,
      gradeCounts: {'excellent': 5668, 'good': 5505, 'repeat': 2782, 'veryGood': 8165},
      weeklyNewPages: [0, 12.5, 0, 30, 0, 0, 147.0, 0, 44, 147.0, -93.4, -721.4],
      halaqaNewPages: {'h1': 51.8, 'h2': 120.3, 'h3': 0},
      strugglingStudents: const [],
    );

List<Override> _overrides({required bool failNetwork}) {
  final session = const DemoSession(userId: 'sup-1', name: 'المشرف', role: 'supervisor');
  return [
    dbProvider.overrideWithValue(AppDatabase.forTesting(NativeDatabase.memory())),
    sessionProvider.overrideWith((_) => session),
    halaqasProvider.overrideWith((_) async {
      if (failNetwork) throw Exception('SocketException: الشبكة محجوبة');
      return [_h('h1', 'حلقة الفرقان', 't-1'), _h('h2', 'حلقة النور', 't-2'), _h('h3', 'حلقة الإحسان', 't-1')];
    }),
    studentsProvider.overrideWith((_) async {
      if (failNetwork) throw Exception('SocketException: الشبكة محجوبة');
      return [
        _s('s1', 'ST1001', 'أحمد محمد', 'h1'),
        _s('s2', 'ST1002', 'سالم عبدالله', 'h2'),
      ];
    }),
    allRecordsProvider.overrideWith((_) async {
      if (failNetwork) throw Exception('SocketException: الشبكة محجوبة');
      return <DailyRecord>[];
    }),
    usersProvider.overrideWith((_) async => <User>[]),
    dashboardStatsProvider.overrideWith((_) async {
      if (failNetwork) throw Exception('SocketException: الشبكة محجوبة');
      return _realStats();
    }),
  ];
}

Future<void> _pumpScreen(WidgetTester tester, Widget screen, {required bool failNetwork}) async {
  SharedPreferences.setMockInitialValues({});
  final router = GoRouter(
    routes: [
      ShellRoute(
        builder: (_, __, child) => HomeShell(child: child),
        routes: [GoRoute(path: '/', builder: (_, __) => screen)],
      ),
    ],
  );
  await tester.pumpWidget(
    ProviderScope(
      overrides: _overrides(failNetwork: failNetwork),
      child: MaterialApp.router(routerConfig: router),
    ),
  );
  await tester.pump(const Duration(seconds: 3));
  await tester.pump(const Duration(seconds: 3));
}

void main() {
  group('الشاشات مع بيانات ناجحة', () {
    testWidgets('الرئيسية (لوحة التحكم)', (t) async {
      await _pumpScreen(t, const DashboardScreen(), failNetwork: false);
      expect(t.takeException(), isNull);
    });
    testWidgets('الطلاب', (t) async {
      await _pumpScreen(t, const StudentsScreen(), failNetwork: false);
      expect(t.takeException(), isNull);
    });
    testWidgets('الحلقات', (t) async {
      await _pumpScreen(t, const HalaqasScreen(), failNetwork: false);
      expect(t.takeException(), isNull);
    });
    testWidgets('التقارير', (t) async {
      await _pumpScreen(t, const ReportsScreen(), failNetwork: false);
      expect(t.takeException(), isNull);
    });
    testWidgets('الإعدادات', (t) async {
      await _pumpScreen(t, const SettingsScreen(), failNetwork: false);
      expect(t.takeException(), isNull);
    });
  });

  group('الشاشات مع فشل الشبكة (محاكاة الحجب بدون VPN)', () {
    testWidgets('الرئيسية', (t) async {
      await _pumpScreen(t, const DashboardScreen(), failNetwork: true);
      expect(t.takeException(), isNull);
    });
    testWidgets('الطلاب', (t) async {
      await _pumpScreen(t, const StudentsScreen(), failNetwork: true);
      expect(t.takeException(), isNull);
    });
    testWidgets('الحلقات', (t) async {
      await _pumpScreen(t, const HalaqasScreen(), failNetwork: true);
      expect(t.takeException(), isNull);
    });
    testWidgets('التقارير', (t) async {
      await _pumpScreen(t, const ReportsScreen(), failNetwork: true);
      expect(t.takeException(), isNull);
    });
  });
}
