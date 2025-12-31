@echo off
setlocal
chcp 65001 >nul
color 0B

rem ============================================
rem JumpFitPro - Setup Local Environment
rem ============================================

cd /d "C:\Users\Master_PC\Desktop\IPtv_projects\Projects Eldad\JumpFitPro_V1" || goto cd_error

echo.
echo ╔══════════════════════════════════════════════════════════╗
echo ║  JumpFitPro - הכנת סביבה מקומית                         ║
echo ╚══════════════════════════════════════════════════════════╝
echo.

echo שלב 1: התקנת תלויות...
call npm install
IF ERRORLEVEL 1 (
    echo ❌ התקנת תלויות נכשלה!
    pause
    goto end
)
echo ✅ תלויות הותקנו בהצלחה!
echo.

echo שלב 2: Build הפרויקט...
call npm run build
IF ERRORLEVEL 1 (
    echo ❌ Build נכשל!
    pause
    goto end
)
echo ✅ Build הושלם בהצלחה!
echo.

echo שלב 3: Migrate DB מקומי...
call npm run db:migrate:local
IF ERRORLEVEL 1 (
    echo ⚠️  Migrate DB נכשל (אולי כבר רץ). ממשיכים...
)
echo ✅ DB migrations הושלמו!
echo.

echo שלב 4: יצירת משתמש אדמין...
echo.
echo האם אתה רוצה ליצור משתמש אדמין? (y/n)
set /p create_admin=הזן y/n: 
if /i "%create_admin%"=="y" (
    echo.
    echo יוצר משתמש אדמין...
    call npx wrangler d1 execute rope-fitness-db --local --file=create_admin.sql
    IF ERRORLEVEL 1 (
        echo ⚠️  יצירת אדמין נכשלה (אולי כבר קיים). ממשיכים...
    ) else (
        echo ✅ משתמש אדמין נוצר בהצלחה!
        echo.
        echo ═══════════════════════════════════════════════════════════
        echo   פרטי התחברות:
        echo   מייל: eldadi9@gmail.com
        echo   סיסמה: eldad123
        echo ═══════════════════════════════════════════════════════════
    )
)

echo.
echo ═══════════════════════════════════════════════════════════
echo   ✅ הכנת הסביבה המקומית הושלמה!
echo.
echo   כעת תוכל להריץ:
echo   1. jumpfit_git_and_deploy.bat - בחר אופציה 1 (מקומי)
echo   2. או: npm run dev
echo.
echo   השרת יעלה על: http://localhost:5173/
echo ═══════════════════════════════════════════════════════════
echo.
pause
goto end

:cd_error
echo.
echo ❌ שגיאה: לא הצלחתי להיכנס לתיקיית הפרויקט.
pause

:end
endlocal

