import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scounter_mobile/config/config.dart';
import 'package:scounter_mobile/features/turnarounds/domain/domain.dart';



// --- WIDGET DEL DIÁLOGO DETALLADO ---
class VueloDetalleLineupDialog extends StatelessWidget {
  final VueloLineup vuelo;
  final Color colorEstatus;
  final String Function(String?, String?) formatearNombre;

  const VueloDetalleLineupDialog({
    required this.vuelo,
    required this.colorEstatus,
    required this.formatearNombre,
  });

  // Formateador para obtener solo la Fecha (dd/MM/yyyy)
  String _formatearFecha(DateTime? dateTime) {
    if (dateTime == null) return 'N/A';
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }

  // Formateador para obtener solo la Hora (HH:mm)
  String _formatearHora(DateTime? dateTime) {
    if (dateTime == null) return 'N/A';
    return DateFormat('HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    const colorVerdeBase = Color(0xFF0FA45F);
    final String baseUrl = Environment.apiUrl;
    final String urlImagen = '$baseUrl/aerolineas${vuelo.imagen ?? ''}';

    // 1. Horas de Servicio (reales con prioridad, fallback a las teóricas/planificadas)
    final inicioServicio = vuelo.horaInicioServicioReal ?? vuelo.horaInicioServicio;
    final finServicio = vuelo.horaFinServicioReal ?? vuelo.horaFinServicio;

    // 2. Ruta formateada: (estacionNombre - lugarDestinoIata)
    final estacion = vuelo.estacionNombre ?? 'N/A';
    final destino = vuelo.lugarDestinoIata ?? 'N/A';
    final ruta = '$estacion - $destino';

    final ordenDepartamentos = ['OPS', 'DES', 'IT'];
    final personalMap = vuelo.personal;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: colorEstatus, width: 6)),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Cabecera con Imagen a la izquierda, Aerolínea y Número de Vuelo
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Imagen de la Aerolínea
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: (vuelo.imagen != null && vuelo.imagen!.isNotEmpty)
                          ? Image.network(
                              urlImagen,
                              width: 36,
                              height: 36,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.flight_takeoff, size: 28, color: colorVerdeBase);
                              },
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return const SizedBox(
                                  width: 28,
                                  height: 28,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: colorVerdeBase),
                                );
                              },
                            )
                          : const Icon(Icons.flight_takeoff, size: 28, color: colorVerdeBase),
                    ),
                    const SizedBox(width: 12),

                    // Nombre de Aerolínea y Número de Vuelo
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            vuelo.aerolineaNombre ?? 'Aerolínea',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Vuelo: ${vuelo.numeroVuelo ?? 'N/A'}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade800,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    IconButton(
                      icon: const Icon(Icons.close, size: 24),
                      onPressed: () => Navigator.of(context).pop(),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),

                const Divider(height: 24, thickness: 1),

                // DETALLES DEL VUELO
                _buildInfoItem(
                  icon: Icons.alt_route,
                  label: 'Ruta',
                  value: ruta,
                ),
                const SizedBox(height: 10),

                // 1. Horas de vuelo comentadas según requerimiento
                /*
                _buildInfoItem(
                  icon: Icons.flight_takeoff,
                  label: 'Horas de Vuelo',
                  value: '${vuelo.vueloHoraInicio ?? '--:--'} - ${vuelo.vueloHoraFin ?? '--:--'}',
                ),
                const SizedBox(height: 10),
                */

                // 2. Fila de Fecha agregada desde horaInicioServicio
                _buildInfoItem(
                  icon: Icons.calendar_today_outlined,
                  label: 'Fecha',
                  value: _formatearFecha(inicioServicio),
                ),
                const SizedBox(height: 10),

                // 3. Inicio y Fin de servicio mostrando ÚNICAMENTE la hora
                _buildInfoItem(
                  icon: Icons.play_circle_outline,
                  label: 'Inicio Servicio',
                  value: _formatearHora(inicioServicio),
                ),
                const SizedBox(height: 10),

                _buildInfoItem(
                  icon: Icons.stop_circle_outlined,
                  label: 'Fin Servicio',
                  value: _formatearHora(finServicio),
                ),

                if (vuelo.terminal?.nombre != null) ...[
                  const SizedBox(height: 10),
                  _buildInfoItem(
                    icon: Icons.place_outlined,
                    label: 'Terminal',
                    value: vuelo.terminal!.nombre!,
                  ),
                ],

                const Divider(height: 28, thickness: 1),

                // PERSONAL ASIGNADO
                const Text(
                  'Personal Asignado',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0FA45F),
                  ),
                ),
                const SizedBox(height: 10),

                if (personalMap == null || personalMap.isEmpty)
                  const Text(
                    'Sin personal asignado.',
                    style: TextStyle(fontSize: 14, color: Colors.grey, fontStyle: FontStyle.italic),
                  )
                else
                  ...ordenDepartamentos.map((codigoArea) {
                    final areaData = personalMap[codigoArea];
                    if (areaData == null) return const SizedBox.shrink();

                    final rolesConfig = [
                      {
                        'titulo': 'Gerente',
                        'items': areaData.gerente,
                        'colorBadge': const Color.fromRGBO(211, 47, 47, 1),
                      },
                      {
                        'titulo': 'Supervisor',
                        'items': areaData.supervisor,
                        'colorBadge': const Color.fromRGBO(237, 108, 2, 1),
                      },
                      {
                        'titulo': 'Personal',
                        'items': areaData.personal,
                        'colorBadge': Theme.of(context).colorScheme.primary,
                      },
                    ];

                    final tienePersonal = rolesConfig.any((role) => (role['items'] as List).isNotEmpty);
                    if (!tienePersonal) return const SizedBox.shrink();

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            codigoArea,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: Colors.grey.shade900,
                            ),
                          ),
                          ...rolesConfig.map((role) {
                            final String tituloCargo = role['titulo'] as String;
                            final List<PersonalItem> listaItems = role['items'] as List<PersonalItem>;
                            final Color colorBadge = role['colorBadge'] as Color;

                            if (listaItems.isEmpty) return const SizedBox.shrink();

                            return Padding(
                              padding: const EdgeInsets.only(left: 6.0, top: 4.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    tituloCargo,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: colorBadge,
                                    ),
                                  ),
                                  ...listaItems.map((persona) {
                                    final nombreMostrar = persona.nombreCompleto ??
                                        formatearNombre(persona.per1erNombre, persona.per1erApellido);

                                    return Padding(
                                      padding: const EdgeInsets.only(left: 8.0, top: 3.0),
                                      child: Row(
                                        children: [
                                          Icon(Icons.person, size: 16, color: colorBadge.withOpacity(0.8)),
                                          const SizedBox(width: 6),
                                          Expanded(
                                            child: Text(
                                              nombreMostrar.isNotEmpty ? nombreMostrar : 'Sin nombre',
                                              style: const TextStyle(fontSize: 14.5),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    );
                  }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 22, color: const Color(0xFF0FA45F)),
        const SizedBox(width: 10),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.black87, fontSize: 15),
              children: [
                TextSpan(
                  text: '$label: ',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: value),
              ],
            ),
          ),
        ),
      ],
    );
  }
}