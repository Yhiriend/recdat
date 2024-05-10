enum UserRole {
  teacher,
  admin,
}

class User {
  final String? uuid;
  final String? name;
  final String? surname;
  final String? lastSurname;
  final String? email;
  final String? phone;
  final UserRole? rol;

  User({
    this.uuid,
    this.name,
    this.surname,
    this.lastSurname,
    this.email,
    this.phone,
    this.rol,
  });
}
