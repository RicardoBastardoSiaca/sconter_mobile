import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../shared/shared.dart';
import '../../domain/entities/entities.dart';
import '../providers/providers.dart';
import '../widgets/widgets.dart';

class ServiciosMiscelaneosScreen extends StatefulWidget {
  const ServiciosMiscelaneosScreen({super.key});

  @override
  State<ServiciosMiscelaneosScreen> createState() =>
      _ServiciosMiscelaneosScreenState();
}

class _ServiciosMiscelaneosScreenState
    extends State<ServiciosMiscelaneosScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: SideMenu(scaffoldKey: scaffoldKey),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {
            // Open the SideMenu SideMenu(scaffoldKey: scaffoldKey),
            // SideMenu(scaffoldKey: scaffoldKey);
            scaffoldKey.currentState?.openDrawer();
          },
          //   // scaffoldKey.currentState?.openDrawer();
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 40),
            Center(
              child: SvgPicture.asset(
                "assets/icons/logo-trc.svg",
                fit: BoxFit.scaleDown,
                height: 35,
              ),
            ),
          ],
        ),
        actions: [
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

      body: const Center(child: _ServiciosMiscelaneosMainView()),
    );
  }
}

// Consumerstatful widget  _ServiciosMiscelaneosScreenState

class _ServiciosMiscelaneosMainView extends ConsumerStatefulWidget {
  const _ServiciosMiscelaneosMainView();

  @override
  ConsumerState<_ServiciosMiscelaneosMainView> createState() =>
      _ServiciosMiscelaneosMainViewState();
}

