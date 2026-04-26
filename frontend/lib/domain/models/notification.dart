/// Loại thông báo
enum NotificationType {
  dailySchedule, // Lịch ngày mai (cron 22:00)
  upcomingClass, // Nhắc tiết sắp học (cron 5 phút)
  scheduleChange, // Admin thay đổi lịch
  general, // Thông báo chung
}

extension NotificationTypeX on NotificationType {
  String get value {
    switch (this) {
      case NotificationType.dailySchedule:
        return 'daily_schedule';
      case NotificationType.upcomingClass:
        return 'upcoming_class';
      case NotificationType.scheduleChange:
        return 'schedule_change';
      case NotificationType.general:
        return 'general';
    }
  }

  String get label {
    switch (this) {
      case NotificationType.dailySchedule:
        return 'Lịch ngày mai';
      case NotificationType.upcomingClass:
        return 'Sắp có tiết học';
      case NotificationType.scheduleChange:
        return 'Thay đổi lịch';
      case NotificationType.general:
        return 'Thông báo';
    }
  }

  static NotificationType fromString(String v) {
    switch (v) {
      case 'daily_schedule':
        return NotificationType.dailySchedule;
      case 'upcoming_class':
        return NotificationType.upcomingClass;
      case 'schedule_change':
        return NotificationType.scheduleChange;
      default:
        return NotificationType.general;
    }
  }
}

class AppNotification {
  final int id;
  final String title;
  final String body;
  final NotificationType type;
  final bool isRead;
  final DateTime createdAt;

  /// Dữ liệu phụ để navigate khi tap (VD: tuần, ngày)
  final Map<String, dynamic> payload;

  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.isRead,
    required this.createdAt,
    this.payload = const {},
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    final rawPayload = json['payload'];
    final payload = <String, dynamic>{};
    if (rawPayload is Map<String, dynamic>) payload.addAll(rawPayload);

    return AppNotification(
      id: json['id'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
      type: NotificationTypeX.fromString(json['type'] as String? ?? 'general'),
      isRead: json['is_read'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      payload: payload,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'body': body,
    'type': type.value,
    'is_read': isRead,
    'created_at': createdAt.toIso8601String(),
    'payload': payload,
  };

  AppNotification copyWith({
    int? id,
    String? title,
    String? body,
    NotificationType? type,
    bool? isRead,
    DateTime? createdAt,
    Map<String, dynamic>? payload,
  }) => AppNotification(
    id: id ?? this.id,
    title: title ?? this.title,
    body: body ?? this.body,
    type: type ?? this.type,
    isRead: isRead ?? this.isRead,
    createdAt: createdAt ?? this.createdAt,
    payload: payload ?? this.payload,
  );

  /// Thời gian hiển thị thân thiện. VD: "5 phút trước", "Hôm qua"
  String get timeAgo {
    final diff = DateTime.now().difference(createdAt);
    if (diff.inMinutes < 1) return 'Vừa xong';
    if (diff.inMinutes < 60) return '${diff.inMinutes} phút trước';
    if (diff.inHours < 24) return '${diff.inHours} giờ trước';
    if (diff.inDays == 1) return 'Hôm qua';
    if (diff.inDays < 7) return '${diff.inDays} ngày trước';
    return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
  }

  @override
  bool operator ==(Object other) => other is AppNotification && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'AppNotification($type – $title)';
}
