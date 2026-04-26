class ClassGroup {
  final int id;
  final String name;        // Ví dụ: "LTMT1-K17"
  final int majorId;
  final String? majorName;
  final int cohortId;
  final String? cohortName; // Ví dụ: "K17"
  final int studentCount;

  const ClassGroup({
    required this.id,
    required this.name,
    required this.majorId,
    required this.cohortId,
    required this.studentCount,
    this.majorName,
    this.cohortName,
  });

  factory ClassGroup.fromJson(Map<String, dynamic> json) => ClassGroup(
    id:           json['id'] as int,
    name:         json['name'] as String,
    majorId:      json['major_id'] as int,
    majorName:    json['major_name'] as String?,
    cohortId:     json['cohort_id'] as int,
    cohortName:   json['cohort_name'] as String?,
    studentCount: json['student_count'] as int? ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'id':            id,
    'name':          name,
    'major_id':      majorId,
    'cohort_id':     cohortId,
    'student_count': studentCount,
  };

  ClassGroup copyWith({
    int? id, String? name, int? majorId, String? majorName,
    int? cohortId, String? cohortName, int? studentCount,
  }) => ClassGroup(
    id:           id ?? this.id,
    name:         name ?? this.name,
    majorId:      majorId ?? this.majorId,
    majorName:    majorName ?? this.majorName,
    cohortId:     cohortId ?? this.cohortId,
    cohortName:   cohortName ?? this.cohortName,
    studentCount: studentCount ?? this.studentCount,
  );

  @override
  bool operator ==(Object other) => other is ClassGroup && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'ClassGroup($name)';
}
