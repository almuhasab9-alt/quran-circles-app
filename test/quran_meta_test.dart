import 'package:flutter_test/flutter_test.dart';
import 'package:quran_center/core/services/quran_meta.dart';

void main() {
  group('QuranMeta - صحة بيانات المصحف', () {
    test('أول صفحة تبدأ بالفاتحة 1', () {
      expect(QuranMeta.pageStartOf(1), (1, 1));
      expect(QuranMeta.pageOf(1, 1), 1);
      expect(QuranMeta.pageOf(1, 7), 1);
    });

    test('الصفحة 2 تبدأ بالبقرة 1', () {
      expect(QuranMeta.pageStartOf(2), (2, 1));
      expect(QuranMeta.pageOf(2, 1), 2);
    });

    test('الصفحة 49 تبدأ بالبقرة 283 (آية الدين) والصفحة 50 تبدأ بآل عمران', () {
      expect(QuranMeta.pageStartOf(49), (2, 283));
      expect(QuranMeta.pageStartOf(50), (3, 1));
    });

    test('آية الكرسي (البقرة 255) في الصفحة 42', () {
      expect(QuranMeta.pageOf(2, 255), 42);
    });

    test('الصفحة 582 تبدأ بسورة النبأ 1', () {
      expect(QuranMeta.pageStartOf(582), (78, 1));
    });

    test('الصفحة الأخيرة 604 تبدأ بسورة الإخلاص', () {
      expect(QuranMeta.pageStartOf(604), (112, 1));
      expect(QuranMeta.pageOf(114, 6), 604);
    });

    test('عدد آيات كل سورة صحيح', () {
      expect(QuranMeta.isValidAyah(1, 7), true);
      expect(QuranMeta.isValidAyah(1, 8), false);
      expect(QuranMeta.isValidAyah(2, 286), true);
      expect(QuranMeta.isValidAyah(2, 287), false);
      expect(QuranMeta.isValidAyah(115, 1), false);
    });
  });

  group('QuranMeta - حساب الصفحات بدقة', () {
    test('الفاتحة كاملة (1-7) = صفحة واحدة تقريباً', () {
      final p = QuranMeta.rangeInPages((1, 1), (1, 7));
      // الفاتحة + بداية البقرة في صفحة واحدة (7 آيات + بسمة/تعريف)
      expect(p, greaterThan(0.5));
      expect(p, lessThanOrEqualTo(1.0));
    });

    test('نطاق آية واحدة داخل صفحة = كسر صغير', () {
      final p = QuranMeta.rangeInPages((2, 255), (2, 255));
      expect(p, greaterThan(0));
      expect(p, lessThan(1));
    });

    test('نطاق صفحة كاملة يعطي ~1.0', () {
      // من بداية صفحة 3 إلى نهاية صفحة 3 (آخر آية قبل بداية صفحة 4)
      final from = QuranMeta.pageStartOf(3); // (2,6)
      // آخر آية في صفحة 3 هي قبل (2,17) أي (2,16)
      final p = QuranMeta.rangeInPages(from, (2, 16));
      expect(p, closeTo(1.0, 0.15));
    });

    test('جزء عمود (20 صفحة) تقريبياً: النبأ كاملة إلى آخرها', () {
      // من بداية صفحة 582 (النبأ 1) إلى نهاية صفحة 601
      final from = QuranMeta.pageStartOf(582);
      final endStart = QuranMeta.pageStartOf(602); // بداية 602
      // آخر موضع في 601: نأخذ بداية 602 ونطرح آية -> نستخدم rangeFullPages للتحقق
      final full = QuranMeta.rangeFullPages(from, endStart);
      expect(full, 21); // 582..602 شامل = 21 صفحة يغطيها النطاق
    });

    test('النطاق المعكوس = صفر', () {
      expect(QuranMeta.rangeInPages((2, 100), (2, 50)), 0);
    });

    test('سورة الناس كاملة موجودة في الصفحة 604', () {
      final p = QuranMeta.rangeInPages((114, 1), (114, 6));
      expect(p, greaterThan(0));
      expect(p, lessThanOrEqualTo(1.0));
    });

    test('rangeFullPages: من الفاتحة 1 إلى البقرة 5 = صفحتان', () {
      expect(QuranMeta.rangeFullPages((1, 1), (2, 5)), 2);
    });
  });

  group('QuranMeta - وصف نصي', () {
    test('أسماء السور', () {
      expect(QuranMeta.surahName(1), 'الفَاتِحة');
      expect(QuranMeta.surahName(112), 'الإخلَاص');
    });

    test('وصف نطاق', () {
      final d = QuranMeta.describeRange((2, 255), (2, 257));
      expect(d.contains('البَقَرَة'), true);
      expect(d.contains('255'), true);
      expect(d.contains('257'), true);
    });
  });
}
