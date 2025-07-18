import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:turnaround_mobile/features/turnarounds/domain/entities/control_actividades.dart';

import '../../../shared/shared.dart';
import '../providers/providers.dart';

// helpers

class ControlActividadesScreen extends ConsumerWidget {
  final int trcId;
  const ControlActividadesScreen({super.key, required this.trcId})
    : super(
        // getControlActividades
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Color
    final Color primaryColor = Theme.of(context).colorScheme.primary;

    // Control de actividades state
    final controlActividadesState = ref.watch(
      controlActividadesProvider(trcId),
    );
    final controlActividades = ref
        .watch(controlActividadesProvider(trcId))
        .controlActividades;
    // var controlActividades = controlActividadesState.controlActividades;

    return DefaultTabController(
      length: controlActividades?.departamentos?.length ?? 0,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                backgroundColor: Colors.white,
                // elevation: 0,
                title: Center(
                  child: SvgPicture.asset(
                    "assets/icons/logo-trc.svg",
                    fit: BoxFit.scaleDown,
                    height: 35,
                  ),
                ),

                pinned: true,
                floating: true,
                bottom: TabBar(
                  labelColor: Colors.white,
                  dividerColor: Colors.transparent,
                  // indicatorColor: Colors.transparent,
                  isScrollable: true,
                  unselectedLabelColor: primaryColor,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [primaryColor, primaryColor],
                    ),
                    borderRadius: BorderRadius.circular(10),
                    color: primaryColor,
                  ),

                  // Map
                  tabs:
                      controlActividades?.departamentos
                          ?.map(
                            (dep) =>
                                _customTabBarHeaderItem(title: dep.nombreArea),
                          )
                          .toList() ??
                      [],
                ),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_sharp),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.manage_accounts),
                    onPressed: () {},
                  ),
                ],
              ),
            ];
          },
          body: TabBarView(
            physics: const BouncingScrollPhysics(),
            children: controlActividades?.departamentos != null
                ? List<Widget>.generate(
                    controlActividades!.departamentos!.length,
                    (index) => _DepartamentosView(
                      departamento: controlActividades.departamentos![index],
                      indexDep: index,
                    ),
                  )
                : <Widget>[],

            // controlActividades?.departamentos?.map((dep) {
            //   return _ControlActividadesMainView(trcId: trcId);
            // }).toList() ??
            // [],
            // children: [
            // children: <Widget>[
            //   Icon(Icons.flight, size: 350),
            //   Icon(Icons.directions_transit, size: 350),
            //   Icon(Icons.flight, size: 350),
            // ],
          ),
        ),
      ),
    );
  }
}

