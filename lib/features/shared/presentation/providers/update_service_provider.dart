// import 'dart:io';
import 'package:dio/dio.dart';
import 'package:ota_update/ota_update.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:permission_handler/permission_handler.dart'; // 1. Import de permisos
import 'package:scounter_mobile/config/config.dart';

class UpdateService {
  final Dio _dio = Dio();
  
  static String apiUrl = '${Environment.apiUrl}/apk-version/latest/';

  /// Comprueba si existe una versión superior en el servidor
  Future<Map<String, dynamic>?> checkForUpdate() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();

      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      print('Build Number Local: ${packageInfo.buildNumber}');
      
      int localBuildNumber = int.tryParse(packageInfo.buildNumber) ?? 0;

      final response = await _dio.get(apiUrl);

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        int serverBuildNumber = data['version_code'];

        if (serverBuildNumber > localBuildNumber) {
          return {
            'hasUpdate': true,
            'versionName': data['version_name'],
            'versionCode': serverBuildNumber,
            'apkUrl': data['apk_url'],
            'isMandatory': data['is_mandatory'],
            'releaseNotes': data['release_notes'],
          };
        }
      }
    } catch (e, stackTrace) {
      print('Error al verificar actualización: $e');
      print('StackTrace: $stackTrace');
    }
    return null;
  }

  /// Verifica permisos y ejecuta la descarga e instalación mediante ota_update
  Stream<OtaEvent> downloadAndInstallApk(String apkUrl) async* {
    try {
      // 2. Verificar/Solicitar permiso para instalar APKs desconocidas (Android 8+)
      var status = await Permission.requestInstallPackages.status;
      if (!status.isGranted) {
        status = await Permission.requestInstallPackages.request();
        if (!status.isGranted) {
          // Si el usuario deniega el permiso, emitimos el evento de error nativo
          yield OtaEvent(
            OtaStatus.PERMISSION_NOT_GRANTED_ERROR,
            'Permisos insuficientes para instalar el APK.',
          );
          return;
        }
      }

      // 3. Emitir y delegar el stream de ota_update
      yield* OtaUpdate().execute(
        apkUrl,
        destinationFilename: 'update.apk',
      );
    } catch (e) {
      print('Error al ejecutar ota_update: $e');
      rethrow;
    }
  }
}