class _ServiciosMiscelaneosMainViewState
  extends ConsumerState<_ServiciosMiscelaneosMainView> {
  
  final ScrollController _scrollController = ScrollController();

    final ConnectivityService _connectivityService = ConnectivityService();
    // bool _isConnected = true;

    Future<void> _handleRefresh() async {
      // Get Turnarounds
      // await ref.read(turnaroundProvider.notifier).getTurnarounds();
      await ref.read(turnaroundProvider.notifier).getServiciosMiscelaneos();
    }

    @override
    void initState() {
    super.initState();

    // _scrollController.addListener(_scrollListener);
    ref.read(turnaroundProvider.notifier).getServiciosMiscelaneos();

    //  _connectivityService.connectionChange.listen((isConnected) {
    //   setState(() {
    //     // _isConnected = isConnected;
    //   });
    // });
  }
  
  @override
  void dispose() {
    _scrollController.dispose();
    _connectivityService.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    // final isConnected = ref.watch(isConnectedProvider);
    final connectivityState = ref.watch(connectivityProvider);
    final turnaroundsState = ref.watch(turnaroundProvider);

    if (turnaroundsState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SafeArea(
      child: Container(
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          child: ListView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              const SizedBox(height: 6),
              Center(
                child: Text(
                  'Servicios Misceláneos',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w900,
                    fontFamily: GoogleFonts.openSans(
                      fontWeight: FontWeight.w900,
                    ).fontFamily,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              _DateFilter(),
              turnaroundsState.serviciosMiscelaneos.isEmpty
                  ? 
                  Column(
                  children: [
                    const SizedBox(height: 20),
                    Center(
                        child: Text(
                          'No hay servicios miscelaneos',
                          // overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium
                        ),
                      ),
                    Center(
                        child: Text(
                          'registrados.',
                          // overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium
                        ),
                      ),
                  ],
                )
                  // Padding(
                  //     padding: const EdgeInsets.only(top: 100.0),
                  //     child: Center(
                  //       child: Text(
                  //         'No hay servicios misceláneos para la fecha seleccionada.',
                  //         // connectivityState == ConnectivityStatus.offline
                  //         //     ? 'No hay conexión a internet.'
                  //         //     : 'No hay servicios misceláneos para la fecha seleccionada.',
                  //         style: Theme.of(context).textTheme.bodyMedium,
                  //       ),
                  //     ),
                  //   )
                  : SizedBox(),
              ...turnaroundsState.serviciosMiscelaneos.map(
                (servicioMiscelaneo) => _ListTileCardContainer(
                  turnaround: servicioMiscelaneo,
                ),
              ),


            ],
          )
        ),
      ),
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
                
                _ServicioMiscelaneoCardViewSideA(
                  estacion: turnaround.fkVuelo.stn?.aeropuerto ?? '', 
                  nroVuelo: "${turnaround.fkVuelo.fkAerolinea.codigoOaci}-${turnaround.fkVuelo.numeroVueloOut}", 
                  ruta: '', 
                  tipoAC: turnaround.fkVuelo.acType,
                  matricula: turnaround.fkVuelo.acReg, 
                  puerta: turnaround.fkVuelo.gate.toString(), 
                  hora: turnaround.fkVuelo.etdOut?.substring(0, 5) ??
                                    "",),
                _ServicioMiscelaneoCardViewSideB(
                  estacion: turnaround.fkVuelo.stn?.codigoIata ?? '', 
                  nroVuelo: "${turnaround.fkVuelo.fkAerolinea.codigoOaci}-${turnaround.fkVuelo.numeroVueloOut}", 
                  ruta: '', 
                  tipoAC: turnaround.fkVuelo.acType,
                  matricula: turnaround.fkVuelo.acReg, 
                  puerta: turnaround.fkVuelo.gate.toString(), 
                  hora: turnaround.fkVuelo.etdOut?.substring(0, 5) ??
                                    "",),
                // SizedBox(
                //   width: MediaQuery.of(context).size.width / 3.1,
                //   // height: 100,
                // ),

                // SizedBox(
                //   width: MediaQuery.of(context).size.width / 3.1,
                //   // height: 100,
                // )

                // // Vuelo de llegada
                // turnaround.fkVuelo.lugarSalida == null
                //     ? Spacer(flex: 1)
                //     : Flexible(
                //         flex: 1,
                //         child:
                //             // IF lugarSalida != null return _InboundView else empty
                //             turnaround.fkVuelo.lugarSalida == null
                //             // empty sizedbox that fill all the space available
                //             ? SizedBox(
                //                 width: MediaQuery.of(context).size.width / 3.1,
                //                 // height: 100,
                //               )
                //             : _InboundView(
                //                 lugarSalida:
                //                     turnaround
                //                         .fkVuelo
                //                         .lugarSalida
                //                         ?.codigoIata ??
                //                     "",
                //                 lugarLlegada:
                //                     turnaround.fkVuelo.stn?.codigoIata ?? "",
                //                 lugarSalidaLargo:
                //                     turnaround.fkVuelo.lugarSalida?.ciudad ??
                //                     "",
                //                 lugarLlegadaLargo:
                //                     turnaround.fkVuelo.stn?.ciudad ?? "",
                //                 hora:
                //                     turnaround.fkVuelo.etaIn?.substring(0, 5) ??
                //                     "",
                //                 numeroVuelo:
                //                     "${turnaround.fkVuelo.fkAerolinea.codigoIata}-${turnaround.fkVuelo.numeroVueloIn} ",
                //                 isInbound: true,
                //               ),
                //       ),

                // // Vuelo de Salida
                // turnaround.fkVuelo.lugarDestino == null
                //     ? Spacer(flex: 1)
                //     : Flexible(
                //         flex: 1,
                //         child: turnaround.fkVuelo.lugarDestino == null
                //             ? SizedBox(
                //                 width: MediaQuery.of(context).size.width / 3.1,
                //                 // height: 100,
                //               )
                //             : _InboundView(
                //                 lugarSalida:
                //                     turnaround.fkVuelo.stn?.codigoIata ?? "",
                //                 lugarLlegada:
                //                     turnaround
                //                         .fkVuelo
                //                         .lugarDestino
                //                         ?.codigoIata ??
                //                     "",
                //                 lugarSalidaLargo:
                //                     turnaround.fkVuelo.stn?.ciudad ?? "",
                //                 lugarLlegadaLargo:
                //                     turnaround.fkVuelo.lugarDestino?.ciudad ??
                //                     "",
                //                 hora:
                //                     turnaround.fkVuelo.etdOut?.substring(
                //                       0,
                //                       5,
                //                     ) ??
                //                     "",
                //                 numeroVuelo:
                //                     "${turnaround.fkVuelo.fkAerolinea.codigoIata}-${turnaround.fkVuelo.numeroVueloOut} ",
                //                 isInbound: false,
                //               ),
                //       ),
              
              
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
      ));
  }
}


