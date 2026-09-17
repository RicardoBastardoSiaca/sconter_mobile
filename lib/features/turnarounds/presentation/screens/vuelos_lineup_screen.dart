import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:scounter_mobile/features/shared/shared.dart';
import 'package:scounter_mobile/features/turnarounds/domain/domain.dart';
import 'package:scounter_mobile/features/turnarounds/presentation/providers/providers.dart';
import 'package:scounter_mobile/features/turnarounds/presentation/widgets/widgets.dart';

class _DatePickerHeader extends ConsumerWidget {
  const _DatePickerHeader();

  DateTime _calcularInicioSemana(DateTime fecha) {
    return fecha.subtract(Duration(days: fecha.weekday - 1));
  }

  void _actualizarRangoSemanas(WidgetRef ref, DateTime lunesIncio) {
    final domingoFin = lunesIncio.add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));
    ref.read(vuelosLineupProvider.notifier).updateDateRange(
      VueloLineupRequest(start: lunesIncio, end: domingoFin),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(vuelosLineupProvider);
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    const colorVerde = Color(0xFF0FA45F);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 16, color: colorVerde),
            onPressed: () {
              final nuevoInicio = state.startDate.subtract(const Duration(days: 7));
              _actualizarRangoSemanas(ref, nuevoInicio);
            },
          ),
          InkWell(
            onTap: () async {
              final DateTime? fechaSeleccionada = await showDatePicker(
                context: context,
                initialDate: state.startDate,
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
                helpText: 'SELECCIONA UNA FECHA',
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.light(primary: colorVerde),
                    ),
                    child: child!,
                  );
                },
              );

              if (fechaSeleccionada != null) {
                final lunesDeSemanaSeleccionada = _calcularInicioSemana(fechaSeleccionada);
                _actualizarRangoSemanas(ref, lunesDeSemanaSeleccionada);
              }
            },
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${formatter.format(state.startDate)} - ${formatter.format(state.endDate)}',
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Colors.black87),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.calendar_month_outlined, size: 18, color: colorVerde),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios, size: 16, color: colorVerde),
            onPressed: () {
              final nuevoInicio = state.startDate.add(const Duration(days: 7));
              _actualizarRangoSemanas(ref, nuevoInicio);
            },
          ),
        ],
      ),
    );
  }
}

class VuelosLineupScreen extends ConsumerStatefulWidget {
  const VuelosLineupScreen({super.key});

  @override
  ConsumerState<VuelosLineupScreen> createState() => _VuelosLineupScreenState();
}

