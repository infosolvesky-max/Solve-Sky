// android/app/build.gradle.kts ফাইলের জন্য চূড়ান্ত এবং সহজ কোড

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.solvesky_app"
    // আমরা ভার্সন নম্বর Flutter-এর উপর ছেড়ে দিচ্ছি
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = "1.8"
    }

    defaultConfig {
        applicationId = "com.example.solvesky_app"
        // আমরা minSdk Flutter-এর উপর ছেড়ে দিচ্ছি, এটিই নিরাপদ
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