class _ServicioMiscelaneoCardViewSideA extends StatelessWidget {
  final String nroVuelo;
  final String ruta;
  final String tipoAC;
  final String matricula;
  final String puerta;
  final String estacion;
  final String hora;
  const _ServicioMiscelaneoCardViewSideA({required this.nroVuelo, required this.ruta, required this.tipoAC, required this.matricula, required this.puerta, required this.estacion, required this.hora});

  @override
  Widget build(BuildContext context) {

    bool isMobile = MediaQuery.of(context).size.width < 500;

    return Flexible(
      flex: 1,
      child: Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 140.0, // Sets the maximum width to 300 logical pixels
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              top: 15,
              bottom: 15,
              left: 9,
              right: 10,
              ),
            child: Column(
              children: [
                Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                
                  Text(
                    nroVuelo,
                    overflow: TextOverflow.ellipsis,
                    style: isMobile
                    ? Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontFamily: GoogleFonts.openSans(
                        fontWeight: FontWeight.w700,
                      ).fontFamily,
                    )
                    : Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontFamily: GoogleFonts.openSans(
                        fontWeight: FontWeight.w700,
                      ).fontFamily,
                    ),
                  ),
                ],
              ),
              SizedBox(height:4),
              SvgPicture.asset("assets/icons/av_en_tierra.svg", height: 30),
              SizedBox(height:2),
              
              Center(
                child: Text(
                  matricula,
                  overflow: TextOverflow.ellipsis,
                  style:isMobile
                    ? Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontFamily: GoogleFonts.openSans(
                        fontWeight: FontWeight.w700,
                      ).fontFamily,
                    )
                    : Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontFamily: GoogleFonts.openSans(
                        fontWeight: FontWeight.w700,
                      ).fontFamily,
                    ),
                ),
              ),
              Center(
                child: Text(
                  tipoAC,
                  overflow: TextOverflow.ellipsis,
                  style:isMobile
                    ? Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontFamily: GoogleFonts.openSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ).fontFamily,
                    )
                    : Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontFamily: GoogleFonts.openSans(
                        fontWeight: FontWeight.w700,
                      ).fontFamily,
                    ),
                ),
              ),
              
              ],
            ),
            )
          
        ),
      ));
  
  }
}
class _ServicioMiscelaneoCardViewSideB extends StatelessWidget {
  final String nroVuelo;
  final String ruta;
  final String tipoAC;
  final String matricula;
  final String puerta;
  final String estacion;
  final String hora;
  const _ServicioMiscelaneoCardViewSideB({required this.nroVuelo, required this.ruta, required this.tipoAC, required this.matricula, required this.puerta, required this.estacion, required this.hora});

  @override
  Widget build(BuildContext context) {
      bool isMobile = MediaQuery.of(context).size.width < 500;

    return Flexible(
      flex: 1,
      child: Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 140.0, // Sets the maximum width to 300 logical pixels
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              top: 15,
              bottom: 15,
              left: 9,
              right: 10,
              ),
            child: Column(
              children: [
                Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                
                  Text(
                    estacion,
                    overflow: TextOverflow.ellipsis,
                    style: isMobile
                    ? Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontFamily: GoogleFonts.openSans(
                        fontWeight: FontWeight.w700,
                      ).fontFamily,
                    )
                    : Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontFamily: GoogleFonts.openSans(
                        fontWeight: FontWeight.w700,
                      ).fontFamily,
                    ),
                  ),
                ],
              ),

              SizedBox(height:4),
              
              SvgPicture.asset("assets/icons/av_en_tierra.svg", height: 30),
              SizedBox(height:2),
              
              Center(
                child: Text(
                  "Rampa $puerta",
                  overflow: TextOverflow.ellipsis,
                  style:isMobile
                    ? Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontFamily: GoogleFonts.openSans(
                        fontWeight: FontWeight.w700,
                      ).fontFamily,
                    )
                    : Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontFamily: GoogleFonts.openSans(
                        fontWeight: FontWeight.w700,
                      ).fontFamily,
                    ),
                ),
              ),
              Center(
                child: Text(
                  hora,
                  overflow: TextOverflow.ellipsis,
                  style:isMobile
                    ? Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontFamily: GoogleFonts.openSans(
                        fontWeight: FontWeight.w700,
                      ).fontFamily,
                    )
                    : Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontFamily: GoogleFonts.openSans(
                        fontWeight: FontWeight.w700,
                      ).fontFamily,
                    ),
                ),
              ),
              
              ],
            ),
            )
          
        ),
      ));
  
  }
}

