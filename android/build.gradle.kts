allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// `amberflutter` (plugin per il login via Amber, NIP-55) dichiara nel suo
// stesso build.gradle un compileSdkVersion 33 fisso, troppo basso per le
// androidx transitive (fragment/lifecycle/core) che richiedono almeno 34.
// Non possiamo modificare il plugin (vive in pub-cache), quindi forziamo
// qui il compileSdk di tutti i moduli Android allo stesso valore usato
// dall'app (flutter.compileSdkVersion).
subprojects {
    afterEvaluate {
        extensions.findByType(com.android.build.gradle.BaseExtension::class.java)?.let {
            it.compileSdkVersion(36)
        }
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
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
