import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:scounter_mobile/features/turnarounds/presentation/providers/providers.dart';
import 'package:scounter_mobile/features/turnarounds/presentation/widgets/widgets.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:scounter_mobile/features/turnarounds/domain/domain.dart';

import '../../shared.dart';

// import 'vuelo_calendario.dart'; // Tu modelo anterior
// 1. Cambia StatefulWidget por ConsumerStatefulWidget
class CalendarioVuelosWidget extends ConsumerStatefulWidget {
  final List<VueloCalendario> vuelos;
  final List<Estacion> estaciones;
  final Function(DateTime)? onMonthChanged;

  const CalendarioVuelosWidget({
    super.key,
    required this.vuelos,
    this.estaciones = const [],
    this.onMonthChanged,
  });

  @override
  ConsumerState<CalendarioVuelosWidget> createState() =>
      _CalendarioVuelosWidgetState();
}

// 2. Cambia State por ConsumerState
class _CalendarioVuelosWidgetState
    extends ConsumerState<CalendarioVuelosWidget> {
  // Ahora todas las funciones de este estado tienen acceso automático a 'ref'

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  int? _aerolineaFilter; // ID de aerolínea seleccionada (null = todas)
  int? _estacionFilter;

  @override
  void didUpdateWidget(covariant CalendarioVuelosWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Validar aerolínea
    if (_aerolineaFilter != null) {
      final existe = widget.vuelos.any(
        (v) => v.aerolineaId == _aerolineaFilter,
      );
      if (!existe) setState(() => _aerolineaFilter = null);
    }
  }

  // Obtener estaciones ordenadas alfabéticamente
  List<Estacion> get listadoEstaciones {
    final lista = List<Estacion>.from(widget.estaciones);
    lista.sort(
      (a, b) => a.nombre.toLowerCase().compareTo(b.nombre.toLowerCase()),
    );
    return lista;
  }

  // Filtrado combinado por Aerolínea y Estación
  List<VueloCalendario> get _vuelosFiltrados {
    return widget.vuelos.where((v) {
      // 1. Evalúa el filtro de aerolínea
      final cumpleAerolinea =
          _aerolineaFilter == null || v.aerolineaId == _aerolineaFilter;

      // 2. Evalúa el filtro de estación comparando con v.estacionId
      final cumpleEstacion =
          _estacionFilter == null || v.estacionId == _estacionFilter;

      return cumpleAerolinea && cumpleEstacion;
    }).toList();
  }

  // A continuación reemplazas tus dos getters actuales por estos:
  List<Map<String, dynamic>> get _listadoOriginalDeAerolineas {
    final seenIds = <int>{};
    return widget.vuelos
        .where((v) => v.aerolineaId != null && seenIds.add(v.aerolineaId!))
        .map(
          (v) => {
            'id': v.aerolineaId,
            'nombre': v.aerolineaNombre ?? 'Desconocida',
          },
        )
        .toList();
  }

  List<Map<String, dynamic>> get listadoAerolineas {
    final lista = _listadoOriginalDeAerolineas;

    lista.sort((a, b) {
      final nameA = (a['nombre'] as String? ?? '').toLowerCase();
      final nameB = (b['nombre'] as String? ?? '').toLowerCase();
      return nameA.compareTo(nameB);
    });

    return lista;
  }

  // Obtener aerolíneas únicas para el filtro
  // List<Map<String, dynamic>> get _listadoOriginalDeAerolineas {
  //   final seenIds = <int>{};
  //   return widget.vuelos
  //       .where((v) => v.aerolineaId != null && seenIds.add(v.aerolineaId!))
  //       .map(
  //         (v) => {
  //           'id': v.aerolineaId,
  //           'nombre': v.aerolineaNombre ?? 'Desconocida',
  //         },
  //       )
  //       .toList();
  // }

  //   List<Map<String, dynamic>> get listadoAerolineas {
  //   // 1. Obtenemos la lista base (ej. de tu estado o variable interna)
  //   final lista = _listadoOriginalDeAerolineas;

  //   // 2. Usamos .sort() comparando las cadenas de texto de 'aerolineaNombre'
  //   lista.sort((a, b) {
  //     final nameA = (a['aerolineaNombre'] as String? ?? '').toLowerCase();
  //     final nameB = (b['aerolineaNombre'] as String? ?? '').toLowerCase();
  //     return nameA.compareTo(nameB);
  //   });

  //   return lista;
  // }

  // Filtrar vuelos por aerolínea seleccionada
  // List<VueloCalendario> get _vuelosFiltrados {
  //   if (_aerolineaFilter == null) return widget.vuelos;
  //   return widget.vuelos
  //       .where((v) => v.aerolineaId == _aerolineaFilter)
  //       .toList();
  // }

  // Agrupar vuelos por la variable auxFecha para el calendario
  List<VueloCalendario> _getVuelosDelDia(DateTime day) {
    return _vuelosFiltrados.where((vuelo) {
      // Validamos que auxFecha no sea nulo
      if (vuelo.auxFecha == null || vuelo.auxFecha.isEmpty) return false;

      try {
        // Parseamos auxFecha (YYYY-MM-DD)
        final fechaVuelo = DateTime.parse(vuelo.auxFecha!);

        // Comparamos si es el mismo día ignorando la hora
        return isSameDay(fechaVuelo, day);
      } catch (e) {
        // En caso de que el formato de fecha no sea válido
        return false;
      }
    }).toList();
  }

  Color _obtenerColorEstatus(String? estatus, {bool isBorder = false}) {
    if (estatus == null) return Colors.blue.shade50;

    switch (estatus.trim()) {
      case 'No Abierto':
        return isBorder ? Colors.black54 : Colors.white;
      case 'En Proceso':
        return isBorder ? Colors.yellow.shade800 : Colors.yellow.shade100;
      case 'Finalizado':
        return isBorder ? Colors.green.shade800 : Colors.green.shade100;
      case 'Cerrado':
        return isBorder ? Colors.blue.shade800 : Colors.blue.shade100;
      case 'Aprobado':
        return isBorder ? Colors.grey.shade700 : Colors.grey.shade200;
      case 'Rechazado':
        return isBorder ? Colors.red.shade800 : Colors.red.shade100;
      case 'Cancelado con ingreso':
        return isBorder ? Colors.orange.shade800 : Colors.orange.shade100;
      default:
        return isBorder
            ? Colors.blue.shade300
            : Colors.blue.shade50; // Por defecto
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // _buildFiltros(),
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: TableCalendar<VueloCalendario>(
              locale:
                  'es', // <--- Esto cambiará "May" por "Mayo", "Mon" por "Lun", etc.
              // rowHeight: 110, // Mantenemos la altura para que se vea bien
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              // ESTA ES LA PROPIEDAD: Cambia el inicio al lunes
              startingDayOfWeek: StartingDayOfWeek.monday,

              // 1. Aumenta la altura de la fila (ajusta según necesites, 100-120 suele ser ideal para eventos)
              rowHeight:
                  125, // Aumentamos un poco más para que quepan los textos de 12px
              // ESTA ES LA CLAVE: Desactiva el cambio de formato por gesto vertical
              availableGestures: AvailableGestures.horizontalSwipe,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              eventLoader: _getVuelosDelDia,
              onFormatChanged: (format) =>
                  setState(() => _calendarFormat = format),
              onDaySelected: (selectedDay, focusedDay) {
                final vuelosDelDia = _getVuelosDelDia(selectedDay);
                if (vuelosDelDia.isNotEmpty) {
                  // Usamos el 'ref' expuesto por ConsumerState
                  ref
                      .read(turnaroundProvider.notifier)
                      .setSelectedDate(selectedDay);
                  _mostrarDetallesDia(selectedDay, vuelosDelDia);
                }
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },

              // 1. Forzamos a que el formato siempre sea mensual
              // calendarFormat: CalendarFormat.month,

              // 2. Personalizamos el encabezado para ocultar el botón
              headerStyle: const HeaderStyle(
                formatButtonVisible: false, // <--- ESTO OCULTA EL BOTÓN
                titleCentered: true, // Opcional: Centra el título "Mayo 2026"
                titleTextStyle: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // 2. Ajusta la altura del header de los días de la semana (Sun, Mon...)
              daysOfWeekHeight: 24,
              // 3. Estilo para mover el número del día hacia arriba y que no choque con los vuelos
              calendarStyle: CalendarStyle(
                cellAlignment:
                    Alignment.topCenter, // Alinea el número del día arriba
                cellMargin: EdgeInsets.all(4),
                selectedDecoration: BoxDecoration(
                  color: Colors.grey[200],
                  shape: BoxShape.circle,
                  border: null,
                ),
                todayDecoration: BoxDecoration(
                  color: Colors.blueGrey,
                  shape: BoxShape.circle,
                  border: null,
                ),
              ),

              // ESTA ES LA CLAVE: Se dispara al deslizar o usar flechas
              onPageChanged: (focusedDay) {
                setState(() {
                  _focusedDay = focusedDay;
                });
                // Notificamos al padre para que dispare la carga de la API
                if (widget.onMonthChanged != null) {
                  widget.onMonthChanged!(focusedDay);
                }
              },

              calendarBuilders: CalendarBuilders(
                // Días del mes normal
                defaultBuilder: (context, day, focusedDay) =>
                    _buildDayCell(day, Colors.transparent, Colors.black87),

                // Días fuera del mes (el cambio que pediste)
                outsideBuilder: (context, day, focusedDay) => _buildDayCell(
                  day,
                  Colors.transparent,
                  Colors.grey.shade400,
                ),

                // Día actual
                todayBuilder: (context, day, focusedDay) => _buildDayCell(
                  day,
                  Colors.blueGrey.shade50,
                  Colors.blueGrey.shade900,
                ),

                // Día seleccionado
                selectedBuilder: (context, day, focusedDay) => _buildDayCell(
                  day,
                  Colors.blue.shade50,
                  Colors.blue.shade900,
                ),

                // 4. Tu markerBuilder existente
                markerBuilder: (context, date, events) {
                  if (events.isEmpty) return const SizedBox();
                  return Positioned(
                    top: 35, // Asegúrate de que empiece debajo del número
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        ...events
                            .take(2)
                            .map((v) => _vueloItemMini(v))
                            .toList(),
                        if (events.length > 2)
                          const SizedBox(
                            height: 2,
                          ), // Espacio antes del "+X más"
                        if (events.length > 2)
                          Text(
                            "+${events.length - 2} más...",
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),

              // Personalización de la celda
              // calendarBuilders: CalendarBuilders(
              //   markerBuilder: (context, date, events) {
              //     if (events.isEmpty) return const SizedBox();
              //     return _buildCustomCellContent(events);
              //   },
              // ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDayCell(DateTime day, Color highlightColor, Color textColor) {
    return Container(
      alignment: Alignment.topCenter,
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: highlightColor,
        borderRadius: BorderRadius.circular(8),
        border:
            (highlightColor != Colors.transparent &&
                highlightColor != Colors.blueGrey.shade50)
            ? Border.all(color: Colors.blue.shade200, width: 1)
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Text(
          '${day.day}',
          style: TextStyle(
            fontSize: 14, // Tamaño consistente para todos
            fontWeight: highlightColor != Colors.transparent
                ? FontWeight.bold
                : FontWeight.normal,
            color: textColor, // Gris claro para los días de fuera
          ),
        ),
      ),
    );
  }

  // Widget _buildDayCell(DateTime day, Color highlightColor, Color textColor) {
  //   return Container(
  //     alignment: Alignment.topCenter,
  //     margin: const EdgeInsets.all(4),
  //     decoration: BoxDecoration(
  //       color: highlightColor,
  //       borderRadius: BorderRadius.circular(8),
  //       // Si quieres un borde cuando esté seleccionado
  //       border: highlightColor != Colors.transparent
  //           ? Border.all(color: Colors.blue.shade300, width: 1)
  //           : null,
  //     ),
  //     child: Padding(
  //       padding: const EdgeInsets.only(top: 6),
  //       child: Text(
  //         '${day.day}',
  //         style: TextStyle(
  //           fontSize: 14,
  //           fontWeight: highlightColor != Colors.transparent
  //               ? FontWeight.bold
  //               : FontWeight.normal,
  //           color: highlightColor != Colors.transparent
  //               ? Colors.blue.shade900
  //               : Colors.black87,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildFiltros() {
    // Validar aerolínea seleccionada
    final aerolineas = listadoAerolineas;
    final bool aeroValueExists = aerolineas.any(
      (aero) => aero['id'] == _aerolineaFilter,
    );
    final int? selectedAeroValue = aeroValueExists ? _aerolineaFilter : null;

    // Validar estación seleccionada
    final estaciones = listadoEstaciones;
    final bool estValueExists = estaciones.any((e) => e.id == _estacionFilter);
    final int? selectedEstValue = estValueExists ? _estacionFilter : null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Row(
        children: [
          // Dropdown 1: Aerolínea
          Expanded(
            child: DropdownButtonFormField<int?>(
              value: selectedAeroValue,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'Aerolínea',
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(fontSize: 14, color: Colors.black87),
              items: [
                const DropdownMenuItem(value: null, child: Text("Todas")),
                ...aerolineas.map(
                  (aero) => DropdownMenuItem<int?>(
                    value: aero['id'],
                    child: Text(
                      aero['nombre'],
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
              onChanged: (val) => setState(() => _aerolineaFilter = val),
            ),
          ),
          const SizedBox(width: 10),

          // Dropdown 2: Estación
          Expanded(
            child: DropdownButtonFormField<int?>(
              value: selectedEstValue,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'Estación',
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(fontSize: 14, color: Colors.black87),
              items: [
                const DropdownMenuItem(value: null, child: Text("Todas")),
                ...estaciones.map(
                  (est) => DropdownMenuItem<int?>(
                    value: est.id,
                    child: Text(est.nombre, overflow: TextOverflow.ellipsis),
                  ),
                ),
              ],
              onChanged: (val) => setState(() => _estacionFilter = val),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomCellContent(List<VueloCalendario> vuelos) {
    return Positioned(
      bottom: 1,
      left: 0,
      right: 0,
      child: Column(
        children: vuelos.take(2).map((vuelo) => _vueloItemMini(vuelo)).toList(),
      ),
    );
  }

  Widget _vueloItemMini(VueloCalendario vuelo) {
    final Color backgroundColor = _obtenerColorEstatus(
      vuelo.estatusVuelo,
      isBorder: false,
    );
    final Color borderColor = _obtenerColorEstatus(
      vuelo.estatusVuelo,
      isBorder: true,
    );

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor, width: 1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          // Icon(Icons.airplanemode_active, size: 14, color: borderColor),
          // const SizedBox(width: 6),
          //  Image.network(
          //   vuelo.imagenLogo ?? '',
          //   width: 14,
          //   height: 14,
          //   errorBuilder: (_, __, ___) =>
          //       Icon(Icons.airplanemode_active, size: 14, color: borderColor),
          // ),
          Expanded(
            child: Text(
              vuelo.numeroVuelo ?? '',
              style: TextStyle(
                fontSize: 12, // Tamaño solicitado
                fontWeight: FontWeight.bold,
                color: vuelo.estatusVuelo == 'No Abierto'
                    ? Colors.black87
                    : borderColor,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  void _mostrarDetallesDia(DateTime date, List<VueloCalendario> vuelos) {
    String fechaFormateada = DateFormat("d 'de' MMMM, y", "es_ES").format(date);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        titlePadding: EdgeInsets.zero,
        title: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.blueGrey.shade50,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Row(
            children: [
              const Icon(Icons.calendar_month, color: Colors.blueGrey),
              const SizedBox(width: 12),
              Text(
                fechaFormateada,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: vuelos.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
  final vuelo = vuelos[index];
  
  // 1. Obtener los colores del estado
  final colorFondo = _obtenerColorEstatus(
    vuelo.estatusVuelo,
    isBorder: false,
  );
  final colorBorde = _obtenerColorEstatus(
    vuelo.estatusVuelo,
    isBorder: true,
  );

  return InkWell(
    onTap: () async {
      Navigator.of(context).pop();
      await _cargarYMostrarDetalleVuelo(context, vuelo);
    },
    child: Container(
      decoration: BoxDecoration(
        color: colorFondo, // <--- Aplicar el color de fondo del estado
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorBorde, width: 1.5), // <--- Aplicar borde del estado
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: IntrinsicHeight(
          child: Row(
            children: [
              // Indicador lateral grueso del color de estado
              Container(
                width: 6,
                color: colorBorde,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            vuelo.numeroVuelo ?? '---',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              letterSpacing: 1.1,
                              color: Colors.black87, // <--- Restablecido a color visible
                              // color: vuelo.estatusVuelo == 'No Abierto'
                              //     ? Colors.black87
                              //     : colorBorde,
                            ),
                          ),
                          // Etiqueta visual con el nombre del estatus
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: colorBorde.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              vuelo.estatusVuelo ?? 'Sin estado',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: colorBorde,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 16,
                            color: Colors.grey.shade700,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            vuelo.routing ?? 'Ruta no definida',
                            style: TextStyle(
                              color: Colors.grey.shade800,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "CERRAR",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _cargarYMostrarDetalleVuelo(
  BuildContext context,
  VueloCalendario vuelo,
) async {
  // 1. Mostrar Dialog de Carga
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const Center(child: CircularProgressIndicator()),
  );

  try {
    final trcId = vuelo.id;

    ref.read(trcIdProvider.notifier).state = vuelo.id;

    final TurnaroundMain? selectedTurnaround = ref
        .read(turnaroundProvider.notifier)
        .getTurnaroundFromStateById(vuelo.id);

    ref
        .read(departamentoPersonalProvider(trcId).notifier)
        .getDepartamentosConPersonal(trcId);

    await Future.wait([]);

    if (context.mounted) Navigator.of(context).pop();

    if (context.mounted) {
      showDialog(
        context: context,
        builder: (context) => Dialog(
          backgroundColor: Colors.white,
          // Reducimos los márgenes exteriores del diálogo para ganar espacio horizontal
          insetPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.85,
              child: Column(
                children: [
                  // --- ENCABEZADO PRINCIPAL ---
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.flight_takeoff,
                              color: Colors.blueGrey,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Detalle de Vuelo ${vuelo.numeroVuelo ?? ''}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.black54),
                          onPressed: () => Navigator.of(context).pop(),
                          tooltip: 'Cerrar',
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, thickness: 1),

                  // --- CUERPO SCROLLABLE (MAXIMIZADO VERTICAL Y HORIZONTALMENTE) ---
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      // Padding mínimo en los bordes de solo 8px para aprovechar la pantalla
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 12.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // --- SECCIÓN 1: DATOS DEL VUELO ---
                          _buildSectionHeader(
                            title: 'Datos del Vuelo',
                            icon: Icons.info_outline,
                          ),
                          Consumer(
                            builder: (context, refConsumer, _) {
                              final controlActividades = refConsumer
                                  .watch(controlActividadesProvider(trcId))
                                  .controlActividades;
                              return VueloDetalle(
                                controlActividades: controlActividades,
                                turnaround: selectedTurnaround,
                                isTurnarond: true,
                              );
                            },
                          ),

                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            child: Divider(thickness: 1, height: 1),
                          ),

                          // --- SECCIÓN 2: CONTROL DE ACTIVIDADES ---
                          // _buildSectionHeader(
                          //   title: 'Control de Actividades',
                          //   icon: Icons.assignment_outlined,
                          // ),
                          // Consumer(
                          //   builder: (context, refConsumer, _) {
                          //     final turnaround = refConsumer.watch(
                          //       selectedTurnaroundProvider,
                          //     );
                          //     final controlActividades = refConsumer
                          //         .watch(controlActividadesProvider(trcId))
                          //         .controlActividades;
                          //     return ControlActividadesDetalle(
                          //       controlActividades: controlActividades,
                          //       turnaround: turnaround,
                          //     );
                          //   },
                          // ),

                          // const Padding(
                          //   padding: EdgeInsets.symmetric(vertical: 16.0),
                          //   child: Divider(thickness: 1, height: 1),
                          // ),

                          // --- SECCIÓN 3: PERSONAL ASIGNADO ---
                          _buildSectionHeader(
                            title: 'Personal Asignado',
                            icon: Icons.people_outline,
                          ),
                          Consumer(
                            builder: (context, refConsumer, _) {
                              final departamentosPersona = refConsumer.watch(
                                departamentoPersonalProvider(trcId),
                              );
                              return PersonalDetalle(
                                departamentosPersona: departamentosPersona
                                    .departamentoPersonalResponse,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  // --- PIE CON BOTÓN DE SALIDA ---
                  const Divider(height: 1, thickness: 1),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    color: Colors.white,
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.exit_to_app, color: Colors.blueGrey),
                      label: const Text(
                        'SALIR',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87, // <--- Restablecido a color visible
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
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

// En lugar de una Card contenedora, usamos una línea de título con un subtil indicador visual
Widget _buildSectionHeader({
  required String title,
  required IconData icon,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12.0, left: 4.0, right: 4.0),
    child: Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: Colors.blueGrey,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Icon(icon, size: 20, color: Colors.blueGrey),
        const SizedBox(width: 6),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87, // <--- Restablecido a color oscuro visible
            letterSpacing: 0.3,
          ),
        ),
      ],
    ),
  );
}

// Widget auxiliar para empaquetar cada sección dentro de una Card limpia con márgenes
Widget _buildCardWrapper({
  required String title,
  required IconData icon,
  required Widget child,
}) {
  return Card(
    elevation: 0,
    color: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(color: Colors.grey.shade300, width: 1),
    ),
    child: Padding(
      padding: const EdgeInsets.all(14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: Colors.blueGrey),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    ),
  );
}
  
  
  // Widget _vueloItemMini(VueloCalendario vuelo) {
  //   const String defaultImg = "https://via.placeholder.com/20";
  //   // Si la imagen es path relativo, concatenar tu base URL
  //   final String imageUrl = (vuelo.imagen != null && vuelo.imagen!.isNotEmpty)
  //       ? "https://tu-dominio.com${vuelo.imagen}"
  //       : defaultImg;

  //   return Container(
  //     margin: const EdgeInsets.symmetric(vertical: 1),
  //     padding: const EdgeInsets.symmetric(horizontal: 2),
  //     decoration: BoxDecoration(
  //       color: Colors.blue.withOpacity(0.1),
  //       borderRadius: BorderRadius.circular(4),
  //     ),
  //     child: Row(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         Image.network(imageUrl, width: 12, height: 12, errorBuilder: (_, __, ___) => const Icon(Icons.airplanemode_active, size: 12)),
  //         const SizedBox(width: 2),
  //         Flexible(
  //           child: Text(
  //             vuelo.numeroVuelo ?? '',
  //             style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold),
  //             overflow: TextOverflow.ellipsis,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
