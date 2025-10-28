// ফাইল: android/build.gradle.kts

buildscript {
    // এখানে অ্যান্ড্রয়েড প্রোজেক্টের জন্য প্রয়োজনীয় ভ্যারিয়েবলগুলো define করা হলো
    val kotlinVersion by extra("1.8.22") // আপনার প্রোজেক্টের জন্য একটি উপযুক্ত ভার্সন

    repositories {
        // এই অংশটি Gradle-কে বলে যে তার নিজের টুলসগুলো কোথা থেকে ডাউনলোড করতে হবে
        google()
        mavenCentral()
    }

    dependencies {
        // এখানে Gradle-এর জন্য প্রয়োজনীয় টুলসগুলো উল্লেখ করা হলো
        classpath("com.android.tools.build:gradle:7.3.0")
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlinVersion")
    }
}

// এই অংশটি আপনার প্রোজেক্টের সমস্ত মডিউলকে বলে যে লাইব্রেরিগুলো কোথা থেকে ডাউনলোড করতে হবে
allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// আপনার পুরোনো বিল্ড ডিরেক্টরি সেটিংস অপরিবর্তিত রাখা হলো
val newBuildDir: org.gradle.api.file.Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.set(newBuildDir)

subprojects {
    val newSubprojectBuildDir: org.gradle.api.file.Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.set(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
