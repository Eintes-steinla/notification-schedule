# TKB CNTT - Node.js BE Setup Script
# Chay tu root du an BE: .\setup_tkb_backend.ps1

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "   TKB CNTT - Node.js BE Setup Script"     -ForegroundColor Cyan
Write-Host "   Bach Khoa HN 2026"                      -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

if (-Not (Test-Path "package.json")) {
    Write-Host "Khong tim thay package.json." -ForegroundColor Yellow
    Write-Host "Khoi tao npm truoc: npm init -y" -ForegroundColor Yellow
    exit 1
}

Write-Host "Tim thay package.json - bat dau tao cau truc..." -ForegroundColor Green
Write-Host ""

function New-JsFile {
    param([string]$RelPath, [string]$Comment)
    $full = Join-Path "src" $RelPath
    $dir  = Split-Path $full -Parent
    if (-Not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }
    if (-Not (Test-Path $full)) {
        Set-Content -Path $full -Encoding UTF8 -Value "// $Comment"
        Write-Host "  + $full" -ForegroundColor Green
    } else {
        Write-Host "  ~ $full (da ton tai, bo qua)" -ForegroundColor Yellow
    }
}

function New-EmptyDir {
    param([string]$RelPath)
    $full = Join-Path "src" $RelPath
    if (-Not (Test-Path $full)) {
        New-Item -ItemType Directory -Path $full -Force | Out-Null
        Set-Content -Path (Join-Path $full ".gitkeep") -Value ""
        Write-Host "  + $full\" -ForegroundColor Green
    } else {
        Write-Host "  ~ $full\ (da ton tai, bo qua)" -ForegroundColor Yellow
    }
}

function New-RootFile {
    param([string]$FileName, [string]$Content)
    if (-Not (Test-Path $FileName)) {
        Set-Content -Path $FileName -Encoding UTF8 -Value $Content
        Write-Host "  + $FileName" -ForegroundColor Green
    } else {
        Write-Host "  ~ $FileName (da ton tai, bo qua)" -ForegroundColor Yellow
    }
}

# config
Write-Host "config" -ForegroundColor Blue
New-JsFile "config\db.js"       "PostgreSQL connection pool (pg)"
New-JsFile "config\firebase.js" "Firebase Admin SDK init"

# middleware
Write-Host "middleware" -ForegroundColor Blue
New-JsFile "middleware\auth.js"      "Verify Firebase ID Token, gan req.user"
New-JsFile "middleware\roleGuard.js" "Kiem tra role: requireAdmin, requireTeacher"
New-JsFile "middleware\validate.js"  "Zod validation wrapper cho request body"

# modules/auth
Write-Host "modules/auth" -ForegroundColor Blue
New-JsFile "modules\auth\auth.routes.js"     "POST /register, GET /me, PATCH /fcm-token"
New-JsFile "modules\auth\auth.controller.js" "Handler cho cac route auth"

# modules/schedule
Write-Host "modules/schedule" -ForegroundColor Blue
New-JsFile "modules\schedule\schedule.routes.js"     "GET POST PATCH DELETE /schedules"
New-JsFile "modules\schedule\schedule.controller.js" "Handler: getSchedules, createSchedule, updateSchedule, deleteSchedule"
New-JsFile "modules\schedule\schedule.service.js"    "Logic truy van DB, goi constraint service"

# modules/constraint
Write-Host "modules/constraint" -ForegroundColor Blue
New-JsFile "modules\constraint\constraint.service.js" "7 rang buoc cung khi xep lich"

# modules/teaching-unit
Write-Host "modules/teaching-unit" -ForegroundColor Blue
New-JsFile "modules\teaching-unit\tu.routes.js"     "GET POST DELETE /teaching-units"
New-JsFile "modules\teaching-unit\tu.controller.js" "Handler cho teaching unit"
New-JsFile "modules\teaching-unit\tu.service.js"    "Logic CRUD teaching unit"

# modules/master
Write-Host "modules/master" -ForegroundColor Blue
New-JsFile "modules\master\room\room.routes.js"           "GET POST PATCH DELETE /rooms"
New-JsFile "modules\master\room\room.controller.js"       "Handler cho rooms"
New-JsFile "modules\master\teacher\teacher.routes.js"     "GET POST PATCH /teachers"
New-JsFile "modules\master\teacher\teacher.controller.js" "Handler cho teachers"
New-JsFile "modules\master\class\class.routes.js"         "GET POST /classes"
New-JsFile "modules\master\class\class.controller.js"     "Handler cho classes"
New-JsFile "modules\master\subject\subject.routes.js"     "GET POST /subjects"
New-JsFile "modules\master\subject\subject.controller.js" "Handler cho subjects"
New-JsFile "modules\master\major\major.routes.js"         "GET POST /majors"
New-JsFile "modules\master\major\major.controller.js"     "Handler cho majors"
New-JsFile "modules\master\location\location.routes.js"   "GET /locations"
New-JsFile "modules\master\location\location.controller.js" "Handler cho locations"

# modules/notification
Write-Host "modules/notification" -ForegroundColor Blue
New-JsFile "modules\notification\notification.routes.js"     "GET /notifications, PATCH read, PATCH read-all"
New-JsFile "modules\notification\notification.controller.js" "Handler cho notifications"
New-JsFile "modules\notification\fcm.service.js"             "Gui FCM message qua Firebase Admin SDK"

# jobs
Write-Host "jobs" -ForegroundColor Blue
New-JsFile "jobs\daily-schedule.job.js" "Cron 22:00 hang ngay: gui FCM lich ngay mai"
New-JsFile "jobs\upcoming-class.job.js" "Cron moi 5 phut: nhac tiet hoc truoc 30-60 phut"

# db
Write-Host "db" -ForegroundColor Blue
New-EmptyDir "db\migrations"
New-EmptyDir "db\seeds"

# entry
Write-Host "entry" -ForegroundColor Blue
New-JsFile "app.js" "Khoi tao Express app, mount routes, error handler"
New-RootFile "server.js" "// Khoi dong server: import app, lang nghe port"

# .env.example
$envContent = "# Server`nPORT=3000`nNODE_ENV=development`n`n# PostgreSQL (Supabase)`nDATABASE_URL=postgresql://postgres:[password]@db.[project].supabase.co:5432/postgres`n`n# Firebase Admin SDK`nFIREBASE_PROJECT_ID=your-project-id`nFIREBASE_CLIENT_EMAIL=firebase-adminsdk-xxx@your-project.iam.gserviceaccount.com`nFIREBASE_PRIVATE_KEY=your-private-key"
New-RootFile ".env.example" $envContent

# .gitignore
$gitignoreContent = "node_modules/`n.env`n*.log`ndist/"
New-RootFile ".gitignore" $gitignoreContent

Write-Host ""
Write-Host "==========================================" -ForegroundColor Green
Write-Host "   Tao cau truc thu muc hoan tat!"         -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Buoc tiep theo:" -ForegroundColor Cyan
Write-Host ""
Write-Host "  1. Them vao package.json:"
Write-Host "       type: module"
Write-Host ""
Write-Host "  2. Cai dependencies:"
Write-Host "       npm install express pg firebase-admin zod node-cron helmet morgan winston dotenv"
Write-Host "       npm install --save-dev nodemon"
Write-Host ""
Write-Host "  3. Them scripts vao package.json:"
Write-Host "       dev: nodemon server.js"
Write-Host "       start: node server.js"
Write-Host ""
Write-Host "  4. Copy file .env va dien thong tin:"
Write-Host "       copy .env.example .env"
Write-Host ""