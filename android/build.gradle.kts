// android/build.gradle.kts ফাইলের জন্য চূড়ান্ত এবং নির্ভুল কোড

plugins {
    // Codemagic-এর বিল্ড পরিবেশের সাথে মিলিয়ে সংস্করণ 8.0.1 করা হলো
    id("com.android.application") version "8.0.1" apply false
    
    // সামঞ্জস্যপূর্ণ কোটলিন সংস্করণ যোগ করা হলো
    id("org.jetbrains.kotlin.android") version "1.9.22" apply false
    
    // Flutter প্লাগইনের সংস্করণ নির্দিষ্ট করা হলো
    id("dev.flutter.flutter-gradle-plugin") version "1.0.0" apply false
}
