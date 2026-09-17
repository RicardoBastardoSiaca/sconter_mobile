import 'package:flutter/material.dart';
import 'package:ota_update/ota_update.dart';
import 'package:scounter_mobile/features/shared/shared.dart';
// import 'update_service.dart';

class UpdateDialog extends StatefulWidget {
  final Map<String, dynamic> updateData;

  const UpdateDialog({
    super.key,
    required this.updateData,
  });

  @override
  State<UpdateDialog> createState() => _UpdateDialogState();
}

class _UpdateDialogState extends State<UpdateDialog> {
  final UpdateService _updateService = UpdateService();
  
  // Color primario de la app
  static const Color primaryGreen = Color(0xFF0FA45F);

  bool _isDownloading = false;
  int _downloadProgress = 0;
  String _statusMessage = '';
  bool _hasError = false;

  void _startUpdate() {
    setState(() {
      _isDownloading = true;
      _hasError = false;
      _statusMessage = 'Iniciando descarga...';
    });

    final String apkUrl = widget.updateData['apkUrl'];

    print('Iniciando descarga del APK desde: $apkUrl');
    _updateService.downloadAndInstallApk(apkUrl).listen(
      (OtaEvent event) {
        setState(() {
          switch (event.status) {
            case OtaStatus.DOWNLOADING:
              _statusMessage = 'Descargando actualización...';
              _downloadProgress = int.tryParse(event.value ?? '0') ?? 0;
              break;
            case OtaStatus.INSTALLING:
              _statusMessage = 'Abriendo instalador...';
              _downloadProgress = 100;
              break;
            case OtaStatus.ALREADY_RUNNING_ERROR:
              _statusMessage = 'Ya hay una descarga en proceso.';
              _hasError = true;
              _isDownloading = false;
              break;
            case OtaStatus.PERMISSION_NOT_GRANTED_ERROR:
              _statusMessage = 'Permisos insuficientes para instalar.';
              _hasError = true;
              _isDownloading = false;
              break;
            default:
              _statusMessage = 'Error al actualizar el APK.';
              _hasError = true;
              _isDownloading = false;
              break;
          }
        });
      },
      onError: (error) {
        setState(() {
          _isDownloading = false;
          _hasError = true;
          _statusMessage = 'Error de conexión durante la descarga.';
        });
        print('Error al descargar el APK: $error');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final String versionName = widget.updateData['versionName'] ?? '';
    final String releaseNotes = widget.updateData['releaseNotes'] ?? 'Sin notas de versión disponibles.';
    final bool isMandatory = widget.updateData['isMandatory'] ?? false;

    return PopScope(
      canPop: !isMandatory && !_isDownloading,
      child: AlertDialog(
        backgroundColor: Colors.white, // Fondo completamente blanco
        surfaceTintColor: Colors.white, // Evita tinte por defecto en Material 3
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.system_update, color: primaryGreen, size: 28),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Nueva versión v$versionName',
                style: const TextStyle(
                  fontSize: 18, 
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isMandatory) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEBEE),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFFFCDD2)),
                ),
                child: const Text(
                  'Esta actualización es requerida para continuar.',
                  style: TextStyle(
                    color: Colors.red, 
                    fontSize: 12, 
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
            
            const Text(
              'Novedades:',
              style: TextStyle(
                fontWeight: FontWeight.bold, 
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 6),
            
            Container(
              constraints: const BoxConstraints(maxHeight: 120),
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SingleChildScrollView(
                child: Text(
                  releaseNotes,
                  style: const TextStyle(fontSize: 13, color: Colors.black87),
                ),
              ),
            ),

            const SizedBox(height: 16),

            if (_isDownloading) ...[
              LinearProgressIndicator(
                value: _downloadProgress > 0 ? _downloadProgress / 100 : null,
                backgroundColor: const Color(0xFFE0E0E0),
                color: primaryGreen,
                minHeight: 8,
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _statusMessage,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Text(
                    '$_downloadProgress%',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],

            if (_hasError) ...[
              Text(
                _statusMessage,
                style: const TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ],
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        actions: [
          // if (!isMandatory && !_isDownloading)
          if (!_isDownloading)
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Más tarde', style: TextStyle(color: Colors.grey)),
            ),

          if (!_isDownloading)
            ElevatedButton(
              onPressed: _startUpdate,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), // Más padding horizontal
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
              child: Text(
                _hasError ? 'Reintentar' : 'Actualizar ahora',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    );
  }
}