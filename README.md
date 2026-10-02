# Madrasati - application éducative primaire (ar/fr/en)

## Option A : APK sans rien installer (GitHub Actions)
1. Créer un dépôt GitHub et y pousser ce dossier.
2. Onglet "Actions" > "Build APK" > attendre ~5 min.
3. Télécharger l'artefact "madrasati-apk" (contient app-release.apk).

## Option B : en local (Flutter installé)
    flutter create --platforms=android --project-name madrasati .
    flutter pub get
    flutter build apk --release
APK : build/app/outputs/flutter-apk/app-release.apk

Note : ajouter <uses-permission android:name="android.permission.INTERNET"/>
dans android/app/src/main/AndroidManifest.xml (polices et API).
