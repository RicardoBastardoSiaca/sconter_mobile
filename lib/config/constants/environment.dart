import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static initEnvironment() async {
    await dotenv.load(fileName: '.env');
  }

  static String apiUrl =
      dotenv.env['API_URL'] ?? 'No esta configurado el API_URL';
  static String encryptKey =
      dotenv.env['ENCRYPT_KEY'] ?? 'No esta configurado el ENCRYPT_KEY';
  static String encryptIV =
      dotenv.env['ENCRYPT_IV'] ?? 'No esta configurado el ENCRYPT_IV';
  // static const String apiUrlprod = 'prod';
}
