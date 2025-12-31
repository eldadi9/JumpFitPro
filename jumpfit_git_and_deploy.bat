@echo off
setlocal
chcp 65001 >nul
color 0A

rem ============================================
rem JumpFitPro - Manager Script
rem ============================================

rem Change to project folder
cd /d "C:\Users\Master_PC\Desktop\IPtv_projects\Projects Eldad\JumpFitPro_V1" || goto cd_error

:menu
cls
echo.
echo ╔══════════════════════════════════════════════════════════╗
echo ║         JumpFitPro - Manager Script                      ║
echo ╚══════════════════════════════════════════════════════════╝
echo.
echo Choose an option:
echo.
echo [1] Local - Run local development server
echo     - Build the project
echo     - Migrate local DB
echo     - Start dev server (localhost:3000)
echo.
echo [2] Git - Push to GitHub
echo     - Git add + commit
echo     - Push to https://github.com/eldadi9/JumpFitPro.git
echo.
echo [3] Cloudflare - Deploy to production
echo     - Build the project
echo     - Migrate production DB
echo     - Deploy to Cloudflare Pages
echo.
echo [0] Exit
echo.
set /p choice=Enter number (1/2/3/0):

if "%choice%"=="1" goto local
if "%choice%"=="2" goto git
if "%choice%"=="3" goto cloudflare
if "%choice%"=="0" goto end
echo.
echo Invalid choice! Please try again.
timeout /t 2 >nul
goto menu

:local
cls
echo.
echo ╔══════════════════════════════════════════════════════════╗
echo ║  Option 1: Run Local Development Server                  ║
echo ╚══════════════════════════════════════════════════════════╝
echo.

echo Step 1: Building the project...
call npm run build
IF ERRORLEVEL 1 (
    echo.
    echo Build failed!
    echo.
    pause
    goto menu
)

echo.
echo Build completed successfully!
echo.

echo Step 2: Migrating local DB...
call npm run db:migrate:local
IF ERRORLEVEL 1 (
    echo.
    echo DB migration failed (maybe already ran). Continuing...
)

echo.
echo Step 3: Starting dev server with Wrangler...
echo.
echo ===============================================
echo   Server will run on: http://localhost:3000/
echo   Press Ctrl+C to stop the server
echo ===============================================
echo.
call npm run dev:sandbox
IF ERRORLEVEL 1 (
    echo.
    echo Dev server failed to start!
    echo.
    pause
    goto menu
)
pause
goto menu

:git
cls
echo.
echo ╔══════════════════════════════════════════════════════════╗
echo ║  Option 2: Push to GitHub                                ║
echo ╚══════════════════════════════════════════════════════════╝
echo.

echo Step 0: Ensuring correct remote...
for /f "delims=" %%A in ('git config --get remote.origin.url 2^>nul') do set "CUR_REMOTE=%%A"
if not "%CUR_REMOTE%"=="https://github.com/eldadi9/JumpFitPro.git" (
    echo Updating origin remote to JumpFitPro.git
    git remote set-url origin https://github.com/eldadi9/JumpFitPro.git
)
echo Current remotes:
git remote -v
echo.

echo Step 1: Checking Git status...
git status
echo.

echo Step 2: Adding files to Git...
git add .
IF ERRORLEVEL 1 (
    echo.
    echo Git add failed!
    pause
    goto menu
)
echo Files added to staging

echo.
echo Step 3: Committing changes...
set /p commit_msg=Enter commit message (or press Enter for default):
if "%commit_msg%"=="" set commit_msg=Auto update %DATE% %TIME%

git commit -m "%commit_msg%"
IF ERRORLEVEL 1 (
    echo.
    echo No changes to commit or commit failed. Continuing...
)

echo.
echo Step 4: Pushing to GitHub...
echo Repository: https://github.com/eldadi9/JumpFitPro.git
git push origin main
IF ERRORLEVEL 1 (
    echo.
    echo Git push failed!
    echo Check your internet connection or GitHub permissions.
    pause
    goto menu
)

echo.
echo Successfully pushed to GitHub!
echo.
pause
goto menu

:cloudflare
cls
echo.
echo ╔══════════════════════════════════════════════════════════╗
echo ║  Option 3: Deploy to Cloudflare                          ║
echo ╚══════════════════════════════════════════════════════════╝
echo.

echo This will deploy to production!
set /p confirm=Are you sure? (y/n):
if /i not "%confirm%"=="y" (
    echo Cancelled.
    timeout /t 2 >nul
    goto menu
)

echo.
echo Step 1: Building the project...
call npm run build
IF ERRORLEVEL 1 (
    echo.
    echo Build failed!
    pause
    goto menu
)
echo Build completed successfully!

echo.
echo Step 2: Migrating production DB (remote)...
call npm run db:migrate:prod
IF ERRORLEVEL 1 (
    echo.
    echo DB migration failed. Continuing with deploy...
)

echo.
echo Step 3: Deploying to Cloudflare Pages...
call npm run deploy:prod
IF ERRORLEVEL 1 (
    echo.
    echo Deploy failed!
    pause
    goto menu
)

echo.
echo Successfully deployed to Cloudflare!
echo.
pause
goto menu

:cd_error
echo.
echo Error: Could not change to project directory.
echo Check that the path is correct:
echo C:\Users\Master_PC\Desktop\IPtv_projects\Projects Eldad\JumpFitPro_V1
pause
goto end

:end
cls
echo.
echo Thank you for using JumpFitPro Manager!
echo.
timeout /t 2 >nul
endlocal
