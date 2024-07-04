import 'package:encrypt/encrypt.dart' as encrypt;

String encryptString(String plainText) {
  final key = encrypt.Key.fromUtf8(
      'cec55c45e80c408482acf0589bde1631'); // La clave debe tener 32 caracteres
  final iv = encrypt.IV.fromLength(16); // IV debe tener 16 bytes

  final encrypter = encrypt.Encrypter(encrypt.AES(key));

  final encrypted = encrypter.encrypt(plainText, iv: iv);
  return encrypted.base64; // Devuelve el texto cifrado en formato base64
}
