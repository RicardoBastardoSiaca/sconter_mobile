import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:scounter_mobile/features/shared/shared.dart';
import 'package:scounter_mobile/features/turnarounds/domain/domain.dart';
import 'package:scounter_mobile/features/turnarounds/presentation/providers/providers.dart';
import 'package:scounter_mobile/features/turnarounds/presentation/widgets/widgets.dart';

class VueloTimelineScreen extends ConsumerStatefulWidget {
  const VueloTimelineScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<VueloTimelineScreen> createState() => _VueloTimelineScreenState();
}

class _VueloTimelineScreenState extends ConsumerState<VueloTimelineScreen> {
  // Key global para identificar el widget del día actual
  final GlobalKey _hoyHeaderKey = GlobalKey();

  // Dimensiones compactas
  static const double _rowHeight = 36.0;
  static const double _sidebarWidth = 90.0;
  static const double _headerHeight = 30.0;

  bool _mostrarFiltros = true; // Controla la visibilidad de la barra superior

  // Filtros locales
  String? _aerolineaSeleccionada;
  String? _estacionSeleccionada;

  // 1. CONTROLADOR DE TEXTO Y VARIABLE DE ESTADO PARA NÚMERO DE VUELO
  final TextEditingController _numeroVueloController = TextEditingController();
  String _numeroVueloFiltro = '';

  // Controladores de Scroll Sincronizados
  late LinkedScrollControllerGroup _horizontalControllers;
  late ScrollController _horizontalHeaderController;
  late ScrollController _horizontalBodyController;

  late LinkedScrollControllerGroup _verticalControllers;
  late ScrollController _verticalSideController;
  late ScrollController _verticalBodyController;

