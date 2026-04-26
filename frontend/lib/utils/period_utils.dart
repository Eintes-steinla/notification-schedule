/// Tiện ích chuyển đổi tiết học ↔ giờ bắt đầu/kết thúc
/// Lịch tiết chuẩn Bách Khoa HN:
///   Sáng : tiết 1–6   (07:00 – 12:00)
///   Chiều: tiết 7–12  (12:30 – 17:30)
class PeriodUtils {
  PeriodUtils._();

  /// Map tiết → (giờ bắt đầu, giờ kết thúc)
  static const Map<int, ({String start, String end})> _periodTimes = {
    1: (start: '07:00', end: '07:45'),
    2: (start: '07:50', end: '08:35'),
    3: (start: '08:40', end: '09:25'),
    4: (start: '09:35', end: '10:20'),
    5: (start: '10:25', end: '11:10'),
    6: (start: '11:15', end: '12:00'),
    7: (start: '12:30', end: '13:15'),
    8: (start: '13:20', end: '14:05'),
    9: (start: '14:10', end: '14:55'),
    10: (start: '15:05', end: '15:50'),
    11: (start: '15:55', end: '16:40'),
    12: (start: '16:45', end: '17:30'),
  };

  /// Lấy giờ bắt đầu của tiết. Ví dụ: getStartTime(1) → "07:00"
  static String getStartTime(int period) {
    assert(period >= 1 && period <= 12, 'Tiết phải từ 1 đến 12');
    return _periodTimes[period]!.start;
  }

  /// Lấy giờ kết thúc của tiết. Ví dụ: getEndTime(3) → "09:25"
  static String getEndTime(int period) {
    assert(period >= 1 && period <= 12, 'Tiết phải từ 1 đến 12');
    return _periodTimes[period]!.end;
  }

  /// Lấy label hiển thị cho một khoảng tiết.
  /// Ví dụ: getRangeLabel(1, 3) → "07:00 – 09:25"
  static String getRangeLabel(int periodStart, int periodEnd) {
    return '${getStartTime(periodStart)} – ${getEndTime(periodEnd)}';
  }

  /// Label ngắn gọn cho tiết đơn. Ví dụ: getShortLabel(1) → "T1 · 07:00"
  static String getShortLabel(int period) {
    return 'T$period · ${getStartTime(period)}';
  }

  /// Kiểm tra 2 khoảng tiết có trùng nhau không
  static bool hasOverlap(int start1, int end1, int start2, int end2) {
    return start1 <= end2 && start2 <= end1;
  }

  /// Số tiết của một ca học
  static int periodCount(int periodStart, int periodEnd) {
    return periodEnd - periodStart + 1;
  }

  /// Tiết thuộc buổi sáng hay chiều
  static bool isMorning(int period) => period <= 6;
  static bool isAfternoon(int period) => period >= 7;

  /// Danh sách tất cả các tiết (dùng cho dropdown)
  static List<int> get allPeriods => List.generate(12, (i) => i + 1);
}
