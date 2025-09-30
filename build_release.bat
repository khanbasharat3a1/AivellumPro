@echo off
echo Building Aivellum Pro Release APK...
echo.

echo Cleaning project...
flutter clean

echo Getting dependencies...
flutter pub get

echo Building release APK...
flutter build apk --release

echo.
echo Building App Bundle for Play Store...
flutter build appbundle --release

echo.
echo Build completed!
echo APK: build\app\outputs\flutter-apk\app-release.apk
echo AAB: build\app\outputs\bundle\release\app-release.aab
echo.
echo Upload the AAB file to Google Play Console
pause