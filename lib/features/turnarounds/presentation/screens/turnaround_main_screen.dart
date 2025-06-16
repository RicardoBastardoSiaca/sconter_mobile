import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
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
        title: const Text('Turnaround 2'),
        // user icon menu
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search_rounded)),
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
    return Column(
      children: [
        // Date Filter
        const SizedBox(height: 10),
        _DateFilter(),
        const SizedBox(height: 10),
        Builder(
          builder: (context) {
            return ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: turnaroundsState.turnarounds.length,
              itemBuilder: (context, index) {
                final turnaround = turnaroundsState.turnarounds[index];
                return _ListTileCard(turnaround: turnaround);
              },
            );
          },
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
          style: TextStyle(fontSize: 20),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.arrow_forward_ios_rounded, size: 20),
        ),
      ],
    );
  }
}

class _ListTileCard extends StatefulWidget {
  final TurnaroundMain turnaround;
  const _ListTileCard({required this.turnaround});

  @override
  State<_ListTileCard> createState() => _ListTileCardState();
}

class _ListTileCardState extends State<_ListTileCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        elevation: 4.0,

        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
          decoration: BoxDecoration(
            // color: Color.fromRGBO(64, 75, 96, .9),
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: _CustomListCardTile(turnaround: widget.turnaround),
        ),
      ),
      onTap: () {
        // *********************************************************************************************************************
        showModalBottomSheet<void>(
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
                  padding: const EdgeInsets.symmetric(
                    vertical: 0.0,
                    horizontal: 5.0,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ListTile(trailing: Icon(Icons.close)),
                      ListTile(
                        leading: Icon(Icons.fact_check_outlined),
                        title: Text('Control de actividades'),
                        onTap: () {
                          // push
                          context.push('/control-actividades');
                          // close bottom sheet
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.lock_clock_outlined),
                        title: Text('Cerrar Turnaround'),
                        onTap: () {
                          // push
                          // context.push('/control-actividades');
                          // close bottom sheet
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
        // *********************************************************************************************************************
      },
    );
  }
}

class _BottomSheetMenu extends StatelessWidget {
  final TurnaroundMain turnaround;
  const _BottomSheetMenu({required this.turnaround});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class _CustomListCardTile extends StatelessWidget {
  final TurnaroundMain turnaround;
  const _CustomListCardTile({required this.turnaround});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            // Image
            Expanded(
              flex: 2,
              child: Image.network(
                turnaround.fkVuelo.fkAerolinea.imagen ?? "",
                width: 60.0,
              ),
            ),
            Expanded(
              flex: 4,
              child: !(turnaround.fkVuelo.lugarSalida == null)
                  ? _CardFligthInfo(
                      turnaround: turnaround,
                      isInbound: true,
                      display: !(turnaround.fkVuelo.lugarSalida == null),
                      numeroVuelo: !(turnaround.fkVuelo.lugarSalida == null)
                          ? turnaround.fkVuelo.numeroVueloIn
                          : '',
                      ruta:
                          "${turnaround.fkVuelo.lugarSalida?.codigoIata} - ${turnaround.fkVuelo.stn?.codigoIata}",
                      hora: turnaround.fkVuelo.etaIn?.substring(0, 5) ?? '',
                    )
                  : const Text(''),
            ),
            Expanded(
              flex: 4,
              child: !(turnaround.fkVuelo.lugarDestino == null)
                  ? _CardFligthInfo(
                      turnaround: turnaround,
                      isInbound: false,
                      display: !(turnaround.fkVuelo.lugarDestino == null),
                      numeroVuelo: !(turnaround.fkVuelo.lugarDestino == null)
                          ? turnaround.fkVuelo.numeroVueloOut ?? ''
                          : '',
                      ruta:
                          "${turnaround.fkVuelo.stn?.codigoIata} - ${turnaround.fkVuelo.lugarDestino?.codigoIata}",
                      hora: turnaround.fkVuelo.etdOut?.substring(0, 5) ?? '',
                    )
                  : const Text(''),
            ),
            // Incoming flight

            // Outgoing flight
          ],
        ),
      ),
    );
  }
}

class _CardFligthInfo extends StatelessWidget {
  final bool isInbound;
  final bool display;
  final String numeroVuelo;
  final String ruta;
  final String hora;
  final TurnaroundMain turnaround;

  const _CardFligthInfo({
    required this.turnaround,
    required this.isInbound,
    required this.display,
    required this.numeroVuelo,
    required this.ruta,
    required this.hora,
  });

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        // SVG of the flight (inbound or outbound)
        if (isInbound)
          SvgPicture.asset("assets/icons/arrival-icon.svg", height: 30),
        if (!isInbound)
          SvgPicture.asset("assets/icons/departure-icon.svg", height: 30),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            children: [
              // flight information
              Text(
                "${turnaround.fkVuelo.fkAerolinea.codigoIata}-$numeroVuelo",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Ruta
              Text(ruta, style: textTheme.bodyLarge),
              // Hora
              if (isInbound) Text(hora, style: textTheme.bodyLarge),
              // Hora
              if (!isInbound)
                Text(
                  hora,
                  style: const TextStyle(
                    fontSize: 16,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
              // Text(
              //   "${turnaround.fkVuelo.fechaSalida} - ${turnaround.fkVuelo.fechaLlegada}",
              //   style: const TextStyle(
              //     fontSize: 16,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CustomBottomNavigationBar extends StatelessWidget {
  const _CustomBottomNavigationBar();

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
