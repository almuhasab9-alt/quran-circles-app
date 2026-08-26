# worker-auth — quran-auth-api

مصدر Worker المصادقة (تسجيل الدخول، الحسابات، لقطة البيانات).

## ملاحظة أمنية
- `HMAC_SECRET` مذكور هنا كنص فقط لأغراض التوثيق/الاسترجاع.
- في الإنتاج يُقرأ من Secret (تعيين عبر: `wrangler secret put HMAC_SECRET`).
- الكود يستخدم fallback إلى القيمة المضمنة إذا لم يوجد الـ Secret — لا تغيّر
  القيمة إلا مع تغييرها في كلٍ من: هذا الملف، quran-auth-api، quran-circles-api،
  وأسرار Cloudflare لكلا الـ Worker (وإلا ستُرفض كل التوكنات القائمة).
