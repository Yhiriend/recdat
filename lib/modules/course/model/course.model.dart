import 'package:cloud_firestore/cloud_firestore.dart';

class CourseType {
  static const String informatic = 'INFORMATICA';
  static const String physical = 'FISICA';
  static const String biology = 'BIOLOGIA';
  static const String math = 'MATEMATICAS';
  static const String chemistry = 'QUIMICA';
  static const String geography = 'GEOGRAFIA';
  static const String economy = 'ECONOMIA';
  static const String art = 'ARTISTICA';
  static const String philosophy = 'FILOSOFIA';
  static const String history = 'HISTORIA';
  static const String ethics = 'ETICA Y VALORES';
  static const String literature = 'LITERATURA';
}

class CourseModel {
  String name;
  String? description;
  Timestamp? createdAt;
  Timestamp? updatedAt;
  String grade;
  String type;

  CourseModel(
      {required this.name,
      this.description,
      this.createdAt,
      this.updatedAt,
      required this.grade,
      required this.type});

  factory CourseModel.fromMap(Map<String, dynamic> map) {
    return CourseModel(
        name: map['name'] ?? '',
        description: map['description'] ?? '',
        createdAt: map['createdAt'] ?? '',
        grade: map['grade'] ?? '',
        updatedAt: map['updatedAt'] ?? '',
        type: map['type'] ?? '');
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "description": description,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "grade": grade,
      "type": type,
    };
  }
}
