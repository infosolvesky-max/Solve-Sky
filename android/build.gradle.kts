// android/build.gradle.kts ফাইলের জন্য চূড়ান্ত এবং ডিফল্ট কোড

plugins {
    id("com.android.application") version "8.0.1" apply false
    id("org.jetbrains.kotlin.android") version "1.8.22" apply false
    id("dev.flutter.flutter-gradle-plugin") version "1.0.0" apply false
}

subprojects {
    project.pluginManager.withPlugin("com.android.application") {
        android {
            // ...
        }
    }
    project.pluginManager.withPlugin("com.android.library") {
        android {
            // ...
        }
    }
}
