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
      // drawer: CustomNavigationDrawer(
      //   selectedIndex: 0,
      //   onItemTapped: (index) {
      //     // Handle navigation item tap
      //   },
      // ),
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
        // title: const Text('Turnaround 2'),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 40),
            Center(
              child: SvgPicture.asset(
                "assets/icons/logotype-scounter.svg",
                fit: BoxFit.scaleDown,
                height: 35,
              ),
            ),
          ],
        ),
        // user icon menu
        actions: [
          // IconButton(
          //   onPressed: () {
          //     // display dialog menu user management options
          //     showDialog(
          //       context: context,
          //       builder: (context) {
          //         return AlertDialog(
          //           // title: Text('Gestionar usuario'),
          //           content: Column(
          //             mainAxisSize: MainAxisSize.min,
          //             children: [
          //               ListTile(
          //                 title: Text(
          //                   'Cambiar Contraseña',
          //                   style: theme.textTheme.bodyMedium,
          //                 ),
          //                 onTap: () {
          //                   // Handle manage users tap
          //                   Navigator.of(context).pop();
          //                 },
          //               ),
          //               // ListTile(
          //               //   title: Text(
          //               //     'Permisos de Usuario',
          //               //     style: theme.textTheme.bodyMedium,
          //               //   ),
          //               //   onTap: () {
          //               //     // Handle user permissions tap
          //               //     Navigator.of(context).pop();
          //               //   },
          //               // ),
          //               ListTile(
          //                 title: Text(
          //                   '
          //  ión',
          //                   style: theme.textTheme.bodyMedium,
          //                 ),
          //                 onTap: () {
          //                   // Handle user permissions tap
          //                   Navigator.of(context).pop();
          //                 },
          //               ),
          //             ],
          //           ),
          //         );
          //       },
          //     );
          //   },
          //   //       child: Text('Manage Users'),
          //   //       value: 'manage_users',
          //   //     ),
          //   //     PopupMenuItem(
          //   //       child: Text('User Permissions'),
          //   //       value: 'user_permissions',
          //   //     ),
          //   //   ],
          //   // );
          //   // , icon: },
          //   icon: const Icon(Icons.manage_accounts),
          // ),

          // no intertnet icon
          // if not connected show wifi_off icon

          // NoInternetIcon(),

          // leyenda de colores icon dialog
          LeyendaColoresStatusDialog(),

          // const SizedBox(width: 10),
          UserConfigMenuIcon(),
          // const SizedBox(width: 60),
        ],
      ),
      body: _TuraroundMainView(),

      // bottomNavigationBar: const _CustomBottomNavigationBar(),
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

  // 1. Controlador de texto y variable de estado para el filtro por número de vuelo
  final TextEditingController _numeroVueloController = TextEditingController();
  String _numeroVueloFiltro = '';

  Future<void> _handleRefresh() async {
    await ref.read(turnaroundProvider.notifier).getTurnarounds();
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
    // Liberar el controlador de texto al destruir el widget
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

    // 2. Filtrado de turnarounds por terminal, aerolínea y búsqueda de texto (Número de vuelo IN/OUT, IATA y AKA)
    final filteredTurnarounds = turnaroundsState.turnarounds.where((turnaround) {
      final cumpleTerminal = selectedTerminal == null ||
          turnaround.fkVuelo.terminal == selectedTerminal.id;

      final cumpleAerolinea = _aerolineaSeleccionada == null ||
          turnaround.fkVuelo.fkAerolinea.aka == _aerolineaSeleccionada;

      // Texto de búsqueda ingresado por el usuario
      final query = _numeroVueloFiltro.trim().toLowerCase();

      // Búsqueda en: numeroVueloIn, numeroVueloOut, codigoIata y aka
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
                  'Check-In',
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
                    const Center(
                      child: _DateFilter(),
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
                        // Define explícitamente los controles de selección para evitar el error de RenderEditable
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
                        // 1. Selector de Aerolínea
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.black12),
                            ),
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
                                    child: Text(
                                      "Aerolíneas",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  ...aerolineasDisponibles.map(
                                    (a) => DropdownMenuItem(
                                      value: a,
                                      child: Text(
                                        a,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ],
                                onChanged: (val) {
                                  setState(() {
                                    _aerolineaSeleccionada = val;
                                  });
                                },
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
  const _DateFilter();

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
          child: Text(
            inputFormat.format(selectedDate).split(' ')[0],
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 18, // Aumentado un par de px
                ),
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
// class _TurnaroundsListView extends StatelessWidget {
//   final List<TurnaroundMain> turnarounds;
//   const _TurnaroundsListView({required this.turnarounds});

//   @override
//   Widget build(BuildContext context) {
//     return Builder(
//       builder: (context) {
//         return
//         ListView.builder(
//           physics:
//               const NeverScrollableScrollPhysics(), // disable scrolling of the ListView
//           shrinkWrap: true,
//           scrollDirection: Axis.vertical,
//           itemCount: turnarounds.length,
//           itemBuilder: (context, index) {
//             final turnaround = turnarounds[index];
//             // return Text("Descomentar para ver la tarjeta");
//             return _ListTileCardContainer(turnaround: turnaround);
//             // return _ListTileCard(turnaround: turnaround);
//           },
//         );
//       },
//     );
//   }
// }

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
              // Shadow

              // altura de la tarjeta
              height: 165,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center, // <---- The magic
              child: SvgPicture.asset(
                // switch case based on turnaround.fkVuelo.estatus.id
                switch (turnaround.fkVuelo.estatus.id) {
                  "2" => 'assets/layouts/contenedor-amarillo.svg',
                  // "2" => 'assets/layouts/contenedor-naranja.svg',
                  "3" => 'assets/layouts/contenedor-verde.svg',
                  // "3" => 'assets/layouts/contenedor-rojo.svg',
                  "4" => 'assets/layouts/contenedor-azul.svg',
                  "7" => 'assets/layouts/contenedor-rojo.svg',
                  "6" => 'assets/layouts/contenedor-gris.svg',
                  "8" => 'assets/layouts/contenedor-naranja.svg',
                  _ => 'assets/layouts/contenedor-blanco.svg', // default case
                },
                // switch (turnaround.fkVuelo.estatus.color) {
                //   "verde" => 'assets/layouts/contenedor-verde.svg',
                //   "amarillo" => 'assets/layouts/contenedor-amarillo.svg',
                //   "rojo" => 'assets/layouts/contenedor-rojo.svg',
                //   "azul" => 'assets/layouts/contenedor-azul.svg',
                //   "gris" => 'assets/layouts/contenedor-gris.svg',
                //   _ => 'assets/layouts/contenedor-blanco.svg', // default case
                // },

                // 'assets/layouts/contenedor-blanco.svg',
                semanticsLabel: 'Image',
                fit: BoxFit.fill,
                alignment: Alignment.center,
                // maxHeight: 140,
                // Box shadow
              ),
            ),
          ),

          GestureDetector(
            // onTap: _onItemTap(context, turnaround),
            onTap: () {
              // show dialog menu with list items
              showDialog(
                context: context,
                builder: (context) => _MenuDialog(turnaround: turnaround),
                // barrierColor: Colors.transparent,
              );
            },
            behavior: HitTestBehavior.opaque,
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Cola de aerolinea
                // Spacer(flex: 1),
                Flexible(
                  // backkground color
                  flex: 1,
                  child: _TailView(
                    image: turnaround.fkVuelo.fkAerolinea.imagen ?? "",
                    name: turnaround.fkVuelo.fkAerolinea.aka,
                  ),
                ),

                // Datos del servicio
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

                // Vuelo de Salida
                turnaround.fkVuelo.lugarDestino == null
                    ? Spacer(flex: 1)
                    : Flexible(
                        flex: 1,
                        child: turnaround.fkVuelo.lugarDestino == null
                            ? SizedBox(
                                width: MediaQuery.of(context).size.width / 3.1,
                                // height: 100,
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
          // Row with 3 equal spaces
          // Row(
          //   children: [
          //     GridTile
          //   ],
          // ),
        ],
      ),
    );
  }
}

// SimpleApiResponse model

class _MenuDialog extends ConsumerWidget {
  final TurnaroundMain turnaround;
  const _MenuDialog({required this.turnaround});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DepartamentoPersonalState departamentoPersonal = ref.watch(
      departamentoPersonalProvider(turnaround.id),
    );
    return AlertDialog(
      // Border Color
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(
          color: Color.fromARGB(255, 255, 255, 255),
          width: 3,
        ),
      ),
      // title: const Text('Menu'),
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
                // Show list tile conditionally based on turnaround status
                // MenuListTile(
                //   leading: Icon(Icons.airplane_ticket),
                //   title: 'Detalles del Vuelo',
                //   onTap: () {
                //     print("onItemTap");
                //     // push
                //     context.push('/detalles-vuelo/${turnaround.id}');
                //     // close bottom sheet
                //     Navigator.pop(context);
                //   },
                // ),
                if (turnaround.estatus == 1 ||
                    turnaround.estatus == 2 ||
                    turnaround.estatus == 3)
                  MenuListTile(
                    leading: Icon(Icons.person_2),
                    title: 'Asignar Personal',
                    onTap: () async {
                      print("onItemTap");

                      // If User has no permission show snackbar and return
                      // bool puedeBorrar = user.rolesList.contains(Roles.eliminarUsuario);
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
                      // hasPermission(Roles.crearPersonal);

                      // set trcIdProvider
                      ref.read(trcIdProvider.notifier).state = turnaround.id;
                      // set selectedTurnaroundProvider
                      ref.read(selectedTurnaroundProvider.notifier).state =
                          turnaround;

                      // Wrong code
                      // final response = await ref
                      //     .read(departamentoPersonalProvider(turnaround.id).notifier)
                      //     .getDepartamentosConPersonal(turnaround.id);
                      // if (response.success) {
                      // print(response);
                      //   context.push('/asignar-personal');
                      //   Navigator.pop(context);
                      // }
                      ref
                          .read(
                            departamentoPersonalProvider(
                              turnaround.id,
                            ).notifier,
                          )
                          .getDepartamentosConPersonal(turnaround.id)
                          .then((response) {
                            if (response.success) {
                              // Hacer las asginaciones AQUI y no en el init del widget
                              context.push('/asignar-personal');
                              Navigator.pop(context);
                            }
                          });

                      // close bottom sheet
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
                        // Cargar counters desde el backend para esa terminal
                        ref
                            .read(counterProvider.notifier)
                            .getCounters(terminalId);

                        Navigator.pop(context);

                        // Mostrar el diálogo pasando tanto el id como el objeto de posicion
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => AsignarCountersDialog(
                            turnaroundId: turnaround.id,
                            posicion:
                                turnaround.posiciones is List<PosicionCounter>
                                ? turnaround.posiciones as List<PosicionCounter>
                                : null, // Pass de la posición actual
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
                        // Cargar puertas desde el backend para esa terminal
                        ref
                            .read(puertaProvider.notifier)
                            .getPuertas(terminalId);

                        Navigator.pop(context);

                        // Mostrar el diálogo pasando el id y el objeto de posición/puerta
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => AsignarPuertaDialog(
                            turnaroundId: turnaround.id,
                            puerta: turnaround
                                .puerta, // Ajusta con la propiedad o campo que contenga la puerta actual
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

                // if (turnaround.estatus == 1 ||
                //     turnaround.estatus == 2 ||
                //     turnaround.estatus == 3)
                //   MenuListTile(
                //     leading: Icon(Icons.agriculture),
                //     title: 'Asignar equipos GSE',
                //     onTap: () {
                //       // print("onItemTap");

                //       // Rol Ckeck
                //       if (!ref.read(authProvider).loginResponse!.hasPermission( Roles.asignarMaquinaria)) {
                //         showCustomErrorSnackbar(  context, 'No tienes permiso para asignar equipos GSE.');
                //         return;
                //       }
                // if (turnaround.estatus == 1 ||
                //     turnaround.estatus == 2 ||
                //     turnaround.estatus == 3)
                //   MenuListTile(
                //     leading: Icon(Icons.agriculture),
                //     title: 'Asignar equipos GSE',
                //     onTap: () {
                //       // print("onItemTap");

                //       // Rol Ckeck
                //       if (!ref.read(authProvider).loginResponse!.hasPermission( Roles.asignarMaquinaria)) {
                //         showCustomErrorSnackbar(  context, 'No tienes permiso para asignar equipos GSE.');
                //         return;
                //       }

                //       // set selectedTurnaroundProvider
                //       ref.read(selectedTurnaroundProvider.notifier).state =
                //           turnaround;

                //       print("selectedTurnaroundProvider: $turnaround");
                //       // push
                //       context.push('/asignar-equipos-gse');
                //       // close bottom sheet
                //       Navigator.pop(context);
                //     },
                //   ),
                if (turnaround.estatus == 1 ||
                    turnaround.estatus == 2 ||
                    turnaround.estatus == 3)
                  MenuListTile(
                    leading: Icon(Icons.computer),
                    title: 'Asignar equipos IT',
                    onTap: () {
                      // print("onItemTap");

                      // Rol Ckeck
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

                      // set selectedTurnaroundProvider
                      ref.read(selectedTurnaroundProvider.notifier).state =
                          turnaround;

                      print("selectedTurnaroundProvider: $turnaround");
                      // push
                      context.push('/asignar-equipos-it');
                      // close bottom sheet
                      Navigator.pop(context);
                    },
                  ),

                // scanner test
                // MenuListTile(
                //     leading: Icon(Icons.start),
                //     title: 'QR Scanner',
                //     onTap: () async {
                //       print("onItemTap");

                //       // void _onScanPressed() async {
                //         // 1. Llamar al servicio y esperar el resultado
                //         final String? result = await ScannerService.scanCode(
                //           context,
                //           title: "Escanear Producto"
                //         );

                //         // 2. Si el resultado no es nulo, procesar el código
                //         if (result != null) {
                //           debugPrint("Código QR/Barras detectado: $result");

                //           // Aquí puedes mostrar un mensaje, navegar a otra pantalla o
                //           // usar el resultado para buscar en una base de datos.
                //           ScaffoldMessenger.of(context).showSnackBar(
                //             SnackBar(content: Text("Código detectado: $result")),
                //           );
                //         } else {
                //           debugPrint("El usuario canceló el escaneo.");
                //         }
                //       // }
                //       // Rol Ckeck
                //       // if (!ref.read(authProvider).loginResponse!.hasPermission( Roles.empezarOperaciones)) {
                //       //   showCustomErrorSnackbar(  context, 'No tienes permiso para iniciar operaciones.');
                //       //   return;
                //       // }

                //       // push
                //       // await iniciarOperaciones(context, ref, turnaround.id);
                //       // close bottom sheet
                //       // Navigator.pop(context);
                //     },
                //   ),
                if (turnaround.estatus == 1)
                  MenuListTile(
                    leading: Icon(Icons.start),
                    title: 'Iniciar Operaciones',
                    onTap: () async {
                      print("onItemTap");

                      // Rol Ckeck
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

                      // push
                      await iniciarOperaciones(context, ref, turnaround.id);
                      // close bottom sheet
                      Navigator.pop(context);
                    },
                  ),

                if (turnaround.estatus == 2 ||
                    turnaround.estatus == 3 ||
                    turnaround.estatus == 7)
                  MenuListTile(
                    leading: Icon(Icons.assignment),
                    title: 'Control de actividades',
                    onTap: () {
                      print("onItemTap");
                      // push
                      // context.push('/control-actividades');

                      // Rol Ckeck
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

                      // set trcIdProvider
                      ref.read(trcIdProvider.notifier).state = turnaround.id;
                      // set selectedTurnaroundProvider
                      ref.read(selectedTurnaroundProvider.notifier).state =
                          turnaround;

                      // get control de actividades by trc id
                      ref
                          .read(
                            controlActividadesProvider(turnaround.id).notifier,
                          )
                          .getControlDeActividadesByTrcId();
                      // push with turnaround id
                      context.push('/control-actividades/${turnaround.id}');
                      // close bottom sheet
                      Navigator.pop(context);
                    },
                  ),

                // **********************************************************************************************************
                // **********************************************************************************************************
                if (turnaround.estatus == 2)
                  MenuListTile(
                    leading: Icon(Icons.lock),
                    title: 'Finalizar Vuelo',
                    onTap: () async {
                      print("onItemTap");

                      // Rol Ckeck
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

                      // set trcIdProvider
                      ref.read(trcIdProvider.notifier).state = turnaround.id;
                      // set selectedTurnaroundProvider
                      ref.read(selectedTurnaroundProvider.notifier).state =
                          turnaround;

                      // Api calls
                      // getcerrar_operacionesById
                      // Control de actividades
                      ref
                          .read(
                            controlActividadesProvider(turnaround.id).notifier,
                          )
                          .getControlDeActividadesByTrcId();

                      // getCodigosMoraByTrc
                      ref
                          .read(demorasProvider.notifier)
                          .getDemorasByTrc(turnaround.id);

                      // Personal
                      ref
                          .read(
                            departamentoPersonalProvider(
                              turnaround.id,
                            ).notifier,
                          )
                          .getDepartamentosConPersonal(turnaround.id);

                      // push
                      context.push('/finalizar-vuelo-screen');
                      // close bottom sheet
                      Navigator.pop(context);
                    },
                  ),


              
                // if (turnaround.estatus == 3
                // // && turnaround.fkVuelo.fkAerolinea.hasSupervisor
                // )
                //   MenuListTile(
                //     leading: Icon(Icons.lock),
                //     title: 'Cerrar Vuelo',
                //     onTap: () async {
                //       print("onItemTap");

                //       // Rol Ckeck
                //       // if (!ref.read(authProvider).loginResponse!.hasPermission( Roles.modificarVuelo)) {
                //       //   showCustomErrorSnackbar(  context, 'No tienes permiso para cerrar el vuelo.');
                //       //   return;
                //       // }

                //       // Rol Ckeck
                //       if (!ref
                //           .read(authProvider)
                //           .loginResponse!
                //           .hasPermission(Roles.firmaDeSupervisor)) {
                //         showCustomErrorSnackbar(
                //           context,
                //           'No tienes permiso para realizar esta accion.',
                //         );
                //         return;
                //       }

                //       // set trcIdProvider
                //       ref.read(trcIdProvider.notifier).state = turnaround.id;
                //       // set selectedTurnaroundProvider
                //       ref.read(selectedTurnaroundProvider.notifier).state =
                //           turnaround;

                //       // Api calls
                //       // getcerrar_operacionesById
                //       // Control de actividades
                //       await ref
                //           .read(
                //             controlActividadesProvider(turnaround.id).notifier,
                //           )
                //           .getControlDeActividadesByTrcId();

                //       // getCodigosMoraByTrc
                //       //  ref
                //       //     .read(demorasProvider.notifier)
                //       //     .getDemorasByTrc(turnaround.id);

                //       // Personal
                //       // ref
                //       //     .read(departamentoPersonalProvider(turnaround.id).notifier)
                //       //     .getDepartamentosConPersonal(turnaround.id);

                //       // TODO: procedimiento de las firmas

                //       await ref
                //           .read(supervisorAerolineaProvider.notifier)
                //           .getSupervisores();
                //       context.push('/cerrar-vuelo-screen');
                //       // close bottom sheet
                //       Navigator.pop(context);
                //       // // push
                //       // context.push('/finalizar-vuelo-screen');
                //       // // close bottom sheet
                //       // Navigator.pop(context);
                //     },
                //   ),
                if (turnaround.estatus == 3
                // && turnaround.fkVuelo.fkAerolinea.hasSupervisor
                )
                  MenuListTile(
                    leading: Icon(Icons.lock),
                    title: 'Firma de supervisor',
                    onTap: () async {
                      print("onItemTap");

                      // Rol Ckeck
                      // if (!ref.read(authProvider).loginResponse!.hasPermission( Roles.modificarVuelo)) {
                      //   showCustomErrorSnackbar(  context, 'No tienes permiso para cerrar el vuelo.');
                      //   return;
                      // }

                      // Rol Ckeck
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

                        // set trcIdProvider
                      ref.read(trcIdProvider.notifier).state = turnaround.id;
                      // set selectedTurnaroundProvider
                      ref.read(selectedTurnaroundProvider.notifier).state =
                          turnaround;

                      await ref
                      .read(supervisorAerolineaProvider.notifier)
                      .getSupervisores();
                  context.push('/firma-supervisor-screen');
                      // close bottom sheet
                      Navigator.pop(context);
                      // // push
                      // context.push('/finalizar-vuelo-screen');
                      // // close bottom sheet
                      // Navigator.pop(context);
                    },
                  ),

                // **********************************************************************************************************
                // **********************************************************************************************************

                // if (turnaround.estatus == 3)
                //   MenuListTile(
                //     leading: Icon(Icons.lock),
                //     title: 'Cerrar Chech-In',
                //     onTap: () {
                //       print("onItemTap");

                //       // Rol Ckeck
                //       if (!ref.read(authProvider).loginResponse!.hasPermission( Roles.modificarVuelo)) {
                //         showCustomErrorSnackbar(  context, 'No tienes permiso para cerrar el check-in.');
                //         return;
                //       }

                //       // set trcIdProvider
                //       ref.read(trcIdProvider.notifier).state = turnaround.id;
                //       // set selectedTurnaroundProvider
                //       ref.read(selectedTurnaroundProvider.notifier).state =
                //           turnaround;

                //       // Api calls
                //       // getcerrar_operacionesById
                //       // Control de actividades
                //       ref.read(controlActividadesProvider(turnaround.id).notifier).getControlDeActividadesByTrcId();

                //       // getCodigosMoraByTrc
                //        ref
                //           .read(demorasProvider.notifier)
                //           .getDemorasByTrc(turnaround.id);

                //       // Personal
                //       ref
                //           .read(departamentoPersonalProvider(turnaround.id).notifier)
                //           .getDepartamentosConPersonal(turnaround.id);

                //       // push
                //       context.push('/cerrar-vuelo-screen');
                //       // close bottom sheet
                //       Navigator.pop(context);

                //       // show snackbar if push return true
                //       // if (result == true) {
                //       //   ScaffoldMessenger.of(context).showSnackBar(
                //       //     SnackBar(content: Text('Vuelo cerrado correctamente')),
                //       //   );
                //       // }
                //     },
                //   ),

                // Consultar Control de actividades
                // if (turnaround.estatus == 4 ||
                //     turnaround.estatus == 5 ||
                //     turnaround.estatus == 6 ||
                //     turnaround.estatus == 7)
                MenuListTile(
                  leading: Icon(Icons.list),
                  title: 'Consultar',
                  onTap: () {
                    print("onItemTap");

                    // Rol Ckeck
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

                    // set trcIdProvider
                    ref.read(trcIdProvider.notifier).state = turnaround.id;
                    // set selectedTurnaroundProvider
                    ref.read(selectedTurnaroundProvider.notifier).state =
                        turnaround;

                    // Api calls
                    // getcerrar_operacionesById
                    // Control de actividades
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

                    // getCodigosMoraByTrc
                    ref
                        .read(demorasProvider.notifier)
                        .getDemorasByTrc(turnaround.id);

                    // Personal
                    ref
                        .read(
                          departamentoPersonalProvider(turnaround.id).notifier,
                        )
                        .getDepartamentosConPersonal(turnaround.id);

                    // push
                    context.push('/consultar-control-actividades-screen');
                    // close bottom sheet
                    Navigator.pop(context);
                  },
                ),

                // Generar reportes
                if (turnaround.estatus == 3 ||
                    (turnaround.estatus != 1 &&
                        turnaround.estatus != 2 &&
                        turnaround.estatus != 3 &&
                        turnaround.estatus != 7))
                  SizedBox(height: 0),

                // MenuListTile(
                //   leading: Icon(Icons.report),
                //   title: 'Generar reportes',
                //   onTap: () {
                //     print("Generar reportes");
                //     // push
                //     context.push('/generar-reportes');
                //     // close bottom sheet
                //     Navigator.pop(context);
                //   },
                // ),
                SizedBox(height: 10),
                // Row with status of the turnaround in his respective color
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
                          _ => Colors.white, // default case
                        },

                        // switch (turnaround.fkVuelo.estatus.color) {
                        //   "verde" => Colors.green,
                        //   "amarillo" => Colors.yellow,
                        //   "rojo" => Colors.red,
                        //   "azul" => Colors.blue,
                        //   "gris" => Colors.grey,
                        //   _ => Colors.white, // default case
                        // },
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.black26, width: 1),
                      ),
                    ),
                    SizedBox(width: 10),

                    Text(
                      turnaround.fkVuelo.estatus.nombre.toUpperCase(),
                      overflow: TextOverflow.ellipsis,
                      // uppercase
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        // italic
                        color: Colors.black54,
                        // fontStyle: FontStyle.italic,
                        // color: switch (turnaround.fkVuelo.estatus.color) {
                        //   "verde" => Colors.green,
                        //   "amarillo" => Colors.yellow,
                        //   "rojo" => Colors.red,
                        //   "azul" => Colors.blue,
                        //   "gris" => Colors.grey,
                        //   _ => Colors.black, // default case
                        // },
                      ),
                      // color based on status
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
    // For example, you can use a service or repository to handle the API call
    print("Iniciar operaciones for turnaround id: $id");
    // Call the API repository to start operations, and show success message
    // await turnaroundsRepository.startOperations(id);
    final SimpleApiResponse response = await ref
        .read(turnaroundProvider.notifier)
        .iniciarOperaciones(id);

    // alert dialog
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

// ignore: unused_element

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
          // mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 10),
            SizedBox(
              height: 90,
              child:
                  // Image.network(image, fit: BoxFit.contain),
                  CachedNetworkImage(
                    imageUrl: image,
                    fit: BoxFit.contain,
                    placeholder: (context, url) =>
                        Placeholder(strokeWidth: 2, color: Colors.transparent),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
            ),
            SizedBox(height: 5),
            // Uppercase
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
    // isLandscape() {
    //   final size = MediaQuery.of(context).size;
    //   return size.width > size.height;
    // }

    bool isMobile = MediaQuery.of(context).size.width < 500;

    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 140.0, // Sets the maximum width to 300 logical pixels
        ),
        child: Padding(
          // padding: const EdgeInsets.only(left: 15, right: 15),
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
                // spacing: -3,
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
                // spacing: -3,
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
              // isInbound
              //     ? Text(
              //         "LLEGADA",
              //         style: Theme.of(context).textTheme.labelSmall?.copyWith(
              //           fontFamily: GoogleFonts.openSans(
              //             fontWeight: FontWeight.w500,
              //           ).fontFamily,
              //         ),
              //       )
              //     : Text(
              //         "SALIDA",
              //         style: Theme.of(context).textTheme.labelSmall?.copyWith(
              //           fontFamily: GoogleFonts.openSans(
              //             fontWeight: FontWeight.w500,
              //           ).fontFamily,
              //         ),
              //       ),

              // SizedBox(height: 10),
              // Text(
              //   numeroVuelo,
              //   style: isMobile
              //       ? Theme.of(context).textTheme.bodySmall?.copyWith(
              //         fontFamily: GoogleFonts.openSans(
              //           fontWeight: FontWeight.w700,
              //         ).fontFamily,
              //         color: Colors.black87
              //       )
              //       : Theme.of(context).textTheme.titleMedium?.copyWith(
              //         fontFamily: GoogleFonts.openSans(
              //           fontWeight: FontWeight.w700,
              //         ).fontFamily,
              //       ),
              // ),
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
    // isLandscape() {
    //   final size = MediaQuery.of(context).size;
    //   return size.width > size.height;
    // }

    bool isMobile = MediaQuery.of(context).size.width < 500;

    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 140.0, // Sets the maximum width to 300 logical pixels
        ),
        child: Padding(
          // padding: const EdgeInsets.only(left: 15, right: 15),
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

              // const SizedBox(height: 10),

              // hora
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
              // isInbound
              //     ? Text(
              //         "LLEGADA",
              //         style: Theme.of(context).textTheme.labelSmall?.copyWith(
              //           fontFamily: GoogleFonts.openSans(
              //             fontWeight: FontWeight.w500,
              //           ).fontFamily,
              //         ),
              //       )
              //     : Text(
              //         "SALIDA",
              //         style: Theme.of(context).textTheme.labelSmall?.copyWith(
              //           fontFamily: GoogleFonts.openSans(
              //             fontWeight: FontWeight.w500,
              //           ).fontFamily,
              //         ),
              //       ),

              // SizedBox(height: 10),
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

// _onItemTap(BuildContext context, TurnaroundMain turnaround) {
//   // return a showModalBottomSheet
//   return () {
//     // *********************************************************************************************************************
//     showModalBottomSheet<void>(
//       elevation: 100,
//       context: context,
//       backgroundColor: Colors.transparent,
//       sheetAnimationStyle: AnimationStyle(
//         duration: Duration(milliseconds: 400),
//         reverseDuration: Duration(milliseconds: 300),
//       ),
//       builder: (BuildContext context) {
//         return ClipRRect(
//           borderRadius: const BorderRadius.all(Radius.circular(16.0)),
//           child: Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(16.0),
//                 topRight: Radius.circular(16.0),
//               ),
//               color: Colors.white,
//               boxShadow: [
//                 BoxShadow(color: Colors.transparent, spreadRadius: 3),
//               ],
//             ),
//             // color: Colors.white,
//             margin: EdgeInsets.symmetric(horizontal: 15),
//             child: Padding(
//               padding: const EdgeInsets.only(
//                 top: 10.0,
//                 bottom: 25.0,
//                 left: 25.0,
//                 right: 3.0,
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   MenuListTile(
//                     leading: Icon(Icons.person_2),
//                     title: 'Asignar Personal',
//                     onTap: () {
//                       print("onItemTap");
//                       // push
//                       context.push('/asignar-personal');
//                       // close bottom sheet
//                       Navigator.pop(context);
//                     },
//                   ),

//                   MenuListTile(
//                     leading: Icon(Icons.agriculture),
//                     title: 'Asignar equipos GSE',
//                     onTap: () {
//                       print("onItemTap");
//                       // push
//                       context.push('/asignar-equipos');
//                       // close bottom sheet
//                       Navigator.pop(context);
//                     },
//                   ),

//                   MenuListTile(
//                     leading: Icon(Icons.start),
//                     title: 'Iniciar Operaciones',
//                     onTap: () {
//                       print("onItemTap");
//                       // push
//                       context.push('/iniciar-operaciones');
//                       // close bottom sheet
//                       Navigator.pop(context);
//                     },
//                   ),

//                   MenuListTile(
//                     leading: Icon(Icons.assignment),
//                     title: 'Control de actividades',
//                     onTap: () {
//                       print("onItemTap");
//                       // push
//                       context.push('/control-actividades');
//                       // close bottom sheet
//                       Navigator.pop(context);
//                     },
//                   ),

//                   MenuListTile(
//                     leading: Icon(Icons.lock),
//                     title: 'Cerrar Vuelo',
//                     onTap: () {
//                       print("onItemTap");
//                       // push
//                       context.push('/cerrar-vuelo');
//                       // close bottom sheet
//                       Navigator.pop(context);
//                     },
//                   ),
//                   // LOGICA
//                   // CustomListTile(
//                   //   leading: Icon(Icons.person),
//                   //   title: 'Asignar Personal',
//                   //   onTap: () {},
//                   // ),
//                   // CustomListTile(
//                   //   leading: Icon(Icons.agriculture),
//                   //   title: 'Asignar equipos GSE',
//                   //   onTap: () {},
//                   // ),
//                   // CustomListTile(
//                   //   leading: Icon(Icons.start),
//                   //   title: 'Iniciar Operaciones',
//                   //   onTap: () {},
//                   // ),
//                   // CustomListTile(
//                   //   leading: Icon(Icons.assignment),
//                   //   title: 'Control de actividades',
//                   //   onTap: () {
//                   //     print("onItemTap");

//                   //     // push
//                   //     context.push('/control-actividades');
//                   //     // close bottom sheet

//                   //     Navigator.pop(context);
//                   //   },
//                   // ),
//                   // CustomListTile(
//                   //   leading: Icon(Icons.lock),
//                   //   title: 'Cerrar Vuelo',
//                   //   onTap: () {},
//                   // ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//     // *********************************************************************************************************************
//   };
// }

String formatTime(String? time) {
  if (time == null || time.length < 5) return "";
  return time.substring(0, 5);
}


