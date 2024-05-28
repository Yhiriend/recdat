import 'dart:convert';

class QRModel {
  String? uid;
  String name;
  String surname;
  String email;
  String date;
  String rol;

  QRModel({
    this.uid,
    required this.name,
    required this.surname,
    required this.email,
    required this.date,
    required this.rol,
  });

  factory QRModel.fromMap(Map<String, dynamic> map) {
    return QRModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      surname: map['surname'] ?? '',
      email: map['email'] ?? '',
      date: map['date'] ?? '',
      rol: map['rol'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "name": name,
      "surname": surname,
      "email": email,
      "date": date,
      "rol": rol,
    };
  }

  String toJson() {
    return jsonEncode(toMap());
  }
}
