import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../shared/shared.dart';
import '../../domain/domain.dart';
import '../providers/providers.dart';

class TurnaroundMainScreen extends StatelessWidget {
  const TurnaroundMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      // backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      drawer: SideMenu(scaffoldKey: scaffoldKey),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () => scaffoldKey.currentState?.openDrawer(),
        ),
        // title: const Text('Turnaround 2'),
        title: Center(
          child: SvgPicture.asset(
            "assets/icons/logo-trc.svg",
            fit: BoxFit.scaleDown,
            height: 35,
          ),
        ),
        // user icon menu
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.manage_accounts)),
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

class _TuraroundMainViewState extends ConsumerState {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    ref.read(turnaroundProvider.notifier).getTurnarounds();
    // _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final turnaroundsState = ref.watch(turnaroundProvider);

    if (turnaroundsState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Stack(
      children: [
        BackgroundImg(),
        SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                // Date Filter
                const SizedBox(height: 3),
                Text(
                  'Turnarounds',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w900,
                    fontFamily: GoogleFonts.openSans(
                      fontWeight: FontWeight.w900,
                    ).fontFamily,
                  ),
                ),
                const SizedBox(height: 2),
                _DateFilter(),
                // const SizedBox(height: ),
                _TurnaroundsListView(turnarounds: turnaroundsState.turnarounds),
              ],
            ),
          ),
        ),
      ],
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

      children: [
        IconButton(
          onPressed: () {
            // subtract one day from selectedDate
            final newDate = selectedDate.subtract(const Duration(days: 1));
            ref.read(datetimeProvider.notifier).state = newDate;

            // setSelectedDate
            ref.read(turnaroundProvider.notifier).setSelectedDate(newDate);

            // ref.read(turnaroundProvider.notifier).state = ref
            //     .read(turnaroundProvider.notifier)
            //     .state
            //     .copyWith(selectedDate: newDate);
            // ref.read(turnaroundProvider.notifier).getTurnarounds();
          },
          icon: Icon(Icons.arrow_back_ios_outlined, size: 20),
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
              ref.read(turnaroundProvider.notifier).setSelectedDate(dateTime);

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
          icon: Icon(Icons.arrow_forward_ios_rounded, size: 20),
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

class _TurnaroundsListView extends StatelessWidget {
  final List<TurnaroundMain> turnarounds;
  const _TurnaroundsListView({required this.turnarounds});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return ListView.builder(
          physics:
              const NeverScrollableScrollPhysics(), // disable scrolling of the ListView
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: turnarounds.length,
          itemBuilder: (context, index) {
            final turnaround = turnarounds[index];
            // return Text("Descomentar para ver la tarjeta");
            return _ListTileCardContainer(turnaround: turnaround);
            // return _ListTileCard(turnaround: turnaround);
          },
        );
      },
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
              height: 150,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center, // <---- The magic
              child: SvgPicture.asset(
                switch (turnaround.fkVuelo.estatus.color) {
                  "verde" => 'assets/layouts/contenedor-verde.svg',
                  "amarillo" => 'assets/layouts/contenedor-amarillo.svg',
                  "rojo" => 'assets/layouts/contenedor-rojo.svg',
                  "azul" => 'assets/layouts/contenedor-azul.svg',
                  "gris" => 'assets/layouts/contenedor-blanco.svg',
                  _ => 'assets/layouts/contenedor-blanco.svg', // default case
                },
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
                Flexible(
                  // backkground color
                  flex: 1,
                  child: _TailView(
                    image: turnaround.fkVuelo.fkAerolinea.imagen ?? "",
                    name: turnaround.fkVuelo.fkAerolinea.aka,
                  ),
                ),

                // Vuelo de llegada
                turnaround.fkVuelo.lugarSalida == null
                    ? Spacer(flex: 1)
                    : Flexible(
                        flex: 1,
                        child:
                            // IF lugarSalida != null return _InboundView else empty
                            turnaround.fkVuelo.lugarSalida == null
                            // empty sizedbox that fill all the space available
                            ? SizedBox(
                                width: MediaQuery.of(context).size.width / 3.1,
                                // height: 100,
                              )
                            : _InboundView(
                                lugarSalida:
                                    turnaround
                                        .fkVuelo
                                        .lugarSalida
                                        ?.codigoIata ??
                                    "",
                                lugarLlegada:
                                    turnaround.fkVuelo.stn?.codigoIata ?? "",
                                lugarSalidaLargo:
                                    turnaround.fkVuelo.lugarSalida?.ciudad ??
                                    "",
                                lugarLlegadaLargo:
                                    turnaround.fkVuelo.stn?.ciudad ?? "",
                                hora:
                                    turnaround.fkVuelo.etaIn?.substring(0, 5) ??
                                    "",
                                numeroVuelo:
                                    "${turnaround.fkVuelo.fkAerolinea.codigoIata} - ${turnaround.fkVuelo.numeroVueloIn} ",
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
                                    "${turnaround.fkVuelo.fkAerolinea.codigoIata} - ${turnaround.fkVuelo.numeroVueloOut} ",
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
      content: Column(
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
              onTap: () {
                print("onItemTap");
                // push
                context.push('/asignar-personal');
                // close bottom sheet
                Navigator.pop(context);
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
                // push with turnaround id
                context.push('/control-actividades/${turnaround.id}');
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
                // push
                context.push('/cerrar-vuelo');
                // close bottom sheet
                Navigator.pop(context);
              },
            ),
          if (turnaround.estatus == 2 || turnaround.estatus == 3)
            MenuListTile(
              leading: Icon(Icons.lock),
              title: 'Cancelar Vuelo',
              onTap: () {
                print("Cancelar Vuelo");
                // push
                // context.push('/cerrar-vuelo');
                // close bottom sheet
                // Navigator.pop(context);
              },
            ),

          // Generar reportes
          if (turnaround.estatus == 3 ||
              (turnaround.estatus != 1 &&
                  turnaround.estatus != 2 &&
                  turnaround.estatus != 3 &&
                  turnaround.estatus != 7))
            MenuListTile(
              leading: Icon(Icons.report),
              title: 'Generar reportes',
              onTap: () {
                print("Generar reportes");
                // push
                context.push('/generar-reportes');
                // close bottom sheet
                Navigator.pop(context);
              },
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
              child: Image.network(image, fit: BoxFit.contain),
            ),
            // Uppercase
            Text(
              name.toUpperCase(),
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
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
            left: 15,
            right: 15,
          ),
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    lugarSalida,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontFamily: GoogleFonts.openSans(
                        fontWeight: FontWeight.w700,
                      ).fontFamily,
                    ),
                  ),
                  Text(
                    lugarLlegada,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontFamily: GoogleFonts.openSans(
                        fontWeight: FontWeight.w700,
                      ).fontFamily,
                    ),
                  ),
                ],
              ),
              isInbound
                  ? SvgPicture.asset("assets/icons/llegada.svg", height: 30)
                  : SvgPicture.asset("assets/icons/salida.svg", height: 30),
              // hora
              Text(
                hora,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontFamily: GoogleFonts.openSans(
                    fontWeight: FontWeight.w700,
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
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontFamily: GoogleFonts.openSans(
                    fontWeight: FontWeight.w700,
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
