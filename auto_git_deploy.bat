@echo off
setlocal

rem קובץ: auto_git_deploy.bat
rem פעולה: git add + commit + push + deploy ל Cloudflare

cd /d "C:\Users\Master_PC\Desktop\IPtv_projects\Projects Eldad\JumpFitPro\webapp_Main" || goto cd_error

echo.
echo ============================
echo שלב 1 - עדכון Git (add, commit, push)
echo ============================
echo.

rem אם תרצה לתת הודעת קומיט מהשורה, אפשר להעביר טקסט אחרי שם ה bat
set MSG=%*
if "%MSG%"=="" set MSG=Auto update %DATE% %TIME%

git add .
git commit -m "%MSG%"
if errorlevel 1 (
    echo אין שינויים לקומיט או שהקומיט נכשל. ממשיכים הלאה...
)

git push origin main
if errorlevel 1 goto git_push_error

echo.
echo ============================
echo שלב 2 - מיגרציית D1 ב Cloudflare
echo ============================
echo.

npm run db:migrate:prod
if errorlevel 1 goto error

echo.
echo ============================
echo שלב 3 - דיפלוי ל Cloudflare Pages
echo ============================
echo.

npm run deploy:prod
if errorlevel 1 goto error

echo.
echo הכל בוצע בהצלחה. Git עודכן והאתר הועלה ל Cloudflare.
pause
goto end

:cd_error
echo לא הצלחתי להיכנס לתיקיית הפרויקט.
pause
goto end

:git_push_error
echo git push נכשל. בדוק אינטרנט או הרשאות ל GitHub.
pause
goto end

:error
echo היתה שגיאה באחת הפקודות. ראה למעלה.
pause

:end
endlocal
