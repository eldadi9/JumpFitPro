
@echo off
chcp 65001 >nul

cd /d "C:\Users\Master_PC\Desktop\IPtv_projects\Projects Eldad\JumpFitPro\webapp_Main"
npm run build
IF ERRORLEVEL 1 (
    echo שגיאה בשלב build
    pause
    exit /b 1
)

npx wrangler d1 migrations apply rope-fitness-db --remote
IF ERRORLEVEL 1 (
    echo שגיאה במיגרציית D1
    pause
    exit /b 1
)

npx wrangler pages deploy
IF ERRORLEVEL 1 (
    echo שגיאה בדיפלוי ל־Cloudflare Pages
    pause
    exit /b 1
)

echo.
echo 🎉 הכל הושלם בהצלחה!
pause
