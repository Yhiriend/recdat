import 'package:cloud_firestore/cloud_firestore.dart';

class CourseOptions {
  final String uid;
  final String name;

  CourseOptions({required this.uid, required this.name});
}

class CourseModel {
  String? uid;
  String? name;
  String? description;
  String? grade;
  String? createdAt;
  String? updatedAt;
  String? type;

  CourseModel(
      {this.uid,
      required this.name,
      required this.description,
      required this.grade,
      required this.createdAt,
      this.updatedAt,
      this.type});

  factory CourseModel.fromMap(Map<String, dynamic> map) {
    return CourseModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      grade: map['grade'] ?? '',
      createdAt: map['createdAt'] ?? '',
      updatedAt: map['updatedAt'] ?? '',
      type: map['type'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "name": name,
      "description": description,
      "grade": grade,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "type": type,
    };
  }
}
