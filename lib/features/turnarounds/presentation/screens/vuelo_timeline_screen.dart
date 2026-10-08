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
  static const double _rowHeight = 40.0;
  static const double _sidebarWidth = 90.0;
  static const double _headerHeight = 30.0;

  bool _mostrarFiltros = true; // Controla la visibilidad de la barra superior

  // Filtros locales
  String? _aerolineaSeleccionada;
  String? _estacionSeleccionada;

  // Controlador de texto y variable para número de vuelo
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

  // Componente visual para la barra de filtros reordenada
  // Componente visual para la barra de filtros reordenada
// Componente visual para la barra de filtros reordenada
Widget _buildBarraFiltros(
  VueloTimelineState state, 
  VueloTimelineNotifier notifier, 
  List<dynamic> estaciones,
  int totalVuelos, // Parámetro para recibir la cantidad total de vuelos
) {
  final inicioFormat = DateFormat('dd/MM/yyyy', 'es').format(state.startDate);
  final finFormat = DateFormat('dd/MM/yyyy', 'es').format(state.endDate);

  final aerolineasDisponibles = state.vuelos
      .map((v) => v.aerolineaNombre)
      .where((a) => a.isNotEmpty)
      .toSet()
      .toList();

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    color: const Color(0xFFF8F9FA),
    child: Column(
      children: [
        // 1. FILTROS DE AEROLÍNEA Y ESTACIÓN
        Row(
          children: [
            // BUSCADOR AEROLÍNEA
            Expanded(
              child: Container(
                height: 40, // <- altura fija
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black12),
                ),
                child: Row(
                  children: [
                    // Área para hacer tap y abrir el modal
                    Expanded(
                      child: InkWell(
                        onTap: () => _mostrarBuscadorAerolineas(context, aerolineasDisponibles),
                        borderRadius: BorderRadius.horizontal(
                          left: const Radius.circular(12),
                          right: Radius.circular(_aerolineaSeleccionada == null ? 12 : 0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12), // <- sin padding vertical
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  _aerolineaSeleccionada ?? "Aerolíneas",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: _aerolineaSeleccionada == null ? Colors.black54 : Colors.black87,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (_aerolineaSeleccionada == null)
                                const Icon(Icons.arrow_drop_down, color: Colors.grey),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Botón de restablecer (X)
                    if (_aerolineaSeleccionada != null)
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () {
                            setState(() {
                              _aerolineaSeleccionada = null;
                            });
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.clear,
                              size: 18,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                  ],
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
                      ...estaciones.map((e) => DropdownMenuItem(
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

        // 2. FILTRO TERMINAL Y BUSCADOR NÚMERO DE VUELO
        Row(
          children: [
            const Expanded(
              child: const TerminalFilterDropdown(
                height: 40,
                menuFontSize: 14.0,
                selectedFontSize: 14.0,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: SizedBox(
                height: 38,
                child: TextField(
                  controller: _numeroVueloController,
                  onChanged: (val) {
                    setState(() {
                      _numeroVueloFiltro = val;
                    });
                  },
                  style: const TextStyle(fontSize: 13),
                  decoration: InputDecoration(
                    hintText: "Nº de vuelo",
                    hintStyle: const TextStyle(fontSize: 13, color: Colors.black38),
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

        const SizedBox(height: 8),

        // 3. FILTRO DE FECHAS SEMANAL CON CONTEO DEBAJO
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left, size: 22),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () => notifier.moveToPreviousWeek(),
            ),
            const SizedBox(width: 6),
            InkWell(
              onTap: () async {
                final fecha = await showDatePicker(
                  context: context,
                  initialDate: state.startDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                );
                if (fecha != null) {
                  notifier.cambiarSemanaPorFecha(fecha);
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEEEEE),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Fila superior: Icono de calendario + Rango de fechas + Flecha
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.calendar_today, size: 13, color: Colors.green),
                        const SizedBox(width: 5),
                        Text(
                          "$inicioFormat - $finFormat",
                          style: const TextStyle(
                            fontSize: 13, 
                            fontWeight: FontWeight.bold, 
                            color: Colors.black87,
                          ),
                        ),
                        const Icon(Icons.arrow_drop_down, size: 16, color: Colors.black54),
                      ],
                    ),
                    const SizedBox(height: 2),
                    // Fila inferior: Total de vuelos centrado debajo
                    Text(
                      "($totalVuelos ${totalVuelos == 1 ? 'vuelo' : 'vuelos'})",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 6),
            IconButton(
              icon: const Icon(Icons.chevron_right, size: 22),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () => notifier.moveToNextWeek(),
            ),
          ],
        ),
      ],
    ),
  );
}


  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


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

                // Lista de aerolíneas filtradas
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


  @override
  Widget build(BuildContext context) {
    final state = ref.watch(vuelosTimelineProvider);
    final notifier = ref.read(vuelosTimelineProvider.notifier);
    final ciudadesState = ref.watch(ciudadesProvider);
    final selectedTerminal = ref.watch(selectedTerminalFilterProvider);

    // --- APLICACIÓN DE LOS FILTROS SOBRE LOS VUELOS ---
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
                if (_mostrarFiltros) 
                  _buildBarraFiltros(
                    state, 
                    notifier, 
                    ciudadesState.estaciones,
                    vuelosFiltrados.length, // <-- Se envía la cantidad de vuelos filtrados
                  ),
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
      children: List.generate(uiRows.length, (index) {
        final item = uiRows[index];

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

          // Contar los vuelos que pertenecen a este día
          int totalVuelosDia = 0;
          for (int j = index + 1; j < uiRows.length; j++) {
            if (uiRows[j] is VueloCalendario) {
              totalVuelosDia++;
            } else {
              break; // Llega al siguiente encabezado de día (String)
            }
          }

          return Container(
            key: esHoy ? _hoyHeaderKey : null,
            height: _rowHeight,
            width: _sidebarWidth,
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
            color: esHoy ? const Color(0xFF4CAF50) : const Color.fromARGB(255, 61, 66, 71),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "$diaSemana $fechaFormateada",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10.0,
                    fontWeight: FontWeight.w800,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 1),
                // FittedBox asegura que el contador siempre se renderice sin desbordamientos
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    "($totalVuelosDia ${totalVuelosDia == 1 ? 'vuelo' : 'vuelos'})",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9.5,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
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
      }),
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
              onTap: () {
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