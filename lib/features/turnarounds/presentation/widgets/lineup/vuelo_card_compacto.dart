import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scounter_mobile/config/config.dart';
import 'package:scounter_mobile/features/turnarounds/domain/domain.dart';

class VueloCompactCard extends StatelessWidget {
  final VueloLineup vuelo;

  const VueloCompactCard({super.key, required this.vuelo});

  Color _obtenerColorEstatus(String? colorString) {
    if (colorString == null) return const Color(0xFF0FA45F);

    switch (colorString.toLowerCase().trim()) {
      case 'verde':
        return const Color(0xFF0FA45F);
      case 'amarillo':
        return Colors.amber;
      case 'azul':
        return Colors.blue;
      case 'rojo':
        return Colors.red;
      case 'naranja':
        return Colors.orange;
      case 'gris':
        return Colors.grey.shade500;
      case 'blanco':
        return Colors.grey.shade300;
      default:
        return const Color(0xFF0FA45F);
    }
  }

  String _formatearNombre(String? primerNombre, String? primerApellido) {
    final completo = '${primerNombre ?? ''} ${primerApellido ?? ''}'.trim().toLowerCase();
    if (completo.isEmpty) return '';

    return completo
        .split(' ')
        .where((str) => str.isNotEmpty)
        .map((str) => '${str[0].toUpperCase()}${str.substring(1)}')
        .join(' ');
  }

