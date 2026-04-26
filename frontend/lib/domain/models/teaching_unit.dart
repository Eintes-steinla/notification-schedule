/// Loại Teaching Unit
enum TuType {
  single,  // 1 lớp học 1 môn
  merged,  // Nhiều lớp gộp học chung
  group,   // 1 lớp tách nhóm (VD: nhóm thực hành)
}

extension TuTypeX on TuType {
  String get label {
    switch (this) {
      case TuType.single: return 'Đơn';
      case TuType.merged: return 'Gộp lớp';
      case TuType.group:  return 'Nhóm';
    }
  }

  String get value {
    switch (this) {
      case TuType.single: return 'single';
      case TuType.merged: return 'merged';
      case TuType.group:  return 'group';
    }
  }

  static TuType fromString(String v) {
    switch (v) {
      case 'merged': return TuType.merged;
      case 'group':  return TuType.group;
      default:       return TuType.single;
    }
  }
}

/// Thành phần lớp học trong một Teaching Unit
class TuClass {
  final int classId;
  final String? className;
  /// Phân số sinh viên tham gia (1.0 = cả lớp, 0.5 = nửa lớp)
  final double studentFraction;

  const TuClass({
    required this.classId,
    this.className,
    this.studentFraction = 1.0,
  });

  factory TuClass.fromJson(Map<String, dynamic> json) => TuClass(
    classId:         json['class_id'] as int,
    className:       json['class_name'] as String?,
    studentFraction: (json['student_fraction'] as num?)?.toDouble() ?? 1.0,
  );

  Map<String, dynamic> toJson() => {
    'class_id':        classId,
    'student_fraction': studentFraction,
  };
}

class TeachingUnit {
  final int id;
  final TuType type;
  final int teacherId;
  final String? teacherName;
  final int subjectId;
  final String? subjectName;
  final int semesterId;
  final List<TuClass> classes; // Danh sách lớp tham gia

  const TeachingUnit({
    required this.id,
    required this.type,
    required this.teacherId,
    required this.subjectId,
    required this.semesterId,
    this.teacherName,
    this.subjectName,
    this.classes = const [],
  });

  factory TeachingUnit.fromJson(Map<String, dynamic> json) {
    final rawClasses = json['classes'];
    final classes = <TuClass>[];
    if (rawClasses is List) {
      for (final c in rawClasses) {
        if (c is Map<String, dynamic>) classes.add(TuClass.fromJson(c));
      }
    }

    return TeachingUnit(
      id:          json['id'] as int,
      type:        TuTypeX.fromString(json['type'] as String),
      teacherId:   json['teacher_id'] as int,
      teacherName: json['teacher_name'] as String?,
      subjectId:   json['subject_id'] as int,
      subjectName: json['subject_name'] as String?,
      semesterId:  json['semester_id'] as int,
      classes:     classes,
    );
  }

  Map<String, dynamic> toJson() => {
    'id':          id,
    'type':        type.value,
    'teacher_id':  teacherId,
    'subject_id':  subjectId,
    'semester_id': semesterId,
    'classes':     classes.map((c) => c.toJson()).toList(),
  };

  /// Tổng số sinh viên ước tính
  int estimatedStudentCount(Map<int, int> classSizes) {
    return classes.fold(0, (sum, tc) {
      final size = classSizes[tc.classId] ?? 0;
      return sum + (size * tc.studentFraction).round();
    });
  }

  TeachingUnit copyWith({
    int? id, TuType? type, int? teacherId, String? teacherName,
    int? subjectId, String? subjectName, int? semesterId,
    List<TuClass>? classes,
  }) => TeachingUnit(
    id:          id ?? this.id,
    type:        type ?? this.type,
    teacherId:   teacherId ?? this.teacherId,
    teacherName: teacherName ?? this.teacherName,
    subjectId:   subjectId ?? this.subjectId,
    subjectName: subjectName ?? this.subjectName,
    semesterId:  semesterId ?? this.semesterId,
    classes:     classes ?? this.classes,
  );

  @override
  bool operator ==(Object other) => other is TeachingUnit && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'TeachingUnit(${type.label} – ${subjectName ?? subjectId})';
}
