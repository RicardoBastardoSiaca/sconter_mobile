import 'dart:math' as FullAxisSize;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:scounter_mobile/features/auth/domain/domain.dart';
import 'package:scounter_mobile/features/auth/presentation/providers/providers.dart';
import 'package:scounter_mobile/features/turnarounds/presentation/widgets/widgets.dart';

import '../../../shared/shared.dart';
import '../../domain/domain.dart';
import '../providers/providers.dart';

class TurnaroundMainScreen extends ConsumerStatefulWidget {
  const TurnaroundMainScreen({super.key});

  @override
  ConsumerState<TurnaroundMainScreen> createState() =>
      _TurnaroundMainScreenState();
}

class _TurnaroundMainScreenState extends ConsumerState<TurnaroundMainScreen> {
  // final scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    // 2. Escuchamos el estado del provider de actualización
    final updateState = ref.watch(appUpdateProvider);

    // final isConnected = ref.watch(isConnectedProvider);
    // final connectivityState = ref.watch(connectivityProvider);

    // final theme = Theme.of(context);
    // final ConnectivityService _connectivityService = ConnectivityService();
    return Scaffold(
      key: scaffoldKey,
      // backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      drawer: SideMenu(scaffoldKey: scaffoldKey),
      appBar: AppBar(
        // 3. Agregamos el Badge en el icono de los 3 puntos
        leading: IconButton(
          icon: Badge(
            isLabelVisible: updateState.hasUpdate,
            backgroundColor: const Color(0xFF0FA45F),
            label: const Text(
              'UP',
              style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
            ),
            offset: const Offset(6, -4),
            child: const Icon(Icons.more_vert, color: Colors.black87),
          ),
          onPressed: () {
            scaffoldKey.currentState?.openDrawer();
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 40),
            Center(
              child: SvgPicture.asset(
                "assets/icons/logotype-scounter.svg",
                fit: BoxFit.scaleDown,
                height: 35,
              ),
            ),
          ],
        ),
        actions: const [
          // leyenda de colores icon dialog
          LeyendaColoresStatusDialog(),
          UserConfigMenuIcon(),
        ],
      ),
      body: const _TuraroundMainView(),
    );
  }
}

class _TuraroundMainView extends ConsumerStatefulWidget {
  const _TuraroundMainView();

  @override
  _TuraroundMainViewState createState() => _TuraroundMainViewState();
}

class _TuraroundMainViewState extends ConsumerState<_TuraroundMainView> {
  final ScrollController _scrollController = ScrollController();

  // Estado local para la aerolínea seleccionada
  String? _aerolineaSeleccionada;

  // Controlador de texto y variable de estado para el filtro por número de vuelo
  final TextEditingController _numeroVueloController = TextEditingController();
  String _numeroVueloFiltro = '';

