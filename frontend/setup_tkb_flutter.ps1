# =============================================================
#  TKB CNTT - Flutter FE folder structure setup script
#  Chay tu root du an Flutter: .\setup_tkb_flutter.ps1
# =============================================================

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "╔══════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║   TKB CNTT - Flutter FE Setup Script     ║" -ForegroundColor Cyan
Write-Host "║   Bach Khoa HN · 2026                    ║" -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# Kiem tra dang o dung thu muc Flutter chua
if (-Not (Test-Path "pubspec.yaml")) {
    Write-Host "⚠️  Khong tim thay pubspec.yaml." -ForegroundColor Yellow
    Write-Host "   Hay chay script nay tu root cua du an Flutter."
    exit 1
}

Write-Host "✓ Tim thay pubspec.yaml - bat dau tao cau truc..." -ForegroundColor Green
Write-Host ""

# -------------------------------------------------------------
# Ham tao file dart voi noi dung placeholder
# -------------------------------------------------------------
function New-DartFile {
    param([string]$RelPath, [string]$Comment = "TODO: implement")
    $full = "lib\$RelPath"
    $dir  = Split-Path $full -Parent
    if (-Not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }
    if (-Not (Test-Path $full)) {
        Set-Content -Path $full -Encoding UTF8 -Value "// $Comment`n// TODO: implement"
        Write-Host "  + $full" -ForegroundColor Green
    } else {
        Write-Host "  ~ $full (da ton tai, bo qua)" -ForegroundColor Yellow
    }
}

# -------------------------------------------------------------
# UI / CORE
# -------------------------------------------------------------
Write-Host "▸ ui/core" -ForegroundColor Blue
New-DartFile "ui\core\ui\shared_widgets.dart"   "AppBar, LoadingWidget, ErrorWidget dung chung"
New-DartFile "ui\core\themes\app_theme.dart"    "Mau sac, typography, spacing toan app"

# -------------------------------------------------------------
# UI / AUTH
# -------------------------------------------------------------
Write-Host "▸ ui/auth" -ForegroundColor Blue
New-DartFile "ui\auth\view_models\auth_view_model.dart"  "Quan ly trang thai dang nhap / dang xuat"
New-DartFile "ui\auth\widgets\login_screen.dart"         "Man hinh dang nhap email + password"

# -------------------------------------------------------------
# UI / TKB
# -------------------------------------------------------------
Write-Host "▸ ui/tkb" -ForegroundColor Blue
New-DartFile "ui\tkb\view_models\tkb_view_model.dart"   "Load lich, filter theo tuan/lop/GV/phong"
New-DartFile "ui\tkb\widgets\tkb_screen.dart"           "Man hinh xem thoi khoa bieu"
New-DartFile "ui\tkb\widgets\tkb_grid_widget.dart"      "Grid 7 ngay x 12 tiet"
New-DartFile "ui\tkb\widgets\tkb_cell_widget.dart"      "Widget mot o trong grid TKB"

# -------------------------------------------------------------
# UI / SCHEDULE (admin)
# -------------------------------------------------------------
Write-Host "▸ ui/schedule" -ForegroundColor Blue
New-DartFile "ui\schedule\view_models\schedule_view_model.dart"  "Xu ly tao/sua/xoa lich hoc"
New-DartFile "ui\schedule\widgets\schedule_form_screen.dart"     "Form xep lich cho admin"
New-DartFile "ui\schedule\widgets\conflict_error_widget.dart"    "Hien thi loi rang buoc chi tiet"

# -------------------------------------------------------------
# UI / TEACHING UNIT (admin)
# -------------------------------------------------------------
Write-Host "▸ ui/teaching_unit" -ForegroundColor Blue
New-DartFile "ui\teaching_unit\view_models\tu_view_model.dart"  "Quan ly Teaching Unit"
New-DartFile "ui\teaching_unit\widgets\tu_list_screen.dart"     "Danh sach Teaching Unit"
New-DartFile "ui\teaching_unit\widgets\tu_form_screen.dart"     "Form tao/sua Teaching Unit"

