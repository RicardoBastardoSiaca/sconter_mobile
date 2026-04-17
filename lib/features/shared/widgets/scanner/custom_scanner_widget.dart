import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class CustomScannerWidget extends StatefulWidget {
  final Function(String) onCodeDetected;
  final String title;

  const CustomScannerWidget({
    super.key,
    required this.onCodeDetected,
    this.title = "Escanear Código",
  });

  @override
  State<CustomScannerWidget> createState() => _CustomScannerWidgetState();
}

class _CustomScannerWidgetState extends State<CustomScannerWidget> {
  // Controlador centralizado para gestionar flash y cámara
  final MobileScannerController controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
    torchEnabled: false,
  );

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
  ValueListenableBuilder<MobileScannerState>(
    valueListenable: controller, // El controlador ahora es el Listenable
    builder: (context, state, child) {
      // El estado de la linterna está en state.torchState
      final TorchState torchState = state.torchState;

      return IconButton(
        icon: Icon(
          torchState == TorchState.on ? Icons.flash_on : Icons.flash_off,
          color: torchState == TorchState.on ? Colors.yellow : Colors.grey,
        ),
        iconSize: 28,
        onPressed: () => controller.toggleTorch(),
      );
    },
  ),
],
      
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            onDetect: (BarcodeCapture capture) {
              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isNotEmpty) {
                final String? code = barcodes.first.rawValue;
                if (code != null) {
                  // Importante: En esta versión, si quieres detener el escaneo 
                  // inmediatamente después de detectar uno, puedes usar:
                  // controller.stop(); 
                  widget.onCodeDetected(code);
                }
              }
            },
          ),
          // Máscara visual (Capa de diseño)
          _buildOverlay(context),
        ],
      ),
    );
  }

  Widget _buildOverlay(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        shape: QrScannerOverlayShape(
          borderColor: Colors.green, // Tu color verde de los botones
          borderRadius: 15,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: MediaQuery.of(context).size.width * 0.7,
        ),
      ),
    );
  }
}

// Dibujamos el recuadro manualmente para no depender de librerías extra de UI
class QrScannerOverlayShape extends ShapeBorder {
  final Color borderColor;
  final double borderWidth;
  final double borderRadius;
  final double borderLength;
  final double cutOutSize;

  const QrScannerOverlayShape({
    this.borderColor = Colors.white,
    this.borderWidth = 1.0,
    this.borderRadius = 0,
    this.borderLength = 40,
    this.cutOutSize = 250,
  });

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) => Path();

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) => Path()..addRect(rect);

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final width = rect.width;
    final height = rect.height;
    final boxWidth = cutOutSize;
    final boxHeight = cutOutSize;
    final left = (width - boxWidth) / 2;
    final top = (height - boxHeight) / 2;

    final backgroundPaint = Paint()..color = Colors.black54; // Fondo semitransparente
    final cutOutRect = Rect.fromLTWH(left, top, boxWidth, boxHeight);

    // Dibuja el fondo oscuro con el hueco
    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(rect),
        Path()..addRRect(RRect.fromRectAndRadius(cutOutRect, Radius.circular(borderRadius))),
      ),
      backgroundPaint,
    );

    // Dibuja las esquinas verdes
    final paint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    final path = Path();
    // Esquina superior izquierda
    path.moveTo(left, top + borderLength);
    path.lineTo(left, top + borderRadius);
    path.arcToPoint(Offset(left + borderRadius, top), radius: Radius.circular(borderRadius));
    path.lineTo(left + borderLength, top);

    // Esquina superior derecha
    path.moveTo(left + boxWidth - borderLength, top);
    path.lineTo(left + boxWidth - borderRadius, top);
    path.arcToPoint(Offset(left + boxWidth, top + borderRadius), radius: Radius.circular(borderRadius));
    path.lineTo(left + boxWidth, top + borderLength);

    // ... (repetir para abajo o dejar así para un look moderno)
    canvas.drawPath(path, paint);
  }

  @override
  ShapeBorder scale(double t) => this;
}