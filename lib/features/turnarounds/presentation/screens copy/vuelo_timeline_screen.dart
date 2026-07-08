import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:scounter_mobile/features/shared/shared.dart';
import 'package:scounter_mobile/features/turnarounds/domain/domain.dart';
import 'package:scounter_mobile/features/turnarounds/presentation/providers/providers.dart';
import 'package:scounter_mobile/features/turnarounds/presentation/widgets/widgets.dart';

class VueloTimelineScreen extends ConsumerStatefulWidget {
  const VueloTimelineScreen({super.key});

  @override
  ConsumerState<VueloTimelineScreen> createState() => _VueloTimelineScreenState();
}

class _VueloTimelineScreenState extends ConsumerState<VueloTimelineScreen> {
  // Controladores sincronizados
  late LinkedScrollControllerGroup _horizontalControllers;
  late ScrollController _horizontalHeaderController;
  late ScrollController _horizontalBodyController;

  late LinkedScrollControllerGroup _verticalControllers;
  late ScrollController _verticalSideController;
  late ScrollController _verticalBodyController;

  // Configuración de dimensiones base
  // Antes: _rowHeight = 80.0; -> Ahora: 40.0 (la mitad)
  final double _rowHeight = 30.0; 

  // Antes: _baseHourWidth = 150.0; -> Ahora: 75.0 (la mitad para zoom out inicial)
  final double _baseHourWidth = 40.0; 

  // Antes: _sideBarWidth = 130.0; -> Ahora: 80.0 (aprox. 40% menos)
  final double _sideBarWidth = 80.0;


  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  bool _showNavigationHeader = true; // Por defecto se muestra

  // 1. Agrega esta variable booleana arriba en tu State (fuera del build) para controlar el disparo único:
bool _yaSeHizoScrollInicial = false;


  @override
  void initState() {
    super.initState();
    _horizontalControllers = LinkedScrollControllerGroup();
    _horizontalHeaderController = _horizontalControllers.addAndGet();
    _horizontalBodyController = _horizontalControllers.addAndGet();

    _verticalControllers = LinkedScrollControllerGroup();
    _verticalSideController = _verticalControllers.addAndGet();
    _verticalBodyController = _verticalControllers.addAndGet();

    _horizontalBodyController.addListener(() {
      setState(() {}); // Fuerza el redibujado de la posición X de la línea roja al hacer scroll
    });

    // ya viene del provider
    
  }