class _MenuDialog extends ConsumerWidget {
  final TurnaroundMain turnaround;
  const _MenuDialog({required this.turnaround});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DepartamentoPersonalState departamentoPersonal = ref.watch(departamentoPersonalProvider(turnaround.id));
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
      content: 
      departamentoPersonal.isLoading
        ? 
        SizedBox(
          height: 100.0,
          width: 100.0,
          child: Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
              strokeWidth: 4.0,
            )
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
                .read(departamentoPersonalProvider(turnaround.id).notifier)
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

          if (turnaround.estatus == 1 ||
              turnaround.estatus == 2 ||
              turnaround.estatus == 3)
            MenuListTile(
              leading: Icon(Icons.agriculture),
              title: 'Asignar equipos GSE',
              onTap: () {
                print("onItemTap");

                // set selectedTurnaroundProvider
                ref.read(selectedTurnaroundProvider.notifier).state =
                    turnaround;

                print("selectedTurnaroundProvider: $turnaround");
                // push
                context.push('/asignar-equipos-gse');
                // close bottom sheet
                Navigator.pop(context);
              },
            ),

          if (turnaround.estatus == 1)
            MenuListTile(
              leading: Icon(Icons.start),
              title: 'Iniciar Operaciones',
              onTap: () async {
                print("onItemTap");
                // push
                await iniciarOperaciones(context, ref, turnaround.id);
                // await iniciarOperacionesServicioMiscelaneo(context, ref, turnaround.id);
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

                // set trcIdProvider
                ref.read(trcIdProvider.notifier).state = turnaround.id;
                // set selectedTurnaroundProvider
                ref.read(selectedTurnaroundProvider.notifier).state =
                    turnaround;

                // get control de actividades by trc id
                // ref.read(controlActividadesProvider(turnaround.id).notifier).getControlDeActividadesByTrcId();
                ref.read(controlActividadesProvider(turnaround.id).notifier).getControlDeActividadesServicioMiscelaneoById();
                // push with turnaround id
                context.push('/control-actividades-servicios-miscelaneos/${turnaround.id}');
                // close bottom sheet
                Navigator.pop(context);
              },
            ),

          if (turnaround.estatus == 3)
            MenuListTile(
              leading: Icon(Icons.lock),
              title: 'Cerrar Vuelo',
              onTap: () {
                print("onItemTap");
                
                // set trcIdProvider
                ref.read(trcIdProvider.notifier).state = turnaround.id;
                // set selectedTurnaroundProvider
                ref.read(selectedTurnaroundProvider.notifier).state =
                    turnaround;

                // Api calls
                // getcerrar_operacionesById
                // Control de actividades
                ref.read(controlActividadesProvider(turnaround.id).notifier).getControlDeActividadesByTrcId();


                // getCodigosMoraByTrc
                 ref
                    .read(demorasProvider.notifier)
                    .getDemorasByTrc(turnaround.id);

                // Personal
                ref
                    .read(departamentoPersonalProvider(turnaround.id).notifier)
                    .getDepartamentosConPersonal(turnaround.id);
                


                // push
                context.push('/cerrar-vuelo-screen');
                // close bottom sheet
                Navigator.pop(context);

                // show snackbar if push return true
                // if (result == true) {
                //   ScaffoldMessenger.of(context).showSnackBar(
                //     SnackBar(content: Text('Vuelo cerrado correctamente')),
                //   );
                // }
              },
            ),
            
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
                
