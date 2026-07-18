import java.io.FileInputStream
import java.util.Properties

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Release signing identity, loaded from android/key.properties (never
// committed — see .gitignore) pointing at the release keystore kept outside
// the repository. Releases up to v0.4.1 were signed with the machine's
// *debug* keystore (a Flutter-template leftover); the identity migrated to a
// dedicated release key on 2026-07-18 — installs of v0.4.1 and older cannot
// upgrade in place across that boundary and must be reinstalled once.
val keystoreProperties = Properties().apply {
    val f = rootProject.file("key.properties")
    if (f.exists()) load(FileInputStream(f))
}

android {
    namespace = "com.echoes.echoes"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.echoes.echoes"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            // Fail loudly when the keystore isn't configured instead of
            // silently falling back to the debug key — that silent fallback
            // is exactly how every release up to v0.4.1 ended up signed
            // with a debug certificate in the first place.
            val storeFilePath = keystoreProperties.getProperty("storeFile")
                ?: throw GradleException(
                    "android/key.properties is missing — release builds must be signed with the release keystore.",
                )
            storeFile = file(storeFilePath)
            storePassword = keystoreProperties.getProperty("storePassword")
            keyAlias = keystoreProperties.getProperty("keyAlias")
            keyPassword = keystoreProperties.getProperty("keyPassword")
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
    }

    // Per-ABI split release APKs (app-armeabi-v7a-release.apk,
    // app-arm64-v8a-release.apk) alongside the universal one, instead of a
    // single "fat" APK carrying every ABI's native libraries — smaller
    // downloads for direct/sideloaded distribution (e.g. GitHub releases).
    // x86_64 deliberately left out: it only matters for emulators/rare
    // x86 tablets, not real phones.
    splits {
        abi {
            isEnable = true
            reset()
            include("armeabi-v7a", "arm64-v8a")
            isUniversalApk = true
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
