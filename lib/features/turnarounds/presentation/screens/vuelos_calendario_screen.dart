import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scounter_mobile/features/shared/domain/domain.dart';
import 'package:scounter_mobile/features/shared/shared.dart';
import 'package:scounter_mobile/features/turnarounds/domain/domain.dart';
import 'package:scounter_mobile/features/turnarounds/presentation/providers/providers.dart';
// import 'vuelos_provider.dart';
// import 'calendario_vuelos_widget.dart'; // El widget que hicimos antes

class VuelosCalendarioScreen extends ConsumerStatefulWidget {
  const VuelosCalendarioScreen({super.key});

  @override
  ConsumerState<VuelosCalendarioScreen> createState() => _VuelosScreenState();
}

class _VuelosScreenState extends ConsumerState<VuelosCalendarioScreen> {
  @override
  void initState() {
    super.initState();
    // Llamada inicial al cargar la pantalla
    Future.microtask(() => ref.read(vuelosCalendarioProvider.notifier).fetchVuelos(getCurrentMonthDateRange(DateTime.now())));
  }


  // funcion que devuelva el primer y el ultimo dia del mes actual
  VueloCalendarioRequest getCurrentMonthDateRange( DateTime? newDate) {
    final now = newDate ?? DateTime.now();
    // final now = DateTime.now();
    final firstDay = DateTime(now.year, now.month, 1);
    final lastDay = DateTime(now.year, now.month + 1, 0);
    return VueloCalendarioRequest( start: firstDay, end: lastDay);
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {

    final state = ref.watch(vuelosCalendarioProvider);

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
        title: Center(child: const Text('Calendario de Vuelos')),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(vuelosCalendarioProvider.notifier).fetchVuelos(getCurrentMonthDateRange(DateTime.now())),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Capa principal: El Calendario
          // Solo se muestra si hay data o si no está cargando la primera vez
          Column(
            children: [
              Expanded(
                child: CalendarioVuelosWidget(
                  vuelos: state.vuelos,
                  // Al cambiar el mes, llamamos a la lógica de Riverpod
                  onMonthChanged: (newDate) {
                    ref.read(vuelosCalendarioProvider.notifier).fetchVuelos(getCurrentMonthDateRange(newDate));
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
          if (!state.isLoading && state.vuelos.isEmpty)
             const Center(
              child: Text("No se encontraron vuelos en este rango."),
            ),
        ],
      ),
    );
  }
}