@echo off
echo ========================================
echo AIVELLUM PRO - Update and Run
echo ========================================
echo.

echo [1/3] Installing Flutter dependencies...
call flutter pub get

echo.
echo [2/3] Checking database...
if exist "assets\data\prompts.db" (
    echo ✓ Database found
) else (
    echo ⚠ Database not found, running migration...
    cd database_tools
    python migrate_json_to_db.py
    cd ..
)

echo.
echo [3/3] Running Flutter app...
call flutter run

pause
