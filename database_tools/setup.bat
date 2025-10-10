@echo off
echo ========================================
echo AIVELLUM PRO - Database Setup
echo ========================================
echo.

echo Checking Python installation...
python --version
if errorlevel 1 (
    echo ERROR: Python not found! Please install Python 3.x
    pause
    exit /b 1
)

echo.
echo Migrating JSON to SQLite database...
python migrate_json_to_db.py

echo.
echo ========================================
echo Setup Complete!
echo ========================================
echo.
echo Next steps:
echo 1. Run 'python cli.py' to manage database
echo 2. Run 'flutter pub get' in main directory
echo 3. Run 'flutter run' to test the app
echo.
pause
