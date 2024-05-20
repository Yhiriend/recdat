class UserRole {
  final String value;

  const UserRole._(this.value);

  static const UserRole admin = UserRole._('admin');
  static const UserRole user = UserRole._('user');
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
  String? profilePic;
  String password;

  UserModel(
      {this.uid,
      this.instituteUid,
      required this.name,
      required this.surname,
      required this.lastSurname,
      required this.email,
      required this.phone,
      required this.rol,
      required this.createdAt,
      required this.profilePic,
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
        profilePic: map['profilePic'] ?? '',
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
      "profilePic": profilePic,
      "password": password,
    };
  }
}