class _VuelosLineupScreenState extends ConsumerState<VuelosLineupScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();
  final Map<String, GlobalKey> _dayKeys = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.read(vuelosLineupProvider);
      if (state.vuelos.isEmpty) {
        final now = DateTime.now();
        final lunesActual = now.subtract(Duration(days: now.weekday - 1));
        final domingoActual = lunesActual.add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));
        
        ref.read(vuelosLineupProvider.notifier).updateDateRange(
          VueloLineupRequest(start: lunesActual, end: domingoActual),
        );
      } else {
        ref.read(vuelosLineupProvider.notifier).fetchVuelos(
          VueloLineupRequest(start: state.startDate, end: state.endDate),
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToCurrentDay(List<DateTime> diasDeLaSemana, Map<String, List<VueloLineup>> vuelosAgrupados) async {
    final hoy = DateFormat('yyyy-MM-dd').format(DateTime.now());

    final diasConVuelos = diasDeLaSemana.where((dia) {
      final key = DateFormat('yyyy-MM-dd').format(dia);
      return (vuelosAgrupados[key] ?? []).isNotEmpty;
    }).toList();

    final indexHoy = diasConVuelos.indexWhere(
      (dia) => DateFormat('yyyy-MM-dd').format(dia) == hoy,
    );

    if (indexHoy == -1 || !_scrollController.hasClients) return;

    final proporcion = indexHoy / diasConVuelos.length;
    final targetOffset = _scrollController.position.maxScrollExtent * proporcion;

    _scrollController.jumpTo(targetOffset);

    await Future.delayed(const Duration(milliseconds: 60));

    final key = _dayKeys[hoy];
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        alignment: 0.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(vuelosLineupProvider, (previous, next) {
      if (previous?.isLoading == true && !next.isLoading && next.vuelos.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final vuelosAgrupados = agruparVuelosPorDia(next.vuelos);
          final diasDeLaSemana = List.generate(7, (index) => next.startDate.add(Duration(days: index)));
          _scrollToCurrentDay(diasDeLaSemana, vuelosAgrupados);
        });
      }
    });

    final state = ref.watch(vuelosLineupProvider);
    final vuelosAgrupados = agruparVuelosPorDia(state.vuelos);
    final diasDeLaSemana = List.generate(7, (index) => state.startDate.add(Duration(days: index)));

    return Scaffold(
      key: scaffoldKey,
      drawer: SideMenu(scaffoldKey: scaffoldKey),
      appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => scaffoldKey.currentState?.openDrawer(),
          ),
          title: const Text('LineUp', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                ref.read(vuelosLineupProvider.notifier).fetchVuelos(
                  VueloLineupRequest(start: state.startDate, end: state.endDate),
                );
              },
            ),
          ]),
      body: Column(
        children: [
          const _DatePickerHeader(),
          const Divider(height: 1, thickness: 0.5, color: Color(0xFFE0E0E0)),
          if (state.isLoading)
            const Expanded(child: Center(child: CircularProgressIndicator.adaptive(valueColor: AlwaysStoppedAnimation(Color(0xFF0FA45F)))))
          else if (state.vuelos.isEmpty)
            const Expanded(child: Center(child: Text('No hay vuelos programados para esta semana.', style: TextStyle(color: Colors.grey))))
          else
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.only(top: 8.0, bottom: 20.0),
                itemCount: diasDeLaSemana.length,
                itemBuilder: (context, index) {
                  final dia = diasDeLaSemana[index];
                  final fechaKey = DateFormat('yyyy-MM-dd').format(dia);
                  final vuelosDelDia = vuelosAgrupados[fechaKey] ?? [];

                  if (vuelosDelDia.isEmpty) return const SizedBox.shrink();

                  _dayKeys.putIfAbsent(fechaKey, () => GlobalKey());

                  final formatoCabecera = DateFormat('EEEE dd/MM', 'es_ES').format(dia).toUpperCase();

                  final hoy = DateTime.now();
                  final esHoy = dia.year == hoy.year && dia.month == hoy.month && dia.day == hoy.day;

                  return Container(
                    key: _dayKeys[fechaKey],
                    decoration: BoxDecoration(
                      color: esHoy ? const Color(0xFF0FA45F).withOpacity(0.02) : Colors.transparent,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    formatoCabecera,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: esHoy ? const Color(0xFF0FA45F) : Colors.black54,
                                      letterSpacing: 0.5
                                    ),
                                  ),
                                  if (esHoy) ...[
                                    const SizedBox(width: 6),
                                    const Text(
                                      '• HOY',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w900,
                                        color: Color(0xFF0FA45F),
                                        letterSpacing: 0.5
                                      ),
                                    ),
                                  ]
                                ],
                              ),
                              if (vuelosDelDia.isNotEmpty)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF0FA45F).withOpacity(esHoy ? 0.2 : 0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    '${vuelosDelDia.length} ${vuelosDelDia.length == 1 ? 'vuelo' : 'vuelos'}',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF0FA45F),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        IntrinsicHeight(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.only(left: 12.0, bottom: 4.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch, 
                              children: vuelosDelDia.map((vuelo) {
                                return VueloCompactCard(vuelo: vuelo);
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

Map<String, List<VueloLineup>> agruparVuelosPorDia(List<VueloLineup> vuelos) {
  final Map<String, List<VueloLineup>> agrupados = {};
  for (var vuelo in vuelos) {
    final fechaKey = (vuelo.auxFecha != null && vuelo.auxFecha!.isNotEmpty)
        ? vuelo.auxFecha!
        : (vuelo.fechaInicio?.split(' ').first ?? '');
        
    if (fechaKey.isNotEmpty) {
      agrupados.putIfAbsent(fechaKey, () => []).add(vuelo);
    }
  }
  return agrupados;
}