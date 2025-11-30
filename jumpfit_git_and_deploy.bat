@echo off
setlocal

rem Change to project folder
cd /d "C:\Users\Master_PC\Desktop\IPtv_projects\Projects Eldad\JumpFitPro\webapp_Main" || goto cd_error

echo ============================
echo Step 1: git pull from origin/main
echo ============================
git pull origin main
IF ERRORLEVEL 1 (
    echo git pull failed. Fix git issues and try again.
    pause
    goto end
)

echo.
echo ============================
echo Choose action:
echo [1] Local dev (npm run dev)
echo [2] Deploy to Cloudflare Pages
echo ============================
set /p choice=Type 1 or 2 and press Enter: 

if "%choice%"=="1" goto dev
if "%choice%"=="2" goto deploy

echo Invalid choice.
pause
goto end

:dev
echo.
echo Running local dev: npm run dev
echo Press Ctrl+C to stop the dev server.
call npm run dev
goto end


:deploy
echo.
echo Step 2: build
call npm run build
IF ERRORLEVEL 1 (
    echo build failed.
    pause
    goto end
)

echo.
echo Step 3: D1 migrations (remote)
call npx wrangler d1 migrations apply rope-fitness-db --remote
IF ERRORLEVEL 1 (
    echo D1 migrations failed.
    pause
    goto end
)

echo.
echo Step 4: deploy to Cloudflare Pages
call npx wrangler pages deploy --commit-message "manual deploy" --commit-dirty=true
IF ERRORLEVEL 1 (
    echo deploy failed.
    pause
    goto end
)

echo.
echo Done. Deploy finished successfully.
pause
goto end

:cd_error
echo Failed to change directory to project folder.
pause

:end
endlocal
