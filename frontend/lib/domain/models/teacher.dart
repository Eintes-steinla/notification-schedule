/// Một slot thời gian GV bận (không thể xếp lịch)
class UnavailableSlot {
  final int dayOfWeek;    // 2–7
  final int periodStart;  // 1–12
  final int periodEnd;    // 1–12

  const UnavailableSlot({
    required this.dayOfWeek,
    required this.periodStart,
    required this.periodEnd,
  });

  factory UnavailableSlot.fromJson(Map<String, dynamic> json) => UnavailableSlot(
    dayOfWeek:   json['day_of_week'] as int,
    periodStart: json['period_start'] as int,
    periodEnd:   json['period_end'] as int,
  );

  Map<String, dynamic> toJson() => {
    'day_of_week':   dayOfWeek,
    'period_start':  periodStart,
    'period_end':    periodEnd,
  };

  @override
  String toString() => 'UnavailableSlot(T$dayOfWeek t$periodStart-$periodEnd)';
}

class Teacher {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final List<UnavailableSlot> unavailableSlots; // Lịch bận lưu dạng JSONB

  const Teacher({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.unavailableSlots = const [],
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    final rawSlots = json['unavailable_slots'];
    final slots = <UnavailableSlot>[];
    if (rawSlots is List) {
      for (final s in rawSlots) {
        if (s is Map<String, dynamic>) {
          slots.add(UnavailableSlot.fromJson(s));
        }
      }
    }

    return Teacher(
      id:               json['id'] as int,
      name:             json['name'] as String,
      email:            json['email'] as String,
      phone:            json['phone'] as String?,
      unavailableSlots: slots,
    );
  }

  Map<String, dynamic> toJson() => {
    'id':                id,
    'name':              name,
    'email':             email,
    if (phone != null) 'phone': phone,
    'unavailable_slots': unavailableSlots.map((s) => s.toJson()).toList(),
  };

  /// Kiểm tra GV có bận vào tiết này không
  bool isBusy(int dayOfWeek, int periodStart, int periodEnd) {
    return unavailableSlots.any((s) =>
      s.dayOfWeek == dayOfWeek &&
      s.periodStart <= periodEnd &&
      s.periodEnd >= periodStart,
    );
  }

  Teacher copyWith({
    int? id, String? name, String? email,
    String? phone, List<UnavailableSlot>? unavailableSlots,
  }) => Teacher(
    id:               id ?? this.id,
    name:             name ?? this.name,
    email:            email ?? this.email,
    phone:            phone ?? this.phone,
    unavailableSlots: unavailableSlots ?? this.unavailableSlots,
  );

  @override
  bool operator ==(Object other) => other is Teacher && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Teacher($name)';
}
