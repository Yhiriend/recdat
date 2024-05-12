import 'package:recdat/modules/course/course.model.dart';

class InstituteModel {
  String? uid;
  String? name;
  List<CourseModel>? courses;
  String? createdAt;

  InstituteModel({
    required this.uid,
    required this.name,
    required this.courses,
    required this.createdAt,
  });

  factory InstituteModel.fromMap(Map<String, dynamic> map) {
    return InstituteModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      courses: (map['courses'] as List<dynamic>?)
          ?.map((course) => CourseModel.fromMap(course))
          .toList(),
      createdAt: map['createdAt'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "name": name,
      "courses": courses?.map((course) => course.toMap()).toList(),
      "createdAt": createdAt,
    };
  }
}
