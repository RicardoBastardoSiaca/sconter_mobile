import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scounter_mobile/features/shared/domain/domain.dart';
import 'package:scounter_mobile/features/shared/shared.dart';
import 'package:scounter_mobile/features/turnarounds/domain/domain.dart';
import 'package:scounter_mobile/features/turnarounds/presentation/providers/providers.dart';
import 'package:scounter_mobile/features/turnarounds/presentation/widgets/widgets.dart';

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

  // CONTROLADOR DE TEXTO Y VARIABLE DE ESTADO
  final TextEditingController _numeroVueloController = TextEditingController();
  String _numeroVueloFiltro = '';

  @override
  void dispose() {
    // Liberar el controlador cuando el widget se destruye
    _numeroVueloController.dispose();
    super.dispose();
  }

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
              // 1. SELECTOR DE AEROLÍNEA (Modal con Búsqueda)
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
                            _aerolineaSeleccionada ?? "Aerolínea",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: _aerolineaSeleccionada == null ? Colors.grey[700] : Colors.black,
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
              const Expanded(child: TerminalFilterDropdown()),
              const SizedBox(width: 8),

              // 4. CAMPO DE BÚSQUEDA POR NÚMERO DE VUELO
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

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(vuelosCalendarioProvider);
    final ciudadesState = ref.watch(ciudadesProvider);

    // 1. Obtener la terminal seleccionada del provider
    final selectedTerminal = ref.watch(selectedTerminalFilterProvider);

    // 2. Aplicar el filtro de terminal en la lista
    final vuelosFiltrados = state.vuelos.where((vuelo) {
      final cumpleAerolinea = _aerolineaSeleccionada == null ||
          vuelo.aerolineaNombre == _aerolineaSeleccionada;

      final cumpleEstacion = _estacionSeleccionada == null ||
          vuelo.estacionId?.toString() == _estacionSeleccionada;

      final cumpleNumeroVuelo = _numeroVueloFiltro.isEmpty ||
          vuelo.numeroVuelo.toLowerCase().contains(_numeroVueloFiltro.toLowerCase().trim());

      final cumpleTerminal = selectedTerminal == null ||
          vuelo.terminal?.id == selectedTerminal.id;

      return cumpleAerolinea && cumpleEstacion && cumpleTerminal && cumpleNumeroVuelo;
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