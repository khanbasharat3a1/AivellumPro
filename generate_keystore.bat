@echo off
echo Creating Android Keystore for Aivellum Pro...
echo.
echo Please provide the following information:
echo.

set /p KEY_ALIAS="Enter key alias (e.g., aivellumpro): "
set /p STORE_PASSWORD="Enter keystore password: "
set /p KEY_PASSWORD="Enter key password: "
set /p VALIDITY="Enter validity in years (e.g., 25): "

echo.
echo Generating keystore...

keytool -genkey -v -keystore aivellumpro-release-key.jks -keyalg RSA -keysize 2048 -validity %VALIDITY%000 -alias %KEY_ALIAS%

echo.
echo Creating key.properties file...

echo storePassword=%STORE_PASSWORD% > android\key.properties
echo keyPassword=%KEY_PASSWORD% >> android\key.properties
echo keyAlias=%KEY_ALIAS% >> android\key.properties
echo storeFile=../aivellumpro-release-key.jks >> android\key.properties

echo.
echo Keystore generated successfully!
echo File: aivellumpro-release-key.jks
echo Properties: android\key.properties
echo.
echo IMPORTANT: Keep these files secure and backed up!
pause