                // set trcIdProvider
                ref.read(trcIdProvider.notifier).state = turnaround.id;
                // set selectedTurnaroundProvider
                ref.read(selectedTurnaroundProvider.notifier).state =
                    turnaround;

                // Api calls
                // getcerrar_operacionesById
                // Control de actividades
                ref.read(controlActividadesProvider(turnaround.id).notifier).getControlDeActividadesByTrcId();

                // ref.read(plantillaDetalleProvider.notifier).getPlantillaDetalleById(turnaround.fkVuelo.fkPlantilla?.id ?? 0);


                // getCodigosMoraByTrc
                 ref
                    .read(demorasProvider.notifier)
                    .getDemorasByTrc(turnaround.id);

                // Personal
                ref
                    .read(departamentoPersonalProvider(turnaround.id).notifier)
                    .getDepartamentosConPersonal(turnaround.id);
                

                // push
                context.push('/consultar-servicios-miscelaneos-screen');
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
                  SizedBox(height: 0,),
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
                    color: 
                    switch (turnaround.fkVuelo.estatus.id) {
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
                    border: Border.all(
                      color: Colors.black26,
                      width: 1,
                    ),
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
                    color: Colors.black54
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
            )


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
        .iniciarOperacionesServiciosMiscelaneos(id);

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
            SizedBox(
              height: 90,
              child: 
              // Image.network(image, fit: BoxFit.contain),
              CachedNetworkImage(
                imageUrl: image,
                fit: BoxFit.contain,
                placeholder: (context, url) => 
                Placeholder(
                  strokeWidth: 2,
                  color: Colors.transparent) ,
                errorWidget: (context, url, error) => Icon(Icons.error),
              )
            ),
            // Uppercase
            Text(
              name.toUpperCase(),
              style: isMobile
              ? Theme.of(context).textTheme.labelSmall?.copyWith(
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

class _DateFilter extends ConsumerWidget {
  const _DateFilter();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(datetimeProvider);
    final inputFormat = DateFormat('dd/MM/yyyy HH:mm');
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,

      // mainAxisSize: MainAxisSize.min,
      children: [
        // calendar green icon
        // IconButton(
        //   onPressed: () {},
        //   icon: Icon(
        //     Icons.calendar_month_sharp,
        //     color: Theme.of(context).colorScheme.primary,
        //   ),
        // ),
        IconButton(
          onPressed: () {
            // subtract one day from selectedDate
            final newDate = selectedDate.subtract(const Duration(days: 1));
            ref.read(datetimeProvider.notifier).state = newDate;

            // setSelectedDate
            ref.read(turnaroundProvider.notifier).setSelectedDate(newDate, true);
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: 18,
            // color: Theme.of(context).colorScheme.primary,
          ),
        ),
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
              // Get the turnarounds for the selected date

              // setSelectedDate
              ref.read(turnaroundProvider.notifier).setSelectedDate(dateTime,true);

              // ref.read(turnaroundProvider.notifier).state = ref
              //     .read(turnaroundProvider.notifier)
              //     .state
              //     .copyWith(selectedDate: dateTime);
              // ref.read(turnaroundProvider.notifier).getTurnarounds();
            }
          },
          child: Text(
            // "${selectedDate.toLocal()}".split(' ')[0],
            inputFormat.format(selectedDate).split(' ')[0],
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.arrow_forward_ios_rounded,
            size: 18,
            // color: Theme.of(context).colorScheme.primary,
          ),
          onPressed: () {
            // add one day to selectedDate
            final newDate = selectedDate.add(const Duration(days: 1));
            ref.read(datetimeProvider.notifier).state = newDate;

            // setSelectedDate
            ref.read(turnaroundProvider.notifier).setSelectedDate(newDate);

            // ref.read(turnaroundProvider.notifier).state = ref
            //     .read(turnaroundProvider.notifier)
            //     .state
            //     .copyWith(selectedDate: newDate);
            // ref.read(turnaroundProvider.notifier).getTurnarounds();
          },
        ),
      ],
    );
  }
}