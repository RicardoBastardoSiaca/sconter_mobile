import 'package:flutter/material.dart';
import '../../domain/entities/vuelo_calendario.dart';

class VueloDetalleDialog extends StatelessWidget {
  final VueloCalendario vuelo;

  const VueloDetalleDialog({super.key, required this.vuelo});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 5,
      backgroundColor: Colors.white,
      child: Container(
        padding: const EdgeInsets.all(16), // Reducido un poco para ganar espacio vertical
        // Agregamos una restricción máxima para que en pantallas pequeñas de landscape no intente medir más de lo físico
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85, 
          maxWidth: 400, // Mantenemos un ancho elegante
        ),
        child: Column(
  mainAxisSize: MainAxisSize.min, // Fuerza a la columna a medir lo mínimo posible
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    // 1. ENCABEZADO FIJO
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              Icon(Icons.flight_takeoff, color: Theme.of(context).primaryColor, size: 22),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Vuelo ${vuelo.numeroVuelo ?? 'N/A'}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        // IconButton(
        //   padding: EdgeInsets.zero,
        //   constraints: const BoxConstraints(),
        //   icon: const Icon(Icons.close, color: Colors.grey, size: 22),
        //   onPressed: () => Navigator.of(context).pop(),
        // ),
      ],
    ),
    const Divider(height: 16, thickness: 1),

    // 2. CUERPO CON FLEXIBLE (Cambia Expanded por Flexible)
    Flexible( // <--- CAMBIO CRÍTICO AQUÍ
      child: SingleChildScrollView(
      // physics para comportamiento consistente en Android
      physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            _buildDetailRow(
              icon: Icons.business, 
              label: "Aerolínea", 
              value: vuelo.aerolineaNombre ?? "No especificada"
            ),
            const SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(
                  child: _buildDetailRow(
                    icon: Icons.access_time, 
                    label: "Hora de Inicio", 
                    value: vuelo.horaInicio ?? "--:--"
                  ),
                ),
                Expanded(
                  child: _buildDetailRow(
                    icon: Icons.access_time_filled, 
                    label: "Hora Fin", 
                    value: vuelo.horaFin ?? "--:--"
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildDetailRow(
                    icon: Icons.door_sliding,
                    label: "Puerta",
                    value: vuelo.gate?.toString() ?? "Por asignar",
                  ),
                ),
                Expanded(
                  child: _buildDetailRow(
                    icon: Icons.location_on, 
                    label: "Estación / Destino", 
                    value: "${vuelo.lugarSalidaIata ?? ''} ➔ ${vuelo.lugarDestinoIata ?? ''}"
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
    
    // Cambiamos el Divider por un espacio sutil si no hay scroll
    const SizedBox(height: 16), 

    // 3. BOTÓN FIJO ABAJO
    SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(vertical: 10),
        ),
        onPressed: () => Navigator.of(context).pop(),
        child: const Text("Cerrar", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ),
    ),
  ],
),
      ),
    );
  }

  Widget _buildDetailRow({required IconData icon, required String label, required String value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14, 
                  color: Colors.grey[500], 
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5
                ),
              ),
              const SizedBox(height: 1),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18, 
                  color: Colors.black87, 
                  fontWeight: FontWeight.w600
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}