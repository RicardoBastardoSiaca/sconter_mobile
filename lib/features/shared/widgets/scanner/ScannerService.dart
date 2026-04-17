import 'package:flutter/material.dart';
import 'custom_scanner_widget.dart';

class ScannerService {
  /// Abre la cámara y devuelve el string detectado o null si se cancela.
  static Future<String?> scanCode(BuildContext context, {String? title}) async {
    return await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => CustomScannerWidget(
          title: title ?? "Escanear QR",
          onCodeDetected: (code) {
            // Devolvemos el valor a la pantalla que llamó al servicio
            Navigator.pop(context, code);
          },
        ),
      ),
    );
  }
}