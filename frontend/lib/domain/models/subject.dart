import 'room.dart';

class Subject {
  final int id;
  final String name;           // Ví dụ: "Lập trình Web"
  final String code;           // Ví dụ: "LTW301"
  final RoomType roomType;     // Yêu cầu loại phòng nào
  final bool isPractice;       // Môn thực hành
  final bool requiresConsecutive; // Phải xếp tiết liên tiếp
  final int totalPeriods;      // Tổng số tiết cả kỳ

  const Subject({
    required this.id,
    required this.name,
    required this.code,
    required this.roomType,
    required this.isPractice,
    required this.requiresConsecutive,
    required this.totalPeriods,
  });

  factory Subject.fromJson(Map<String, dynamic> json) => Subject(
    id:                  json['id'] as int,
    name:                json['name'] as String,
    code:                json['code'] as String,
    roomType:            RoomTypeX.fromString(json['room_type'] as String),
    isPractice:          json['is_practice'] as bool? ?? false,
    requiresConsecutive: json['requires_consecutive'] as bool? ?? false,
    totalPeriods:        json['total_periods'] as int? ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'id':                   id,
    'name':                 name,
    'code':                 code,
    'room_type':            roomType.value,
    'is_practice':          isPractice,
    'requires_consecutive': requiresConsecutive,
    'total_periods':        totalPeriods,
  };

  Subject copyWith({
    int? id, String? name, String? code, RoomType? roomType,
    bool? isPractice, bool? requiresConsecutive, int? totalPeriods,
  }) => Subject(
    id:                  id ?? this.id,
    name:                name ?? this.name,
    code:                code ?? this.code,
    roomType:            roomType ?? this.roomType,
    isPractice:          isPractice ?? this.isPractice,
    requiresConsecutive: requiresConsecutive ?? this.requiresConsecutive,
    totalPeriods:        totalPeriods ?? this.totalPeriods,
  );

  @override
  bool operator ==(Object other) => other is Subject && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Subject($code – $name)';
}