  Future<void> _handleRefresh() async {
    await ref.read(turnaroundProvider.notifier).getTurnarounds();
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

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(appUpdateProvider.notifier).checkForUpdate();

      if (!mounted) return;
      final updateState = ref.read(appUpdateProvider);

      if (updateState.hasUpdate) {
        showDialog(
          context: context,
          barrierDismissible: !updateState.isMandatory,
          builder: (context) => UpdateDialog(updateData: updateState.toMap()),
        );
      }

      ref.read(turnaroundProvider.notifier).getTurnarounds();
      ref.read(terminalProvider.notifier).getTerminales();
    });
  }

  @override
  void dispose() {
    _numeroVueloController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final turnaroundsState = ref.watch(turnaroundProvider);
    final selectedTerminal = ref.watch(selectedTerminalFilterProvider);

    if (turnaroundsState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // 1. Extraer lista única de aerolíneas disponibles
    final aerolineasDisponibles = turnaroundsState.turnarounds
        .map((t) => t.fkVuelo.fkAerolinea.aka)
        .where((nombre) => nombre.isNotEmpty)
        .toSet()
        .toList();

    // 2. Filtrado de turnarounds por terminal, aerolínea y búsqueda de texto
    final filteredTurnarounds = turnaroundsState.turnarounds.where((turnaround) {
      final cumpleTerminal = selectedTerminal == null ||
          turnaround.fkVuelo.terminal == selectedTerminal.id;

      final cumpleAerolinea = _aerolineaSeleccionada == null ||
          turnaround.fkVuelo.fkAerolinea.aka == _aerolineaSeleccionada;

      final query = _numeroVueloFiltro.trim().toLowerCase();

      final cumpleTextoBusqueda = query.isEmpty ||
          (turnaround.fkVuelo.numeroVueloIn.toLowerCase().contains(query)) ||
          (turnaround.fkVuelo.numeroVueloOut?.toLowerCase().contains(query) ?? false) ||
          (turnaround.fkVuelo.fkAerolinea.codigoIata.toLowerCase().contains(query)) ||
          (turnaround.fkVuelo.fkAerolinea.aka.toLowerCase().contains(query));

      return cumpleTerminal && cumpleAerolinea && cumpleTextoBusqueda;
    }).toList();

    return SafeArea(
      child: Container(
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          child: ListView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              const SizedBox(height: 3),
              Center(
                child: Text(
                  'Turnaround',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w900,
                    fontFamily: GoogleFonts.openSans(
                      fontWeight: FontWeight.w900,
                    ).fontFamily,
                  ),
                ),
              ),
              const SizedBox(height: 4),

              // Contenedor principal de Filtros
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  children: [
                    // --- FILA 1: Filtro de Fecha ---
                    Center(
                      child: _DateFilter(totalVuelos: filteredTurnarounds.length),
                    ),

                    const SizedBox(height: 8),

                    // --- FILA 2: Campo de entrada para Número de Vuelo ---
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.black12),
                      ),
                      child: TextField(
                        controller: _numeroVueloController,
                        selectionControls: MaterialTextSelectionControls(),
                        onChanged: (val) {
                          setState(() {
                            _numeroVueloFiltro = val;
                          });
                        },
                        style: const TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                          hintText: "Buscar por N° Vuelo / Aerolínea",
                          hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
                          prefixIcon: const Icon(Icons.search, size: 20, color: Colors.grey),
                          suffixIcon: _numeroVueloFiltro.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear, size: 18),
                                  onPressed: () {
                                    _numeroVueloController.clear();
                                    setState(() {
                                      _numeroVueloFiltro = '';
                                    });
                                  },
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // --- FILA 3: Aerolínea primero, Terminales segundo ---
                    Row(
                      children: [
                        // 1. Selector de Aerolínea con Buscador
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

                        // 2. Selector de Terminales
                        const Expanded(
                          child: TerminalFilterDropdown(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Lista filtrada de turnarounds
              if (filteredTurnarounds.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Center(
                    child: Text('No hay turnarounds disponibles.'),
                  ),
                )
              else
                ...filteredTurnarounds.map(
                  (turnaround) => _ListTileCardContainer(turnaround: turnaround),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DateFilter extends ConsumerWidget {
  final int totalVuelos;
  const _DateFilter({required this.totalVuelos});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(datetimeProvider);
    final inputFormat = DateFormat('dd/MM/yyyy HH:mm');

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          onPressed: () {
            final newDate = selectedDate.subtract(const Duration(days: 1));
            ref.read(datetimeProvider.notifier).state = newDate;
            ref.read(turnaroundProvider.notifier).setSelectedDate(newDate);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 18,
          ),
        ),
        const SizedBox(width: 4),
        GestureDetector(
          onTap: () async {
            final DateTime? dateTime = await showDatePicker(
              context: context,
              initialDate: selectedDate,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (dateTime != null) {
              ref.read(datetimeProvider.notifier).state = dateTime;
              ref.read(turnaroundProvider.notifier).setSelectedDate(dateTime);
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                inputFormat.format(selectedDate).split(' ')[0],
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 18,
                    ),
              ),
              Text(
                '$totalVuelos vuelo${totalVuelos == 1 ? '' : 's'}',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      // color: Theme.of(context).colorScheme.primary,
                      color: Colors.black54,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 4),
        IconButton(
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 18,
          ),
          onPressed: () {
            final newDate = selectedDate.add(const Duration(days: 1));
            ref.read(datetimeProvider.notifier).state = newDate;
            ref.read(turnaroundProvider.notifier).setSelectedDate(newDate);
          },
        ),
      ],
    );
  }
}

class _ListTileCardContainer extends StatelessWidget {
  final TurnaroundMain turnaround;
  const _ListTileCardContainer({required this.turnaround});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
      child: Stack(
        children: [
          FittedBox(
            child: Container(
              height: 165,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              child: SvgPicture.asset(
                switch (turnaround.fkVuelo.estatus.id) {
                  "2" => 'assets/layouts/contenedor-amarillo.svg',
                  "3" => 'assets/layouts/contenedor-verde.svg',
                  "4" => 'assets/layouts/contenedor-azul.svg',
                  "7" => 'assets/layouts/contenedor-rojo.svg',
                  "6" => 'assets/layouts/contenedor-gris.svg',
                  "8" => 'assets/layouts/contenedor-naranja.svg',
                  _ => 'assets/layouts/contenedor-blanco.svg',
                },
                semanticsLabel: 'Image',
                fit: BoxFit.fill,
                alignment: Alignment.center,
              ),
            ),
          ),

          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => _MenuDialog(turnaround: turnaround),
              );
            },
            behavior: HitTestBehavior.opaque,
            child: Row(
              children: [
                Flexible(
                  flex: 1,
                  child: _TailView(
                    image: turnaround.fkVuelo.fkAerolinea.imagen ?? "",
                    name: turnaround.fkVuelo.fkAerolinea.aka,
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: _ServicioView(
                    lugarSalida:
                        turnaround.fkVuelo.lugarSalida?.codigoIata ?? "",
                    lugarLlegada: turnaround.fkVuelo.stn?.codigoIata ?? "",
                    lugarSalidaLargo:
                        turnaround.fkVuelo.lugarSalida?.ciudad ?? "",
                    lugarLlegadaLargo: turnaround.fkVuelo.stn?.ciudad ?? "",
                    hora: formatTime(turnaround.fkVuelo.etaIn),
                    horaServicioInicio: formatTime(
                      turnaround.horaInicioServicio_,
                    ),
                    horaServicioFin: formatTime(turnaround.horaFinServicio_),
                    numeroVuelo:
                        "${turnaround.fkVuelo.fkAerolinea.codigoIata}-${turnaround.fkVuelo.numeroVueloIn} ",
                    isInbound: true,
                  ),
                ),
                turnaround.fkVuelo.lugarDestino == null
                    ? const Spacer(flex: 1)
                    : Flexible(
                        flex: 1,
                        child: turnaround.fkVuelo.lugarDestino == null
                            ? SizedBox(
                                width: MediaQuery.of(context).size.width / 3.1,
                              )
                            : _InboundView(
                                lugarSalida:
                                    turnaround.fkVuelo.stn?.codigoIata ?? "",
                                lugarLlegada:
                                    turnaround
                                        .fkVuelo
                                        .lugarDestino
                                        ?.codigoIata ??
                                    "",
                                lugarSalidaLargo:
                                    turnaround.fkVuelo.stn?.ciudad ?? "",
                                lugarLlegadaLargo:
                                    turnaround.fkVuelo.lugarDestino?.ciudad ??
                                    "",
                                hora:
                                    turnaround.fkVuelo.etdOut?.substring(
                                      0,
                                      5,
                                    ) ??
                                    "",
                                numeroVuelo:
                                    "${turnaround.fkVuelo.fkAerolinea.codigoIata}-${turnaround.fkVuelo.numeroVueloOut} ",
                                isInbound: false,
                              ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuDialog extends ConsumerWidget {
  final TurnaroundMain turnaround;
  const _MenuDialog({required this.turnaround});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DepartamentoPersonalState departamentoPersonal = ref.watch(
      departamentoPersonalProvider(turnaround.id),
    );
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(
          color: Color.fromARGB(255, 255, 255, 255),
          width: 3,
        ),
      ),
      backgroundColor: Colors.grey.shade100,
      content: departamentoPersonal.isLoading
          ? SizedBox(
              height: 100.0,
              width: 100.0,
              child: Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.primary,
                  strokeWidth: 4.0,
                ),
              ),
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if (turnaround.estatus == 1 ||
                    turnaround.estatus == 2 ||
                    turnaround.estatus == 3)
                  MenuListTile(
                    leading: const Icon(Icons.person_2),
                    title: 'Asignar Personal',
                    onTap: () async {
                      if (!ref
                          .read(authProvider)
                          .loginResponse!
                          .hasPermission(Roles.asignarPersonal)) {
                        showCustomErrorSnackbar(
                          context,
                          'No tienes permiso para asignar personal.',
                        );
                        return;
                      }

                      ref.read(trcIdProvider.notifier).state = turnaround.id;
                      ref.read(selectedTurnaroundProvider.notifier).state =
                          turnaround;

                      ref
                          .read(
                            departamentoPersonalProvider(
                              turnaround.id,
                            ).notifier,
                          )
                          .getDepartamentosConPersonal(turnaround.id)
                          .then((response) {
                            if (response.success) {
                              context.push('/asignar-personal');
                              Navigator.pop(context);
                            }
                          });
                    },
                  ),

                if (turnaround.estatus == 2 || turnaround.estatus == 3)
                  MenuListTile(
                    leading: const Icon(Icons.desk),
                    title: 'Asignar Counters',
                    onTap: () async {
                      ref.read(trcIdProvider.notifier).state = turnaround.id;
                      ref.read(selectedTurnaroundProvider.notifier).state =
                          turnaround;

                      final terminalId = turnaround.fkVuelo.terminal ?? -1;

                      if (terminalId != -1) {
                        ref
                            .read(counterProvider.notifier)
                            .getCounters(terminalId);

                        Navigator.pop(context);

                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => AsignarCountersDialog(
                            turnaroundId: turnaround.id,
                            posicion:
                                turnaround.posiciones is List<PosicionCounter>
                                ? turnaround.posiciones as List<PosicionCounter>
                                : null,
                          ),
                        );
                      } else {
                        showCustomErrorSnackbar(
                          context,
                          'El vuelo no tiene una terminal asignada.',
                        );
                      }
                    },
                  ),

                if (turnaround.estatus == 2 || turnaround.estatus == 3)
                  MenuListTile(
                    leading: const Icon(Icons.sensor_door_outlined),
                    title: 'Asignar Puerta',
                    onTap: () async {
                      ref.read(trcIdProvider.notifier).state = turnaround.id;
                      ref.read(selectedTurnaroundProvider.notifier).state =
                          turnaround;

                      final terminalId = turnaround.fkVuelo.terminal ?? -1;

                      if (terminalId != -1) {
                        ref
                            .read(puertaProvider.notifier)
                            .getPuertas(terminalId);

                        Navigator.pop(context);

                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => AsignarPuertaDialog(
                            turnaroundId: turnaround.id,
                            puerta: turnaround.puerta,
                          ),
                        );
                      } else {
                        showCustomErrorSnackbar(
                          context,
                          'El vuelo no tiene una terminal asignada.',
                        );
                      }
                    },
                  ),

                if (turnaround.estatus == 1 ||
                    turnaround.estatus == 2 ||
                    turnaround.estatus == 3)
                  MenuListTile(
                    leading: const Icon(Icons.computer),
                    title: 'Asignar equipos IT',
                    onTap: () {
                      if (!ref
                          .read(authProvider)
                          .loginResponse!
                          .hasPermission(Roles.asignarMaquinaria)) {
                        showCustomErrorSnackbar(
                          context,
                          'No tienes permiso para asignar equipos IT.',
                        );
                        return;
                      }

                      ref.read(selectedTurnaroundProvider.notifier).state =
                          turnaround;

                      context.push('/asignar-equipos-it');
                      Navigator.pop(context);
                    },
                  ),

                if (turnaround.estatus == 1)
                  MenuListTile(
                    leading: const Icon(Icons.start),
                    title: 'Iniciar Operaciones',
                    onTap: () async {
                      if (!ref
                          .read(authProvider)
                          .loginResponse!
                          .hasPermission(Roles.empezarOperaciones)) {
                        showCustomErrorSnackbar(
                          context,
                          'No tienes permiso para iniciar operaciones.',
                        );
                        return;
                      }

                      await iniciarOperaciones(context, ref, turnaround.id);
                      Navigator.pop(context);
                    },
                  ),

                if (turnaround.estatus == 2 ||
                    turnaround.estatus == 3 ||
                    turnaround.estatus == 7)
                  MenuListTile(
                    leading: const Icon(Icons.assignment),
                    title: 'Control de actividades',
                    onTap: () {
                      if (!ref
                          .read(authProvider)
                          .loginResponse!
                          .hasPermission(Roles.modificarControlDeActividades)) {
                        showCustomErrorSnackbar(
                          context,
                          'No tienes permiso para modificar control de actividades.',
                        );
                        return;
                      }

                      ref.read(trcIdProvider.notifier).state = turnaround.id;
                      ref.read(selectedTurnaroundProvider.notifier).state =
                          turnaround;

                      ref
                          .read(
                            controlActividadesProvider(turnaround.id).notifier,
                          )
                          .getControlDeActividadesByTrcId();

                      context.push('/control-actividades/${turnaround.id}');
                      Navigator.pop(context);
                    },
                  ),

                if (turnaround.estatus == 2)
                  MenuListTile(
                    leading: const Icon(Icons.lock),
                    title: 'Finalizar Vuelo',
                    onTap: () async {
                      if (!ref
                          .read(authProvider)
                          .loginResponse!
                          .hasPermission(Roles.modificarVuelo)) {
                        showCustomErrorSnackbar(
                          context,
                          'No tienes permiso para finalizar el vuelo.',
                        );
                        return;
                      }

                      ref.read(trcIdProvider.notifier).state = turnaround.id;
                      ref.read(selectedTurnaroundProvider.notifier).state =
                          turnaround;

                      ref
                          .read(
                            controlActividadesProvider(turnaround.id).notifier,
                          )
                          .getControlDeActividadesByTrcId();

                      ref
                          .read(demorasProvider.notifier)
                          .getDemorasByTrc(turnaround.id);

                      ref
                          .read(
                            departamentoPersonalProvider(
                              turnaround.id,
                            ).notifier,
                          )
                          .getDepartamentosConPersonal(turnaround.id);

                      context.push('/finalizar-vuelo-screen');
                      Navigator.pop(context);
                    },
                  ),

                if (turnaround.estatus == 3)
                  MenuListTile(
                    leading: const Icon(Icons.lock),
                    title: 'Firma de supervisor',
                    onTap: () async {
                      if (!ref
                          .read(authProvider)
                          .loginResponse!
                          .hasPermission(Roles.firmaDeSupervisor)) {
                        showCustomErrorSnackbar(
                          context,
                          'No tienes permiso para realizar esta accion.',
                        );
                        return;
                      }

                      ref.read(trcIdProvider.notifier).state = turnaround.id;
                      ref.read(selectedTurnaroundProvider.notifier).state =
                          turnaround;

                      await ref
                          .read(supervisorAerolineaProvider.notifier)
                          .getSupervisores();

                      context.push('/firma-supervisor-screen');
                      Navigator.pop(context);
                    },
                  ),

                MenuListTile(
                  leading: const Icon(Icons.list),
                  title: 'Consultar',
                  onTap: () {
                    if (!ref
                        .read(authProvider)
                        .loginResponse!
                        .hasPermission(Roles.consultarControlDeActividades)) {
                      showCustomErrorSnackbar(
                        context,
                        'No tienes permiso para consultar el control de actividades.',
                      );
                      return;
                    }

                    ref.read(trcIdProvider.notifier).state = turnaround.id;
                    ref.read(selectedTurnaroundProvider.notifier).state =
                        turnaround;

                    ref
                        .read(
                          controlActividadesProvider(turnaround.id).notifier,
                        )
                        .getControlDeActividadesByTrcId();

                    ref
                        .read(plantillaDetalleProvider.notifier)
                        .getPlantillaDetalleById(
                          turnaround.fkVuelo.fkPlantilla?.id ?? 0,
                        );

                    ref
                        .read(demorasProvider.notifier)
                        .getDemorasByTrc(turnaround.id);

                    ref
                        .read(
                          departamentoPersonalProvider(turnaround.id).notifier,
                        )
                        .getDepartamentosConPersonal(turnaround.id);

                    context.push('/consultar-control-actividades-screen');
                    Navigator.pop(context);
                  },
                ),

                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 13,
                      height: 13,
                      decoration: BoxDecoration(
                        color: switch (turnaround.fkVuelo.estatus.id) {
                          "2" => Colors.yellow,
                          "3" => Colors.green,
                          "4" => Colors.blue,
                          "6" => Colors.grey,
                          "7" => Colors.red,
                          "8" => Colors.orange,
                          _ => Colors.white,
                        },
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.black26, width: 1),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      turnaround.fkVuelo.estatus.nombre.toUpperCase(),
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  Future<void> iniciarOperaciones(
    BuildContext context,
    WidgetRef ref,
    int id,
  ) async {
    final SimpleApiResponse response = await ref
        .read(turnaroundProvider.notifier)
        .iniciarOperaciones(id);

    if (response.success) {
      await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Operaciones Iniciadas'),
            content: Text(response.message),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text(response.message),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}

class _TailView extends StatelessWidget {
  final String image;
  final String name;
  const _TailView({required this.image, required this.name});

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 500;

    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            SizedBox(
              height: 90,
              child: CachedNetworkImage(
                imageUrl: image,
                fit: BoxFit.contain,
                placeholder: (context, url) =>
                    const Placeholder(strokeWidth: 2, color: Colors.transparent),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              name.toUpperCase(),
              style: isMobile
                  ? Theme.of(context).textTheme.labelSmall?.copyWith(
                      letterSpacing: 0,
                      wordSpacing: 0.3,
                      fontSize: 14,
                      fontFamily: GoogleFonts.openSans(
                        fontWeight: FontWeight.w700,
                      ).fontFamily,
                      color: Colors.black87,
                    )
                  : Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontFamily: GoogleFonts.openSans(
                        fontWeight: FontWeight.w700,
                      ).fontFamily,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ServicioView extends StatelessWidget {
  final String lugarSalida;
  final String lugarLlegada;
  final String lugarSalidaLargo;
  final String lugarLlegadaLargo;
  final bool isInbound;

  final String hora;
  final String horaServicioInicio;
  final String horaServicioFin;
  final String numeroVuelo;
  const _ServicioView({
    required this.lugarSalida,
    required this.lugarLlegada,
    required this.lugarSalidaLargo,
    required this.lugarLlegadaLargo,
    required this.hora,
    required this.horaServicioInicio,
    required this.horaServicioFin,
    required this.numeroVuelo,
    required this.isInbound,
  });

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 500;

    return Center(
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 140.0,
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            top: 15,
            bottom: 15,
            left: 9,
            right: 10,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Apertura:",
                    style: isMobile
                        ? Theme.of(context).textTheme.labelMedium?.copyWith(
                            fontFamily: GoogleFonts.openSans(
                              fontWeight: FontWeight.w600,
                            ).fontFamily,
                          )
                        : Theme.of(context).textTheme.labelMedium?.copyWith(
                            fontFamily: GoogleFonts.openSans(
                              fontWeight: FontWeight.w600,
                            ).fontFamily,
                          ),
                  ),
                  Text(
                    horaServicioInicio,
                    style: isMobile
                        ? Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontFamily: GoogleFonts.openSans(
                              fontWeight: FontWeight.w600,
                            ).fontFamily,
                          )
                        : Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontFamily: GoogleFonts.openSans(
                              fontWeight: FontWeight.w600,
                            ).fontFamily,
                          ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Cierre:",
                    style: isMobile
                        ? Theme.of(context).textTheme.labelMedium?.copyWith(
                            fontFamily: GoogleFonts.openSans(
                              fontWeight: FontWeight.w600,
                            ).fontFamily,
                          )
                        : Theme.of(context).textTheme.labelMedium?.copyWith(
                            fontFamily: GoogleFonts.openSans(
                              fontWeight: FontWeight.w600,
                            ).fontFamily,
                          ),
                  ),
                  Text(
                    horaServicioFin,
                    style: isMobile
                        ? Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontFamily: GoogleFonts.openSans(
                              fontWeight: FontWeight.w600,
                            ).fontFamily,
                          )
                        : Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontFamily: GoogleFonts.openSans(
                              fontWeight: FontWeight.w600,
                            ).fontFamily,
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InboundView extends StatelessWidget {
  final String lugarSalida;
  final String lugarLlegada;
  final String lugarSalidaLargo;
  final String lugarLlegadaLargo;
  final bool isInbound;

  final String hora;
  final String numeroVuelo;
  const _InboundView({
    required this.lugarSalida,
    required this.lugarLlegada,
    required this.lugarSalidaLargo,
    required this.lugarLlegadaLargo,
    required this.hora,
    required this.numeroVuelo,
    required this.isInbound,
  });

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 500;

    return Center(
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 140.0,
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            top: 15,
            bottom: 12,
            left: 8,
            right: 14,
          ),
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    lugarSalida,
                    style: isMobile
                        ? Theme.of(context).textTheme.labelMedium?.copyWith(
                            fontFamily: GoogleFonts.openSans(
                              fontWeight: FontWeight.w600,
                            ).fontFamily,
                            color: Colors.black87,
                          )
                        : Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontFamily: GoogleFonts.openSans(
                              fontWeight: FontWeight.w600,
                            ).fontFamily,
                          ),
                  ),
                  Text(
                    lugarLlegada,
                    style: isMobile
                        ? Theme.of(context).textTheme.labelMedium?.copyWith(
                            fontFamily: GoogleFonts.openSans(
                              fontWeight: FontWeight.w600,
                            ).fontFamily,
                            color: Colors.black87,
                          )
                        : Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontFamily: GoogleFonts.openSans(
                              fontWeight: FontWeight.w600,
                            ).fontFamily,
                          ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              isInbound
                  ? SvgPicture.asset("assets/icons/llegada.svg", height: 30)
                  : SvgPicture.asset("assets/icons/salida.svg", height: 30),
              Text(
                hora,
                style: isMobile
                    ? Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontFamily: GoogleFonts.openSans(
                          fontWeight: FontWeight.w600,
                        ).fontFamily,
                      )
                    : Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontFamily: GoogleFonts.openSans(
                          fontWeight: FontWeight.w600,
                        ).fontFamily,
                      ),
              ),
              Text(
                numeroVuelo,
                style: isMobile
                    ? Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontFamily: GoogleFonts.openSans(
                          fontWeight: FontWeight.w600,
                        ).fontFamily,
                        color: Colors.black87,
                      )
                    : Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontFamily: GoogleFonts.openSans(
                          fontWeight: FontWeight.w600,
                        ).fontFamily,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String formatTime(String? time) {
  if (time == null || time.length < 5) return "";
  return time.substring(0, 5);
}