import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

fun getKeystoreProperties(project: org.gradle.api.Project): java.util.Properties {
    val properties = Properties()
    val keystorePropertiesFile = project.rootProject.file("key.properties")
    if (keystorePropertiesFile.exists() && keystorePropertiesFile.isFile) {
        try {
            FileInputStream(keystorePropertiesFile).use { fis ->
                properties.load(fis)
            }
        } catch (e: java.io.IOException) {
            project.logger.warn("Could not load keystore properties file.")
        }
    }
    return properties
}

android {
    namespace = "dev.christhoval.apps.cosecha"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "dev.christhoval.apps.cosecha"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    val keystoreProperties = getKeystoreProperties(project)

    signingConfigs {
        create("release") {
            if (keystoreProperties.containsKey("storeFile")) {
                storeFile = file(keystoreProperties["storeFile"] as String)
                storePassword = keystoreProperties["storePassword"] as String
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
            } else {
                // Configuración de firma de depuración si no se encuentran las propiedades de release
                // Esto es opcional, Flutter suele manejar bien la firma de debug por defecto
                // storeFile = file(debugKeystore.absolutePath) // Ejemplo
                // storePassword = "android"
                // keyAlias = "androiddebugkey"
                // keyPassword = "android"
                project.logger.warn("Release signing config not found. Using debug or no signing.")
            }
        }
    }

    buildTypes {
        getByName("release") {
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("release")

            isMinifyEnabled = true // Flutter suele poner esto en true por defecto para release
            isShrinkResources = true // Reduce el tamaño del APK
            proguardFiles(getDefaultProguardFile("proguard-android.txt"), "proguard-rules.pro")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation("com.google.android.play:core:1.10.3")
}