  void _mostrarDetalleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _VueloDetalleDialog(
        vuelo: vuelo,
        colorEstatus: _obtenerColorEstatus(vuelo.estatusColor),
        formatearNombre: _formatearNombre,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final maxCardWidth = MediaQuery.of(context).size.width * 0.43;
    const colorVerdeBase = Color(0xFF0FA45F);
    final colorEstatus = _obtenerColorEstatus(vuelo.estatusColor);

    final String baseUrl = Environment.apiUrl;
    final String urlImagen = '$baseUrl/aerolineas${vuelo.imagen ?? ''}';

    final ordenDepartamentos = ['OPS', 'DES', 'IT'];
    final personalMap = vuelo.personal;

    return Container(
      width: maxCardWidth,
      margin: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey.shade200, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        color: colorVerdeBase.withOpacity(0.03),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _mostrarDetalleDialog(context),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                decoration: BoxDecoration(
                  border: Border(left: BorderSide(color: colorEstatus, width: 4)),
                ),
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Cabecera: Horas e Icono
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: (vuelo.imagen != null && vuelo.imagen!.isNotEmpty)
                              ? Image.network(
                                  urlImagen,
                                  width: 20,
                                  height: 20,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.flight_takeoff, size: 16, color: colorVerdeBase);
                                  },
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(strokeWidth: 1.5, color: colorVerdeBase),
                                    );
                                  },
                                )
                              : const Icon(Icons.flight_takeoff, size: 16, color: colorVerdeBase),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            '${vuelo.vueloHoraInicio ?? '--:--'} - ${vuelo.vueloHoraFin ?? '--:--'}',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 15,
                              color: Colors.blueGrey[800],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    // Número de Vuelo
                    Text(
                      vuelo.numeroVuelo ?? '',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Colors.grey.shade800,
                      ),
                    ),

                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.0),
                      child: Divider(height: 1, thickness: 0.5, color: Color(0xFFE0E0E0)),
                    ),

                    // Despliegue de Personal con Jerarquía Distinguible
                    if (personalMap == null || personalMap.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Center(
                          child: Text(
                            'Sin asignar',
                            style: TextStyle(fontSize: 11, color: Colors.grey, fontStyle: FontStyle.italic),
                          ),
                        ),
                      )
                    else
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: ordenDepartamentos.map((codigoArea) {
                          final areaData = personalMap[codigoArea];
                          if (areaData == null) return const SizedBox.shrink();

                          final rolesConfig = [
                            {
                              'titulo': 'Gerente',
                              'items': areaData.gerente,
                              'colorBadge': const Color.fromRGBO(211, 47, 47, 1),
                              'bgBadge': const Color(0xFFDBEAFE),
                            },
                            {
                              'titulo': 'Supervisor',
                              'items': areaData.supervisor,
                              'colorBadge': const Color.fromRGBO(237, 108, 2, 1),
                              'bgBadge': const Color(0xFFFFEDD5),
                            },
                            {
                              'titulo': 'Personal',
                              'items': areaData.personal,
                              'colorBadge': Theme.of(context).colorScheme.primary,
                              'bgBadge': Colors.grey.shade200,
                            },
                          ];

                          final tienePersonal = rolesConfig.any((role) => (role['items'] as List).isNotEmpty);
                          if (!tienePersonal) return const SizedBox.shrink();

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 6.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  codigoArea,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.grey.shade900,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                ...rolesConfig.map((role) {
                                  final String tituloCargo = role['titulo'] as String;
                                  final List<PersonalItem> listaItems = role['items'] as List<PersonalItem>;
                                  final Color colorBadge = role['colorBadge'] as Color;

                                  if (listaItems.isEmpty) return const SizedBox.shrink();

                                  return Padding(
                                    padding: const EdgeInsets.only(left: 4.0, top: 3.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          tituloCargo,
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w800,
                                            color: colorBadge,
                                            letterSpacing: 0.3,
                                          ),
                                        ),
                                        const SizedBox(height: 1),
                                        ...listaItems.map((persona) {
                                          final nombreMostrar = persona.nombreCompleto ??
                                              _formatearNombre(persona.per1erNombre, persona.per1erApellido);

                                          return Padding(
                                            padding: const EdgeInsets.only(left: 6.0, top: 1.0),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 3,
                                                  height: 3,
                                                  decoration: BoxDecoration(
                                                    color: colorBadge.withOpacity(0.7),
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                                const SizedBox(width: 4),
                                                Expanded(
                                                  child: Text(
                                                    nombreMostrar.isNotEmpty ? nombreMostrar : 'Sin nombre',
                                                    style: const TextStyle(
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.w500,
                                                      color: Colors.black87,
                                                    ),
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 1,
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
                        }).toList(),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// --- WIDGET DEL DIÁLOGO DETALLADO ---
class _VueloDetalleDialog extends StatelessWidget {
  final VueloLineup vuelo;
  final Color colorEstatus;
  final String Function(String?, String?) formatearNombre;

  const _VueloDetalleDialog({
    required this.vuelo,
    required this.colorEstatus,
    required this.formatearNombre,
  });

  String _formatearFecha(DateTime? dateTime) {
    if (dateTime == null) return 'N/A';
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }

  String _formatearFechaHora(DateTime? dateTime) {
    if (dateTime == null) return 'N/A';
    return DateFormat('HH:mm').format(dateTime); // Muestra solo la hora
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
                              fontSize: 20, // Fuente más grande
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Vuelo: ${vuelo.numeroVuelo ?? 'N/A'}',
                            style: TextStyle(
                              fontSize: 16, // Fuente más grande
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

                // FECHA DE SERVICIO (Agregada antes de inicio de servicio)
                _buildInfoItem(
                  icon: Icons.calendar_today_outlined,
                  label: 'Fecha',
                  value: _formatearFecha(inicioServicio),
                ),
                const SizedBox(height: 10),

                _buildInfoItem(
                  icon: Icons.play_circle_outline,
                  label: 'Inicio Servicio',
                  value: _formatearFechaHora(inicioServicio),
                ),
                const SizedBox(height: 10),

                _buildInfoItem(
                  icon: Icons.stop_circle_outlined,
                  label: 'Fin Servicio',
                  value: _formatearFechaHora(finServicio),
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
                    fontSize: 18, // Fuente más grande
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
                              fontSize: 17, // Fuente más grande
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
                                      fontSize: 16, // Fuente más grande
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
                                              style: const TextStyle(fontSize: 18), // Fuente más grande
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
              style: const TextStyle(color: Colors.black87, fontSize: 15), // Fuente más grande
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