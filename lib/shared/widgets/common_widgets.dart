import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';

// شارة الوضع التجريبي الثابتة
class DemoBadge extends StatelessWidget {
  const DemoBadge({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      color: Colors.amber.shade700,
      child: const Text(
        AppConstants.demoBadge,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
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

Color levelColor(String level) {
  switch (level) {
    case 'excellent': return const Color(0xFF2E7D32);
    case 'veryGood': return const Color(0xFF558B2F);
    case 'good': return const Color(0xFFF9A825);
    case 'improve': return const Color(0xFFE65100);
    case 'followUp': return const Color(0xFFC62828);
    default: return Colors.grey;
  }
}

String levelAr(String level) {
  switch (level) {
    case 'excellent': return 'متقن';
    case 'veryGood': return 'جيد جداً';
    case 'good': return 'جيد';
    case 'improve': return 'يحتاج تحسيناً';
    case 'followUp': return 'يحتاج متابعة';
    default: return level;
  }
}

String attendanceAr(String a) {
  switch (a) {
    case 'present': return 'حاضر';
    case 'late': return 'متأخر';
    case 'excusedAbsence': return 'غائب بعذر';
    case 'unexcusedAbsence': return 'غائب بلا عذر';
    default: return a;
  }
}
