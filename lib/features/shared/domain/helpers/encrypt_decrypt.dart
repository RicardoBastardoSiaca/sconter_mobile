import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/foundation.dart';
import 'package:turnaround_mobile/config/constants/environment.dart';

class EncryptDecrypt {
  final encrypt.Key key; // 32 chars for AES-256
  final encrypt.IV iv; // 16 chars for AES CBC IV

  EncryptDecrypt()
    : key = encrypt.Key.fromUtf8(Environment.encryptKey),
      iv = encrypt.IV.fromUtf8(Environment.encryptIV);

  String encryptUsingAES256(String text) {
    final encrypter = encrypt.Encrypter(
      encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: 'PKCS7'),
    );
    final encrypted = encrypter.encrypt(text, iv: iv);
    return encrypted.base64;
  }

  String decryptUsingAES256(String encryptedText) {
    final encrypter = encrypt.Encrypter(
      encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: 'PKCS7'),
    );
    final decrypted = encrypter.decrypt64(encryptedText, iv: iv);
    return decrypted;
  }
}
