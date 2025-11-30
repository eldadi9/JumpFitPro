@echo off
chcp 65001 >nul

cd /d "C:\Users\Master_PC\Desktop\IPtv_projects\Projects Eldad\JumpFitPro\webapp_Main"
npm run build
npx wrangler d1 migrations apply rope-fitness-db --remote
npx wrangler pages deploy

pause
