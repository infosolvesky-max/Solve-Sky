// android/build.gradle.kts ফাইলের জন্য চূড়ান্ত এবং নির্ভুল কোড

plugins {
    // Codemagic-এর ত্রুটি অনুযায়ী, নিশ্চিতভাবে 8.0.1 ব্যবহার করা হলো
    id("com.android.application") version "8.0.1" apply false 
    
    // সামঞ্জস্যপূর্ণ কোটলিন সংস্করণ
    id("org.jetbrains.kotlin.android") version "1.9.22" apply false
    
    // Flutter প্লাগইনের সংস্করণ
    id("dev.flutter.flutter-gradle-plugin") version "1.0.0" apply false
}
