/// Loại phòng học
enum RoomType {
  theory,  // Phòng lý thuyết
  lab,     // Phòng thực hành
  design,  // Phòng thiết kế
}

extension RoomTypeX on RoomType {
  String get label {
    switch (this) {
      case RoomType.theory: return 'Lý thuyết';
      case RoomType.lab:    return 'Thực hành';
      case RoomType.design: return 'Thiết kế';
    }
  }

  /// Giá trị gửi lên API
  String get value {
    switch (this) {
      case RoomType.theory: return 'theory';
      case RoomType.lab:    return 'lab';
      case RoomType.design: return 'design';
    }
  }

  static RoomType fromString(String v) {
    switch (v) {
      case 'lab':    return RoomType.lab;
      case 'design': return RoomType.design;
      default:       return RoomType.theory;
    }
  }
}

class Room {
  final int id;
  final String code;        // Ví dụ: "A17-101"
  final RoomType type;
  final int capacity;
  final int locationId;
  final String? locationName; // Nullable – không phải lúc nào API cũng join

  const Room({
    required this.id,
    required this.code,
    required this.type,
    required this.capacity,
    required this.locationId,
    this.locationName,
  });

  factory Room.fromJson(Map<String, dynamic> json) => Room(
    id:           json['id'] as int,
    code:         json['code'] as String,
    type:         RoomTypeX.fromString(json['type'] as String),
    capacity:     json['capacity'] as int,
    locationId:   json['location_id'] as int,
    locationName: json['location_name'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id':          id,
    'code':        code,
    'type':        type.value,
    'capacity':    capacity,
    'location_id': locationId,
  };

  Room copyWith({
    int? id, String? code, RoomType? type,
    int? capacity, int? locationId, String? locationName,
  }) => Room(
    id:           id ?? this.id,
    code:         code ?? this.code,
    type:         type ?? this.type,
    capacity:     capacity ?? this.capacity,
    locationId:   locationId ?? this.locationId,
    locationName: locationName ?? this.locationName,
  );

  @override
  bool operator ==(Object other) => other is Room && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Room($code, ${type.label})';
}
