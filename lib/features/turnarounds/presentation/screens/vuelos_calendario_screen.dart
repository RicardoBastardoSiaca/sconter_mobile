import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scounter_mobile/features/shared/domain/domain.dart';
import 'package:scounter_mobile/features/shared/shared.dart';
import 'package:scounter_mobile/features/turnarounds/domain/domain.dart';
import 'package:scounter_mobile/features/turnarounds/presentation/providers/providers.dart';
import 'package:scounter_mobile/features/turnarounds/presentation/widgets/widgets.dart';
// import 'vuelos_provider.dart';
// import 'calendario_vuelos_widget.dart';

class VuelosCalendarioScreen extends ConsumerStatefulWidget {
  const VuelosCalendarioScreen({super.key});

  @override
  ConsumerState<VuelosCalendarioScreen> createState() => _VuelosScreenState();
}

class _VuelosScreenState extends ConsumerState<VuelosCalendarioScreen> {
  bool _mostrarFiltros = true; // Controla la visibilidad de la barra de filtros

  // Filtros seleccionados
  String? _aerolineaSeleccionada;
  String? _estacionSeleccionada;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      // Disparar ambas peticiones en paralelo al cargar
      ref.read(vuelosCalendarioProvider.notifier).fetchVuelos(
        getCurrentMonthDateRange(DateTime.now()),
      );
      ref.read(ciudadesProvider.notifier).cargarEstaciones();
    });
  }

  // Función que devuelve el primer y el último día del mes
  VueloCalendarioRequest getCurrentMonthDateRange(DateTime? newDate) {
    final now = newDate ?? DateTime.now();
    final firstDay = DateTime(now.year, now.month, 1);
    final lastDay = DateTime(now.year, now.month + 1, 0);
    return VueloCalendarioRequest(start: firstDay, end: lastDay);
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  // Componente visual para la barra de filtros
  Widget _buildBarraFiltros(List<VueloCalendario> vuelos, List<Estacion> estaciones) {
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
                    // color: const Color(0xFFEEEEEE),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: Row(
                    children: [
                      // const Icon(Icons.flight, size: 14, color: Colors.black54),
                      const SizedBox(width: 8),
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isDense: true,
                            isExpanded: true,
                            value: _aerolineaSeleccionada,
                            hint: const Text(
                              "Aerolínea",
                              style: TextStyle(fontSize: 16, ),
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
                    // color: const Color(0xFFEEEEEE),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: Row(
                    children: [
                      // const Icon(Icons.location_on, size: 14, color: Colors.black54),
                      const SizedBox(width: 4),
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isDense: true,
                            isExpanded: true,
                            value: _estacionSeleccionada,
                            hint: const Text(
                              "Estación",
                              style: TextStyle(fontSize:16),
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
        
        const SizedBox(height: 4,),
          Row(
            children: [
              // TerminalFilterDropdown()
              Expanded(child: TerminalFilterDropdown()),
              Expanded(child: SizedBox())
            ],
          )
        
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(vuelosCalendarioProvider);
    final ciudadesState = ref.watch(ciudadesProvider);

    // Filtrado de la lista local de vuelos según los selects elegidos
    final vuelosFiltrados = state.vuelos.where((vuelo) {
      final cumpleAerolinea = _aerolineaSeleccionada == null ||
          vuelo.aerolineaNombre == _aerolineaSeleccionada;
      final cumpleEstacion = _estacionSeleccionada == null ||
          vuelo.estacionId?.toString() == _estacionSeleccionada;
      return cumpleAerolinea && cumpleEstacion;
    }).toList();

    return Scaffold(
      key: scaffoldKey,
      drawer: SideMenu(scaffoldKey: scaffoldKey),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {
            scaffoldKey.currentState?.openDrawer();
          },
        ),
        title: const Center(child: Text('Calendario de Vuelos')),
        actions: [
          // Botón para Mostrar / Ocultar Filtros
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
          // Botón de refrescar
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref
                .read(vuelosCalendarioProvider.notifier)
                .fetchVuelos(getCurrentMonthDateRange(DateTime.now())),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Capa principal: Filtros + Calendario
          Column(
            children: [
              // Muestra u oculta la barra de filtros dinámicamente
              if (_mostrarFiltros)
                _buildBarraFiltros(state.vuelos, ciudadesState.estaciones),

              Expanded(
                child: CalendarioVuelosWidget(
                  vuelos: vuelosFiltrados,
                  estaciones: ciudadesState.estaciones,
                  onMonthChanged: (newDate) {
                    ref
                        .read(vuelosCalendarioProvider.notifier)
                        .fetchVuelos(getCurrentMonthDateRange(newDate));
                  },
                ),
              ),
            ],
          ),

          // Capa de carga (Overlay)
          if (state.isLoading)
            Container(
              color: Colors.black12,
              child: const Center(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text("Cargando vuelos..."),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          // Mensaje si no hay vuelos y no está cargando
          if (!state.isLoading && vuelosFiltrados.isEmpty)
            const Center(
              child: Text("No se encontraron vuelos en este rango."),
            ),
        ],
      ),
    );
  }
}