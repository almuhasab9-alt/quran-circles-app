plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.quran.center.quran_center"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    // ضغط المكتبات الأصلية (.so) داخل الـ APK لتقليل حجم التنزيل
    packaging {
        jniLibs {
            useLegacyPackaging = true
        }
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.quran.center.quran_center"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // توقيع الإصدار: يُقرأ من متغيرات البيئة (أسرار CI) — لا تُكتب المفاتيح في المستودع.
    // بدون المتغيرات (بناء محلي) يُستخدم مفتاح التصحيح تلقائياً.
    val keystorePath = System.getenv("QC_KEYSTORE_PATH")
    if (!keystorePath.isNullOrEmpty()) {
        signingConfigs {
            create("release") {
                storeFile = file(keystorePath)
                storePassword = System.getenv("QC_KEYSTORE_PASSWORD")
                keyAlias = System.getenv("QC_KEY_ALIAS")
                // في PKCS12 يجب أن تتطابق كلمة مرور المفتاح مع كلمة مرور المخزن
                keyPassword = System.getenv("QC_KEYSTORE_PASSWORD")
            }
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.findByName("release")
                ?: signingConfigs.getByName("debug")
            // تصغير الحجم: تقليص الكود (R8) والموارد غير المستخدمة
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro",
            )
        }
    }
}

flutter {
    source = "../.."
}
