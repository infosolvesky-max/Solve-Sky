// android/build.gradle.kts ফাইলের জন্য চূড়ান্ত এবং সহজ কোড

plugins {
    // আমরা ভার্সন নম্বর সরিয়ে দিচ্ছি, যাতে Flutter নিজে থেকে সঠিক ভার্সন বেছে নিতে পারে
    id("com.android.application") apply false
    id("org.jetbrains.kotlin.android") apply false
    id("dev.flutter.flutter-gradle-plugin") apply false
}

// এই অংশটি পুরোনো সিস্টেমের সাথে সামঞ্জস্যের জন্য জরুরি
allprojects {
    repositories {
        google()
        mavenCentral()
    }
}
