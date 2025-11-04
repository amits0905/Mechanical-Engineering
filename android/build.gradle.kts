// Top-level build file for common project configuration

buildscript {
    val kotlinVersion = "1.9.22"

    repositories {
        google()
        mavenCentral()
    }

    dependencies {
        // Android Gradle plugin
        classpath("com.android.tools.build:gradle:8.1.4")
        // Kotlin Gradle plugin (required by Flutter)
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlinVersion")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// ✅ Correct type for Kotlin DSL (File instead of String)
rootProject.buildDir = File(rootProject.projectDir, "../build")

subprojects {
    project.buildDir = File("${rootProject.buildDir}/${project.name}")
    project.evaluationDependsOn(":app")
}

// ✅ Clean task
tasks.register("clean", Delete::class) {
    delete(rootProject.buildDir)
}

// ✅ Force Java 17 toolchain for all Kotlin compile tasks
gradle.projectsEvaluated {
    tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile>().configureEach {
        kotlinOptions {
            jvmTarget = "17"
            freeCompilerArgs += listOf("-Xlint:-options", "-Xlint:deprecation")
        }
    }
}

// ✅ Force Java 17 for all Java compile tasks
tasks.withType<JavaCompile>().configureEach {
    sourceCompatibility = JavaVersion.VERSION_17.toString()
    targetCompatibility = JavaVersion.VERSION_17.toString()
    options.compilerArgs.addAll(listOf("-Xlint:-options", "-Xlint:deprecation"))
}