  @override
  void dispose() {
    _horizontalHeaderController.dispose();
    _horizontalBodyController.dispose();
    _verticalSideController.dispose();
    _verticalBodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(vuelosTimelineProvider);
    // Aplicamos el Zoom Lógico al ancho de la hora
    final double currentHourWidth = _baseHourWidth * state.zoomLevel;
    // final lanes = VueloLayoutHelper.asignarVuelosALanes(widget.vuelos);
    

    // Escuchamos el estado del provider
    final timelineState = ref.watch(vuelosTimelineProvider);
    final notifier = ref.read(vuelosTimelineProvider.notifier);
    // final lanes = timelineState.lanes;
    

    ref.listen(vuelosTimelineProvider.select((s) => s.startDate), (previous, next) {
    final state = ref.read(vuelosTimelineProvider);
    
    // AQUÍ LLAMAS A TU REPOSITORIO O USE CASE
    // Ejemplo:
    ref.read(vuelosTimelineProvider.notifier).getVuelosTimeline(
      VueloCalendarioRequest(
        start: state.startDate,
        end: state.endDate
      )
    );
    
    print("Cargando datos desde ${state.startDate} hasta ${state.endDate}");
  });


    // Formateamos la fecha actual (ej: "OCTUBRE 2018")
  final monthLabel = DateFormat('MMMM yyyy', 'es').format(timelineState.startDate).toUpperCase();

    // if (timelineState.isLoading) {
    //   return const Center(child: CircularProgressIndicator());
    // }

    // if (lanes.isEmpty) {
    //   return const Center(child: Text("No hay vuelos programados"));
    // }



    // // Una forma rápida de hacerlo en el build o en el provider:
    // final List<dynamic> itemsParaMostrar = [];
    // String? ultimoDia;

    // for (var lane in state.lanes) {
    //   if (lane.dia != ultimoDia) {
    //     itemsParaMostrar.add(lane.dia); // Agregamos el String de la fecha como separador
    //     ultimoDia = lane.dia;
    //   }
    //   itemsParaMostrar.add(lane); // Agregamos el objeto Lane normal
    // }


    // 1. PRIMERO evaluamos si está cargando
  if (state.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

  // 2. SEGUNDO evaluamos si después de cargar realmente no hay nada
  if (timelineState.lanes.isEmpty) {
    return Scaffold(
      // backgroundColor: Colors.grey[100],
      appBar: AppBar(title: const Text("Workload")),
      body: Column(
        children: [
          _buildNavigationHeader(context, timelineState, notifier), // Para poder movernos de mes aunque esté vacío
          const Expanded(child: Center(child: Text("No hay vuelos en este periodo"))),
        ],
      ),
    );
  }

    
// 1. FILTRADO REACTIVO DE LANES
//   final lanesFiltradas = state.lanes.where((lane) {
//   // Si el set está vacío, significa que no hay restricciones (muestra todas)
//   if (state.aerolineasFiltradas.isEmpty) return true; 
//   // Si no está vacío, verifica si el nombre está en las seleccionadas
//   return state.aerolineasFiltradas.contains(lane.aerolineaNombre);
// }).toList();

// Dentro del método build de tu Scaffold:
final lanesFiltradas = state.lanes.where((lane) {
  // Si el set está vacío, significa que no hay restricciones (muestra todas)
  if (state.aerolineasFiltradas.isEmpty) return true; 
  // Si no está vacío, verifica si el nombre está en las seleccionadas
  return state.aerolineasFiltradas.contains(lane.aerolineaNombre);
}).toList();

   // 2. CONSTRUCCIÓN DE UI ROWS CON LAS LANES FILTRADAS
  final List<dynamic> uiRows = [];
  String? ultimoDia;
  for (var lane in lanesFiltradas) {
    if (lane.dia != ultimoDia) {
      uiRows.add(lane.dia);
      ultimoDia = lane.dia;
    }
    uiRows.add(lane);
  }

void _scrollToCurrentTime(double hourWidth, List<dynamic> uiRows) {
  final ahora = DateTime.now();

  // 1. Control de seguridad diario (Fuera del callback es seguro porque usa uiRows del build)
  final String hoyFormateado = DateFormat('yyyy-MM-dd').format(ahora);
  bool laSemanaContieneAHoy = uiRows.any((item) => item is String && item == hoyFormateado);
  if (!laSemanaContieneAHoy) return;

  // 2. PASAMOS TODO EL BLOQUE DENTRO DEL POST FRAME CALLBACK
  WidgetsBinding.instance.addPostFrameCallback((_) {
    // Verificamos de forma segura si el controlador ya tiene vistas asignadas
    if (_horizontalBodyController.hasClients) {
      
      // Calculamos la posición X absoluta de la hora actual en píxeles
      final double horaDecimal = ahora.hour + (ahora.minute / 60.0);
      final double positionXLinearoja = horaDecimal * hourWidth;

      // Obtenemos el ancho de la pantalla y el 20% de margen
      final double screenWidth = MediaQuery.of(context).size.width;
      final double offsetAl20PorCiento = screenWidth * 0.20;

      // Ahora sí es 100% seguro leer maxScrollExtent porque hasClients es verdadero
      final double targetScrollX = (positionXLinearoja - offsetAl20PorCiento).clamp(
        0.0, 
        _horizontalBodyController.position.maxScrollExtent,
      );

      // Ejecutamos la animación fluida
      _horizontalBodyController.animateTo(
        targetScrollX,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOutCubic,
      );
    }
  });
}
// void _scrollToCurrentTime(double hourWidth) {
//   final ahora = DateTime.now();

//   // 1. CONTROL DE SEGURIDAD: Solo hacemos scroll si el día de hoy está en pantalla
//   final String hoyFormateado = DateFormat('yyyy-MM-dd').format(ahora);
//   bool laSemanaContieneAHoy = uiRows.any((item) => item is String && item == hoyFormateado);
//   if (!laSemanaContieneAHoy) return;

//   // 2. Calculamos la posición X absoluta de la hora actual en píxeles
//   final double horaDecimal = ahora.hour + (ahora.minute / 60.0);
//   final double positionXLinearoja = horaDecimal * hourWidth;

//   // 3. Obtenemos el ancho de la pantalla y calculamos el 20% de margen
//   final double screenWidth = MediaQuery.of(context).size.width;
//   final double offsetAl20PorCiento = screenWidth * 0.20;

//   // 4. El destino del scroll será la posición de la línea menos ese 20%
//   // Usamos .clamp para evitar valores negativos si es muy temprano en la madrugada (ej: 1:00 AM)
//   final double targetScrollX = (positionXLinearoja - offsetAl20PorCiento).clamp(
//     0.0, 
//     _horizontalBodyController.position.maxScrollExtent,
//   );

//   // 5. Ejecutamos el scroll de forma fluida
//   WidgetsBinding.instance.addPostFrameCallback((_) {
//     if (_horizontalBodyController.hasClients) {
//       _horizontalBodyController.animateTo(
//         targetScrollX,
//         duration: const Duration(milliseconds: 800),
//         curve: Curves.easeInOutCubic,
//       );
//     }
//   });
// }

// return Scaffold(
//       backgroundColor: Colors.grey[100],
//       key: scaffoldKey,
//       drawer: SideMenu(scaffoldKey: scaffoldKey),
//       // 1. Envolvemos el AppBar en un PreferredSize
//       appBar: PreferredSize(
//         // La altura responde dinámicamente al estado del filtro
//         preferredSize: Size.fromHeight(appBarHeight + 24.0), // 24px base para las acciones/título
//         child: AppBar(
//           backgroundColor: Colors.white,
//           elevation: 0,
//           // Eliminamos los paddings por defecto del título
//           titleSpacing: 0, 
//           // 2. Usamos el widget de navegación por meses que ya tenías
//           leading: IconButton(
//             icon: const Icon(Icons.more_vert),
//             onPressed: () {
//               // Open the SideMenu SideMenu(scaffoldKey: scaffoldKey),
//               // SideMenu(scaffoldKey: scaffoldKey);
//               scaffoldKey.currentState?.openDrawer();
//             },
//             //   // scaffoldKey.currentState?.openDrawer();
//           ),


    // Calculamos la altura dinámica del AppBar superior
  final double appBarHeight = _showNavigationHeader ? 64.0 : 0.0; // Subió a 64px para albergar las dos filas
  final double totalAppBarHeight = appBarHeight + 32.0;
    // ----------------------------------------



    void _scrollToCurrentDay(List<dynamic> uiRows) {
      // 1. Obtenemos la fecha de hoy sin horas (Año-Mes-Día)
      final String hoyFormateado = DateFormat('yyyy-MM-dd').format(DateTime.now());

      // 2. Buscamos el índice en uiRows que coincida con la fecha de hoy
      int indexHoy = uiRows.indexWhere((item) => item is String && item == hoyFormateado);

      // Si encuentra el día de hoy en la semana actual, hacemos el scroll
      if (indexHoy != -1) {
        // Calculamos los píxeles exactos: índice multiplicado por el alto de tu fila
        final double targetOffset = indexHoy * _rowHeight;

        // Ejecutamos después de que el frame de Flutter termine de dibujarse
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_verticalSideController.hasClients) {
            _verticalSideController.animateTo(
              targetOffset,
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeInOutCubic,
            );
            
            // ¡RECUERDA!: Si usas otro controlador vertical para el cuerpo del timeline 
            // (ej: _verticalBodyController), debes replicar el animateTo aquí para que vayan juntos.
            // _verticalBodyController.animateTo(targetOffset, duration: const Duration(milliseconds: 600), curve: Curves.easeInOutCubic);
          }
        });
      }
    }

    // Dentro del método build, justo antes del return Scaffold:
    // if (uiRows.isNotEmpty) {
    //   _scrollToCurrentDay(uiRows);
    // }


    // DEJA ÚNICAMENTE ESTE BLOQUE:
    if (uiRows.isNotEmpty && !state.scrollInicialRealizado) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!state.scrollInicialRealizado) {
          notifier.marcarScrollComoRealizado(); 
          _scrollToCurrentDay(uiRows);
          _scrollToCurrentTime(currentHourWidth, uiRows);
        }
      });
    }

    return Scaffold(
  backgroundColor: Colors.grey[100],
  key: scaffoldKey,
  drawer: SideMenu(scaffoldKey: scaffoldKey),
  
  // =========================================================================
  // APPBAR ESTÁNDAR LIMPIO
  // =========================================================================
  appBar: AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
    titleSpacing: 12,
    leading: IconButton(
      icon: const Icon(Icons.more_vert),
      onPressed: () {
        scaffoldKey.currentState?.openDrawer();
      },
    ),
    title: const Center(
      child: Text(
        "Workload",
        style: TextStyle(
          color: Colors.black87,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    actions: [
      IconButton(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        constraints: const BoxConstraints(),
        icon: Icon(
          _showNavigationHeader ? Icons.filter_alt : Icons.filter_alt_off,
          color: _showNavigationHeader ? const Color(0xFF00A859) : Colors.grey,
          size: 20,
        ),
        onPressed: () {
          setState(() {
            _showNavigationHeader = !_showNavigationHeader;
          });
        },
      ),
    ],
  ),

  // =========================================================================
  // BODY PRINCIPAL DE LA PANTALLA
  // =========================================================================
  body: SafeArea(
    top: false, // Evita duplicar el padding superior del notch con el AppBar
    child: Column(
      children: [
        // 1. Cabecera animada de filtros (Fechas + Selector Múltiple de Aerolíneas)
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return SizeTransition(
              sizeFactor: animation,
              child: FadeTransition(opacity: animation, child: child),
            );
          },
          child: _showNavigationHeader
              ? _buildNavigationHeader(context, state, notifier)
              : const SizedBox.shrink(),
        ),

        // 2. Línea divisoria decorativa compacta debajo del header
        if (_showNavigationHeader)
          Container(
            height: 1,
            color: Colors.grey.withOpacity(0.2),
          ),

        // 3. El encabezado horizontal de las horas (0:00, 1:00...)
        _buildTimeHeaderRow(currentHourWidth),
        
        // 4. Contenido principal del Timeline (Barra lateral + Canvas de vuelos)
        Expanded(
          child: uiRows.isEmpty
              ? const Center(child: Text("No hay vuelos programados"))
              : Row(
                  children: [
                    // Barra lateral izquierda (Días resaltados + Filtro reactivo)
                    _buildSideBar(uiRows),
                    
                    // Cuerpo del Timeline con detector de gestos para el Zoom táctil
                    Expanded(
                      child: GestureDetector(
                        onScaleUpdate: (details) {
                          if (details.scale != 1.0) {
                            notifier.setZoom(state.zoomLevel * details.scale);
                          }
                        },
                        // Llama a la versión segura del timeline con la línea roja incorporada dentro
                        child: _buildTimelineBody(uiRows, currentHourWidth),
                      ),
                    ),
                  ],
                ),
        ),
      ],
    ),
  ),
);
}

  // --- COMPONENTES DEL LAYOUT ---
