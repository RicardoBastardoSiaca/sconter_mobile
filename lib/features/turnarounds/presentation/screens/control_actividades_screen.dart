import 'dart:io';
import 'dart:ui' as ui;

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:turnaround_mobile/features/turnarounds/domain/entities/control_actividades.dart';
// shared
import '../../../../config/config.dart';
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
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
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
                _TareaImagenView(tarea: tarea),
                // if (tarea.imagenes != null && tarea.imagenes!.isNotEmpty) ...[
                //   _TareaImagenView(tarea: tarea),
                // ]
              ],
            ),
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

    return Stack(
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
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
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

    return Column(
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
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
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
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
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
    );
  }
}

// TODO: Tarea Cantidad
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

class _TareaImagenView extends ConsumerWidget {
  final Tarea tarea;
  const _TareaImagenView({required this.tarea});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trcId = ref.read(trcIdProvider);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Imágenes:',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w400),
            ),
            // Camera icon
            Row(
              // mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ElevatedButton(
                  // disable if isLoading
                  onPressed: () async {
                    final photoPath = await CameraGalleryServiceImpl()
                        .selectPhoto();

                    if (photoPath == null) {
                      return;
                    }

                    // add image to tarea provider
                    // ref.read(controlActividadesProvider(trcId).notifier)
                    //     .addImage(photoPath);

                    // Upload image
                    final response = await ref
                        .read(controlActividadesProvider(trcId).notifier)
                        .uploadImage(photoPath, tarea.id);

                    if (response == null) {
                      return;
                    }
                    // Show snackbar response
                    CustomSnackbar.showResponseSnackbar(
                      response.message,
                      response.success,
                      // ignore: use_build_context_synchronously
                      context,
                    );

                    print('Selected photo path: $photoPath');
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
                    Icons.photo_library_outlined,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                ElevatedButton(
                  // disable if isLoading
                  onPressed: () async {
                    final photoPath = await CameraGalleryServiceImpl()
                        .takePhoto();

                    print('Selected photo path: $photoPath');

                    if (photoPath == null) {
                      return;
                    }

                    // Upload image
                    final response = await ref
                        .read(controlActividadesProvider(trcId).notifier)
                        .uploadImage(photoPath, tarea.id);

                    if (response == null) {
                      return;
                    }
                    // Show snackbar response
                    CustomSnackbar.showResponseSnackbar(
                      response.message,
                      response.success,
                      // ignore: use_build_context_synchronously
                      context,
                    );
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
                    Icons.camera_alt_outlined,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ],
            ),
          ],
        ),

        _ComplicatedImageDemo(images: tarea.imagen ?? []),

        // _CarouselWithIndicatorDemo(images: tarea.imagen ?? []),
        // _ImageCarousel(images: tarea.imagen ?? []),
        // SizedBox(
        //   height: 250,
        //   width: 600,
        //   child: _ImageGallery(images: tarea.imagen ?? []),
        // ),

        // if (tarea.imagenes != null && tarea.imagenes!.isNotEmpty)
        //   ...tarea.imagenes!.map((image) {
        //     return Padding(
        //       padding: const EdgeInsets.symmetric(vertical: 8.0),
        //       child: Image.network(
        //         image.url,
        //         fit: BoxFit.cover,
        //         height: 150,
        //         width: double.infinity,
        //       ),
        //     );
        //   }).toList(),
        // if (tarea.imagenes == null || tarea.imagenes!.isEmpty)
        //   const Text('No hay imágenes para esta tarea'),
      ],
    );
  }
}

class _ImageCarousel extends StatelessWidget {
  final List<Imagen> images;
  const _ImageCarousel({required this.images});

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return Container();
      // ClipRRect(
      //   borderRadius: const BorderRadius.all(Radius.circular(20)),
      //   child: Image.asset('assets/images/no-image.jpg', fit: BoxFit.cover),
      // );
    }

    return CarouselSlider.builder(
      itemCount: images.length,
      itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
        final int first = itemIndex;
        final int? second = itemIndex < images.length - 1 ? first + 1 : null;
        return Row(
          children: [first, second].map((idx) {
            return idx != null
                ? Expanded(
                    flex: 1,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Image.network(
                        images[idx].imagen != null
                            ? '${Environment.apiUrl}/aerolineas/media/${images[itemIndex].imagen}'
                            : '',
                        fit: BoxFit.contain,
                        // height: 200,
                        // width: double.infinity,
                      ),
                    ),
                  )
                : Container();
          }).toList(),
        );
      },
      // Container(
      //   child: ClipRRect(
      //     borderRadius: const BorderRadius.all(Radius.circular(20)),
      //     child: FadeInImage(
      //       fit: BoxFit.cover,
      //       image: NetworkImage(
      //         images[itemIndex].imagen != null
      //             ? '${Environment.apiUrl}/aerolineas/media/${images[itemIndex].imagen}'
      //             : '',
      //       ),
      //       placeholder: const AssetImage('assets/images/no-image.jpg'),
      //       // images[itemIndex].imagen?.startsWith('http') == true
      //       //     ? NetworkImage(images[itemIndex].imagen ?? '')
      //       //     : FileImage(File(images[itemIndex].imagen ?? '')),
      //       // placeholder: const AssetImage(
      //       //   'assets/loaders/bottle-loader.gif',
      //       // ),
      //     ),
      //   ),
      // ),
      options: CarouselOptions(
        height: 240,
        aspectRatio: 16 / 9,
        viewportFraction: 0.8,
        initialPage: 0,
        enableInfiniteScroll: false,
        reverse: false,
        autoPlay: false,
        autoPlayInterval: Duration(seconds: 3),
        autoPlayAnimationDuration: Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        // enlargeCenterPage: true,
        // enlargeFactor: 0.3,
        // onPageChanged: callbackFunction,
        scrollDirection: Axis.horizontal,
      ),
    );

    //   return CarouselSlider(
    //     options: CarouselOptions(height: 250.0),
    //     items: images.map((i) {
    //       late ImageProvider imageProvider;
    //       if (i.imagen?.startsWith('http') == true) {
    //         imageProvider = NetworkImage(i.imagen ?? '');
    //       } else {
    //         imageProvider = FileImage(File(i.imagen ?? ''));
    //       }
    //       return Builder(
    //         builder: (BuildContext context) {
    //           return Container(
    //             width: MediaQuery.of(context).size.width,
    //             margin: EdgeInsets.symmetric(horizontal: 5.0),
    //             decoration: BoxDecoration(color: Colors.amber),
    //             child: Image(image: imageProvider, fit: BoxFit.cover),
    //           );
    //         },
    //       );
    //     }).toList(),
    //   );
  }
}

