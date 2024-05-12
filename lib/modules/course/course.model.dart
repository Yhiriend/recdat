class CourseModel {
  String? uid;
  String? name;
  String? description;
  int? grade;
  String? createdAt;

  CourseModel({
    required this.uid,
    required this.name,
    required this.description,
    required this.grade,
    required this.createdAt,
  });

  factory CourseModel.fromMap(Map<String, dynamic> map) {
    return CourseModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      grade: map['grade'] ?? 0,
      createdAt: map['createdAt'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "name": name,
      "description": description,
      "grade": grade,
      "createdAt": createdAt,
    };
  }
}
