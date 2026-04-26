import 'package:intl/intl.dart';
import '../config/app_config.dart';

/// Tiện ích xử lý ngày tháng cho TKB
/// Tuần học được tính từ [AppConfig.semesterStartDate]
class TkbDateUtils {
  TkbDateUtils._();

  static const List<String> _weekdayNames = [
    '', // index 0 bỏ trống
    'Thứ 2',
    'Thứ 3',
    'Thứ 4',
    'Thứ 5',
    'Thứ 6',
    'Thứ 7',
  ];

  static const List<String> _weekdayShort = [
    '',
    'T2',
    'T3',
    'T4',
    'T5',
    'T6',
    'T7',
  ];

  // ── Tính số tuần ───────────────────────────────────────────

  /// Tính số tuần học từ ngày bắt đầu kỳ.
  /// Tuần 1 = tuần đầu tiên của kỳ học.
  static int weekNumberOf(DateTime date) {
    final start = _mondayOf(AppConfig.semesterStartDate);
    final monday = _mondayOf(date);
    final diff = monday.difference(start).inDays;
    return (diff ~/ 7) + 1;
  }

  /// Số tuần của hôm nay
  static int get currentWeek => weekNumberOf(DateTime.now());

  /// Ngày đầu tuần (Thứ 2) của tuần học thứ [week]
  static DateTime mondayOfWeek(int week) {
    final start = _mondayOf(AppConfig.semesterStartDate);
    return start.add(Duration(days: (week - 1) * 7));
  }

  /// Ngày cuối tuần (Thứ 7) của tuần học thứ [week]
  static DateTime saturdayOfWeek(int week) {
    return mondayOfWeek(week).add(const Duration(days: 5));
  }

  /// Lấy DateTime cụ thể của [dayOfWeek] trong tuần [week].
  /// dayOfWeek: 2=T2, 3=T3, ..., 7=T7
  static DateTime dateOfWeekDay(int week, int dayOfWeek) {
    final monday = mondayOfWeek(week);
    return monday.add(Duration(days: dayOfWeek - 2));
  }

  // ── Format hiển thị ────────────────────────────────────────

  /// "Thứ 2", "Thứ 3", ... "Thứ 7"  (dayOfWeek: 2–7)
  static String weekdayName(int dayOfWeek) {
    assert(dayOfWeek >= 2 && dayOfWeek <= 7);
    return _weekdayNames[dayOfWeek - 1];
  }

  /// "T2", "T3", ... "T7"
  static String weekdayShort(int dayOfWeek) {
    assert(dayOfWeek >= 2 && dayOfWeek <= 7);
    return _weekdayShort[dayOfWeek - 1];
  }

  /// "Tuần 5 · 28/10 – 02/11"
  static String weekRangeLabel(int week) {
    final mon = mondayOfWeek(week);
    final sat = saturdayOfWeek(week);
    return 'Tuần $week · ${_dmy(mon)} – ${_dmy(sat)}';
  }

  /// "28/10/2025"
  static String formatFull(DateTime date) =>
      DateFormat('dd/MM/yyyy').format(date);

  /// "28/10"
  static String formatShort(DateTime date) => DateFormat('dd/MM').format(date);

  /// "Thứ 2, 28/10"
  static String formatWithWeekday(DateTime date) {
    final wd = date.weekday; // 1=Mon, 6=Sat
    final dayCode = wd + 1; // 2=T2 ... 7=T7
    final name = dayCode <= 7 ? _weekdayNames[dayCode - 1] : 'CN';
    return '$name, ${formatShort(date)}';
  }

  /// Kiểm tra ngày có phải hôm nay không
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// dayOfWeek (2–7) của hôm nay. Trả về null nếu là Chủ nhật.
  static int? get todayDayOfWeek {
    final wd = DateTime.now().weekday; // Mon=1 … Sat=6, Sun=7
    if (wd == 7) return null; // Chủ nhật
    return wd + 1;
  }

  // ── Helper nội bộ ──────────────────────────────────────────

  static DateTime _mondayOf(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }

  static String _dmy(DateTime d) => DateFormat('dd/MM').format(d);
}