Widget _buildNavigationHeader(BuildContext context, VueloTimelineState state, VueloTimelineNotifier notifier) {
  final String fechaInicioFormateada = DateFormat('dd MMM', 'es').format(state.startDate).toUpperCase();
  final String fechaFinFormateada = DateFormat('dd MMM yyyy', 'es').format(state.endDate).toUpperCase();
  final String weekLabel = "$fechaInicioFormateada - $fechaFinFormateada";

  // final Set<String> aerolineasUnicas = state.lanes.map((l) => l.aerolineaNombre).toSet();
  // final bool tieneFiltroActivo = state.aerolineasFiltradas.isNotEmpty;

  final Set<String> aerolineasUnicas = state.lanes.map((l) => l.aerolineaNombre).toSet();
  final bool tieneFiltroActivo = state.aerolineasFiltradas.isNotEmpty;

  // Texto dinámico para el botón de filtro
  final String textoBoton = tieneFiltroActivo 
      ? "Aerolíneas (${state.aerolineasFiltradas.length})" 
      : "Filtrar por Aerolínea";

  return Container(
    // height: 64.0, // Altura para las dos filas compactas
    padding: const EdgeInsets.only(left: 8, right: 8, top: 0, bottom: 4), // Un padding vertical cómodo
    decoration: const BoxDecoration(
      color: Colors.white,
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min, // Le dice a la columna que ocupe el mínimo espacio vertical requerido
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ================= FILA 1: NAVEGACIÓN TEMPORAL =================
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: const Icon(Icons.arrow_back_ios_new, size: 14),
              // onPressed: () => notifier.moveToPreviousWeek(),
              onPressed: () {
              setState(() {
                _yaSeHizoScrollInicial = false; // Permitimos que al redibujar la nueva semana busque el ancla si corresponde
              });
              notifier.moveToPreviousWeek();
            }
            ),
            GestureDetector(
              onTap: () async {
            // Abrimos el DatePicker nativo
            final DateTime? fechaElegida = await showDatePicker(
              context: context,
              initialDate: state.startDate, // Abre por defecto en la semana actual
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
              locale: const Locale('es', 'ES'), // Fuerza el calendario en español
              builder: (context, child) {
                // Personalización estética para que combine con tu paleta oscura corporativa
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.light(
                      primary: Colors.blueGrey[900]!, // Fondo del encabezado del calendario
                      onPrimary: Colors.white,
                      onSurface: Colors.black87, // Color de los días
                    ),
                    // --- AQUÍ REDUCIMOS LAS FUENTES DEL CALENDARIO ---
                    textTheme: const TextTheme(
                      // Texto del año y día seleccionados en el encabezado superior
                      headlineMedium: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold), 
                      // Texto del mes y año del selector (Ej: "Junio 2026")
                      titleSmall: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
                      // Los números de los días en la cuadrícula
                      bodyLarge: TextStyle(fontSize: 16.0),
                      // Los nombres de los días de la semana (L, M, M, J...)
                      labelLarge: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                    ),
                    // ------------------------------------------------
                    // --- CAPTURA Y ESTILIZA LOS BOTONES DE ACCIÓN ---
                    textButtonTheme: TextButtonThemeData(
                      style: TextButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.primary, // <-- Aquí asignas el color del texto de los botones
                        textStyle: const TextStyle(
                          fontSize: 14.0, // Tamaño de letra para los botones "Aceptar/Cancelar"
                          fontWeight: FontWeight.bold,
                        ),
                        // border
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          side: BorderSide(color: Theme.of(context).colorScheme.primary), // Borde del botón
                        ),
                        
                      ),
                    ),
                    // ------------------------------------------------
                  ),
                  child: child!,
                );
              },
            );

            // Si el usuario no canceló, procesamos la fecha
            if (fechaElegida != null) {
              notifier.cambiarSemanaPorFecha(fechaElegida);
            }
          },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.calendar_month, size: 12, color: Colors.blueAccent),
                    const SizedBox(width: 6),
                    Text(
                      weekLabel,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold, 
                        fontSize: 11, // Tus 11px estables
                        height: 1.0,
                      ),
                    ),
                    const SizedBox(width: 2),
                    const Icon(Icons.arrow_drop_down, size: 14, color: Colors.grey),
                  ],
                ),
              ),
            ),

            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: const Icon(Icons.arrow_forward_ios, size: 14),
              // onPressed: () => notifier.moveToNextWeek(),
              onPressed: () {
                setState(() {
                  _yaSeHizoScrollInicial = false; // Permitimos que al redibujar la nueva semana busque el ancla si corresponde
                });
                notifier.moveToNextWeek();
              }
            ),
          ],
        ),
        
        const SizedBox(height: 6), // Espaciador sutil entre filas

        // ================= FILA 2: FILTROS DE CONTENIDO =================
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => _mostrarSelectorMultiAerolineas(context, state, notifier, aerolineasUnicas),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: tieneFiltroActivo ? Colors.blueAccent.withOpacity(0.12) : Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: tieneFiltroActivo ? Colors.blueAccent : Colors.grey.shade300,
                    width: 0.8,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.connecting_airports, 
                      size: 13, 
                      color: tieneFiltroActivo ? Colors.blueAccent : Colors.grey[600]
                    ),
                    const SizedBox(width: 6),
                    Text(
                      textoBoton,
                      style: TextStyle(
                        color: tieneFiltroActivo ? Colors.blueAccent : Colors.black87, 
                        fontSize: 11, 
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    const SizedBox(width: 2),
                    Icon(Icons.arrow_drop_down, size: 14, color: tieneFiltroActivo ? Colors.blueAccent : Colors.grey),
                  ],
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 6), // Espaciador sutil entre filas
      ],
    ),
  );
}

