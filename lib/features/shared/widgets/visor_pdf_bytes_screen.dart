import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';

class VisorPdfBytesScreen extends StatelessWidget {
  final Uint8List bytes;

  const VisorPdfBytesScreen({super.key, required this.bytes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reporte Generado'),
      ),
      // Usamos .data para mostrar lo que descargamos como Blob/Bytes
      body: Column(
        children: [
          Expanded(
            child: PdfViewer.data(
              bytes,
              params: const PdfViewerParams(
                // enableTextSelection: true,
                backgroundColor: Color(0xFFF0F2F5),
              ), sourceName: 'reporte.pdf',
            ),
          ),
        ],
      ),
    );
  }
}