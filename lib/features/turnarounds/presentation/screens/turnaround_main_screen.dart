import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

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
        title: const Text('Turnaround'),
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
    return Builder(
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
    return Card(
      elevation: 4.0,

      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(
          // color: Color.fromRGBO(64, 75, 96, .9),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: _CustomListCardTile(turnaround: widget.turnaround),
      ),
    );
  }
}

class _CustomListCardTile extends StatelessWidget {
  final TurnaroundMain turnaround;
  const _CustomListCardTile({super.key, required this.turnaround});

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
                      isInbound: true,
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
    super.key,
    required this.turnaround,
    required this.isInbound,
    required this.display,
    required this.numeroVuelo,
    required this.ruta,
    required this.hora,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // SVG of the flight (inbound or outbound)
        if (isInbound)
          SvgPicture.asset("assets/icons/departure-icon.svg", height: 40),
        if (!isInbound)
          SvgPicture.asset("assets/icons/arrival-icon.svg", height: 40),
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
              Text(
                ruta,
                style: const TextStyle(
                  fontSize: 16,
                  // fontWeight: FontWeight.bold,
                ),
              ),
              // Hora
              if (isInbound)
                Text(
                  hora,
                  style: const TextStyle(
                    fontSize: 16,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
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

// class _CustomListTile extends StatelessWidget {
//   final TurnaroundMain turnaround;
//   const _CustomListTile({required this.turnaround});

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//         contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
//         // Leading Image
//         leading: Image.network(turnaround.fkVuelo.fkAerolinea.imagen ?? "", width: 40.0),
//         // Container(
//         //   padding: EdgeInsets.only(right: 12.0),
//         //   decoration: new BoxDecoration(
//         //       border: new Border(
//         //           right: new BorderSide(width: 1.0, color: Colors.white24))),
//         //   child: Icon(Icons.autorenew, color: Colors.white),
//         // ),
//         title: Text(
//           "Introduction to Driving",
//           // style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//           style: TextStyle( fontWeight: FontWeight.bold),
//         ),
//         // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

//         subtitle: Row(
//           children: <Widget>[
//             Icon(Icons.linear_scale, color: Colors.blue),
//             Text(" Intermediate", style: TextStyle(color: Colors.black))
//           ],
//         ),
//         trailing:
//             Icon(Icons.keyboard_arrow_right, color: Colors.black, size: 30.0));

//     // ListTile(
//     //   title: const Text('Titulo'),
//     //   subtitle: const Text('Subtitulo'),
//     //   leading: const Icon( Icons.accessibility_new ),
//     //   trailing: const Icon( Icons.keyboard_arrow_right ),
//     //   onTap: (){},

//     // );
//   }
// }

class _CustomBottomNavigationBar extends StatelessWidget {
  const _CustomBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