class _CarouselWithIndicatorDemo extends StatefulWidget {
  final List<Imagen> images;
  const _CarouselWithIndicatorDemo({super.key, required this.images});

  @override
  State<StatefulWidget> createState() {
    return _CarouselWithIndicatorState();
  }
}

class _CarouselWithIndicatorState extends State<_CarouselWithIndicatorDemo> {
  int _current = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    final images = widget.images;
    if (images.isEmpty) {
      return Container();
    }
    return Column(
      children: [
        CarouselSlider(
          items: images.map((img) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Image.network(
                img.imagen != null
                    ? '${Environment.apiUrl}/aerolineas/media/${img.imagen}'
                    : '',
                fit: BoxFit.contain,
              ),
            );
          }).toList(),
          carouselController: _controller,
          options: CarouselOptions(
            autoPlay: false,
            enlargeCenterPage: true,
            aspectRatio: 2.0,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: images.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _controller.animateToPage(entry.key),
              child: Container(
                width: 12.0,
                height: 12.0,
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      (Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black)
                          .withOpacity(_current == entry.key ? 0.9 : 0.4),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _ComplicatedImageDemo extends ConsumerWidget {
  final List<Imagen> images;
  const _ComplicatedImageDemo({super.key, required this.images});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (images.isEmpty) {
      return Container();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: CarouselSlider.builder(
        options: CarouselOptions(
          aspectRatio: 2.0,
          enlargeCenterPage: false,
          viewportFraction: 1,
          enableInfiniteScroll: false,
        ),
        itemCount: (images.length / 2).round(),
        itemBuilder: (context, index, realIdx) {
          final int first = index * 2;
          final int second = first + 1;
          return Row(
            children: [first, second].map((idx) {
              if (idx >= images.length) {
                return Container();
              }
              return Expanded(
                flex: 1,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    child: GestureDetector(
                      onTap: () {
                        // print("onItemTap");
                        // push with images list and id
                        // Navigator.pushNamed(context, '/asignar-personal');
                        // Set provider data
                        ref
                            .read(imagesListProvider.notifier)
                            .state = CustomFullscreenCarouselData(
                          imagenes: images,
                          index: idx,
                        );
                        // or use go_router
                        context.push('/image-fullscreen-carousel');

                        // close bottom sheet
                        // Navigator.pop(context);
                      },
                      child: Stack(
                        children: <Widget>[
                          Image.network(
                            '${Environment.apiUrl}/aerolineas/media/${images[idx].imagen}',
                            fit: BoxFit.cover,
                            width: 1000.0,
                          ),
                          Positioned(
                            bottom: 0.0,
                            left: 0.0,
                            right: 0.0,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color.fromARGB(200, 0, 0, 0),
                                    Color.fromARGB(0, 0, 0, 0),
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: 10.0,
                                horizontal: 20.0,
                              ),
                              child: Text(
                                // 'No. $idx ',
                                '${idx + 1}/${images.length}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

//                     )
// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     appBar: AppBar(title: Text('Complicated image slider demo')),
//     body: Container(
//       child: CarouselSlider(
//         options: CarouselOptions(
//           autoPlay: true,
//           aspectRatio: 2.0,
//           enlargeCenterPage: true,
//         ),
//         items: imageSliders,
//       ),
//     ),
//   );
// }

class _ImageGallery extends StatelessWidget {
  final List<Imagen> images;
  const _ImageGallery({required this.images});

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return Container();
      // ClipRRect(
      //   borderRadius: const BorderRadius.all(Radius.circular(20)),
      //   child: Image.asset('assets/images/no-image.jpg', fit: BoxFit.cover),
      // );
    }
    print('***********************************************************');
    // print('${Environment.apiUrl}/aerolineas/media/${images[0].imagen}');

    return PageView(
      scrollDirection: Axis.horizontal,
      controller: PageController(viewportFraction: 0.7),
      children: images.map((image) {
        late ImageProvider imageProvider;
        // if (image.imagen?.startsWith('http') == true) {
        //   imageProvider = NetworkImage(image.imagen ?? '');
        // } else {
        //   imageProvider = FileImage(File(image.imagen ?? ''));
        // }
        imageProvider = NetworkImage(
          image.imagen != null
              ? '${Environment.apiUrl}/aerolineas/media/${image.imagen}'
              : '',
        );

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            child: FadeInImage(
              fit: BoxFit.cover,
              image: imageProvider,
              placeholder: const AssetImage('assets/loaders/bottle-loader.gif'),
            ),
          ),
        );
      }).toList(),
    );
  }
}

void updateTareaImagenes(Tarea tarea, List<Imagen> imagenes) {}

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
