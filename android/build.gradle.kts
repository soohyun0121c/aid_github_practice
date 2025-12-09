allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
    
    // Fix flutter_tts, permission_handler, vibration and other plugins SDK version issue
    afterEvaluate {
        if (plugins.hasPlugin("com.android.library")) {
            extensions.configure<com.android.build.gradle.LibraryExtension> {
                compileSdk = 36
                defaultConfig {
                    minSdk = 21
                    targetSdk = 36
                }
            }
        }
        
        // Explicitly handle vibration plugin Java compatibility
        if (project.name.contains("vibration")) {
            tasks.withType<JavaCompile> {
                sourceCompatibility = JavaVersion.VERSION_11.toString()
                targetCompatibility = JavaVersion.VERSION_11.toString()
            }
        }
    }
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
