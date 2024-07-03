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
  DateTime? createdAt;
  DateTime? updatedAt;
  String? profilePic;
  bool isActive;
  List<CourseModel>? courses;
  List<Attendance>? attendances;
  List<UserEntryAssignment>? entryAssigments;
  String password;
  String? question;
  String? answer;

  UserModel(
      {this.uid,
      this.question,
      this.answer,
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
      this.entryAssigments,
      required this.isActive,
      required this.password});

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
        uid: map['uid'] ?? '',
        question: map['question'],
        answer: map['answer'],
        instituteUid: map['instituteUid'] ?? '',
        name: map['name'] ?? '',
        surname: map['surname'] ?? '',
        lastSurname: map['lastSurname'] ?? '',
        email: map['email'] ?? '',
        phone: map['phone'] ?? '',
        rol: map['rol'] ?? '',
        createdAt:
            map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
        updatedAt:
            map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
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
        entryAssigments: map['entryAssigments'] != null
            ? List<UserEntryAssignment>.from((map['entryAssigments'] as List)
                .map((item) => UserEntryAssignment.fromMap(item)))
            : [],
        password: map['password'] ?? '');
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "question": question,
      "answer": answer,
      "instituteUid": instituteUid,
      "name": name,
      "surname": surname,
      "lastSurname": lastSurname,
      "email": email,
      "phone": phone,
      "rol": rol,
      "createdAt": createdAt?.toIso8601String(),
      "updatedAt": updatedAt?.toIso8601String(),
      "profilePic": profilePic,
      "isActive": isActive,
      "courses": courses?.map((course) => course.toMap()).toList(),
      'attendances':
          attendances?.map((attendance) => attendance.toMap()).toList(),
      'entryAssigments': entryAssigments
          ?.map((entryAssigments) => entryAssigments.toMap())
          .toList(),
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

class UserEntryAssignment {
  final String day;
  String hour;

  UserEntryAssignment({
    required this.day,
    this.hour = "",
  });

  void clearHour() {
    hour = "";
  }

  void setHour(String newHour) {
    hour = newHour;
  }

  Map<String, dynamic> toMap() {
    return {
      'day': day,
      'hour': hour,
    };
  }

  factory UserEntryAssignment.fromMap(Map<String, dynamic> map) {
    return UserEntryAssignment(
      day: map['day'] ?? '',
      hour: map['hour'] ?? '',
    );
  }
}
