import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scounter_mobile/features/shared/shared.dart';
import 'package:scounter_mobile/features/turnarounds/domain/domain.dart';
import 'package:scounter_mobile/features/turnarounds/presentation/providers/providers.dart';
import 'package:scounter_mobile/features/turnarounds/presentation/widgets/widgets.dart';

class VueloCalendarioDetalleDialog {
  /// Carga la información requerida de personal y muestra el diálogo con los datos de VueloCalendario.
  static Future<void> mostrar({
    required BuildContext context,
    required WidgetRef ref,
    required VueloCalendario vuelo,
  }) async {
    // 1. Mostrar Dialog de Carga
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
    );

    try {
      final trcId = vuelo.id;

      ref.read(trcIdProvider.notifier).state = vuelo.id;

      // Cargar personal asignado
      ref
          .read(departamentoPersonalProvider(trcId).notifier)
          .getDepartamentosConPersonal(trcId);

      await Future.wait([]);

      if (context.mounted) Navigator.of(context).pop();

      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) {
            final colorEstadoBorde =
                _obtenerColorEstatusLocal(vuelo.estatusVuelo, isBorder: true);
            final colorEstadoFondo =
                _obtenerColorEstatusLocal(vuelo.estatusVuelo, isBorder: false);
            final List<Color> coloresHeaderEstatus =
                _obtenerGradientHeaderPorEstatus(vuelo.estatusVuelo);

            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 24),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.82,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 16,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Column(
                    children: [
                      // --- ENCABEZADO HEADER ---
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: coloresHeaderEstatus,
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.flight_takeoff,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'VUELO ${vuelo.numeroVuelo.isNotEmpty ? vuelo.numeroVuelo : '---'}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                  if (vuelo.aerolineaNombre.isNotEmpty)
                                    Text(
                                      vuelo.aerolineaNombre,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.white70,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon:
                                  const Icon(Icons.close, color: Colors.white),
                              onPressed: () => Navigator.of(context).pop(),
                              tooltip: 'Cerrar',
                            ),
                          ],
                        ),
                      ),

                      // --- RESUMEN DE ESTATUS Y RUTA ---
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 5),
                              decoration: BoxDecoration(
                                color: colorEstadoFondo,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: colorEstadoBorde, width: 1.2),
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 4,
                                    backgroundColor: colorEstadoBorde,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    vuelo.estatusVuelo.isNotEmpty
                                        ? vuelo.estatusVuelo
                                        : 'Sin estado',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: colorEstadoBorde,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (vuelo.routing.isNotEmpty)
                              Row(
                                children: [
                                  const Icon(Icons.location_on_outlined,
                                      size: 16, color: Colors.black54),
                                  const SizedBox(width: 4),
                                  Text(
                                    vuelo.routing,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),

                      const Divider(
                          height: 1, thickness: 1, color: Colors.black12),

                      // --- CUERPO SCROLLABLE DEL DIÁLOGO ---
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // SECCIÓN 1: DATOS DEL VUELO (DESDE VUELOCALENDARIO)
                              _buildModernSectionCard(
                                title: 'Datos del Vuelo',
                                icon: Icons.info_outline_rounded,
                                child: _buildDatosVueloContent(vuelo),
                              ),

                              const SizedBox(height: 12),

                              // SECCIÓN 2: PERSONAL ASIGNADO
                              // _buildModernSectionCard(
                              //   title: 'Personal Asignado',
                              //   icon: Icons.people_alt_outlined,
                              //   child: Consumer(
                              //     builder: (context, refConsumer, _) {
                              //       final departamentosPersona =
                              //           refConsumer.watch(
                              //         departamentoPersonalProvider(trcId),
                              //       );
                              //       return PersonalDetalle(
                              //         departamentosPersona:
                              //             departamentosPersona
                              //                 .departamentoPersonalResponse,
                              //       );
                              //     },
                              //   ),
                              // ),
                              
                            ],
                          ),
                        ),
                      ),

                      // --- FOOTER CON BOTÓN EN VERDE ---
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          border: Border(
                              top: BorderSide(
                                  color: Colors.black12, width: 1)),
                        ),
                        alignment: Alignment.centerRight,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade800,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.check_circle_outline,
                              size: 18),
                          label: const Text(
                            'CERRAR',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }
    } catch (e) {
      if (context.mounted) Navigator.of(context).pop();
      if (context.mounted) {
        CustomSnackbar.showErrorSnackbar(
          'Error al cargar detalles del vuelo: $e',
          context,
        );
      }
    }
  }

  /// Construye la información del vuelo utilizando los campos de VueloCalendario
  static Widget _buildDatosVueloContent(VueloCalendario vuelo) {
    // Función auxiliar para extraer solo la hora HH:mm de un DateTime
    String formatearHora(DateTime? dateTime, String? fallback) {
      if (dateTime != null) {
        final hora = dateTime.hour.toString().padLeft(2, '0');
        final minuto = dateTime.minute.toString().padLeft(2, '0');
        return '$hora:$minuto';
      }
      return fallback ?? '--:--';
    }

    // Formatear horas tomando las variables DateTime principales
    final horaInicio = formatearHora(
      vuelo.horaInicioServicio,
      vuelo.horaInicioServicio_ ?? vuelo.vueloHoraInicio,
    );

    final horaFin = formatearHora(
      vuelo.horaFinServicio,
      vuelo.horaFinServicio_ ?? vuelo.vueloHoraFin,
    );

    final fecha = vuelo.auxFecha.isNotEmpty
        ? vuelo.auxFecha
        : (vuelo.trcFechaInicio ?? '---');

    return Column(
      children: [
        _buildInfoRow(
          icon: Icons.flight_outlined,
          label: 'Aerolínea',
          value: vuelo.aerolineaNombre.isNotEmpty
              ? vuelo.aerolineaNombre
              : '---',
        ),
        _buildInfoRow(
          icon: Icons.numbers_outlined,
          label: 'Nro. de Vuelo',
          value: vuelo.numeroVuelo.isNotEmpty ? vuelo.numeroVuelo : '---',
        ),
        _buildInfoRow(
          icon: Icons.alt_route_outlined,
          label: 'Routing',
          value: vuelo.routing.isNotEmpty ? vuelo.routing : '---',
        ),
        _buildInfoRow(
          icon: Icons.calendar_today_outlined,
          label: 'Fecha',
          value: fecha,
        ),
        _buildInfoRow(
          icon: Icons.access_time_outlined,
          label: 'Inicio de Servicio',
          value: horaInicio,
        ),
        _buildInfoRow(
          icon: Icons.access_time_filled_outlined,
          label: 'Fin de Servicio',
          value: horaFin,
        ),
        if (vuelo.estacionNombre.isNotEmpty)
          _buildInfoRow(
            icon: Icons.business_outlined,
            label: 'Estación',
            value: vuelo.estacionNombre,
          ),
      ],
    );
  }

  /// Fila de detalle clave-valor
  static Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.blueGrey.shade600),
          const SizedBox(width: 10),
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildModernSectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black.withOpacity(0.06)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFF34495E).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 18, color: const Color(0xFF2C3E50)),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Divider(height: 1, thickness: 0.8, color: Colors.black12),
          ),
          child,
        ],
      ),
    );
  }

  static List<Color> _obtenerGradientHeaderPorEstatus(String? estatus) {
    if (estatus == null) {
      return [Colors.blueGrey.shade700, Colors.blueGrey.shade900];
    }

    switch (estatus.trim()) {
      case 'No Abierto':
        return [Colors.grey.shade700, Colors.grey.shade900];
      case 'En Proceso':
        return [Colors.orange.shade700, Colors.orange.shade900];
      case 'Finalizado':
        return [Colors.green.shade700, Colors.green.shade900];
      case 'Cerrado':
        return [Colors.blue.shade700, Colors.blue.shade900];
      case 'Aprobado':
        return [Colors.teal.shade700, Colors.teal.shade900];
      case 'Rechazado':
        return [Colors.red.shade700, Colors.red.shade900];
      case 'Cancelado con ingreso':
        return [Colors.deepOrange.shade700, Colors.deepOrange.shade900];
      default:
        return [Colors.blueGrey.shade700, Colors.blueGrey.shade900];
    }
  }

  static Color _obtenerColorEstatusLocal(String? estatus,
      {bool isBorder = false}) {
    if (estatus == null) return isBorder ? Colors.grey : Colors.grey.shade100;

    switch (estatus.trim()) {
      case 'No Abierto':
        return isBorder ? Colors.black54 : Colors.grey.shade200;
      case 'En Proceso':
        return isBorder ? Colors.orange.shade800 : Colors.amber.shade50;
      case 'Finalizado':
        return isBorder ? Colors.green.shade800 : Colors.green.shade50;
      case 'Cerrado':
        return isBorder ? Colors.blue.shade800 : Colors.blue.shade50;
      case 'Aprobado':
        return isBorder ? Colors.teal.shade800 : Colors.teal.shade50;
      case 'Rechazado':
        return isBorder ? Colors.red.shade800 : Colors.red.shade50;
      case 'Cancelado con ingreso':
        return isBorder
            ? Colors.deepOrange.shade800
            : Colors.deepOrange.shade50;
      default:
        return isBorder ? Colors.blue.shade400 : Colors.blue.shade50;
    }
  }
}