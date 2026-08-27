# Flutter wrapper code — keep all Flutter engine classes intact
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# تجنب تحذيرات المكتبات
-dontwarn java.lang.invoke.*
-dontwarn javax.annotation.**

# فئات Play Core الاختيارية (المكونات المؤجلة) — غير مستخدمة في هذا التطبيق
-dontwarn com.google.android.play.core.**
