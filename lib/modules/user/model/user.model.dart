import 'package:recdat/modules/attendance/model/attendance.model.dart';
import 'package:recdat/modules/course/course.model.dart';

class UserRole {
  final String value;

  const UserRole._(this.value);

  static const UserRole admin = UserRole._('admin');
  static const UserRole teacher = UserRole._('teacher');
}

class UserModel {
  String? uid;
  String? instituteUid;
  String name;
  String surname;
  String? lastSurname;
  String? email;
  String? phone;
  String? rol;
  String? createdAt;
  String? updatedAt;
  String? profilePic;
  bool isActive;
  List<CourseModel>? courses;
  List<Attendance>? attendances;
  String password;

  UserModel(
      {this.uid,
      this.instituteUid,
      required this.name,
      required this.surname,
      this.lastSurname,
      required this.email,
      this.phone,
      required this.rol,
      this.createdAt,
      this.updatedAt,
      this.profilePic,
      this.courses,
      this.attendances,
      required this.isActive,
      required this.password});

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
        uid: map['uid'] ?? '',
        instituteUid: map['instituteUid'] ?? '',
        name: map['name'] ?? '',
        surname: map['surname'] ?? '',
        lastSurname: map['lastSurname'] ?? '',
        email: map['email'] ?? '',
        phone: map['phone'] ?? '',
        rol: map['rol'] ?? '',
        createdAt: map['createdAt'] ?? '',
        updatedAt: map['updatedAt'] ?? '',
        profilePic: map['profilePic'],
        isActive: map['isActive'] ?? false,
        courses: map['courses'] != null
            ? List<CourseModel>.from((map['courses'] as List)
                .map((item) => CourseModel.fromMap(item)))
            : [],
        attendances: map['attendances'] != null
            ? List<Attendance>.from((map['attendances'] as List)
                .map((item) => Attendance.fromMap(item)))
            : [],
        password: map['password'] ?? '');
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "instituteUid": instituteUid,
      "name": name,
      "surname": surname,
      "lastSurname": lastSurname,
      "email": email,
      "phone": phone,
      "rol": rol,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "profilePic": profilePic,
      "isActive": isActive,
      "courses": courses?.map((course) => course.toMap()).toList(),
      'attendances':
          attendances?.map((attendance) => attendance.toMap()).toList(),
      "password": password,
    };
  }

  bool isComplete() {
    return (uid!.isNotEmpty &&
        name.isNotEmpty &&
        surname.isNotEmpty &&
        email!.isNotEmpty &&
        rol!.isNotEmpty);
  }
}