  @override
  void initState() {
    super.initState();

    _horizontalControllers = LinkedScrollControllerGroup();
    _horizontalHeaderController = _horizontalControllers.addAndGet();
    _horizontalBodyController = _horizontalControllers.addAndGet();

    _verticalControllers = LinkedScrollControllerGroup();
    _verticalSideController = _verticalControllers.addAndGet();
    _verticalBodyController = _verticalControllers.addAndGet();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(vuelosTimelineProvider.notifier).resetScrollInicial();
      ref.read(ciudadesProvider.notifier).cargarEstaciones();
    });
  }

  @override
  void dispose() {
    // 2. DISPOSE DEL CONTROLADOR DE TEXTO
    _numeroVueloController.dispose();
    _horizontalHeaderController.dispose();
    _horizontalBodyController.dispose();
    _verticalSideController.dispose();
    _verticalBodyController.dispose();
    super.dispose();
  }

  void _scrollToCurrentDay(List<dynamic> uiRows) {
    void ejecutarScroll() {
      if (!mounted) return;

      final currentContext = _hoyHeaderKey.currentContext;

      if (currentContext != null) {
        Scrollable.ensureVisible(
          currentContext,
          alignment: 0.0,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Future.delayed(const Duration(milliseconds: 50), () => ejecutarScroll());
        });
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 150), () => ejecutarScroll());
    });
  }

  void _scrollToCurrentTime(double hourWidth, List<dynamic> uiRows) {
    final ahoraVenezuela = DateTime.now().toUtc().subtract(const Duration(hours: 4));

    final String hoyFormateado = DateFormat('yyyy-MM-dd').format(ahoraVenezuela);
    bool laSemanaContieneAHoy = uiRows.any((item) => item is String && item == hoyFormateado);
    if (!laSemanaContieneAHoy) return;

    void intentarScrollHoriz([int intentos = 0]) {
      if (!mounted) return;

      if (_horizontalBodyController.hasClients &&
          _horizontalBodyController.position.hasContentDimensions &&
          _horizontalBodyController.position.maxScrollExtent > 0) {
        final double horaDecimal = ahoraVenezuela.hour + (ahoraVenezuela.minute / 60.0);
        final double positionXLineaRoja = horaDecimal * hourWidth;
        final double screenWidth = MediaQuery.of(context).size.width;
        final double offsetAl20PorCiento = screenWidth * 0.20;

        final double targetScrollX = (positionXLineaRoja - offsetAl20PorCiento).clamp(
          0.0,
          _horizontalBodyController.position.maxScrollExtent,
        );

        _horizontalBodyController.animateTo(
          targetScrollX,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOutCubic,
        );
      } else if (intentos < 15) {
        Future.delayed(const Duration(milliseconds: 50), () {
          intentarScrollHoriz(intentos + 1);
        });
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => intentarScrollHoriz());
  }

  List<dynamic> _prepararRowsUi(Map<String, List<VueloCalendario>> vuelosPorDia) {
    final List<dynamic> rows = [];
    vuelosPorDia.forEach((fecha, listaVuelos) {
      rows.add(fecha);
      rows.addAll(listaVuelos);
    });
    return rows;
  }

  // Widget _buildBarraFiltros(VueloTimelineState state, VueloTimelineNotifier notifier, List<dynamic> estaciones) {
  //   final inicioFormat = DateFormat('dd MMM', 'es').format(state.startDate).toUpperCase();
  //   final finFormat = DateFormat('dd MMM yyyy', 'es').format(state.endDate).toUpperCase();

  //   final aerolineasDisponibles = state.vuelos
  //       .map((v) => v.aerolineaNombre)
  //       .where((a) => a.isNotEmpty)
  //       .toSet()
  //       .toList();

  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  //     color: const Color(0xFFF8F9FA),
  //     child: Column(
  //       children: [
  //         // 1. FILTRO DE FECHAS SEMANAL
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             IconButton(
  //               icon: const Icon(Icons.chevron_left, size: 22),
  //               padding: EdgeInsets.zero,
  //               constraints: const BoxConstraints(),
  //               onPressed: () => notifier.moveToPreviousWeek(),
  //             ),
  //             const SizedBox(width: 8),
  //             InkWell(
  //               onTap: () async {
  //                 final fecha = await showDatePicker(
  //                   context: context,
  //                   initialDate: state.startDate,
  //                   firstDate: DateTime(2020),
  //                   lastDate: DateTime(2030),
  //                 );
  //                 if (fecha != null) {
  //                   notifier.cambiarSemanaPorFecha(fecha);
  //                 }
  //               },
  //               child: Container(
  //                 padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
  //                 decoration: BoxDecoration(
  //                   color: const Color(0xFFEEEEEE),
  //                   borderRadius: BorderRadius.circular(16),
  //                 ),
  //                 child: Row(
  //                   children: [
  //                     const Icon(Icons.calendar_today, size: 14, color: Colors.blue),
  //                     const SizedBox(width: 6),
  //                     Text(
  //                       "$inicioFormat - $finFormat",
  //                       style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black87),
  //                     ),
  //                     const Icon(Icons.arrow_drop_down, size: 16, color: Colors.black54),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //             const SizedBox(width: 8),
  //             IconButton(
  //               icon: const Icon(Icons.chevron_right, size: 22),
  //               padding: EdgeInsets.zero,
  //               constraints: const BoxConstraints(),
  //               onPressed: () => notifier.moveToNextWeek(),
  //             ),
  //           ],
  //         ),

  //         const SizedBox(height: 8),

  //         // 2. FILTROS DE AEROLÍNEA Y ESTACIÓN
  //         Row(
  //           children: [
  //             // DROPDOWN AEROLÍNEA
  //             Expanded(
  //               child: Container(
  //                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
  //                 decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(12),
  //                   border: Border.all(color: Colors.black12),
  //                 ),
  //                 child: DropdownButtonHideUnderline(
  //                   child: DropdownButton<String>(
  //                     isDense: true,
  //                     isExpanded: true,
  //                     value: _aerolineaSeleccionada,
  //                     hint: const Text("Aerolíneas", style: TextStyle(fontSize: 14)),
  //                     items: [
  //                       const DropdownMenuItem<String>(
  //                         value: null,
  //                         child: Text("Todas las Aerolíneas", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
  //                       ),
  //                       ...aerolineasDisponibles.map((a) => DropdownMenuItem(
  //                             value: a,
  //                             child: Text(a, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis),
  //                           )),
  //                     ],
  //                     onChanged: (val) {
  //                       setState(() {
  //                         _aerolineaSeleccionada = val;
  //                       });
  //                     },
  //                   ),
  //                 ),
  //               ),
  //             ),

  //             const SizedBox(width: 8),

  //             // DROPDOWN ESTACIÓN
  //             Expanded(
  //               child: Container(
  //                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
  //                 decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(12),
  //                   border: Border.all(color: Colors.black12),
  //                 ),
  //                 child: DropdownButtonHideUnderline(
  //                   child: DropdownButton<String>(
  //                     isDense: true,
  //                     isExpanded: true,
  //                     value: _estacionSeleccionada,
  //                     hint: const Text("Estaciones", style: TextStyle(fontSize: 14)),
  //                     items: [
  //                       const DropdownMenuItem<String>(
  //                         value: null,
  //                         child: Text("Todas las Estaciones", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
  //                       ),
  //                       ...estaciones.map((e) => DropdownMenuItem(
  //                             value: e.id.toString(),
  //                             child: Text(e.nombre ?? '', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis),
  //                           )),
  //                     ],
  //                     onChanged: (val) {
  //                       setState(() {
  //                         _estacionSeleccionada = val;
  //                       });
  //                     },
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),

  //         const SizedBox(height: 6),

  //         // 3. FILTRO TERMINAL Y BUSCADOR POR NÚMERO DE VUELO
  //         Row(
  //           children: [
  //             Expanded(
  //               child: const TerminalFilterDropdown(
  //                 menuFontSize: 14.0,
  //                 selectedFontSize: 14.0,
  //               ),
  //             ),
  //             const SizedBox(width: 8),
  //             // CAMPO DE BÚSQUEDA POR NÚMERO DE VUELO (SIN DOBLE BORDE)
  //             Expanded(
  //               child: SizedBox(
  //                 height: 40,
  //                 child: TextField(
  //                   controller: _numeroVueloController,
  //                   onChanged: (val) {
  //                     setState(() {
  //                       _numeroVueloFiltro = val;
  //                     });
  //                   },
  //                   style: const TextStyle(fontSize: 13),
  //                   decoration: InputDecoration(
  //                     hintText: "Nº de vuelo",
  //                     hintStyle: const TextStyle(fontSize: 13, color: Colors.black38),
  //                     prefixIcon: const Icon(Icons.search, size: 18, color: Colors.black54),
  //                     suffixIcon: _numeroVueloFiltro.isNotEmpty
  //                         ? GestureDetector(
  //                             onTap: () {
  //                               setState(() {
  //                                 _numeroVueloController.clear();
  //                                 _numeroVueloFiltro = '';
  //                               });
  //                             },
  //                             child: const Icon(Icons.clear, size: 16, color: Colors.black54),
  //                           )
  //                         : null,
  //                     contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      
  //                     // Bordes unificados con los demás controles
  //                     enabledBorder: OutlineInputBorder(
  //                       borderRadius: BorderRadius.circular(12),
  //                       borderSide: const BorderSide(color: Colors.black12),
  //                     ),
  //                     focusedBorder: OutlineInputBorder(
  //                       borderRadius: BorderRadius.circular(12),
  //                       borderSide: const BorderSide(color: Colors.black38, width: 1.2),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Componente visual para la barra de filtros
  Widget _buildBarraFiltros(List<VueloCalendario> vuelos, List<Estacion> estaciones) {
  // Widget _buildBarraFiltros(VueloTimelineState state, VueloTimelineNotifier notifier, List<dynamic> estaciones) {
    // Extraer aerolíneas únicas disponibles en los vuelos
    final aerolineasDisponibles = vuelos
        .map((v) => v.aerolineaNombre)
        .where((a) => a.isNotEmpty)
        .toSet()
        .toList();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: const Color(0xFFF8F9FA),
      child: Column(
        children: [
          Row(
            children: [
              // 1. SELECTOR DE AEROLÍNEA
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 8),
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isDense: true,
                            isExpanded: true,
                            value: _aerolineaSeleccionada,
                            hint: const Text(
                              "Aerolínea",
                              style: TextStyle(fontSize: 16),
                            ),
                            items: [
                              const DropdownMenuItem<String>(
                                value: null,
                                child: Text("Aerolíneas", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                              ),
                              ...aerolineasDisponibles.map((a) => DropdownMenuItem(
                                    value: a,
                                    child: Text(a, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis),
                                  )),
                            ],
                            onChanged: (val) {
                              setState(() {
                                _aerolineaSeleccionada = val;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          
              const SizedBox(width: 8),
          
              // 2. SELECTOR DE ESTACIÓN
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 4),
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isDense: true,
                            isExpanded: true,
                            value: _estacionSeleccionada,
                            hint: const Text(
                              "Estación",
                              style: TextStyle(fontSize: 16),
                            ),
                            items: [
                              const DropdownMenuItem<String>(
                                value: null,
                                child: Text("Estaciones", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                              ),
                              ...estaciones.map((e) => DropdownMenuItem(
                                    value: e.id.toString(),
                                    child: Text(e.nombre ?? '', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis),
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
                    ],
                  ),
                ),
              ),
            ],
          ),
        
          const SizedBox(height: 6),

          Row(
            children: [
              // 3. SELECTOR DE TERMINAL
              Expanded(child: TerminalFilterDropdown()),
              const SizedBox(width: 8),
              
              // 4. CAMPO DE BÚSQUEDA POR NÚMERO DE VUELO (Borde unificado)
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: TextField(
                    controller: _numeroVueloController,
                    onChanged: (val) {
                      setState(() {
                        _numeroVueloFiltro = val;
                      });
                    },
                    style: const TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: "Nº de vuelo",
                      hintStyle: const TextStyle(fontSize: 14, color: Colors.black38),
                      prefixIcon: const Icon(Icons.search, size: 18, color: Colors.black54),
                      suffixIcon: _numeroVueloFiltro.isNotEmpty
                          ? GestureDetector(
                              onTap: () {
                                setState(() {
                                  _numeroVueloController.clear();
                                  _numeroVueloFiltro = '';
                                });
                              },
                              child: const Icon(Icons.clear, size: 16, color: Colors.black54),
                            )
                          : null,
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      
                      // Bordes unificados con los demás controles
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.black12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.black38, width: 1.2),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(vuelosTimelineProvider);
    final notifier = ref.read(vuelosTimelineProvider.notifier);
    final ciudadesState = ref.watch(ciudadesProvider);
    final selectedTerminal = ref.watch(selectedTerminalFilterProvider);

    // --- APLICACIÓN DE LOS FILTROS SOBRE LOS VUELOS (INCLUYENDO NÚMERO DE VUELO) ---
    final vuelosFiltrados = state.vuelos.where((vuelo) {
      final cumpleAerolinea = _aerolineaSeleccionada == null || vuelo.aerolineaNombre == _aerolineaSeleccionada;
      final cumpleEstacion = _estacionSeleccionada == null || vuelo.estacionId.toString() == _estacionSeleccionada;
      final cumpleTerminal = selectedTerminal == null || vuelo.terminal?.id == selectedTerminal.id;
      final cumpleNumeroVuelo = _numeroVueloFiltro.isEmpty ||
          vuelo.numeroVuelo.toLowerCase().contains(_numeroVueloFiltro.toLowerCase().trim());

      return cumpleAerolinea && cumpleEstacion && cumpleTerminal && cumpleNumeroVuelo;
    }).toList();

    // 1. Inicializar el mapa con todos los días de la semana activa
final Map<String, List<VueloCalendario>> vuelosPorDiaFiltrados = {};
final DateFormat formatterKey = DateFormat('yyyy-MM-dd');

DateTime cursor = state.startDate;
while (cursor.isBefore(state.endDate) || cursor.isAtSameMomentAs(state.endDate)) {
  final fechaKey = formatterKey.format(cursor);
  vuelosPorDiaFiltrados[fechaKey] = [];
  cursor = cursor.add(const Duration(days: 1));
}

// 2. Insertar los vuelos en su día correspondiente
for (var vuelo in vuelosFiltrados) {
  final fechaKey = vuelo.auxFecha;
  if (vuelosPorDiaFiltrados.containsKey(fechaKey)) {
    vuelosPorDiaFiltrados[fechaKey]!.add(vuelo);
  }
}

    final double currentHourWidth = state.anchoHora;
    final double totalGridWidth = currentHourWidth * 24;
    final uiRows = _prepararRowsUi(vuelosPorDiaFiltrados);

    // Escuchar cambios para scroll automático
    ref.listen<VueloTimelineState>(
      vuelosTimelineProvider,
      (previous, next) {
        final terminoDeCargar = (previous?.isLoading ?? true) && !next.isLoading;
        final requiereScroll = !next.scrollInicialRealizado;

        if ((terminoDeCargar || requiereScroll) && uiRows.isNotEmpty) {
          notifier.marcarScrollComoRealizado();
          _scrollToCurrentDay(uiRows);
          _scrollToCurrentTime(currentHourWidth, uiRows);
        }
      },
    );

    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      drawer: SideMenu(scaffoldKey: _scaffoldKey),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        leading: Builder(
          builder: (BuildContext innerContext) {
            return IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.black87),
              onPressed: () {
                Scaffold.of(innerContext).openDrawer();
              },
            );
          },
        ),
        title: const Text(
          "Workload",
          style: TextStyle(color: Colors.black87, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                icon: Icon(
                  Icons.filter_alt,
                  size: 20,
                  color: _mostrarFiltros ? const Color(0xFF4CAF50) : Colors.grey,
                ),
                tooltip: "Mostrar/Ocultar Filtros",
                onPressed: () {
                  setState(() {
                    _mostrarFiltros = !_mostrarFiltros;
                  });
                },
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                icon: const Icon(Icons.my_location, size: 20, color: Color(0xFF4CAF50)),
                tooltip: "Ir a la hora actual",
                onPressed: () {
                  _scrollToCurrentDay(uiRows);
                  _scrollToCurrentTime(currentHourWidth, uiRows);
                },
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                icon: const Icon(Icons.refresh, size: 20, color: Colors.black87),
                onPressed: () {
                  notifier.resetScrollInicial();
                  notifier.cargarDatos();
                },
              ),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
      body: state.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.greenAccent),
            )
          : Column(
              children: [
                if (_mostrarFiltros) _buildBarraFiltros(vuelosFiltrados, ciudadesState.estaciones),

                // 1. CABECERA HORAS (00:00 - 23:00)
                SizedBox(
                  height: _headerHeight,
                  child: Row(
                    children: [
                      Container(
                        width: _sidebarWidth,
                        height: _headerHeight,
                        color: Colors.white,
                        alignment: Alignment.center,
                        child: const Text(
                          "Día / Hora",
                          style: TextStyle(
                            color: Color(0xFF212529),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          controller: _horizontalHeaderController,
                          scrollDirection: Axis.horizontal,
                          physics: const ClampingScrollPhysics(),
                          child: _buildHeaderHours(currentHourWidth, totalGridWidth),
                        ),
                      ),
                    ],
                  ),
                ),

                // 2. CUERPO PRINCIPAL
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: _sidebarWidth,
                        child: SingleChildScrollView(
                          controller: _verticalSideController,
                          scrollDirection: Axis.vertical,
                          physics: const ClampingScrollPhysics(),
                          child: _buildSideBar(uiRows),
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          controller: _verticalBodyController,
                          scrollDirection: Axis.vertical,
                          physics: const ClampingScrollPhysics(),
                          child: SingleChildScrollView(
                            controller: _horizontalBodyController,
                            scrollDirection: Axis.horizontal,
                            physics: const ClampingScrollPhysics(),
                            child: _buildTimelineBody(
                              uiRows: uiRows,
                              hourWidth: currentHourWidth,
                              totalWidth: totalGridWidth,
                            ),
                          ),
                        ),
                      ),
                    ],
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
    builder: (context) => const Center(
      child: CircularProgressIndicator(color: Colors.white),
    ),
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
        builder: (context) {
          final colorEstadoBorde = _obtenerColorEstatusLocal(vuelo.estatusVuelo, isBorder: true);
          final colorEstadoFondo = _obtenerColorEstatusLocal(vuelo.estatusVuelo, isBorder: false);
          final List<Color> coloresHeaderEstatus = _obtenerGradientHeaderPorEstatus(vuelo.estatusVuelo);

          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 24),
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
                    // --- ENCABEZADO HEADER CON COLOR BASADO EN EL ESTATUS ---
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () => Navigator.of(context).pop(),
                            tooltip: 'Cerrar',
                          ),
                        ],
                      ),
                    ),

                    // --- TARJETA RESUMEN DE ESTATUS Y RUTA ---
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Badge de Estatus
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                            decoration: BoxDecoration(
                              color: colorEstadoFondo,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: colorEstadoBorde, width: 1.2),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 4,
                                  backgroundColor: colorEstadoBorde,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  vuelo.estatusVuelo ?? 'Sin estado',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: colorEstadoBorde,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Ruta / Estación
                          if (vuelo.routing != null && vuelo.routing!.isNotEmpty)
                            Row(
                              children: [
                                const Icon(Icons.location_on_outlined, size: 16, color: Colors.black54),
                                const SizedBox(width: 4),
                                Text(
                                  vuelo.routing!,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),

                    const Divider(height: 1, thickness: 1, color: Colors.black12),

                    // --- CUERPO SCROLLABLE DEL DIÁLOGO ---
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // SECCIÓN 1: DATOS DEL VUELO
                            _buildModernSectionCard(
                              title: 'Datos del Vuelo',
                              icon: Icons.info_outline_rounded,
                              child: Consumer(
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
                            ),

                            const SizedBox(height: 12),

                            // SECCIÓN 2: PERSONAL ASIGNADO
                            _buildModernSectionCard(
                              title: 'Personal Asignado',
                              icon: Icons.people_alt_outlined,
                              child: Consumer(
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
                            ),
                          ],
                        ),
                      ),
                    ),

                    // --- FOOTER CON BOTÓN DE CERRAR EN VERDE ---
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(top: BorderSide(color: Colors.black12, width: 1)),
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
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.check_circle_outline, size: 18),
                        label: const Text(
                          'CERRAR',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
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

// Devuelve un degradado para el Header ajustado según el estatus
List<Color> _obtenerGradientHeaderPorEstatus(String? estatus) {
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
// Widget auxiliar para crear tarjetas contenedoras con un diseño más moderno
Widget _buildModernSectionCard({
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

// Helper local para obtener colores por estatus dentro del diálogo
Color _obtenerColorEstatusLocal(String? estatus, {bool isBorder = false}) {
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
      return isBorder ? Colors.deepOrange.shade800 : Colors.deepOrange.shade50;
    default:
      return isBorder ? Colors.blue.shade400 : Colors.blue.shade50;
  }
}


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
            color: Colors.black87,
            letterSpacing: 0.3,
          ),
        ),
      ],
    ),
  );
}



  // --- COMPONENTES VISUALES Y GRID ---

  Widget _buildHeaderHours(double hourWidth, double totalWidth) {
    return Container(
      width: totalWidth,
      height: _headerHeight,
      color: Colors.white,
      child: Row(
        children: List.generate(24, (index) {
          final horaStr = index.toString().padLeft(2, '0');
          return Container(
            width: hourWidth,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              border: Border(left: BorderSide(color: Color(0xFFE0E0E0), width: 1)),
            ),
            child: Text(
              "$horaStr:00",
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 10.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSideBar(List<dynamic> uiRows) {
    final ahoraVenezuela = DateTime.now().toUtc().subtract(const Duration(hours: 4));

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: uiRows.map((item) {
        if (item is String) {
          bool esHoy = false;
          String diaSemana = "";
          String fechaFormateada = item;

          try {
            final date = DateTime.parse(item);
            diaSemana = DateFormat('EEE', 'es').format(date).toUpperCase();
            fechaFormateada = DateFormat('dd-MM-yy').format(date);

            esHoy = date.year == ahoraVenezuela.year &&
                date.month == ahoraVenezuela.month &&
                date.day == ahoraVenezuela.day;
          } catch (_) {
            diaSemana = "DÍA";
          }

          return Container(
            key: esHoy ? _hoyHeaderKey : null,
            height: _rowHeight,
            width: _sidebarWidth,
            padding: const EdgeInsets.symmetric(horizontal: 2),
            color: esHoy ? const Color(0xFF4CAF50) : const Color.fromARGB(255, 61, 66, 71),
            alignment: Alignment.center,
            child: Text(
              "$diaSemana $fechaFormateada",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11.5,
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          );
        } else if (item is VueloCalendario) {
          return Container(
            height: _rowHeight,
            width: _sidebarWidth,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Color(0xFFE0E0E0), width: 0.8),
                right: BorderSide(color: Color(0xFFE0E0E0), width: 1),
              ),
            ),
            alignment: Alignment.centerLeft,
            child: Text(
              item.aerolineaNombre.isNotEmpty ? item.aerolineaNombre : "Sin datos",
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          );
        } else {
          return Container(height: _rowHeight, width: _sidebarWidth, color: Colors.white);
        }
      }).toList(),
    );
  }

  Widget _buildTimelineBody({
    required List<dynamic> uiRows,
    required double hourWidth,
    required double totalWidth,
  }) {
    final ahoraVenezuela = DateTime.now().toUtc().subtract(const Duration(hours: 4));
    final double horaDecimalActual = ahoraVenezuela.hour + (ahoraVenezuela.minute / 60.0);
    final double lineaRojaX = horaDecimalActual * hourWidth;

    final double totalHeight = uiRows.length * _rowHeight;

    return SizedBox(
      width: totalWidth,
      height: totalHeight,
      child: Stack(
        alignment: Alignment.topLeft,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: uiRows.map((item) {
              final isHeader = item is String;
              return Container(
                height: _rowHeight,
                width: totalWidth,
                decoration: BoxDecoration(
                  color: isHeader ? const Color(0xFFF0F0F0) : Colors.white,
                  border: const Border(bottom: BorderSide(color: Color(0xFFE0E0E0), width: 0.8)),
                ),
                child: Row(
                  children: List.generate(24, (index) {
                    return Container(
                      width: hourWidth,
                      decoration: const BoxDecoration(
                        border: Border(left: BorderSide(color: Color(0xFFE0E0E0), width: 0.8)),
                      ),
                    );
                  }),
                ),
              );
            }).toList(),
          ),

          ..._buildTarjetasVuelos(uiRows, hourWidth),

          Positioned(
            top: 0,
            height: totalHeight,
            left: lineaRojaX,
            child: Container(
              width: 2,
              color: const Color(0xFFC62828),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildTarjetasVuelos(List<dynamic> uiRows, double hourWidth) {
    final List<Widget> tarjetas = [];

    for (int index = 0; index < uiRows.length; index++) {
      final item = uiRows[index];

      if (item is VueloCalendario) {
        final double topOffset = index * _rowHeight;

        DateTime? inicio = item.horaInicioServicioReal ?? item.horaInicioServicio;

        if (inicio == null && item.auxFecha.isNotEmpty && item.horaInicio.isNotEmpty) {
          inicio = DateTime.tryParse("${item.auxFecha} ${item.horaInicio}");
        }

        if (inicio == null) continue;

        DateTime? fin = item.horaFinServicioReal ?? item.horaFinServicio;

        if (fin == null && item.auxFecha.isNotEmpty && item.horaFin.isNotEmpty) {
          fin = DateTime.tryParse("${item.auxFecha} ${item.horaFin}");
        }

        final double horaDecimalInicio = inicio.hour + (inicio.minute / 60.0);
        final double horaDecimalFin = fin != null 
            ? fin.hour + (fin.minute / 60.0) 
            : horaDecimalInicio + 1.5;

        double duracionHoras = horaDecimalFin - horaDecimalInicio;
        if (duracionHoras <= 0) duracionHoras = 1.0;

        final double leftX = horaDecimalInicio * hourWidth;
        final double width = duracionHoras * hourWidth;

        final Color cardColor = obtenerColorPorEstatus(item);

        tarjetas.add(
          Positioned(
            top: topOffset + 3,
            left: leftX,
            width: width.clamp(40.0, double.infinity),
            height: _rowHeight - 6,
            child: GestureDetector(
              // onTap: () => _cargarYMostrarDetalleVuelo(context, item),
              onTap: () {
                // LLAMADA AL DIÁLOGO REUTILIZABLE:
                VueloCalendarioDetalleDialog.mostrar(
                  context: context,
                  ref: ref,
                  vuelo: item,
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.black54,
                    width: 1.2,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  item.numeroVuelo.isNotEmpty ? item.numeroVuelo : "N/A",
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        );
      }
    }

    return tarjetas;
  }
}