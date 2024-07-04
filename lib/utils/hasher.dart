import 'dart:convert';
import 'package:crypto/crypto.dart';

String hashPassword(String password) {
  // Convertir la contraseña en bytes utilizando UTF-8
  var bytes = utf8.encode(password);

  // Aplicar la función de hash (SHA-256 en este caso)
  var digest = sha256.convert(bytes);

  // Convertir el resultado del hash en una cadena hexadecimal
  return digest.toString();
}

bool verifyPassword(String enteredPassword, String storedHashedPassword) {
  // Hashear la contraseña ingresada por el usuario
  String hashedEnteredPassword = hashPassword(enteredPassword);

  // Comparar la contraseña hasheada ingresada con la almacenada
  return hashedEnteredPassword == storedHashedPassword;
}