class _DepartamentosView extends StatelessWidget {
  final Departamento departamento;
  final int indexDep;
  const _DepartamentosView({
    required this.departamento,
    required this.indexDep,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 8),

        // Actividades map view
        Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: departamento.actividades.length,
            itemBuilder: (context, index) {
              final actividad = departamento.actividades[index];
              return _ActividadView(
                actividad: actividad,
                indexAct: index,
                indexDep: indexDep,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ActividadView extends StatelessWidget {
  final Actividades actividad;
  final int indexAct;
  final int indexDep;
  const _ActividadView({
    required this.actividad,
    required this.indexDep,
    required this.indexAct,
  });

  @override
  Widget build(BuildContext context) {
    bool isExpanded = true;
    return ExpansionPanelList(
      // elevation: 0,
      expandedHeaderPadding: EdgeInsets.zero,
      expansionCallback: (int index, bool isExpanded) {
        isExpanded = !isExpanded;
      },
      children: [
        ExpansionPanel(
          canTapOnHeader: true,

          // borderRadius: BorderRadius.circular(8),
          backgroundColor: Colors.white,
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text(
                actividad.nombreActividad,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  // color: Theme.of(context).colorScheme.primary,
                ),
              ),
            );
          },
          isExpanded: isExpanded,
          body: Column(
            children: actividad.tareas!.map((tarea) {
              return _TareaView(
                tarea: tarea,
                indexTar: indexAct,
                indexAct: indexAct,
                indexDep: indexDep,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _TareaView extends StatelessWidget {
  final Tarea tarea;
  final int indexTar;
  final int indexAct;
  final int indexDep;

  const _TareaView({
    required this.tarea,
    required this.indexTar,
    required this.indexAct,
    required this.indexDep,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      // elevation: 0,
      expandedHeaderPadding: EdgeInsets.zero,
      expansionCallback: (int index, bool isExpanded) {
        // isExpanded = !isExpanded;
      },
      children: [
        ExpansionPanel(
          backgroundColor: Colors.white,
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text(
                tarea.titulo,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w400,
                  // color: Theme.of(context).colorScheme.primary,
                ),
              ),
            );
          },
          isExpanded: true,
          body: Column(
            children: [
              switch (tarea.tipoId) {
                2 => _TareaHoraView(tarea: tarea),
                3 => _TareaHoraInicioFinView(tarea: tarea),
                1 => _TareaCantidadView(tarea: tarea),
                4 => _TareaMaquinariaSinTiempoView(tarea: tarea),
                5 => _TareaMaquinariaConTiempoView(tarea: tarea),
                6 => _TareaTextoView(tarea: tarea),
                7 => _TareaPasajerosView(tarea: tarea),
                8 => _TareaExcesoEquipajeView(tarea: tarea),
                9 => _TareaITView(tarea: tarea),
                10 => _TareaLimpiezaView(tarea: tarea),
                // Default case
                _ => _TareaHoraView(tarea: tarea),
              },

              // Image list display
              // if (tarea.imagenes != null && tarea.imagenes!.isNotEmpty) ...[
              //   _TareaImagenView(tarea: tarea),
              // ]
            ],
          ),
        ),
      ],
    );
  }
}

// Tareas por tipo

class _TareaHoraView extends ConsumerWidget {
  final Tarea tarea;
  const _TareaHoraView({required this.tarea});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Loading indicator
    // Format time
    final timeFormat = DateFormat('HH:mm');

    // State to manage loading
    bool isLoading = ref.watch(isLoadingControlActividadesProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Stack(
        children: [
          // isLoading
          //     ?

          // : const SizedBox.shrink(),
          // Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // ifLoading
              GestureDetector(
                onTap: () async {
                  print('Hora tapped');
                  // Show time picker dialog
                  final selectedTime = await showTimePickerDialog(
                    context,
                    tarea,
                    tarea.horaInicio != null
                        ? TimeOfDay.fromDateTime(tarea.horaInicio!)
                        : null,
                  );
                  print('Selected time: $selectedTime');
                  if (selectedTime != null) {
                    // TODO: Api call to update tarea with selected time
                    final response = await setHoraInicio(
                      ref,
                      tarea.id,
                      DateTime(
                        DateTime.now().year,
                        DateTime.now().month,
                        DateTime.now().day,
                        selectedTime.hour,
                        selectedTime.minute,
                        0,
                      ),
                      'Hora',
                    );

                    // Show snackbar response
                    CustomSnackbar.showResponseSnackbar(
                      response.message,
                      response.success,
                      // ignore: use_build_context_synchronously
                      context,
                    );
                  }
                },
                child: SizedBox(
                  // width: 100,
                  child: Row(
                    children: [
                      Text(
                        'Hora:',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        // min width: 100,
                        constraints: const BoxConstraints(minWidth: 60),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 210, 210, 210),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          (tarea.horaInicio != null
                                  ? timeFormat.format(tarea.horaInicio!)
                                  : '')
                              .toString(),
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Rounded button to set current time
              isLoading
                  ? Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: SizedBox(
                        height: 25.0,
                        width: 25.0,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.primary,
                            strokeWidth: 3.0,
                          ),
                        ),
                      ),
                    )
                  : ElevatedButton(
                      // disable if isLoading
                      onPressed: () async {
                        if (isLoading) return;
                        // Show loading indicator
                        ref
                            .read(isLoadingControlActividadesProvider.notifier)
                            .update((state) => true);
                        // wait 3 seconds
                        // await Future.delayed(const Duration(seconds: 3));
                        final response = await setHoraInicio(
                          ref,
                          tarea.id,
                          DateTime.now(),
                          'Hora',
                        );
                        CustomSnackbar.showResponseSnackbar(
                          response.message,
                          response.success,
                          // ignore: use_build_context_synchronously
                          context,
                        );
                        ref
                            .read(isLoadingControlActividadesProvider.notifier)
                            .update((state) => false);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(2),
                        // iconSize: 40,
                        fixedSize: const Size(25, 25),
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.primary, // <-- Button color
                        foregroundColor: Colors.red, // <-- Splash color
                      ),
                      child: Icon(
                        Icons.access_time,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
              // IconButton(
              //   icon: Icon(
              //     Icons.access_time,
              //     color: Theme.of(context).colorScheme.primary,
              //   ),
              //   onPressed: () {},
              // ),
            ],
          ),
          // BackdropFilter(
          //   filter: ui.ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
          //   child: Container(color: Colors.transparent),
          // ),
        ],
      ),
    );
  }
}

Future<SnackbarResponse> setHoraInicio(
  WidgetRef ref,
  int id,
  DateTime horaInicio,
  String tipo,
) async {
  // transform horaInicio to the format required by the API '2025-07-16T19:23:18.861Z'
  // final String formattedDate = DateFormat('yyyy-MM-ddTHH:mm:ss').format(horaInicio);
  // const formattedDate = new Date( this.myForm.value.fecha.getFullYear() + '-' + (this.myForm.value.fecha.getMonth() + 1) + '-' + this.myForm.value.fecha.getDate() + ' ' + this.myForm.value.hora + ':' +'00' );

  // Call the repository method to set horaInicio
  final trcId = ref.read(trcIdProvider);
  return await ref
      .read(controlActividadesProvider(trcId).notifier)
      .setHoraInicio(id, horaInicio, tipo);
  // Optionally, you can show a snackbar or a dialog to confirm the action
  // ScaffoldMessenger.of(context).showSnackBar(
  //   const SnackBar(content: Text('Hora de inicio actualizada correctamente.')),
  // );
}

Future<SnackbarResponse> setHoraFin(
  WidgetRef ref,
  int id,
  DateTime horaFin,
) async {
  // Call the repository method to set horaInicio
  final trcId = ref.read(trcIdProvider);
  return await ref
      .read(controlActividadesProvider(trcId).notifier)
      .setHoraInicio(id, horaFin, 'Hora final');
  // Optionally, you can show a snackbar or a dialog to confirm the action
  // ScaffoldMessenger.of(context).showSnackBar(
  //   const SnackBar(content: Text('Hora de inicio actualizada correctamente.')),
  // );
}

// Centralized showTimePicker function
Future<TimeOfDay?> showTimePickerDialog(
  BuildContext context,
  // WidgetRef ref,
  Tarea tarea,
  TimeOfDay? initialTime,
) async {
  // TODO: 24 hour format
  final selectedTime = await showTimePicker(
    confirmText: 'Seleccionar',
    cancelText: 'Cancelar',
    minuteLabelText: 'Minutos',
    hourLabelText: 'Horas',
    useRootNavigator: true,
    initialEntryMode: TimePickerEntryMode.input,
    helpText: 'Seleccionar hora',
    context: context,
    initialTime: initialTime != null
        ? TimeOfDay.fromDateTime(tarea.horaInicio!)
        : TimeOfDay.now(),
  );
  return selectedTime;

  // if (selectedTime != null) {
  //   print('Selected time: ${selectedTime.format(context)}');
  //   // TODO: Update tarea with selected time
  //   tarea.horaInicio = DateTime(
  //     DateTime.now().year,
  //     DateTime.now().month,
  //     DateTime.now().day,
  //     selectedTime.hour,
  //     selectedTime.minute,
  //   );
  // Update state
  // }
}

class _TareaHoraInicioFinView extends ConsumerWidget {
  final Tarea tarea;
  const _TareaHoraInicioFinView({required this.tarea});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Loading indicator
    // Format time
    final timeFormat = DateFormat('HH:mm');

    // State to manage loading
    bool isLoading = ref.watch(isLoadingControlActividadesProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),

      child: Column(
        children: [
          // Hora de inicio
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // ifLoading
              GestureDetector(
                onTap: () async {
                  print('Hora inicio tapped');
                  // Show time picker dialog
                  final selectedTime = await showTimePickerDialog(
                    context,
                    tarea,
                    tarea.horaInicio != null
                        ? TimeOfDay.fromDateTime(tarea.horaInicio!)
                        : null,
                  );
                  print('Selected time: $selectedTime');
                  if (selectedTime != null) {
                    // TODO: Api call to update tarea with selected time
                    final response = await setHoraInicio(
                      ref,
                      tarea.id,
                      DateTime(
                        DateTime.now().year,
                        DateTime.now().month,
                        DateTime.now().day,
                        selectedTime.hour,
                        selectedTime.minute,
                        0,
                      ),
                      'Hora de Inicio',
                    );

                    // Show snackbar response
                    CustomSnackbar.showResponseSnackbar(
                      response.message,
                      response.success,
                      // ignore: use_build_context_synchronously
                      context,
                    );
                  }
                },
                child: SizedBox(
                  // width: 100,
                  child: Row(
                    children: [
                      Text(
                        'Hora de inicio',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        // min width: 100,
                        constraints: const BoxConstraints(minWidth: 60),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 210, 210, 210),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          (tarea.horaInicio != null
                                  ? timeFormat.format(tarea.horaInicio!)
                                  : '')
                              .toString(),
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Rounded button to set current time
              isLoading
                  ? Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: SizedBox(
                        height: 25.0,
                        width: 25.0,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.primary,
                            strokeWidth: 3.0,
                          ),
                        ),
                      ),
                    )
                  : ElevatedButton(
                      // disable if isLoading
                      onPressed: () async {
                        if (isLoading) return;
                        // Show loading indicator
                        ref
                            .read(isLoadingControlActividadesProvider.notifier)
                            .update((state) => true);
                        // wait 3 seconds
                        // await Future.delayed(const Duration(seconds: 3));
                        final response = await setHoraInicio(
                          ref,
                          tarea.id,
                          DateTime.now(),
                          'Hora de Inicio',
                        );
                        CustomSnackbar.showResponseSnackbar(
                          response.message,
                          response.success,
                          // ignore: use_build_context_synchronously
                          context,
                        );
                        ref
                            .read(isLoadingControlActividadesProvider.notifier)
                            .update((state) => false);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(2),
                        fixedSize: const Size(25, 25),
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.primary, // <-- Button color
                        foregroundColor: Colors.red, // <-- Splash color
                      ),
                      child: Icon(
                        Icons.access_time,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
            ],
          ),

          // Hora Final
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // ifLoading
              GestureDetector(
                onTap: () async {
                  print('Hora final tapped');
                  // Show time picker dialog
                  final selectedTime = await showTimePickerDialog(
                    context,
                    tarea,
                    tarea.horaFin != null
                        ? TimeOfDay.fromDateTime(tarea.horaFin!)
                        : null,
                  );
                  print('Selected time: $selectedTime');
                  if (selectedTime != null) {
                    // TODO: Api call to update tarea with selected time
                    final response = await setHoraInicio(
                      ref,
                      tarea.id,
                      DateTime(
                        DateTime.now().year,
                        DateTime.now().month,
                        DateTime.now().day,
                        selectedTime.hour,
                        selectedTime.minute,
                        0,
                      ),
                      'Hora final',
                    );

                    // Show snackbar response
                    CustomSnackbar.showResponseSnackbar(
                      response.message,
                      response.success,
                      // ignore: use_build_context_synchronously
                      context,
                    );
                  }
                },
                child: SizedBox(
                  // width: 100,
                  child: Row(
                    children: [
                      Text(
                        'Hora final:',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        // min width: 100,
                        constraints: const BoxConstraints(minWidth: 60),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 210, 210, 210),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          (tarea.horaFin != null
                                  ? timeFormat.format(tarea.horaFin!)
                                  : '')
                              .toString(),
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Rounded button to set current time
              isLoading
                  ? Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: SizedBox(
                        height: 25.0,
                        width: 25.0,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.primary,
                            strokeWidth: 3.0,
                          ),
                        ),
                      ),
                    )
                  : ElevatedButton(
                      // disable if isLoading
                      onPressed: () async {
                        if (isLoading) return;
                        // Show loading indicator
                        ref
                            .read(isLoadingControlActividadesProvider.notifier)
                            .update((state) => true);
                        // wait 3 seconds
                        // await Future.delayed(const Duration(seconds: 3));
                        final response = await setHoraInicio(
                          ref,
                          tarea.id,
                          DateTime.now(),
                          'Hora final',
                        );
                        CustomSnackbar.showResponseSnackbar(
                          response.message,
                          response.success,
                          // ignore: use_build_context_synchronously
                          context,
                        );
                        ref
                            .read(isLoadingControlActividadesProvider.notifier)
                            .update((state) => false);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(2),
                        fixedSize: const Size(25, 25),
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.primary, // <-- Button color
                        foregroundColor: Colors.red, // <-- Splash color
                      ),
                      child: Icon(
                        Icons.access_time,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TareaCantidadView extends StatelessWidget {
  final Tarea tarea;
  const _TareaCantidadView({required this.tarea});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class _TareaMaquinariaSinTiempoView extends StatelessWidget {
  final Tarea tarea;
  const _TareaMaquinariaSinTiempoView({required this.tarea});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class _TareaMaquinariaConTiempoView extends StatelessWidget {
  final Tarea tarea;
  const _TareaMaquinariaConTiempoView({required this.tarea});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class _TareaTextoView extends StatelessWidget {
  final Tarea tarea;
  const _TareaTextoView({required this.tarea});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class _TareaPasajerosView extends StatelessWidget {
  final Tarea tarea;
  const _TareaPasajerosView({required this.tarea});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class _TareaExcesoEquipajeView extends StatelessWidget {
  final Tarea tarea;
  const _TareaExcesoEquipajeView({required this.tarea});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class _TareaITView extends StatelessWidget {
  final Tarea tarea;
  const _TareaITView({required this.tarea});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class _TareaLimpiezaView extends StatelessWidget {
  final Tarea tarea;
  const _TareaLimpiezaView({required this.tarea});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class _TareaImagenView extends StatelessWidget {
  final Tarea tarea;
  const _TareaImagenView({required this.tarea});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class _customTabBarHeaderItem extends StatelessWidget {
  final String title;
  const _customTabBarHeaderItem({required this.title});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Text(
        title,
        style: GoogleFonts.openSans().copyWith(fontWeight: FontWeight.w800),
      ),
    );
  }
}

class _ControlActividadesMainView extends ConsumerWidget {
  final int trcId;
  const _ControlActividadesMainView({required this.trcId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ControlActividadesState controlActividadesState = ref.read(
      controlActividadesProvider(trcId),
    );
    final controlActividades = controlActividadesState.controlActividades;

    return Stack(
      children: [
        // Background image
        BackgroundImg(),
        // Main content
        SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    'Control de Actividades',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontFamily: GoogleFonts.openSans(
                        fontWeight: FontWeight.w700,
                      ).fontFamily,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}































































// ****************************************************************************************************************************************
// ****************************************************************************************************************************************
// ****************************************************************************************************************************************
// ****************************************************************************************************************************************


// class ControlActividadesScreen extends ConsumerWidget {
//   final int trcId;
//   const ControlActividadesScreen({super.key, required this.trcId});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     // final theme = Theme.of(context);

//     final scaffoldKey = GlobalKey<ScaffoldState>();

//     return Scaffold(
//       // backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
//       drawer: SideMenu(scaffoldKey: scaffoldKey),
//       appBar: AppBar(
//         leading: IconButton(
//           // Back button
//           icon: const Icon(Icons.arrow_back_sharp),
//           onPressed: () => Navigator.of(context).pop(),
//           // icon: const Icon(Icons.more_vert),
//           // onPressed: () => scaffoldKey.currentState?.openDrawer(),
//         ),
//         // title: const Text('Turnaround 2'),
//         title: Center(
//           child: SvgPicture.asset(
//             "assets/icons/logo-trc.svg",
//             fit: BoxFit.scaleDown,
//             height: 35,
//           ),
//         ),
//         // user icon menu
//         actions: [
//           IconButton(onPressed: () {}, icon: const Icon(Icons.manage_accounts)),
//         ],
//       ),
//       body: _ControlActividadesMainView(trcId: trcId),

//       // bottomNavigationBar: const _CustomBottomNavigationBar(),
//     );
//   }
// }

// class _ControlActividadesMainView extends ConsumerWidget {
//   final int trcId;
//   const _ControlActividadesMainView({super.key, required this.trcId});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final ControlActividadesState controlActividadesState = ref.read(
//       controlActividadesProvider(trcId),
//     );

//     return Stack(
//       children: [
//         // Background image
//         BackgroundImg(),
//         // Main content
//         SafeArea(
//           child: SingleChildScrollView(
//             physics: BouncingScrollPhysics(),
//             child: Column(
//               children: [
//                 const SizedBox(height: 8),
//                 Center(
//                   child: Text(
//                     'Control de Actividades',
//                     style: Theme.of(context).textTheme.headlineLarge?.copyWith(
//                       color: Theme.of(context).colorScheme.primary,
//                       fontFamily: GoogleFonts.openSans(
//                         fontWeight: FontWeight.w700,
//                       ).fontFamily,
//                     ),
//                   ),
//                 ),
                
//                 // const SizedBox(height: 20),
//                 // const _ControlActividadesHeader(),
//                 // const SizedBox(height: 20),
//                 // const _ControlActividadesSearchBar(),
//                 // const SizedBox(height: 20),
//                 // controlActividadesState.when(
//                 //   data: (data) => ControlActividadesListView(
//                 //     controlActividades: data,
//                 //   ),
//                 //   error: (error, stackTrace) => Center(
//                 //     child: Text('Error: $error'),
//                 //   ),
//                 //   loading: () => const Center(child: CircularProgressIndicator()),
//                 // ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }





// ****************************************************************************************************************************************
// ****************************************************************************************************************************************
// ****************************************************************************************************************************************
// ****************************************************************************************************************************************














































// class _ControlActividadesMainView extends ConsumerStatefulWidget {
//   final int trcId;
//   const _ControlActividadesMainView({required this.trcId});

//   @override
//   _ControlActividadesMainViewState createState() =>
//       _ControlActividadesMainViewState();
// }

// class _ControlActividadesMainViewState extends ConsumerState {
//   final ScrollController _scrollController = ScrollController();

//   @override
//   void initState() {
//     super.initState();

//     ref
//         .read(controlActividadesProvider(trcId).notifier)
//         .getControlDeActividadesByTrcId();

//     // ref
//     // .read(controlActividadesProvider(widget.trcId).notifier);
//     // .getControlDeActividadesByTrcId();
//     // _scrollController.addListener(_scrollListener);
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // final controlActividadesState = ref.watch(controlActividadesProvider(widget.trcId));
//      final ControlActividadesState controlActividadesState = ref.read(
//       controlActividadesProvider(trcId),
//     );

//     return Center();
//   }
// }
