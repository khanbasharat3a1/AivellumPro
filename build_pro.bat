@echo off
echo Building Aivellum Pro...
echo.

echo Cleaning previous builds...
flutter clean

echo Getting dependencies...
flutter pub get

echo Building APK...
flutter build apk --release

echo Building App Bundle...
flutter build appbundle --release

echo.
echo Build complete!
echo APK: build\app\outputs\flutter-apk\app-release.apk
echo Bundle: build\app\outputs\bundle\release\app-release.aab
echo.
pause