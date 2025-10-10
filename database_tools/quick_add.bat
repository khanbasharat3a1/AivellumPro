@echo off
echo ========================================
echo Quick Add Prompts to Database
echo ========================================
echo.
echo Edit ai_add_prompts.py to add your prompts
echo Then run this script to update everything
echo.
pause

python ai_add_prompts.py

echo.
echo ========================================
echo Database updated!
echo ========================================
echo.
echo The Flutter app will now use the updated database.
echo Run 'flutter run' to test.
echo.
pause
