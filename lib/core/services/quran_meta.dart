import 'quran_meta_data.dart';

/// نظام خلفي دقيق لحسابات المصحف الشريف (مصحف المدينة، 604 صفحات).
///
/// يتيح:
/// - تحويل موضع (سورة، آية) إلى رقم صفحة.
/// - تحويل رقم صفحة إلى أول موضع فيها.
/// - حساب مقدار النطاق بالصفحات بدقة (كسور الصفحات مشمولة).
class QuranMeta {
  QuranMeta._();

  static const int totalPages = 604;
  static const int totalSurahs = 114;

  /// أول صفحة = 1، آخر صفحة = 604
  static bool isValidPage(int page) => page >= 1 && page <= totalPages;

  static bool isValidSurah(int surah) => surah >= 1 && surah <= totalSurahs;

  static bool isValidAyah(int surah, int ayah) =>
      isValidSurah(surah) && ayah >= 1 && ayah <= QuranMetaData.ayahCount[surah];

  /// اسم السورة بالعربية
  static String surahName(int surah) =>
      isValidSurah(surah) ? QuranMetaData.surahNames[surah] : '';

  /// رقم الصفحة التي يقع فيها الموضع (سورة، آية).
  /// يعتمد على البحث الثنائي في جدول بدايات الصفحات.
  static int pageOf(int surah, int ayah) {
    if (!isValidAyah(surah, ayah)) return 0;
    // نبحث عن أكبر صفحة p بحيث pageStart[p] <= (surah, ayah)
    int lo = 1, hi = totalPages, ans = 1;
    while (lo <= hi) {
      final mid = (lo + hi) >> 1;
      final start = QuranMetaData.pageStart[mid];
      if (_comparePos(start.$1, start.$2, surah, ayah) <= 0) {
        ans = mid;
        lo = mid + 1;
      } else {
        hi = mid - 1;
      }
    }
    return ans;
  }

  /// أول موضع في صفحة معيّنة
  static QuranPos pageStartOf(int page) {
    if (!isValidPage(page)) return (0, 0);
    return QuranMetaData.pageStart[page];
  }

  /// عدد الآيات في الصفحة (تقريبي عبر الفرق بين البدايات، بالمواضع المطلقة)
  static int ayahsInPage(int page) {
    if (!isValidPage(page)) return 0;
    final startAbs = _toAbsolute(QuranMetaData.pageStart[page]);
    final endAbs = page == totalPages
        ? _totalAyahs() + 1
        : _toAbsolute(QuranMetaData.pageStart[page + 1]);
    return endAbs - startAbs;
  }

  /// يحسب مقدار النطاق من (من سورة/آية) إلى (إلى سورة/آية) بالصفحات بدقة.
  ///
  /// الحساب: يُحسب الفرق بالمواضع المطلقة ويُقسم على متوسط كثافة الصفحة الواحدة
  /// في منطقة النطاق نفسه، فيعطي كسراً دقيقاً لعدد الصفحات.
  static double rangeInPages(QuranPos from, QuranPos to) {
    if (!isValidAyah(from.$1, from.$2) || !isValidAyah(to.$1, to.$2)) return 0;
    final fromAbs = _toAbsolute(from);
    final toAbs = _toAbsolute(to);
    if (toAbs < fromAbs) return 0;
    final ayahCount = toAbs - fromAbs + 1; // شامل الطرفين
    if (ayahCount <= 0) return 0;
    // متوسط عدد الآيات في الصفحة الواحدة ضمن الصفحات التي يغطيها النطاق
    final startPage = pageOf(from.$1, from.$2);
    final endPage = pageOf(to.$1, to.$2);
    if (endPage <= startPage) {
      // ضمن صفحة واحدة
      final inPage = ayahsInPage(startPage);
      return inPage <= 0 ? 0 : ayahCount / inPage;
    }
    // آيات كل الصفحات المغطاة من بداية startPage حتى نهاية endPage
    final spanStartAbs = _toAbsolute(QuranMetaData.pageStart[startPage]);
    final spanEndAbs = endPage == totalPages
        ? _totalAyahs() + 1
        : _toAbsolute(QuranMetaData.pageStart[endPage + 1]);
    final totalAyahsInSpan = spanEndAbs - spanStartAbs;
    final pagesInSpan = endPage - startPage + 1;
    final avgPerPage = totalAyahsInSpan / pagesInSpan;
    return avgPerPage <= 0 ? 0 : ayahCount / avgPerPage;
  }

  /// عدد الصفحات الكاملة التي يغطيها النطاق (صحيح، شامل)
  static int rangeFullPages(QuranPos from, QuranPos to) {
    final startPage = pageOf(from.$1, from.$2);
    final endPage = pageOf(to.$1, to.$2);
    if (startPage <= 0 || endPage <= 0 || endPage < startPage) return 0;
    return endPage - startPage + 1;
  }

  /// نص وصفي مختصر للموضع، مثل: «البقرة ٢٥٥»
  static String describe(QuranPos pos) =>
      '${surahName(pos.$1)} ${pos.$2}';

  /// وصف نطاق: «من الفاتحة 1 إلى البقرة 5»
  static String describeRange(QuranPos from, QuranPos to) =>
      'من ${describe(from)} إلى ${describe(to)}';

  /// وصف نطاق بالصفحات: «من صفحة 1 إلى صفحة 3»
  static String describePageRange(int fromPage, int toPage) =>
      'من صفحة $fromPage إلى صفحة $toPage';

  // ---------- داخلي ----------

  /// تحويل موضع (سورة، آية) إلى رقم مطلق تسلسلي (1-based عبر كل المصحف)
  static int _toAbsolute(QuranPos pos) {
    int abs = 0;
    for (int s = 1; s < pos.$1; s++) {
      abs += QuranMetaData.ayahCount[s];
    }
    return abs + pos.$2;
  }

  static int _totalAyahs() {
    int t = 0;
    for (int s = 1; s <= totalSurahs; s++) {
      t += QuranMetaData.ayahCount[s];
    }
    return t;
  }

  /// مقارنة موضعين: سالب إذا (s1,a1) قبل (s2,a2)
  static int _comparePos(int s1, int a1, int s2, int a2) {
    if (s1 != s2) return s1 - s2;
    return a1 - a2;
  }
}
