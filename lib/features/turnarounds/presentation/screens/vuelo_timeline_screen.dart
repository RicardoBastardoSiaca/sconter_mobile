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
  // Dimensiones
  // 1. CONSTANTES DE DIMENSIONES COMPACTAS
// 1. CONSTANTES DE DIMENSIONES COMPACTAS (Reducidas un 20% horizontalmente)
static const double _rowHeight = 36.0;    
static const double _sidebarWidth = 90.0;  
static const double _headerHeight = 25.0;   
static const double _hourWidth = 48.0;     // Reducido de 60.0 a 48.0 (-20%)     // Reducido de 80.0 a 60.0

bool _mostrarFiltros = true; // Controla la visibilidad de la barra superior

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
  });
}

  @override
  void dispose() {
    _horizontalHeaderController.dispose();
    _horizontalBodyController.dispose();
    _verticalSideController.dispose();
    _verticalBodyController.dispose();
    super.dispose();
  }

  // --- MÉTODOS DE SCROLL CON HORA VENEZUELA (UTC-4) ---

  void _scrollToCurrentTime(double hourWidth, List<dynamic> uiRows) {
    final ahoraVenezuela = DateTime.now().toUtc().subtract(const Duration(hours: 4));

    final String hoyFormateado = DateFormat('yyyy-MM-dd').format(ahoraVenezuela);
    bool laSemanaContieneAHoy = uiRows.any((item) => item is String && item == hoyFormateado);
    if (!laSemanaContieneAHoy) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_horizontalBodyController.hasClients) {
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
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  void _scrollToCurrentDay(List<dynamic> uiRows) {
    final ahoraVenezuela = DateTime.now().toUtc().subtract(const Duration(hours: 4));
    final String hoyFormateado = DateFormat('yyyy-MM-dd').format(ahoraVenezuela);

    int indexHoy = uiRows.indexWhere((item) => item is String && item == hoyFormateado);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_verticalSideController.hasClients) {
        if (indexHoy != -1) {
          final double targetOffset = indexHoy * _rowHeight;
          _verticalSideController.animateTo(
            targetOffset,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOutCubic,
          );
        } else {
          _verticalSideController.jumpTo(0.0);
        }
      }
    });
  }

  List<dynamic> _prepararRowsUi(Map<String, List<VueloCalendario>> vuelosPorDia) {
    final List<dynamic> rows = [];
    vuelosPorDia.forEach((fecha, listaVuelos) {
      rows.add(fecha);
      rows.addAll(listaVuelos);
    });
    return rows;
  }

  Widget _buildBarraFiltros(VueloTimelineState state, VueloTimelineNotifier notifier) {
  final inicioFormat = DateFormat('dd MMM', 'es').format(state.startDate).toUpperCase();
  final finFormat = DateFormat('dd MMM yyyy', 'es').format(state.endDate).toUpperCase();

  // Extraer lista única de aerolíneas disponibles en los vuelos cargados
  final aerolineasDisponibles = state.vuelos
      .map((v) => v.aerolineaNombre)
      .where((a) => a.isNotEmpty)
      .toSet()
      .toList();

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    color: const Color(0xFFF8F9FA),
    child: Column(
      children: [
        // 1. FILTRO DE FECHAS SEMANAL (< DD MMM - DD MMM YYYY >)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left, size: 22),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () => notifier.moveToPreviousWeek(),
            ),
            const SizedBox(width: 8),
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
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEEEEE),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 14, color: Colors.blue),
                    const SizedBox(width: 6),
                    Text(
                      "$inicioFormat - $finFormat",
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    const Icon(Icons.arrow_drop_down, size: 16, color: Colors.black54),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.chevron_right, size: 22),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () => notifier.moveToNextWeek(),
            ),
          ],
        ),

        const SizedBox(height: 6),

        // 2. FILTRO POR AEROLÍNEA
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFEEEEEE),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.tune, size: 14, color: Colors.black54),
                  const SizedBox(width: 4),
                  DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isDense: true,
                      value: state.aerolineasFiltradas.isEmpty ? null : state.aerolineasFiltradas.first,
                      hint: const Text(
                        "Filtrar por Aerolínea",
                        style: TextStyle(fontSize: 11, color: Colors.black87),
                      ),
                      items: [
                        const DropdownMenuItem<String>(
                          value: null,
                          child: Text("Todas las Aerolíneas", style: TextStyle(fontSize: 11)),
                        ),
                        ...aerolineasDisponibles.map((a) => DropdownMenuItem(
                              value: a,
                              child: Text(a, style: const TextStyle(fontSize: 11)),
                            )),
                      ],
                      onChanged: (val) {
                        if (val == null) {
                          notifier.limpiarFiltroAerolineas();
                        } else {
                          notifier.limpiarFiltroAerolineas();
                          notifier.toggleAerolineaFiltro(val);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

// 1. Mover la key aquí afuera para que persista durante todo el ciclo de vida
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(vuelosTimelineProvider);
    final notifier = ref.read(vuelosTimelineProvider.notifier);

    final double currentHourWidth = state.anchoHora;
    final double totalGridWidth = currentHourWidth * 24;
    final uiRows = _prepararRowsUi(state.vuelosPorDia);

    // Escuchar cambios para scroll automático
    ref.listen<VueloTimelineState>(
      vuelosTimelineProvider,
      (previous, next) {
        final terminoDeCargar = (previous?.isLoading ?? true) && !next.isLoading;
        final requiereScroll = !next.scrollInicialRealizado;

        if ((terminoDeCargar || requiereScroll) && uiRows.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              notifier.marcarScrollComoRealizado();
              _scrollToCurrentDay(uiRows);
              _scrollToCurrentTime(currentHourWidth, uiRows);
            }
          });
        }
      },
    );

    if (uiRows.isNotEmpty && !state.scrollInicialRealizado && !state.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          notifier.marcarScrollComoRealizado();
          _scrollToCurrentDay(uiRows);
          _scrollToCurrentTime(currentHourWidth, uiRows);
        }
      });
    }

    // final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      // backgroundColor: const Color(0xFFF8F9FA), // Fondo gris neutro ultra claro
      backgroundColor: Colors.white, // Garantiza que no haya fondos oscuros al reducir la vista
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
                Scaffold.of(innerContext).openDrawer(); // Usa innerContext
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
      // 1. Botón Filtros
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
      // 2. Botón Mi Ubicación
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
      // 3. Botón Refresh
      IconButton(
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
        icon: const Icon(Icons.refresh, size: 20, color: Colors.black87),
        onPressed: () {
          notifier.resetScrollInicial();
          notifier.cargarDatos();
        },
      ),
      const SizedBox(width: 8), // Margen respecto al borde derecho de la pantalla
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

                // DENTRO DE Column(children: [...])
                if (_mostrarFiltros) _buildBarraFiltros(state, notifier),
                // 1. CABECERA HORAS (00:00 - 23:00)
                SizedBox(
                  height: _headerHeight,
                  child: Row(
                    children: [
                      Container(
                        width: _sidebarWidth,
                        height: _headerHeight,
                        // color: const Color(0xFF212529), // Gris oscuro/Negro neutro uniforme con las filas de días
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
                // 2. CUERPO PRINCIPAL
Expanded(
  child: Row(
    crossAxisAlignment: CrossAxisAlignment.start, // <-- AÑADIR ESTA LÍNEA (Alinea sidebar y grid arriba)
    children: [
      // Sidebar lateral
      SizedBox(
        width: _sidebarWidth,
        child: SingleChildScrollView(
          controller: _verticalSideController,
          scrollDirection: Axis.vertical,
          physics: const ClampingScrollPhysics(),
          child: _buildSideBar(uiRows),
        ),
      ),
      // Rejilla Central
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

  // --- COMPONENTES VISUALES ---

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
          alignment: Alignment.center, // Centramos la hora para optimizar el espacio de 48px
          decoration: const BoxDecoration(
            border: Border(left: BorderSide(color: Color(0xFFE0E0E0), width: 1)),
          ),
          child: Text(
            "$horaStr:00",
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 11.0, 
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
    mainAxisAlignment: MainAxisAlignment.start, // Alinea las filas al inicio (arriba)
    crossAxisAlignment: CrossAxisAlignment.start,
    children: uiRows.map((item) {
      if (item is String) {
        // Encabezado de Fecha
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
          height: _rowHeight,
          width: _sidebarWidth,
          padding: const EdgeInsets.symmetric(horizontal: 2),
          color: esHoy ? const Color(0xFF4CAF50) : const Color.fromARGB(255, 61, 66, 71),
          alignment: Alignment.center,
          child: Text(
            "$diaSemana $fechaFormateada",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11.5, // +2px
              fontWeight: FontWeight.w800, // Mayor peso visual
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        );
      } else if (item is VueloCalendario) {
        // Fila de Aerolínea
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
              fontWeight: FontWeight.w600, // Más peso
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

  // Calculamos la altura total exacta que debe tener la cuadrícula
  final double totalHeight = uiRows.length * _rowHeight;

  return SizedBox(
    width: totalWidth,
    height: totalHeight, // <-- Altura fija explícita para evitar centrado/expansión vertical
    child: Stack(
      alignment: Alignment.topLeft,
      children: [
        // 1. DIBUJAR RETÍCULA DE FONDO
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

        // 2. DIBUJAR TARJETAS DE VUELO
        ..._buildTarjetasVuelos(uiRows, hourWidth),

        // 3. LÍNEA ROJA (HORA ACTUAL)
        Positioned(
          top: 0,
          height: totalHeight, // <-- Usamos la altura explícita en vez de bottom: 0
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

/// Genera los widgets posicionados de cada tarjeta de vuelo dentro del Stack
List<Widget> _buildTarjetasVuelos(List<dynamic> uiRows, double hourWidth) {
  final List<Widget> tarjetas = [];

  for (int index = 0; index < uiRows.length; index++) {
    final item = uiRows[index];

    if (item is VueloCalendario) {
      final double topOffset = index * _rowHeight;

      // Cálculo de horas inicio y fin
      final DateTime? inicio = item.trcFechaInicio != null && item.trcHoraInicio != null
          ? DateTime.tryParse("${item.trcFechaInicio} ${item.trcHoraInicio}")
          : (item.fechaInicio != null ? DateTime.tryParse(item.fechaInicio!) : null);

      final DateTime? fin = item.trcFechaFin != null && item.trcHoraFin != null
          ? DateTime.tryParse("${item.trcFechaFin} ${item.trcHoraFin}")
          : (item.fechaFin != null ? DateTime.tryParse(item.fechaFin!) : null);

      if (inicio == null) continue;

      final double horaDecimalInicio = inicio.hour + (inicio.minute / 60.0);
      final double horaDecimalFin = fin != null 
          ? fin.hour + (fin.minute / 60.0) 
          : horaDecimalInicio + 1.5; // Duración por defecto si no viene fin

      double duracionHoras = horaDecimalFin - horaDecimalInicio;
      if (duracionHoras <= 0) duracionHoras = 1.0; // Evita anchos negativos

      final double leftX = horaDecimalInicio * hourWidth;
      final double width = duracionHoras * hourWidth;

      // Definir color de la tarjeta según estatus/color de la API
      // Obtiene el Color directamente según el nombre recibido en estatusColor
      final Color cardColor = obtenerColorPorEstatus(item);

      tarjetas.add(
        Positioned(
          top: topOffset + 3,
          left: leftX,
          width: width.clamp(40.0, double.infinity), // Ancho mínimo para legibilidad
          height: _rowHeight - 6,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.black12, width: 0.8),
            ),
            alignment: Alignment.center,
            child: Text(
              item.numeroVuelo,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 11,
                fontWeight: FontWeight.w800, // Negrita marcada para resaltar la matrícula/número
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      );
    }
  }

  return tarjetas;
}
}



