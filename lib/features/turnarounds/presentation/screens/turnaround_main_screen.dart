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
                const SizedBox(height: 15),
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
                const SizedBox(height: 10),
                _DateFilter(),
                const SizedBox(height: 10),
                Builder(
                  builder: (context) {
                    return ListView.builder(
                      physics:
                          NeverScrollableScrollPhysics(), // disable scrolling of the ListView
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: turnaroundsState.turnarounds.length,
                      itemBuilder: (context, index) {
                        final turnaround = turnaroundsState.turnarounds[index];
                        // return Text("Descomentar para ver la tarjeta");
                        return _ListTileCardContainer(turnaround: turnaround);
                        // return _ListTileCard(turnaround: turnaround);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _DateFilter extends StatefulWidget {
  const _DateFilter();

  @override
  State<_DateFilter> createState() => _DateFilterState();
}

class _DateFilterState extends State<_DateFilter> {
  DateTime selectedDate = DateTime.now();
  DateFormat inputFormat = DateFormat('dd/MM/yyyy HH:mm');

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,

      children: [
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.arrow_back_ios_outlined, size: 20),
        ),
        Text(
          // "${selectedDate.toLocal()}".split(' ')[0],
          inputFormat.format(selectedDate).split(' ')[0],
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.arrow_forward_ios_rounded, size: 20),
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
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: GestureDetector(
        onTap: _onItemTap(context, turnaround),
        behavior: HitTestBehavior.opaque,
        child: Stack(
          children: [
            // svg background
            // SvgPicture.asset(
            //   "assets/layouts/fligth-container-gris.svg",
            //   alignment: Alignment.center,
            //   height: 50,
            //   fit: BoxFit.fill,
            // ),
            FittedBox(
              child: Center(
                child: Container(
                  // altura de la tarjeta
                  height: 175,
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center, // <---- The magic
                  // padding: const EdgeInsets.all(12),
                  child: SvgPicture.asset(
                    // 'assets/layouts/fligth-container-gris.svg',
                    'assets/layouts/contenedor-blanco.svg',
                    // fit: BoxFit.fill,
                    // width: MediaQuery.of(context).size.width,
                    // Max width of the card
                    // width: 400,
                    semanticsLabel: 'Image',
                    // height: 300,
                    fit: BoxFit.fill,

                    alignment: Alignment.center,
                  ),
                ),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisSize: MainAxisSize.max,
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // shrinkWrap: true,
              // physics: NeverScrollableScrollPhysics(),
              children: [
                // Cola de aerolinea
                Flexible(
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
                                height: 100,
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
                Flexible(
                  flex: 1,
                  child: turnaround.fkVuelo.lugarDestino == null
                      ? SizedBox(
                          width: MediaQuery.of(context).size.width / 3.1,
                          height: 100,
                        )
                      : _InboundView(
                          lugarSalida: turnaround.fkVuelo.stn?.codigoIata ?? "",
                          lugarLlegada:
                              turnaround.fkVuelo.lugarDestino?.codigoIata ?? "",
                          lugarSalidaLargo:
                              turnaround.fkVuelo.stn?.ciudad ?? "",
                          lugarLlegadaLargo:
                              turnaround.fkVuelo.lugarDestino?.ciudad ?? "",
                          hora:
                              turnaround.fkVuelo.etdOut?.substring(0, 5) ?? "",
                          numeroVuelo:
                              "${turnaround.fkVuelo.fkAerolinea.codigoIata} - ${turnaround.fkVuelo.numeroVueloOut} ",
                          isInbound: false,
                        ),
                ),
              ],
            ),
            // Row with 3 equal spaces
            // Row(
            //   children: [
            //     GridTile
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}

// OnTap menu function

class _TailView extends StatelessWidget {
  final String image;
  final String name;
  const _TailView({required this.image, required this.name});

  @override
  Widget build(BuildContext context) {
    return Column(
      // mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            // top: 0,
            // bottom: 0,
            left: 23,
            right: 10,
          ),
          child: Image.network(image),
        ),
        // Uppercase
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            name.toUpperCase(),
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontFamily: GoogleFonts.openSans(
                fontWeight: FontWeight.w700,
              ).fontFamily,
            ),
          ),
        ),
      ],
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
    return Padding(
      padding: const EdgeInsets.only(top: 18, bottom: 10, left: 15, right: 15),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // crossAxisAlignment: CrossAxisAlignment.stretch,
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
            isInbound
                ? Text(
                    "LLEGADA",
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontFamily: GoogleFonts.openSans(
                        fontWeight: FontWeight.w500,
                      ).fontFamily,
                    ),
                  )
                : Text(
                    "SALIDA",
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontFamily: GoogleFonts.openSans(
                        fontWeight: FontWeight.w500,
                      ).fontFamily,
                    ),
                  ),

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
    );
  }
}

_onItemTap(BuildContext context, TurnaroundMain turnaround) {
  // return a showModalBottomSheet
  return () {
    // *********************************************************************************************************************
    showModalBottomSheet<void>(
      elevation: 100,
      context: context,
      backgroundColor: Colors.transparent,
      sheetAnimationStyle: AnimationStyle(
        duration: Duration(milliseconds: 400),
        reverseDuration: Duration(milliseconds: 300),
      ),
      builder: (BuildContext context) {
        return ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              ),
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.transparent, spreadRadius: 3),
              ],
            ),
            // color: Colors.white,
            margin: EdgeInsets.symmetric(horizontal: 15),
            child: Padding(
              padding: const EdgeInsets.only(
                // top: 3.0,
                bottom: 5.0,
                left: 3.0,
                right: 3.0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // LOGICA
                  CustomListTile(
                    leading: Icon(Icons.person),
                    title: 'Asignar Personal',
                    onTap: () {},
                  ),
                  CustomListTile(
                    leading: Icon(Icons.agriculture),
                    title: 'Asignar equipos GSE',
                    onTap: () {},
                  ),
                  CustomListTile(
                    leading: Icon(Icons.start),
                    title: 'Iniciar Operaciones',
                    onTap: () {},
                  ),
                  CustomListTile(
                    leading: Icon(Icons.assignment),
                    title: 'Control de actividades',
                    onTap: () {
                      // push
                      context.push('/control-actividades');
                      // close bottom sheet

                      Navigator.pop(context);
                    },
                  ),
                  CustomListTile(
                    leading: Icon(Icons.lock),
                    title: 'Cerrar Vuelo',
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
    // *********************************************************************************************************************
  };
}
