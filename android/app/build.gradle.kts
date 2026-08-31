import java.io.FileInputStream
import java.util.Properties

plugins {
    id("com.android.application")
    id("com.google.gms.google-services")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

// ------------------------------------------------------------
// Local properties
// ------------------------------------------------------------

val localProperties = Properties()
val localPropertiesFile = rootProject.file("local.properties")

if (localPropertiesFile.exists()) {
    FileInputStream(localPropertiesFile).use {
        localProperties.load(it)
    }
}

val youtubeApiKey =
    localProperties.getProperty("youtubeApiKey") ?: ""

// ------------------------------------------------------------
// Release signing properties
// ------------------------------------------------------------

val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()

if (keystorePropertiesFile.exists()) {
    FileInputStream(keystorePropertiesFile).use {
        keystoreProperties.load(it)
    }
}

android {
    namespace = "com.example.hisn_almuslim"
    compileSdk = 36

    ndkVersion = flutter.ndkVersion

    buildFeatures {
        buildConfig = true
    }

    defaultConfig {
        applicationId = "com.example.hisn_almuslim"
        minSdk = flutter.minSdkVersion
        targetSdk = 36
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        multiDexEnabled = true

        // YouTube API Key
        buildConfigField(
            "String",
            "YOUTUBE_API_KEY",
            "\"$youtubeApiKey\""
        )
    }

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = "1.8"
    }

    // ----------------------------------------------------------
    // Release signing
    // ----------------------------------------------------------

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String
            keyPassword = keystoreProperties["keyPassword"] as String
            storeFile = file(
                keystoreProperties["storeFile"] as String
            )
            storePassword = keystoreProperties["storePassword"] as String
        }
    }

    // ----------------------------------------------------------
    // Build types
    // ----------------------------------------------------------

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")

            isMinifyEnabled = true
            isShrinkResources = true

            proguardFiles(
                getDefaultProguardFile(
                    "proguard-android-optimize.txt"
                ),
                file("proguard-rules.pro")
            )
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation(
        platform(
            "com.google.firebase:firebase-bom:34.9.0"
        )
    )

    implementation(
        "androidx.multidex:multidex:2.0.1"
    )

    coreLibraryDesugaring(
        "com.android.tools:desugar_jdk_libs:2.1.4"
    )

    implementation(
        "androidx.window:window:1.0.0"
    )

    implementation(
        "androidx.window:window-java:1.0.0"
    )
}