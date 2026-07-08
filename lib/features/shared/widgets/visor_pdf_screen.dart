import 'package:flutter/material.dart';
// import 'package:pdfrx/pdfrx.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:scounter_mobile/features/shared/domain/domain.dart';
// import 'package:open_file_plus/open_file_plus.dart';
import 'package:open_file/open_file.dart';
import 'package:scounter_mobile/features/shared/shared.dart';


class VisorPdfScreen extends StatelessWidget {
  final String url;

  const VisorPdfScreen({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reporte'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.download_rounded),
            onPressed: () async {
              // Aquí integras la lógica de descarga que vimos antes
              // Mostrar un pequeño diálogo de progresoogreso(context);
              _mostrarDialogoProgreso(context);

              await PdfDownloadService.descargarReporte(
                url: url,
                nombreSugerido: "Reporte_${DateTime.now().millisecondsSinceEpoch}.pdf",
                onProgress: (progreso) {
                  // Aquí podrías actualizar un LinearProgressIndicator si usas un StatefullWidget
                },
                onSuccess: (ruta) {
                  Navigator.pop(context); // Cerrar loading
                  // _mostrarNotificacionExito(context, ruta);
                  CustomSnackbar.showSuccessSnackbar(
                        '¡Descarga completada con éxito!',
                        context,
                        isFixed: true,
                      );

                  // OPCIONAL: Abrir el archivo inmediatamente
                  OpenFile.open(ruta);
                },
                onError: (error) {
                  Navigator.pop(context);
                  // _mostrarError(context, error);
                  CustomSnackbar.showErrorSnackbar(
                        'Error al descargar el archivo',
                        context,
                        isFixed: true,
                      );

                },
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PdfViewer.uri(
              Uri.parse(url), // Convertimos el string a un objeto Uri
              params: const PdfViewerParams(
                // enableTextSelection
                textSelectionParams: PdfTextSelectionParams(
            enabled: true
                )
                // Puedes personalizar el loader aquí si lo deseas
              ),
            ),
          ),
        ],
      ),
    );
  }
}



void _mostrarDialogoProgreso(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, // El usuario no puede cerrarlo tocando fuera
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          CircularProgressIndicator(),
          SizedBox(height: 20),
          Text("Descargando reporte...", 
               style: TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    ),
  );
}
void _mostrarNotificacionExito(BuildContext context, String ruta) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: const Text('¡Descarga completada con éxito!'),
      backgroundColor: Colors.green.shade700,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(15),
      action: SnackBarAction(
        label: "CERRAR",
        textColor: Colors.white,
        onPressed: () {},
      ),
    ),
  );
}

void _mostrarError(BuildContext context, String mensaje) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(mensaje),
      backgroundColor: Colors.redAccent,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  );
}