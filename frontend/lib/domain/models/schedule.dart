/// Hình thức học
enum ScheduleMode { offline, online }

extension ScheduleModeX on ScheduleMode {
  String get value => this == ScheduleMode.offline ? 'offline' : 'online';
  String get label => this == ScheduleMode.offline ? 'Trực tiếp' : 'Trực tuyến';

  static ScheduleMode fromString(String v) =>
      v == 'online' ? ScheduleMode.online : ScheduleMode.offline;
}

class Schedule {
  final int id;
  final int teachingUnitId;
  final int? roomId;           // Null nếu online
  final String? roomCode;
  final String? locationName;
  final int dayOfWeek;         // 2=Thứ 2 … 7=Thứ 7
  final int periodStart;       // 1–12
  final int periodEnd;         // 1–12
  final int weekNumber;
  final ScheduleMode mode;

  // Thông tin join từ API (dùng cho hiển thị trên grid)
  final String? teacherName;
  final String? subjectName;
  final String? subjectCode;
  final List<String> classNames; // Có thể nhiều lớp (merged/group)

  const Schedule({
    required this.id,
    required this.teachingUnitId,
    required this.dayOfWeek,
    required this.periodStart,
    required this.periodEnd,
    required this.weekNumber,
    required this.mode,
    this.roomId,
    this.roomCode,
    this.locationName,
    this.teacherName,
    this.subjectName,
    this.subjectCode,
    this.classNames = const [],
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    final rawClasses = json['class_names'];
    final classNames = <String>[];
    if (rawClasses is List) {
      classNames.addAll(rawClasses.whereType<String>());
    }

    return Schedule(
      id:             json['id'] as int,
      teachingUnitId: json['teaching_unit_id'] as int,
      roomId:         json['room_id'] as int?,
      roomCode:       json['room_code'] as String?,
      locationName:   json['location_name'] as String?,
      dayOfWeek:      json['day_of_week'] as int,
      periodStart:    json['period_start'] as int,
      periodEnd:      json['period_end'] as int,
      weekNumber:     json['week_number'] as int,
      mode:           ScheduleModeX.fromString(json['mode'] as String? ?? 'offline'),
      teacherName:    json['teacher_name'] as String?,
      subjectName:    json['subject_name'] as String?,
      subjectCode:    json['subject_code'] as String?,
      classNames:     classNames,
    );
  }

  Map<String, dynamic> toJson() => {
    'teaching_unit_id': teachingUnitId,
    if (roomId != null) 'room_id': roomId,
    'day_of_week':  dayOfWeek,
    'period_start': periodStart,
    'period_end':   periodEnd,
    'week_number':  weekNumber,
    'mode':         mode.value,
  };

  /// Số tiết của ca học này
  int get periodCount => periodEnd - periodStart + 1;

  /// Hiển thị tên lớp gộp lại
  String get classLabel => classNames.join(', ');

  Schedule copyWith({
    int? id, int? teachingUnitId, int? roomId, String? roomCode,
    String? locationName, int? dayOfWeek, int? periodStart, int? periodEnd,
    int? weekNumber, ScheduleMode? mode, String? teacherName,
    String? subjectName, String? subjectCode, List<String>? classNames,
  }) => Schedule(
    id:             id ?? this.id,
    teachingUnitId: teachingUnitId ?? this.teachingUnitId,
    roomId:         roomId ?? this.roomId,
    roomCode:       roomCode ?? this.roomCode,
    locationName:   locationName ?? this.locationName,
    dayOfWeek:      dayOfWeek ?? this.dayOfWeek,
    periodStart:    periodStart ?? this.periodStart,
    periodEnd:      periodEnd ?? this.periodEnd,
    weekNumber:     weekNumber ?? this.weekNumber,
    mode:           mode ?? this.mode,
    teacherName:    teacherName ?? this.teacherName,
    subjectName:    subjectName ?? this.subjectName,
    subjectCode:    subjectCode ?? this.subjectCode,
    classNames:     classNames ?? this.classNames,
  );

  @override
  bool operator ==(Object other) => other is Schedule && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'Schedule(T$dayOfWeek t$periodStart-$periodEnd w$weekNumber ${subjectCode ?? ""})';
}