// --- MODAL DE SELECCIÓN MÚLTIPLE ---
void _mostrarSelectorMultiAerolineas(
  BuildContext context, 
  VueloTimelineState state, 
  VueloTimelineNotifier notifier,
  Set<String> aerolineas,
) {
  showDialog(
    context: context,
    builder: (context) {
      // Usamos StatefulBuilder para que los checkboxes se marquen/desmarquen fluidamente dentro del modal
      return StatefulBuilder(
        builder: (context, setModalState) {
          return AlertDialog(
            title: const Text(
              "Seleccionar Aerolíneas",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
            content: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Opción para limpiar filtros rápidamente
                  ListTile(
                    leading: const Icon(Icons.clear_all, color: Colors.redAccent, size: 20),
                    title: const Text("Mostrar Todas (Reset)", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                    onTap: () {
                      notifier.limpiarFiltroAerolineas();
                      Navigator.of(context).pop(); // Cierra el modal de inmediato al resetear
                    },
                  ),
                  const Divider(height: 1),
                  
                  // Listado dinámico con Checkboxes
                  Flexible(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        // Creamos la lista ordenada entre paréntesis y luego la mapeamos a los Widgets correspondientes
                        ...(aerolineas.toList()..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase())))
                            .map((String aerolinea) {
                          final bool estaSeleccionada = state.aerolineasFiltradas.contains(aerolinea);
                          return CheckboxListTile(
                            title: Text(aerolinea, style: const TextStyle(fontSize: 13)),
                            value: estaSeleccionada,
                            activeColor: Theme.of(context).colorScheme.primary,
                            controlAffinity: ListTileControlAffinity.leading,
                            dense: true,
                            onChanged: (_) {
                              notifier.toggleAerolineaFiltro(aerolinea);
                              setModalState(() {}); 
                            },
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.primary,
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: BorderSide(color: Theme.of(context).colorScheme.primary),
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text("Aplicar"),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}


//   Widget _buildNavigationHeader(BuildContext context, VueloTimelineState state, VueloTimelineNotifier notifier) {
//   final String fechaInicioFormateada = DateFormat('dd MMM', 'es').format(state.startDate).toUpperCase();
//   final String fechaFinFormateada = DateFormat('dd MMM yyyy', 'es').format(state.endDate).toUpperCase();
//   final String weekLabel = "$fechaInicioFormateada - $fechaFinFormateada";

//   // OBTENER LISTA DE AEROLÍNEAS ÚNICAS DESDE EL ESTADO BASE
//   // Usamos un Set para eliminar nombres duplicados automáticamente
//   final Set<String> aerolineasUnicas = state.lanes.map((l) => l.aerolineaNombre).toSet();

//   return Container(
//     height: 36.0,
//     padding: const EdgeInsets.symmetric(horizontal: 8),
//     decoration: const BoxDecoration(color: Colors.white),
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         // Flecha Izquierda
//         IconButton(
//           padding: EdgeInsets.zero,
//           constraints: const BoxConstraints(),
//           icon: const Icon(Icons.arrow_back_ios_new, size: 14),
//           onPressed: () => notifier.moveToPreviousWeek(),
//         ),
        
//         // --- CHIP 1: DATE PICKER ---
//         GestureDetector(
//           onTap: () async {
//             // Abrimos el DatePicker nativo
//             final DateTime? fechaElegida = await showDatePicker(
//               context: context,
//               initialDate: state.startDate, // Abre por defecto en la semana actual
//               firstDate: DateTime(2020),
//               lastDate: DateTime(2030),
//               locale: const Locale('es', 'ES'), // Fuerza el calendario en español
//               builder: (context, child) {
//                 // Personalización estética para que combine con tu paleta oscura corporativa
//                 return Theme(
//                   data: Theme.of(context).copyWith(
//                     colorScheme: ColorScheme.light(
//                       primary: Colors.blueGrey[900]!, // Fondo del encabezado del calendario
//                       onPrimary: Colors.white,
//                       onSurface: Colors.black87, // Color de los días
//                     ),
//                     // --- AQUÍ REDUCIMOS LAS FUENTES DEL CALENDARIO ---
//                     textTheme: const TextTheme(
//                       // Texto del año y día seleccionados en el encabezado superior
//                       headlineMedium: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold), 
//                       // Texto del mes y año del selector (Ej: "Junio 2026")
//                       titleSmall: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
//                       // Los números de los días en la cuadrícula
//                       bodyLarge: TextStyle(fontSize: 16.0),
//                       // Los nombres de los días de la semana (L, M, M, J...)
//                       labelLarge: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
//                     ),
//                     // ------------------------------------------------
//                     // --- CAPTURA Y ESTILIZA LOS BOTONES DE ACCIÓN ---
//                     textButtonTheme: TextButtonThemeData(
//                       style: TextButton.styleFrom(
//                         foregroundColor: Theme.of(context).colorScheme.primary, // <-- Aquí asignas el color del texto de los botones
//                         textStyle: const TextStyle(
//                           fontSize: 14.0, // Tamaño de letra para los botones "Aceptar/Cancelar"
//                           fontWeight: FontWeight.bold,
//                         ),
//                         // border
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(20.0),
//                           side: BorderSide(color: Theme.of(context).colorScheme.primary), // Borde del botón
//                         ),
                        
//                       ),
//                     ),
//                     // ------------------------------------------------
//                   ),
//                   child: child!,
//                 );
//               },
//             );

//             // Si el usuario no canceló, procesamos la fecha
//             if (fechaElegida != null) {
//               notifier.cambiarSemanaPorFecha(fechaElegida);
//             }
//           },
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//             decoration: BoxDecoration(
//               color: Colors.grey[200],
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Row(
//               children: [
//                 const Icon(Icons.calendar_month, size: 12, color: Colors.blueAccent),
//                 const SizedBox(width: 4),
//                 Text(weekLabel, style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 10.5, height: 1.0)),
//                 const Icon(Icons.arrow_drop_down, size: 14, color: Colors.grey),
//               ],
//             ),
//           ),
//         ),

//         const SizedBox(width: 4), // Separador sutil entre los dos filtros

//         // --- CHIP 2: DROPDOWN DE AEROLÍNEAS ---
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//           decoration: BoxDecoration(
//             color: state.aerolineaFiltrada != null ? Colors.blueAccent.withOpacity(0.15) : Colors.grey[200],
//             borderRadius: BorderRadius.circular(12),
//             border: state.aerolineaFiltrada != null ? Border.all(color: Colors.blueAccent, width: 0.5) : null,
//           ),
//           child: DropdownButtonHideUnderline(
//             child: DropdownButton<String>(
//               value: state.aerolineaFiltrada,
//               hint: Row(
//                 children: [
//                   Icon(Icons.connecting_airports, size: 12, color: Colors.grey[600]),
//                   const SizedBox(width: 4),
//                   const Text("Aerolíneas", style: TextStyle(color: Colors.black87, fontSize: 10.5, fontWeight: FontWeight.bold)),
//                 ],
//               ),
//               icon: const Icon(Icons.arrow_drop_down, size: 14, color: Colors.grey),
//               isDense: true, // Crucial para mantener los 36px de alto del AppBar
//               style: const TextStyle(color: Colors.black87, fontSize: 11, fontWeight: FontWeight.bold),
//               dropdownColor: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//               onChanged: (String? nuevoValor) {
//                 notifier.filtrarPorAerolinea(nuevoValor);
//               },
//               items: [
//                 // OPCIÓN POR DEFECTO: Resetear / Mostrar todas
//                 DropdownMenuItem<String>(
//                   value: null,
//                   child: Row(
//                     children: [
//                       Icon(Icons.clear_all, size: 14, color: Colors.blueGrey[900]),
//                       const SizedBox(width: 6),
//                       Text("Mostrar Todas", style: TextStyle(color: Colors.blueGrey[900], fontWeight: FontWeight.bold)),
//                     ],
//                   ),
//                 ),
//                 // MAPEO DE AEROLÍNEAS DINÁMICAS
//                 ...aerolineasUnicas.map((String aerolinea) {
//                   return DropdownMenuItem<String>(
//                     value: aerolinea,
//                     child: Text(aerolinea),
//                   );
//                 }),
//               ],
//             ),
//           ),
//         ),

//         // Flecha Derecha
//         IconButton(
//           padding: EdgeInsets.zero,
//           constraints: const BoxConstraints(),
//           icon: const Icon(Icons.arrow_forward_ios, size: 14),
//           onPressed: () => notifier.moveToNextWeek(),
//         ),
//       ],
//     ),
//   );
// }
  
  
  Widget _buildTimeHeaderRow(double hourWidth) {
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          SizedBox(width: _sideBarWidth), // Espacio de la barra lateral
          Expanded(
            child: SingleChildScrollView(
              controller: _horizontalHeaderController,
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(24, (i) => Container(
                  width: hourWidth,
                  height: 25, // Antes era 40, ahora más delgado
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(color: Colors.grey.shade300),
                      bottom: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  child: Text("$i:00", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                )),
              ),
            ),
          ),
        ],
      ),
    );
  }

Widget _buildSideBar(List<dynamic> uiRows) {
  return SizedBox(
    width: _sideBarWidth,
    child: ListView.builder(
      controller: _verticalSideController,
      itemCount: uiRows.length,
      itemExtent: _rowHeight, 
      itemBuilder: (context, index) {
        final item = uiRows[index];

        // CASO A: SEPARADOR DE DÍA
        if (item is String) {
          String diaSemana = '';
          String fechaFormateada = item;
          bool esHoy = false; // <--- Bandera para saber si es el día actual

          try {
    final date = DateTime.parse(item);
    diaSemana = DateFormat('EEEE', 'es').format(date).toUpperCase();
    fechaFormateada = DateFormat('dd-MM-yyyy').format(date);
    
    // Verificamos si la fecha de la fila es exactamente HOY
    final ahora = DateTime.now();
    esHoy = date.year == ahora.year && date.month == ahora.month && date.day == ahora.day;
  } catch (e) {
    diaSemana = "FECHA";
  }

          return Container(
            height: _rowHeight,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              // CAMBIO DE COLOR: Si es hoy, usamos el verde corporativo. Si no, tu BlueGrey oscuro de siempre.
              color: esHoy ? Theme.of(context).colorScheme.primary : Colors.blueGrey[900],
              border: Border(
                bottom: BorderSide(color: Colors.black.withOpacity(0.2)),
                // Si es hoy, le ponemos una sutil línea brillante abajo para darle más carácter
                top: esHoy ? const BorderSide(color: Colors.white30, width: 1) : BorderSide.none,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  diaSemana,
                  style: const TextStyle(
                    // color: Colors.blueAccent,
                    color: Colors.white,
                    fontSize: 14.0, // Subió de 7 a 9
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.3,
                    height: 0.9, // Reduce interlineado para evitar desborde
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  fechaFormateada, // <--- Agrega etiqueta visual extra
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14.0, // Subió de 8.5 a 10.5
                    fontWeight: FontWeight.w600,
                    height: 0.9,
                  ),
                ),
              ],
            ),
          );
        }

        // CASO B: AEROLÍNEA NORMAL
        final lane = item as VueloLane;
        return Container(
          height: _rowHeight,
          padding: const EdgeInsets.symmetric(horizontal: 2),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade200),
              right: BorderSide(color: Colors.grey.shade300),
            ),
          ),
          child: Text(
            lane.aerolineaNombre,
            style: const TextStyle(
              fontSize: 11.0, // Subió de 9 a 11
              fontWeight: FontWeight.bold, // Más grueso para mejor legibilidad
              color: Colors.black87,
              height: 1.0,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        );
      },
    ),
  );
}

Widget _buildTimelineBody(List<dynamic> uiRows, double hourWidth) {
  final double totalWidth = 24 * hourWidth;
  final double totalHeight = uiRows.length * _rowHeight; // Altura exacta calculada en píxeles

  return SingleChildScrollView(
    controller: _horizontalBodyController,
    scrollDirection: Axis.horizontal,
    child: SizedBox(
      width: totalWidth, 
      child: SingleChildScrollView(
        controller: _verticalBodyController,
        scrollDirection: Axis.vertical,
        child: SizedBox(
          height: totalHeight, // <--- EL BLINDAJE: Esto le da el tamaño vertical exacto que Flutter exige
          child: Stack(
            children: [
              // 1. TU MALLA DE FONDO ORIGINAL (Se queda justo al inicio del Stack)
              _buildBackgroundGrid(uiRows.length, hourWidth),
              
              // 2. TUS TARJETAS DE VUELOS Y SEPARADORES
              ..._buildTimelineElements(uiRows, hourWidth),

              // =========================================================
              // 3. INDICADOR EN VIVO: LÍNEA ROJA VERTICAL (SIEMPRE AL FINAL)
              // =========================================================
              StreamBuilder<DateTime>(
                stream: Stream.periodic(const Duration(seconds: 30), (_) => DateTime.now()),
                builder: (context, snapshot) {
                  final ahora = DateTime.now();
                  
                  // Validación de seguridad semanal
                  final String hoyFormateado = DateFormat('yyyy-MM-dd').format(ahora);
                  bool laSemanaContieneAHoy = uiRows.any((item) => item is String && item == hoyFormateado);
                  
                  if (!laSemanaContieneAHoy) return const SizedBox.shrink();

                  final double leftPosition = _getXPositionForCurrentTime(hourWidth);

                  return Positioned(
                    key: const ValueKey('linea_roja_time_indicator'), 
                    top: 0,
                    bottom: 0, // Ahora es 100% legal usar bottom: 0 porque el SizedBox padre fija la altura (totalHeight)
                    left: leftPosition,
                    width: 2.0, 
                    child: Container(
                      color: Colors.redAccent.shade700,
                    ),
                  );
                },
              ),
              // =========================================================
            ],
          ),
        ),
      ),
    ),
  );
}
// Widget _buildTimelineBody(List<dynamic> uiRows, double hourWidth) {
//   return RepaintBoundary(
//     child: SingleChildScrollView(
//       controller: _horizontalBodyController,
//       scrollDirection: Axis.horizontal,
//       child: SingleChildScrollView(
//         controller: _verticalBodyController,
//         child: SizedBox(
//           width: 24 * hourWidth,
//           // El alto ahora contempla las filas normales + las filas de separador
//           height: uiRows.length * _rowHeight, 
//           child: Stack(
//             children: [
//               // Cuadrícula base (líneas verticales de horas)
//               _buildBackgroundGrid(uiRows.length, hourWidth),
              
//               // Capa de Separadores horizontales y nodos de Vuelo
//               ..._buildTimelineElements(uiRows, hourWidth),
//             ],
//           ),
//         ),
//       ),
//     ),
//   );
// }

List<Widget> _buildTimelineElements(List<dynamic> uiRows, double hourWidth) {
  final List<Widget> elements = [];
  
  final double screenWidth = MediaQuery.of(context).size.width;
  
  final double scrollX = _horizontalBodyController.hasClients 
      ? _horizontalBodyController.offset 
      : 0.0;

  // --- CORRECCIÓN ULTRA-SEGURA PARA EXTREMOS (22:00h+) ---
  // Extendemos el buffer de visualización. 
  // Hacia la izquierda mantenemos 500px, pero hacia la derecha le damos 1500px 
  // para capturar vuelos nocturnos antes de que el scroll físico llegue a ellos.
  final double viewPortStart = scrollX - 500;
  final double viewPortEnd = scrollX + screenWidth + 1500; 

  for (int i = 0; i < uiRows.length; i++) {
    final item = uiRows[i];
    final double topPosition = i * _rowHeight;

    // CASO A: SEPARADOR DE FECHA
    if (item is String) {
      elements.add(
        Positioned(
          top: topPosition,
          left: 0,
          right: 0,
          height: _rowHeight,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blueGrey.withOpacity(0.08),
              border: Border(
                bottom: BorderSide(color: Colors.grey.withOpacity(0.3), width: 1),
              ),
            ),
          ),
        ),
      );
      continue; 
    }

    // CASO B: FILA DE VUELOS
    final lane = item as VueloLane;
    for (var vuelo in lane.vuelos) {
      final double startPos = _timeToDouble(vuelo.horaInicio) * hourWidth;
      final double endPos = _timeToDouble(vuelo.horaFin) * hourWidth;

      // FILTRO DE CULLING REVISADO
      if (endPos < viewPortStart || startPos > viewPortEnd) {
        continue; // Fuera del súper rango seguro
      }

      elements.add(
        Positioned(
          key: ValueKey(vuelo.id),
          left: startPos,
          top: topPosition + 3, 
          width: (endPos - startPos).clamp(10.0, double.infinity), 
          height: _rowHeight - 6,
          child: VueloCard(vuelo: vuelo),
        ),
      );
    }
  }
  return elements;
}

  // Widget _buildSideBar(List<VueloLane> lanes) {
  //   return SizedBox(
  //   width: _sideBarWidth,
  //   child: ListView.builder( // Cambiamos Column por ListView.builder
  //     controller: _verticalSideController,
  //     itemCount: lanes.length,
  //     itemExtent: _rowHeight, // Altura fija para optimización máxima
  //     itemBuilder: (context, index) {
  //       final lane = lanes[index];
  //       // Comprobamos si es el primer registro de un nuevo día
  //       bool esNuevoDia = index == 0 || lanes[index - 1].dia != lane.dia;
  //       return Container(
  //         height: _rowHeight,
  //         padding: const EdgeInsets.symmetric(horizontal: 4),
  //         alignment: Alignment.center,
  //         decoration: BoxDecoration(
  //           // Si es un nuevo día, ponemos un fondo ligeramente distinto y un borde superior
  //           color: esNuevoDia ? Colors.grey[400] : Colors.white,
  //           border: Border(
  //             top: esNuevoDia ? BorderSide(color: Colors.blueGrey.shade300, width: 1.5) : BorderSide.none,
  //             bottom: BorderSide(color: Colors.grey.shade200),
  //             right: BorderSide(color: Colors.grey.shade300),
  //           ),
  //         ),
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Text(
  //               // lane.aerolineaNombre, 
  //               // Dia de la semana + número (ej: "LUN 15")
  //               "${lane.diaSemana} ${lane.diaNumero}", 
  //               style: TextStyle(
  //                 fontSize: 11, 
  //                 fontWeight: esNuevoDia ? FontWeight.bold : FontWeight.normal,
  //                 color: esNuevoDia ? Colors.blueGrey[800] : Colors.black87,
  //               ),
  //               maxLines: 1,
  //               overflow: TextOverflow.ellipsis,
  //             ),
  //               Text(lane.aerolineaNombre, style: const TextStyle(fontSize: 8, color: Colors.blueAccent, fontWeight: FontWeight.bold)),
  //             // if (esNuevoDia) // Solo mostramos el día si es el inicio del bloque
  //             //   Text(lane.dia, style: const TextStyle(fontSize: 7, color: Colors.blueAccent, fontWeight: FontWeight.bold)),
  //           ],
  //         ),
  //       );
  //     },
  //   ),
  // );
  // }

  // Widget _buildTimelineBody(List<VueloLane> lanes, double hourWidth) {
  //   return SingleChildScrollView(
  //     controller: _horizontalBodyController,
  //     scrollDirection: Axis.horizontal,
  //     child: SingleChildScrollView(
  //       controller: _verticalBodyController,
  //       child: SizedBox(
  //         width: 24 * hourWidth,
  //         height: lanes.length * _rowHeight,
  //         child: Stack(
  //           children: [
  //             // Cuadrícula de fondo
  //             RepaintBoundary(
  //             child: _buildBackgroundGrid(lanes.length, hourWidth),
  //           ),
              
  //             // Tarjetas de vuelos
  //             ..._buildVueloNodes(lanes, hourWidth),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildBackgroundGrid(int totalLanes, double hourWidth) {
    return Stack(
      children: List.generate(24, (i) => Positioned(
        left: i * hourWidth,
        top: 0,
        bottom: 0,
        child: Container(
          width: 1,
          color: Colors.grey.withOpacity(0.2),
        ),
      )),
    );
  }

  // Optimizar la creación de nodos
List<Widget> _buildVueloNodes(List<VueloLane> lanes, double hourWidth) {
  final List<Widget> nodes = [];
  
  // 1. Obtenemos el ancho de la pantalla y el scroll actual
  final double screenWidth = MediaQuery.of(context).size.width;
  final double scrollX = _horizontalBodyController.hasClients 
      ? _horizontalBodyController.offset 
      : 0.0;

  // Definimos un margen de seguridad (buffer) para que no "desaparezcan" al borde
  final double viewPortStart = scrollX - 200;
  final double viewPortEnd = scrollX + screenWidth + 200;

  for (int i = 0; i < lanes.length; i++) {
    final topPosition = i * _rowHeight + 10;
    
    for (var vuelo in lanes[i].vuelos) {
      final double startPos = _timeToDouble(vuelo.horaInicio) * hourWidth;
      final double endPos = _timeToDouble(vuelo.horaFin) * hourWidth;

      // 2. FILTRO DE RENDIMIENTO (Culling)
      // Si el vuelo termina antes de que empiece la vista, o empieza después de que termine...
      // ¡NO lo renderizamos!
      if (endPos < viewPortStart || startPos > viewPortEnd) {
        continue;
      }

      nodes.add(
        Positioned(
          key: ValueKey(vuelo.id),
          left: startPos,
          top: i * _rowHeight + 4, // Reducimos margen de 10 a 4
          width: endPos - startPos,
          height: _rowHeight - 8,  // Aumentamos el aprovechamiento del alto (40 - 8 = 32px)
          child: VueloCard(vuelo: vuelo),
        ),
      );
    }
  }
  return nodes;
}

  double _timeToDouble(String? hora) {
    if (hora == null || hora.isEmpty) return 0.0;
    try {
      final partes = hora.split(':');
      return double.parse(partes[0]) + (double.parse(partes[1]) / 60);
    } catch (e) {
      return 0.0;
    }
  }


}



double _getXPositionForCurrentTime(double hourWidth) {
  final ahora = DateTime.now();
  // Transformamos la hora actual a formato decimal (Ej: 14:30 -> 14.5)
  final double horaDecimal = ahora.hour + (ahora.minute / 60.0);
  return horaDecimal * hourWidth;
}




