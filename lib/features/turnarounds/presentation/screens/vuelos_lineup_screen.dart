import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:scounter_mobile/features/shared/shared.dart';
import 'package:scounter_mobile/features/turnarounds/domain/domain.dart';
import 'package:scounter_mobile/features/turnarounds/presentation/providers/providers.dart';
import 'package:scounter_mobile/features/turnarounds/presentation/widgets/widgets.dart';

class _DatePickerHeader extends ConsumerWidget {
  const _DatePickerHeader();

  DateTime _calcularInicioSemana(DateTime fecha) {
    return fecha.subtract(Duration(days: fecha.weekday - 1));
  }

  void _actualizarRangoSemanas(WidgetRef ref, DateTime lunesIncio) {
    final domingoFin = lunesIncio.add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));
    ref.read(vuelosLineupProvider.notifier).updateDateRange(
      VueloLineupRequest(start: lunesIncio, end: domingoFin),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(vuelosLineupProvider);
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    const colorVerde = Color(0xFF0FA45F);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 16, color: colorVerde),
            onPressed: () {
              final nuevoInicio = state.startDate.subtract(const Duration(days: 7));
              _actualizarRangoSemanas(ref, nuevoInicio);
            },
          ),
          InkWell(
            onTap: () async {
              final DateTime? fechaSeleccionada = await showDatePicker(
                context: context,
                initialDate: state.startDate,
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
                helpText: 'SELECCIONA UNA FECHA',
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.light(primary: colorVerde),
                    ),
                    child: child!,
                  );
                },
              );

              if (fechaSeleccionada != null) {
                final lunesDeSemanaSeleccionada = _calcularInicioSemana(fechaSeleccionada);
                _actualizarRangoSemanas(ref, lunesDeSemanaSeleccionada);
              }
            },
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${formatter.format(state.startDate)} - ${formatter.format(state.endDate)}',
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Colors.black87),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.calendar_month_outlined, size: 18, color: colorVerde),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios, size: 16, color: colorVerde),
            onPressed: () {
              final nuevoInicio = state.startDate.add(const Duration(days: 7));
              _actualizarRangoSemanas(ref, nuevoInicio);
            },
          ),
        ],
      ),
    );
  }
}

class VuelosLineupScreen extends ConsumerStatefulWidget {
  const VuelosLineupScreen({super.key});

  @override
  ConsumerState<VuelosLineupScreen> createState() => _VuelosLineupScreenState();
}

