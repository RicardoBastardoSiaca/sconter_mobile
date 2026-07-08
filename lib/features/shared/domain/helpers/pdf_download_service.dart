import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:permission_handler/permission_handler.dart';

class PdfDownloadService {
  static Future<void> descargarReporte({
    required String url,
    required String nombreSugerido,
    required Function(double) onProgress,
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    try {
      // 1. Solicitar permisos (Vital en Android)
      if (Platform.isAndroid) {
        final status = await Permission.storage.request();
        // Nota: En Android 13+ se usa media library, pero para archivos 
        // privados de la app esto se puede omitir.
      }

      // 2. Definir la ruta de guardado
      Directory? directory;
      if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        // En Android, usamos la carpeta de Descargas pública para que el usuario lo encuentre fácil
        directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) {
          directory = await getExternalStorageDirectory();
        }
      }

      final String rutaFinal = "${directory!.path}/$nombreSugerido";

      // 3. Ejecutar descarga con Dio
      await Dio().download(
        url,
        rutaFinal,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            onProgress(received / total);
          }
        },
      );

      onSuccess(rutaFinal);
    } catch (e) {
      onError("No se pudo guardar el archivo: $e");
    }
  }
}