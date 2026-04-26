enum AppEnv { development, staging, production }

class AppConfig {
  AppConfig._();

  // ── Đổi biến này khi build ──────────────────────────────
  static const AppEnv _env = AppEnv.development;
  // ─────────────────────────────────────────────────────────

  static AppEnv get env => _env;

  static bool get isDev => _env == AppEnv.development;
  static bool get isStaging => _env == AppEnv.staging;
  static bool get isProd => _env == AppEnv.production;

  static String get baseUrl {
    switch (_env) {
      case AppEnv.development:
        return 'http://10.0.2.2:3000/api/v1'; // Android emulator → localhost
      case AppEnv.staging:
        return 'https://tkb-api-staging.up.railway.app/api/v1';
      case AppEnv.production:
        return 'https://tkb-api.up.railway.app/api/v1';
    }
  }

  // Timeout cho Dio (milliseconds)
  static const int connectTimeout = 10000;
  static const int receiveTimeout = 15000;

  // Số tiết học trong ngày
  static const int totalPeriods = 12;

  // Số ngày trong tuần (Thứ 2 → Thứ 7)
  static const int firstDayOfWeek = 2; // 2 = Thứ 2
  static const int lastDayOfWeek = 7; // 7 = Thứ 7

  // Ngày bắt đầu năm học (dùng để tính số tuần)
  // TODO: Cập nhật mỗi năm học hoặc lấy từ API
  static final DateTime semesterStartDate = DateTime(2025, 9, 1);
}
