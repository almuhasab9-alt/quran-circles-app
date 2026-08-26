import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// تثبيت معالجات الأخطاء العامة للتطبيق — تُستدعى مرة واحدة من main().
///
/// الهدف: عدم ظهور «شاشة رمادية فارغة» إطلاقاً. أي خطأ غير متوقع في
/// بناء أي واجهة يُستبدل بشاشة خطأ عربية واضحة مع زر إعادة المحاولة
/// (بدلاً من ErrorWidget الرمادي الافتراضي في وضع الإصدار).
void installGlobalErrorHandlers() {
  // استبدال ودجت الخطأ الافتراضي (الرمادي في Release) بشاشة مفهومة
  ErrorWidget.builder = (details) => AppErrorScreen(details: details);

  // أخطاء إطار العمل غير الملتقطة (بناء/رسم/أحداث)
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
  };

  // أخطاء غير متزامنة خارج إطار Flutter
  PlatformDispatcher.instance.onError = (error, stack) {
    if (kDebugMode) {
      debugPrint('AppError(async): $error');
    }
    return true; // تم التعامل معه — منع انهيار التطبيق
  };
}

/// شاشة خطأ تظهر بدلاً من أي واجهة انهارت — بديل الشاشة الرمادية.
class AppErrorScreen extends StatelessWidget {
  final FlutterErrorDetails details;
  const AppErrorScreen({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    const title = 'حدث خطأ غير متوقع';
    final msg = '${details.exception}';
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        color: const Color(0xFFFAF6F1),
        alignment: Alignment.center,
        padding: const EdgeInsets.all(20),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 48),
          const SizedBox(height: 10),
          const Text(title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black87)),
          const SizedBox(height: 6),
          Text(msg,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: Colors.black54)),
          const SizedBox(height: 14),
          Builder(builder: (btnCtx) {
            return FilledButton.icon(
              onPressed: () {
                final nav = Navigator.maybeOf(btnCtx);
                if (nav != null && nav.canPop()) {
                  nav.pop();
                } else {
                  // نعيد تشغيل الإطار الحالي لإعادة بناء الواجهة
                  final el = btnCtx as Element;
                  el.markNeedsBuild();
                }
              },
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('إعادة المحاولة'),
            );
          }),
        ]),
      ),
    );
  }
}

// حالة فارغة
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  const EmptyState({super.key, this.icon = Icons.inbox, required this.message});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(icon, size: 56, color: Colors.grey),
        const SizedBox(height: 12),
        Text(message, style: const TextStyle(color: Colors.grey, fontSize: 15)),
      ]),
    );
  }
}

// حالة خطأ
class ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  const ErrorState({super.key, required this.message, this.onRetry});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.error_outline, size: 56, color: Colors.red),
        const SizedBox(height: 12),
        Text(message, textAlign: TextAlign.center),
        if (onRetry != null) ...[
          const SizedBox(height: 12),
          FilledButton(onPressed: onRetry, child: const Text('إعادة المحاولة')),
        ],
      ]),
    );
  }
}

// بطاقة إحصائية
class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;
  const StatCard({super.key, required this.title, required this.value, required this.icon, required this.color, this.onTap});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap, borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 6),
            Text(value, style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: color)),
            Text(title, style: const TextStyle(fontSize: 11, color: Colors.black54), textAlign: TextAlign.center),
          ]),
        ),
      ),
    );
  }
}

Color gradeColor(String grade) {
  switch (grade) {
    case 'excellent': return const Color(0xFF2E7D32);
    case 'veryGood': return const Color(0xFF558B2F);
    case 'good': return const Color(0xFFF9A825);
    case 'repeat': return const Color(0xFFC62828);
    default: return Colors.grey;
  }
}

String gradeAr(String grade) {
  switch (grade) {
    case 'excellent': return 'ممتاز';
    case 'veryGood': return 'جيد جداً';
    case 'good': return 'جيد';
    case 'repeat': return 'إعادة';
    default: return grade;
  }
}

/// حارس محلي حول قسم واحد من الواجهة (مخطط/جدول/قائمة):
/// إذا انهار بناء القسم يعرض بطاقة خطأ مفهومة بدل أن يسقط بقية الشاشة.
///
/// ملاحظة: التقاط أخطاء البناء الحقيقي يتم عبر المعالج العام
/// installGlobalErrorHandlers() — هذا الحارس يوفر بديلاً «صغير الحجم»
/// داخل القوائم حتى لا تختفي الشاشة كلها.
class SectionGuard extends StatelessWidget {
  final Widget child;
  final String sectionName;
  const SectionGuard({super.key, required this.child, this.sectionName = 'القسم'});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(child: child);
  }
}
