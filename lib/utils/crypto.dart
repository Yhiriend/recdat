import 'dart:convert';

class SimpleEncryptionService {
  static String encryptText(String text, String key) {
    // Convertir la clave y el texto a listas de caracteres modificables
    List<int> keyBytes = key.runes.toList();
    List<int> textBytes = text.runes.toList();

    // Aplicar XOR entre cada byte del texto y la clave
    for (int i = 0; i < textBytes.length; i++) {
      textBytes[i] ^= keyBytes[i % keyBytes.length];
    }

    // Convertir la lista de bytes a una cadena de texto
    String encryptedText = String.fromCharCodes(textBytes);

    // Codificar el texto cifrado en Base64
    String base64Encoded = base64.encode(utf8.encode(encryptedText));
    return base64Encoded;
  }
}