# -------------------------------------------------------------
# UI / MASTER DATA (admin)
# -------------------------------------------------------------
Write-Host "▸ ui/master" -ForegroundColor Blue
New-DartFile "ui\master\rooms\room_list_screen.dart"        "Danh sach phong hoc"
New-DartFile "ui\master\rooms\room_view_model.dart"         "CRUD phong hoc"
New-DartFile "ui\master\teachers\teacher_list_screen.dart"  "Danh sach giang vien"
New-DartFile "ui\master\teachers\teacher_view_model.dart"   "CRUD giang vien"
New-DartFile "ui\master\classes\class_list_screen.dart"     "Danh sach lop hoc"

# -------------------------------------------------------------
# UI / NOTIFICATION
# -------------------------------------------------------------
Write-Host "▸ ui/notification" -ForegroundColor Blue
New-DartFile "ui\notification\view_models\notification_view_model.dart"  "Inbox, danh dau da doc"
New-DartFile "ui\notification\widgets\notification_screen.dart"          "Man hinh inbox thong bao"
New-DartFile "ui\notification\widgets\notification_badge.dart"           "Badge so thong bao chua doc"

# -------------------------------------------------------------
# DOMAIN / MODELS
# -------------------------------------------------------------
Write-Host "▸ domain/models" -ForegroundColor Blue
New-DartFile "domain\models\schedule.dart"       "Model lich hoc"
New-DartFile "domain\models\teaching_unit.dart"  "Model Teaching Unit (single/merged/group)"
New-DartFile "domain\models\room.dart"           "Model phong hoc"
New-DartFile "domain\models\teacher.dart"        "Model giang vien"
New-DartFile "domain\models\class_group.dart"    "Model lop hoc"
New-DartFile "domain\models\subject.dart"        "Model mon hoc"
New-DartFile "domain\models\notification.dart"   "Model thong bao"

# -------------------------------------------------------------
# DATA / REPOSITORIES
# -------------------------------------------------------------
Write-Host "▸ data/repositories" -ForegroundColor Blue
New-DartFile "data\repositories\schedule_repository.dart"      "Goi API schedule, cache local"
New-DartFile "data\repositories\tkb_repository.dart"           "Goi API GET /schedules voi filter"
New-DartFile "data\repositories\notification_repository.dart"  "Goi API notification"

# -------------------------------------------------------------
# DATA / SERVICES
# -------------------------------------------------------------
Write-Host "▸ data/services" -ForegroundColor Blue
New-DartFile "data\services\api_service.dart"  "Dio setup, interceptors, tu dong gan Bearer token"
New-DartFile "data\services\fcm_service.dart"  "FCM foreground & background handler"

# -------------------------------------------------------------
# DATA / DTO
# -------------------------------------------------------------
Write-Host "▸ data/model (DTO)" -ForegroundColor Blue
New-DartFile "data\model\schedule_dto.dart"   "Parse JSON schedule tu API"
New-DartFile "data\model\api_response.dart"   "Wrapper { success, data, error, meta }"

# -------------------------------------------------------------
# CONFIG
# -------------------------------------------------------------
Write-Host "▸ config" -ForegroundColor Blue
New-DartFile "config\app_config.dart"        "Base URL, env flag (dev/staging/prod)"
New-DartFile "config\firebase_options.dart"  "Auto-generated boi FlutterFire CLI"

# -------------------------------------------------------------
# UTILS
# -------------------------------------------------------------
Write-Host "▸ utils" -ForegroundColor Blue
New-DartFile "utils\date_utils.dart"    "Tuan -> ngay, format ngay/gio tieng Viet"
New-DartFile "utils\period_utils.dart"  "Tiet -> gio bat dau/ket thuc"

# -------------------------------------------------------------
# ROUTING
# -------------------------------------------------------------
Write-Host "▸ routing" -ForegroundColor Blue
New-DartFile "routing\app_router.dart"  "go_router config, guard phan quyen theo role"

# -------------------------------------------------------------
# ENTRY POINTS
# -------------------------------------------------------------
Write-Host "▸ entry points" -ForegroundColor Blue
$entryTemplate = @"
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(body: Center(child: Text('TKB CNTT'))),
    );
  }
}
"@

foreach ($entry in @("main.dart", "main_development.dart", "main_staging.dart")) {
    $path = "lib\$entry"
    if (-Not (Test-Path $path)) {
        Set-Content -Path $path -Encoding UTF8 -Value $entryTemplate
        Write-Host "  + $path" -ForegroundColor Green
    } else {
        Write-Host "  ~ $path (da ton tai, bo qua)" -ForegroundColor Yellow
    }
}

# -------------------------------------------------------------
# Ket qua
# -------------------------------------------------------------