class _VuelosLineupScreenState extends ConsumerState<VuelosLineupScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();
  final Map<String, GlobalKey> _dayKeys = {};

  bool _mostrarFiltros = true; // Controla la visibilidad de los filtros (visible al iniciar)

  // Filtros locales
  String? _aerolineaSeleccionada;
  String? _estacionSeleccionada;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(ciudadesProvider.notifier).cargarEstaciones();
      
      final state = ref.read(vuelosLineupProvider);
      if (state.vuelos.isEmpty) {
        final now = DateTime.now();
        final lunesActual = now.subtract(Duration(days: now.weekday - 1));
        final domingoActual = lunesActual.add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));
        
        ref.read(vuelosLineupProvider.notifier).updateDateRange(
          VueloLineupRequest(start: lunesActual, end: domingoActual),
        );
      } else {
        ref.read(vuelosLineupProvider.notifier).fetchVuelos(
          VueloLineupRequest(start: state.startDate, end: state.endDate),
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _mostrarBuscadorAerolineas(BuildContext context, List<String> aerolineas) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        String filtro = '';

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStateModal) {
            // Filtrar y ordenar alfabéticamente de la A a la Z
            final filtradas = aerolineas
                .where((a) => a.toLowerCase().contains(filtro.toLowerCase()))
                .toList()
              ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                top: 16,
                left: 16,
                right: 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Indicador visual superior
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Campo de búsqueda dentro del modal
                  TextField(
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'Buscar aerolínea...',
                      prefixIcon: const Icon(Icons.search),
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: (val) {
                      setStateModal(() {
                        filtro = val;
                      });
                    },
                  ),
                  const SizedBox(height: 10),

                  // Lista de aerolíneas filtradas y ordenadas
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.4,
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: filtradas.length + 1, // +1 para la opción "Todas"
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return ListTile(
                            dense: true,
                            visualDensity: const VisualDensity(vertical: -2),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                            title: const Text(
                              'Todas las Aerolíneas',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            selected: _aerolineaSeleccionada == null,
                            onTap: () {
                              setState(() {
                                _aerolineaSeleccionada = null;
                              });
                              Navigator.pop(context);
                            },
                          );
                        }

                        final aerolinea = filtradas[index - 1];
                        return ListTile(
                          dense: true,
                          visualDensity: const VisualDensity(vertical: -2),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                          title: Text(
                            aerolinea,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          selected: _aerolineaSeleccionada == aerolinea,
                          onTap: () {
                            setState(() {
                              _aerolineaSeleccionada = aerolinea;
                            });
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _scrollToCurrentDay(List<DateTime> diasDeLaSemana, Map<String, List<VueloLineup>> vuelosAgrupados) async {
    final hoy = DateFormat('yyyy-MM-dd').format(DateTime.now());

    final diasConVuelos = diasDeLaSemana.where((dia) {
      final key = DateFormat('yyyy-MM-dd').format(dia);
      return (vuelosAgrupados[key] ?? []).isNotEmpty;
    }).toList();

    final indexHoy = diasConVuelos.indexWhere(
      (dia) => DateFormat('yyyy-MM-dd').format(dia) == hoy,
    );

    if (indexHoy == -1 || !_scrollController.hasClients) return;

    final proporcion = indexHoy / diasConVuelos.length;
    final targetOffset = _scrollController.position.maxScrollExtent * proporcion;

    _scrollController.jumpTo(targetOffset);

    await Future.delayed(const Duration(milliseconds: 60));

    final key = _dayKeys[hoy];
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        alignment: 0.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(vuelosLineupProvider);
    final ciudadesState = ref.watch(ciudadesProvider);
    final selectedTerminal = ref.watch(selectedTerminalFilterProvider);

    // Obtener aerolíneas disponibles del estado actual
    final aerolineasDisponibles = state.vuelos
        .map((v) => v.aerolineaNombre)
        .where((a) => a != null && a.isNotEmpty)
        .cast<String>()
        .toSet()
        .toList();

    // --- APLICACIÓN DE LOS FILTROS SOBRE LOS VUELOS ---
    final vuelosFiltrados = state.vuelos.where((vuelo) {
      final cumpleAerolinea = _aerolineaSeleccionada == null || vuelo.aerolineaNombre == _aerolineaSeleccionada;
      final cumpleEstacion = _estacionSeleccionada == null || vuelo.estacionId.toString() == _estacionSeleccionada;
      final cumpleTerminal = selectedTerminal == null || vuelo.terminal?.id == selectedTerminal.id;

      return cumpleAerolinea && cumpleEstacion && cumpleTerminal;
    }).toList();

    ref.listen(vuelosLineupProvider, (previous, next) {
      if (previous?.isLoading == true && !next.isLoading && next.vuelos.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final filtradosOnListen = next.vuelos.where((vuelo) {
            final cumpleAerolinea = _aerolineaSeleccionada == null || vuelo.aerolineaNombre == _aerolineaSeleccionada;
            final cumpleEstacion = _estacionSeleccionada == null || vuelo.estacionId.toString() == _estacionSeleccionada;
            final cumpleTerminal = selectedTerminal == null || vuelo.terminal?.id == selectedTerminal.id;
            return cumpleAerolinea && cumpleEstacion && cumpleTerminal;
          }).toList();

          final vuelosAgrupados = agruparVuelosPorDia(filtradosOnListen);
          final diasDeLaSemana = List.generate(7, (index) => next.startDate.add(Duration(days: index)));
          _scrollToCurrentDay(diasDeLaSemana, vuelosAgrupados);
        });
      }
    });

    final vuelosAgrupados = agruparVuelosPorDia(vuelosFiltrados);
    final diasDeLaSemana = List.generate(7, (index) => state.startDate.add(Duration(days: index)));

    return Scaffold(
      key: scaffoldKey,
      drawer: SideMenu(scaffoldKey: scaffoldKey),
      appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => scaffoldKey.currentState?.openDrawer(),
          ),
          title: const Text('LineUp', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          actions: [
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
              icon: Icon(
                Icons.filter_alt,
                size: 20,
                color: _mostrarFiltros ? const Color(0xFF0FA45F) : Colors.grey,
              ),
              tooltip: "Mostrar/Ocultar Filtros",
              onPressed: () {
                setState(() {
                  _mostrarFiltros = !_mostrarFiltros;
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                ref.read(vuelosLineupProvider.notifier).fetchVuelos(
                  VueloLineupRequest(start: state.startDate, end: state.endDate),
                );
              },
            ),
            const SizedBox(width: 8),
          ]),
      body: Column(
        children: [
          const _DatePickerHeader(),

          // --- BARRA DE FILTROS (MOSTRAR / OCULTAR) ---
          if (_mostrarFiltros)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      // SELECTOR DE AEROLÍNEA (Modal con Búsqueda)
                      Expanded(
                        child: InkWell(
                          onTap: () => _mostrarBuscadorAerolineas(context, aerolineasDisponibles),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.black12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    _aerolineaSeleccionada ?? "Aerolíneas",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: _aerolineaSeleccionada == null ? Colors.black54 : Colors.black,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (_aerolineaSeleccionada != null)
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _aerolineaSeleccionada = null;
                                      });
                                    },
                                    child: const Icon(Icons.clear, size: 18, color: Colors.grey),
                                  )
                                else
                                  const Icon(Icons.arrow_drop_down, color: Colors.grey),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),

                      // DROPDOWN ESTACIÓN
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.black12),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              isDense: true,
                              isExpanded: true,
                              value: _estacionSeleccionada,
                              hint: const Text("Estaciones", style: TextStyle(fontSize: 14)),
                              items: [
                                const DropdownMenuItem<String>(
                                  value: null,
                                  child: Text("Todas las Estaciones", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                                ),
                                ...ciudadesState.estaciones.map((e) => DropdownMenuItem(
                                      value: e.id.toString(),
                                      child: Text(e.nombre ?? '', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis),
                                    )),
                              ],
                              onChanged: (val) {
                                setState(() {
                                  _estacionSeleccionada = val;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Row(
                    children: [
                      Expanded(
                        child: TerminalFilterDropdown(
                          menuFontSize: 14.0,
                          selectedFontSize: 14.0,
                        ),
                      ),
                      Expanded(child: SizedBox()),
                    ],
                  ),
                ],
              ),
            ),

          const SizedBox(height: 4),
          const Divider(height: 1, thickness: 0.5, color: Color(0xFFE0E0E0)),
          if (state.isLoading)
            const Expanded(child: Center(child: CircularProgressIndicator.adaptive(valueColor: AlwaysStoppedAnimation(Color(0xFF0FA45F)))))
          else if (vuelosFiltrados.isEmpty)
            const Expanded(child: Center(child: Text('No hay vuelos programados para esta semana.', style: TextStyle(color: Colors.grey))))
          else
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.only(top: 8.0, bottom: 20.0),
                itemCount: diasDeLaSemana.length,
                itemBuilder: (context, index) {
                  final dia = diasDeLaSemana[index];
                  final fechaKey = DateFormat('yyyy-MM-dd').format(dia);
                  final vuelosDelDia = vuelosAgrupados[fechaKey] ?? [];

                  if (vuelosDelDia.isEmpty) return const SizedBox.shrink();

                  _dayKeys.putIfAbsent(fechaKey, () => GlobalKey());

                  final formatoCabecera = DateFormat('EEEE dd/MM', 'es_ES').format(dia).toUpperCase();

                  final hoy = DateTime.now();
                  final esHoy = dia.year == hoy.year && dia.month == hoy.month && dia.day == hoy.day;

                  return Container(
                    key: _dayKeys[fechaKey],
                    decoration: BoxDecoration(
                      color: esHoy ? const Color(0xFF0FA45F).withOpacity(0.02) : Colors.transparent,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    formatoCabecera,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: esHoy ? const Color(0xFF0FA45F) : Colors.black54,
                                      letterSpacing: 0.5
                                    ),
                                  ),
                                  if (esHoy) ...[
                                    const SizedBox(width: 6),
                                    const Text(
                                      '• HOY',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w900,
                                        color: Color(0xFF0FA45F),
                                        letterSpacing: 0.5
                                      ),
                                    ),
                                  ]
                                ],
                              ),
                              if (vuelosDelDia.isNotEmpty)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF0FA45F).withOpacity(esHoy ? 0.2 : 0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    '${vuelosDelDia.length} ${vuelosDelDia.length == 1 ? 'vuelo' : 'vuelos'}',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF0FA45F),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        IntrinsicHeight(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.only(left: 12.0, bottom: 4.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch, 
                              children: vuelosDelDia.map((vuelo) {
                                return VueloCompactCard(vuelo: vuelo);
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

Map<String, List<VueloLineup>> agruparVuelosPorDia(List<VueloLineup> vuelos) {
  final Map<String, List<VueloLineup>> agrupados = {};
  for (var vuelo in vuelos) {
    final fechaKey = (vuelo.auxFecha != null && vuelo.auxFecha!.isNotEmpty)
        ? vuelo.auxFecha!
        : (vuelo.fechaInicio?.split(' ').first ?? '');
        
    if (fechaKey.isNotEmpty) {
      agrupados.putIfAbsent(fechaKey, () => []).add(vuelo);
    }
  }
  return agrupados;
}