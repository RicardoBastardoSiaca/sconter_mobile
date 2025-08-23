import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
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
import '../widgets/widgets.dart';

// helpers

class ControlActividadesScreen extends ConsumerStatefulWidget {
  final int trcId;
  const ControlActividadesScreen({super.key, required this.trcId});

  @override
  ConsumerState<ControlActividadesScreen> createState() =>
      _ControlActividadesScreenState();
}

class _ControlActividadesScreenState
    extends ConsumerState<ControlActividadesScreen> {
  final key = GlobalKey<ExpandableFabState>();
  @override
  Widget build(BuildContext context) {
    final turnaround = ref.watch(selectedTurnaroundProvider);
    // Color
    final Color primaryColor = Theme.of(context).colorScheme.primary;

    final ControlActividades? controlActividades = ref
        .watch(controlActividadesProvider(widget.trcId))
        .controlActividades;

    return DefaultTabController(
      length: controlActividades?.departamentos?.length ?? 0,
      child: Scaffold(
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     // Add your menu button logic here
        //     print('Menu button pressed!');
        //   },
        //   child: Icon(Icons.menu),
        // ),
        floatingActionButtonLocation: ExpandableFab.location,
        floatingActionButton: ExpandableFab(
          // Change icon
          // child: const Icon(Icons.add, size: 40.0),
          //   openButton: FloatingActionButton(
          //   child: const Icon(Icons.add, size: 40.0), // Main FAB icon size
          //   onPressed: () {},
          // ),
          openButtonBuilder: RotateFloatingActionButtonBuilder(
            child: const Icon(Icons.add), // Your custom icon
            fabSize: ExpandableFabSize.regular,
            foregroundColor: Colors.white,
            backgroundColor: Colors.grey.shade500,
            shape: const CircleBorder(),
            angle: 3.14 * 2, // Rotate a full circle
            elevation: 10,
          ),
          closeButtonBuilder: RotateFloatingActionButtonBuilder(
            child: const Icon(Icons.close), // Your custom icon
            fabSize: ExpandableFabSize.small,
            foregroundColor: Colors.white,
            backgroundColor: Colors.grey.shade500,
            shape: const CircleBorder(),
            angle: 3.14 * 2, // Rotate a full circle
            elevation: 10,
          ),
          //   heroTag: null,
          //   // backgroundColor: primaryColor, // Main FAB icon size
          //   onPressed: openController,
          //   child: const Icon(Icons.add, size: 40.0),
          // ),
          // )
          key: key,
          type: ExpandableFabType.up,
          childrenAnimation: ExpandableFabAnimation.none,
          distance: 60,

          overlayStyle: ExpandableFabOverlayStyle(
            // color: Colors.black.withValues(alpha: 0.1),
            color: Colors.white.withValues(alpha: 0.8),
            blur: 5,
          ),
          onOpen: () {
            debugPrint('onOpen');
          },
          afterOpen: () {
            debugPrint('afterOpen');
          },
          onClose: () {
            debugPrint('onClose');
          },
          afterClose: () {
            debugPrint('afterClose');
          },
          // overlayStyle: ExpandableFabOverlayStyle(
          //   color: Colors.white.withOpacity(0.9),
          // ),
          children: [
            // SizedBox(height: 0.2),
            GestureDetector(
              onTap: () async {
                print('Firma del Supervisor pressed');

                await ref
                    .read(supervisorAerolineaProvider.notifier)
                    .getSupervisores();
                context.push('/firma-supervisor-screen');
              },
              child: Row(
                children: [
                  Text(
                    'Firma del Supervisor',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      // Rounded

                      // color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 20),
                  FloatingActionButton.small(
                    heroTag: null,
                    backgroundColor: primaryColor,
                    onPressed: () {
                      print('Firma del Supervisor pressed - BUTTON');
                      context.push('/firma-supervisor-screen');
                      // close bottom sheet
                      // Navigator.pop(context);
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Icon(Icons.edit, color: Colors.white),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () async {
                print('Demoras pressed');

                await ref
                    .read(demorasProvider.notifier)
                    .getDemorasByTrc(turnaround!.id);
                context.push('/demoras-screen');
              },
              child: Row(
                children: [
                  Text(
                    'Demoras',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      // color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 20),
                  FloatingActionButton.small(
                    heroTag: null,
                    backgroundColor: primaryColor,
                    onPressed: null,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Icon(Icons.schedule, color: Colors.white),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                print('Servicios adicionales pressed - ROW');
                context.push('/servicios-adicionales-screen');
              },
              child: Row(
                children: [
                  Text(
                    'Servicios Adicionales',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      // color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 20),
                  FloatingActionButton.small(
                    heroTag: null,
                    backgroundColor: primaryColor,
                    onPressed: () {
                      print('Servicios adicionales pressed - BUTTON');
                      context.push('/servicios-adicionales-screen');
                      // close bottom sheet
                      // Navigator.pop(context);
                    },

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Icon(Icons.agriculture, color: Colors.white),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                print('Servicios especiales pressed - ROW');
                context.push('/servicios-especiales-screen');
                // print('Servicios especiales pressed');
                // push servicios-especiales
                // context.pushNamed('servicios-especiales', extra: widget.trcId);
                // context.push('/servicios-especiales');
              },
              child: Row(
                children: [
                  Text(
                    'Servicios Especiales',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      // color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 20),
                  FloatingActionButton.small(
                    heroTag: null,
                    backgroundColor: primaryColor,
                    onPressed: () {
                      print('Servicios especiales pressed - ROW');
                      context.push('/servicios-especiales-screen');
                    },

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Icon(
                      Icons.add_moderator_outlined,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            // FloatingActionButton.small(
            //   heroTag: null,
            // backgroundColor: primaryColor,
            //   onPressed: null,
            //   child: Icon(Icons.add),
            // ),
          ],
        ),
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                backgroundColor: Colors.white,
                // expandedHeight: 100.0,
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
                                _CustomTabBarHeaderItem(title: dep.nombreArea),
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
            dragStartBehavior: DragStartBehavior.down,
            physics: const BouncingScrollPhysics(),
            children: controlActividades?.departamentos != null
                ? List<Widget>.generate(
                    controlActividades!.departamentos!.length,
                    (index) => _DepartamentosView(
                      controlActividades: controlActividades,
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

class _DepartamentosView extends StatefulWidget {
  final Departamento departamento;
  final int indexDep;
  final ControlActividades controlActividades;
  const _DepartamentosView({
    required this.controlActividades,
    required this.departamento,
    required this.indexDep,
  });

  @override
  State<_DepartamentosView> createState() => _DepartamentosViewState();
}

class _DepartamentosViewState extends State<_DepartamentosView> {
  @override
  Widget build(BuildContext context) {
    // scroll
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // SizedBox(height: 8),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    // icon button
                    IconButton(
                      icon: const Icon(Icons.expand_more),
                      onPressed: () {
                        setState(() {
                          for (
                            int i = 0;
                            i < widget.departamento.actividades.length;
                            i++
                          ) {
                            widget.departamento.actividades[i].isExpanded =
                                true;
                          }
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.expand_less),
                      onPressed: () {
                        setState(() {
                          for (
                            int i = 0;
                            i < widget.departamento.actividades.length;
                            i++
                          ) {
                            widget.departamento.actividades[i].isExpanded =
                                false;
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
              // Servicios Adicionales
              // Expanded(child: _ServiciosAdicionalesView(controlActividades: controlActividades)),
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: widget.departamento.actividades.length,
                  itemBuilder: (context, index) {
                    final actividad = widget.departamento.actividades[index];
                    return _ActividadView(
                      departamento: widget.departamento,
                      actividad: actividad,
                      indexAct: index,
                      indexDep: widget.indexDep,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActividadView extends StatefulWidget {
  final Actividades actividad;
  final int indexAct;
  final int indexDep;
  final Departamento departamento;

  const _ActividadView({
    required this.actividad,
    required this.indexDep,
    required this.indexAct,
    required this.departamento,
  });

  @override
  State<_ActividadView> createState() => _ActividadViewState();
}

class _ActividadViewState extends State<_ActividadView> {
  //  bool active = false;
  // bool isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          // Padding for the expansion panel
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: ExpansionPanelList(
              // elevation: 0,
              expandedHeaderPadding: EdgeInsets.zero,
              // expansionCallback: (int index, bool isExpanded) {
              //   isExpanded = !isExpanded;
              // },
              expansionCallback: (panelIndex, expanded) {
                widget.departamento.actividades[panelIndex].isExpanded =
                    !widget.departamento.actividades[panelIndex].isExpanded;
                setState(() {});
              },
              children: [
                ExpansionPanel(
                  isExpanded: widget.actividad.isExpanded,
                  canTapOnHeader: true,

                  // borderRadius: BorderRadius.circular(8),
                  backgroundColor: Colors.white,
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return ListTile(
                      title: Text(
                        '${widget.indexAct + 1}. ${widget.actividad.nombreActividad}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          // color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    );
                  },
                  // isExpanded: isExpanded
                  body: Column(
                    children: widget.actividad.tareas!.asMap().entries.map((
                      entry,
                    ) {
                      final indexTar = entry.key;
                      final tarea = entry.value;
                      return _TareaView(
                        actividad: widget.actividad,
                        tarea: tarea,
                        indexTar: indexTar,
                        indexAct: widget.indexAct,
                        indexDep: widget.indexDep,
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TareaView extends StatefulWidget {
  final Actividades actividad;
  final Tarea tarea;
  final int indexTar;
  final int indexAct;
  final int indexDep;

  const _TareaView({
    required this.actividad,
    required this.tarea,
    required this.indexTar,
    required this.indexAct,
    required this.indexDep,
  });

  @override
  State<_TareaView> createState() => _TareaViewState();
}

class _TareaViewState extends State<_TareaView> {
  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      // elevation: 0,
      expandedHeaderPadding: EdgeInsets.zero,
      expansionCallback: (index, isExpanded) {
        // isExpanded = !isExpanded;
        // widget.actividad.tareas?[index].isExpanded =
        // !widget.actividad.tareas![index].isExpanded;

        widget.tarea.isExpanded = !widget.tarea.isExpanded;
        setState(() {});
      },
      children: [
        ExpansionPanel(
          canTapOnHeader: true,
          isExpanded: widget.tarea.isExpanded,
          backgroundColor: Colors.white,
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              // set min height
              // minVerticalPadding: 40,
              title: Text(
                widget.tarea.titulo,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  // color: Theme.of(context).colorScheme.primary,
                ),
              ),
            );
          },
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                switch (widget.tarea.tipoId) {
                  2 => _TareaHoraView(tarea: widget.tarea),
                  3 => _TareaHoraInicioFinView(tarea: widget.tarea),
                  1 => _TareaCantidadView(tarea: widget.tarea),
                  4 => _TareaMaquinariaSinTiempoView(tarea: widget.tarea),
                  5 => _TareaMaquinariaConTiempoView(
                    tarea: widget.tarea,
                    indexTar: widget.indexTar,
                    indexAct: widget.indexAct,
                    indexDep: widget.indexDep,
                  ),
                  6 => _TareaTextoView(tarea: widget.tarea),
                  7 => _TareaPasajerosView(tarea: widget.tarea),
                  8 => _TareaExcesoEquipajeView(tarea: widget.tarea),
                  9 => _TareaITView(tarea: widget.tarea),
                  10 => _TareaLimpiezaView(tarea: widget.tarea),
                  // Default case
                  _ => _TareaHoraView(tarea: widget.tarea),
                },

                // Image list display
                _TareaImagenView(tarea: widget.tarea),

                _ComentarioView(tarea: widget.tarea),
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
              behavior: HitTestBehavior.translucent,
              onTap: () async {
                // print('Hora tapped');
                // Show time picker dialog
                final selectedTime =
                    await CustomTimePickerDialog.showTimePickerDialog(
                      context,
                      tarea.horaInicio ?? DateTime.now(),
                      tarea.horaInicio != null
                          ? TimeOfDay.fromDateTime(tarea.horaInicio!)
                          : null,
                    );
                // print('Selected time: $selectedTime');
                if (selectedTime != null) {
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
                    isFixed: true,
                  );
                }
              },
              child: SizedBox(
                // width: 100,
                child: Row(
                  children: [
                    Text(
                      'Hora:',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
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
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        (tarea.horaInicio != null
                                ? timeFormat.format(tarea.horaInicio!)
                                : '')
                            .toString(),
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
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
                        isFixed: true,
                      );
                      ref
                          .read(isLoadingControlActividadesProvider.notifier)
                          .update((state) => false);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(5),
                      // iconSize: 35,
                      fixedSize: const Size(45, 45),
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.primary, // <-- Button color
                      foregroundColor: Colors.red, // <-- Splash color
                    ),
                    child: Icon(
                      Icons.access_time,
                      color: Colors.white,
                      size: 35,
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
// Future<TimeOfDay?> showTimePickerDialog(
//   BuildContext context,
//   // WidgetRef ref,
//   DateTime hora,
//   TimeOfDay? initialTime,
// ) async {
//   final selectedTime = await showTimePicker(
//     confirmText: 'Seleccionar',
//     cancelText: 'Cancelar',
//     minuteLabelText: 'Minutos',
//     hourLabelText: 'Horas',
//     useRootNavigator: true,
//     initialEntryMode: TimePickerEntryMode.input,
//     helpText: 'Seleccionar hora',
//     context: context,
//     initialTime: initialTime != null
//         ? TimeOfDay.fromDateTime(hora)
//         : TimeOfDay.now(),
//   );
//   return selectedTime;
// }

// Future<TimeOfDay?> showTimePickerMaquinariasDialog(
//   BuildContext context,
//   // WidgetRef ref,
//   Maquinaria maquinaria,
//   TimeOfDay? initialTime,
// ) async {
//   final selectedTime = await showTimePicker(
//     confirmText: 'Seleccionar',
//     cancelText: 'Cancelar',
//     minuteLabelText: 'Minutos',
//     hourLabelText: 'Horas',
//     useRootNavigator: true,
//     initialEntryMode: TimePickerEntryMode.input,
//     helpText: 'Seleccionar hora',
//     context: context,
//     initialTime: initialTime != null
//         ? TimeOfDay.fromDateTime(maquinaria.horaInicio )
//         : TimeOfDay.now(),
//   );
//   return selectedTime;
// }

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
              behavior: HitTestBehavior.translucent,
              onTap: () async {
                print('Hora inicio tapped');
                // Show time picker dialog
                final selectedTime =
                    await CustomTimePickerDialog.showTimePickerDialog(
                      context,
                      // ref,
                      tarea.horaInicio ?? DateTime.now(),
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
                    isFixed: true,
                  );
                }
              },
              child: SizedBox(
                // width: 100,
                child: Row(
                  children: [
                    Text(
                      'Hora de inicio',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
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
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        (tarea.horaInicio != null
                                ? timeFormat.format(tarea.horaInicio!)
                                : '')
                            .toString(),
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
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
                        isFixed: true,
                      );
                      ref
                          .read(isLoadingControlActividadesProvider.notifier)
                          .update((state) => false);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(5),
                      fixedSize: const Size(45, 45),
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.primary, // <-- Button color
                      foregroundColor: Colors.red, // <-- Splash color
                    ),
                    child: Icon(
                      Icons.access_time,
                      color: Colors.white,
                      size: 35,
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
              behavior: HitTestBehavior.translucent,
              onTap: () async {
                // Show time picker dialog
                final selectedTime =
                    await CustomTimePickerDialog.showTimePickerDialog(
                      context,
                      tarea.horaFin ?? DateTime.now(),
                      tarea.horaFin != null
                          ? TimeOfDay.fromDateTime(tarea.horaFin!)
                          : null,
                    );
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
                    isFixed: true,
                  );
                }
              },
              child: SizedBox(
                // width: 100,
                child: Row(
                  children: [
                    Text(
                      'Hora final:',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
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
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        (tarea.horaFin != null
                                ? timeFormat.format(tarea.horaFin!)
                                : '')
                            .toString(),
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
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
                        isFixed: true,
                      );
                      ref
                          .read(isLoadingControlActividadesProvider.notifier)
                          .update((state) => false);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(5),
                      fixedSize: const Size(45, 45),
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.primary, // <-- Button color
                      foregroundColor: Colors.red, // <-- Splash color
                    ),
                    child: Icon(
                      Icons.access_time,
                      color: Colors.white,
                      size: 35,
                    ),
                  ),
          ],
        ),
      ],
    );
  }
}

// TODO: Tarea Cantidad
class _TareaCantidadView extends ConsumerWidget {
  final Tarea tarea;
  const _TareaCantidadView({required this.tarea});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController numberController = TextEditingController();
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  'Cantidad',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w400),
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
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      tarea.numero?.toString() ?? '',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Button to open dialog to set and submit cantidad
            ElevatedButton(
              // disable if isLoading
              onPressed:
                  (
                    // Open a dialog to write and submit the comment
                  ) async {
                    // set initial value in the text field controller
                    numberController.text = tarea.numero?.toString() ?? '';
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Colors.white,
                          title: Text('Cantidad'),
                          content: TextField(
                            controller: numberController,
                            keyboardType:
                                TextInputType.number, // Show numeric keyboard
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter
                                  .digitsOnly, // Allow only digits
                            ],

                            decoration: InputDecoration(
                              hintText: '123...',
                              border: null,
                              filled: true,
                              fillColor: Colors.grey[200],
                            ),
                          ),
                          actions: <Widget>[
                            FilledButton(
                              style: FilledButton.styleFrom(
                                // primary
                                backgroundColor: Colors.grey,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                numberController.clear();
                              },
                              child: Text(
                                'Salir',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            CustomFilledButton(
                              text: 'Guardar',
                              // buttonColor: Colors.green,
                              onPressed: () async {
                                final SetNumeroTareaRequest body =
                                    SetNumeroTareaRequest(
                                      id: tarea.id,
                                      numero: int.parse(numberController.text),
                                    );

                                print("Numero: ${body.numero}");

                                final trcId = ref
                                    .read(selectedTurnaroundProvider.notifier)
                                    .state!
                                    .id;
                                final response = await ref
                                    .read(
                                      controlActividadesProvider(
                                        trcId,
                                      ).notifier,
                                    )
                                    .setNumero(body);

                                // Show snackbar response
                                CustomSnackbar.showResponseSnackbar(
                                  response.message,
                                  response.success,
                                  // ignore: use_build_context_synchronously
                                  context,
                                  isFixed: true,
                                );

                                Navigator.pop(context);
                                numberController.clear();
                              },

                              // final trcId = ref
                              //     .read(selectedTurnaroundProvider.notifier)
                              //     .state!
                              //     .id;
                              // final response = await ref
                              //     .read(
                              //       controlActividadesProvider(
                              //         trcId,
                              //       ).notifier,
                              //     )
                              //     .setComentario(body);

                              // // Show snackbar response
                              // CustomSnackbar.showResponseSnackbar(
                              //   response.message,
                              //   response.success,
                              //   // ignore: use_build_context_synchronously
                              //   context,
                              // );

                              // Navigator.pop(context);
                              // textController.clear();
                            ),

                            // TextButton(
                            //   child: Text('Cancel'),
                            //   onPressed: () {
                            //     Navigator.of(context).pop(); // Close the dialog
                            //   },
                            // ),
                            // ElevatedButton(
                            //   child: Text('Submit'),
                            //   onPressed: () {
                            //     String submittedText = textController.text;
                            //     // Process the submitted text (e.g., save it, display it)
                            //     print('Submitted text: $submittedText');
                            //     Navigator.of(context).pop(); // Close the dialog
                            //     textController
                            //         .clear(); // Clear the text field after submission
                            //   },
                            // ),
                          ],
                        );
                      },
                    );
                  },
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                padding: EdgeInsets.all(5),
                fixedSize: const Size(45, 45),
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.primary, // <-- Button color
                foregroundColor: Colors.red, // <-- Splash color
              ),
              child: Icon(
                Icons.onetwothree_outlined,
                color: Colors.white,
                size: 35,
              ),
            ),
          ],
        ),
      ],
    );
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

class _TareaMaquinariaConTiempoView extends ConsumerWidget {
  final Tarea tarea;
  final int indexTar;
  final int indexDep;
  final int indexAct;

  const _TareaMaquinariaConTiempoView({
    required this.tarea,
    required this.indexTar,
    required this.indexDep,
    required this.indexAct,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        _TareaHoraInicioFinView(tarea: tarea),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Equipos GSE',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w400),
            ),
            ElevatedButton(
              // disable if isLoading
              // Aca mismo es
              onPressed: () async {
                ref.read(selectedTaskProvider.notifier).state = {
                  "indexDep": indexDep,
                  "indexAct": indexAct,
                  "indexTarea": indexTar,
                  "tareaId": tarea.id,
                };
                ref.read(selectedMaquinariasTaskProvider.notifier).state =
                    tarea.maquinaria ?? [];

                await ref
                    .read(categoriasEquiposGseProvider.notifier)
                    .getCategoriasEquiposGse();

                print("asignar equipos gse");
                context.push('/asignar-equipos-gse-control-actividades');

                // get control de actividades after close
                // await ref
                //     .read(controlDeActividadesProvider.notifier)
                //     .getControlDeActividadesByTrcId(trcId);
              },
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                padding: EdgeInsets.all(5),
                fixedSize: const Size(45, 45),
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.primary, // <-- Button color
                // foregroundColor: Colors.red, // <-- Splash color
              ),
              child: Icon(Icons.agriculture, color: Colors.white, size: 35),
            ),
          ],
        ),

        // Listado de maquinarias con hora de inicio y fin
        _ListadoMaquinariasConTiempoView(
          tarea: tarea,
          indexTar: indexTar,
          indexDep: indexDep,
          indexAct: indexAct,
        ),
      ],
    );
  }
}

class _ListadoMaquinariasConTiempoView extends ConsumerWidget {
  final int indexAct, indexDep, indexTar;
  final Tarea tarea;
  const _ListadoMaquinariasConTiempoView({
    required this.indexTar,
    required this.indexDep,
    required this.indexAct,
    required this.tarea,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timeFormat = DateFormat('HH:mm');
    bool isLoading = ref.watch(isLoadingControlActividadesProvider);
    return ListView.builder(
      shrinkWrap: true,
      itemCount: tarea.maquinaria?.length,
      itemBuilder: (context, index) {
        final maquinaria = tarea.maquinaria?[index];
        return Column(
          children: [
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '${maquinaria?['maquinaria_identificador']} - ${maquinaria?['maquinaria_modelo']}',

                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),

            // ******************************************
            // Hora de inicio Maquinaria
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // ifLoading
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () async {
                      print('Hora inicio tapped');
                      // Show time picker dialog
                      final selectedTime =
                          await CustomTimePickerDialog.showTimePickerDialog(
                            context,
                            maquinaria["hora_inicio"] ?? DateTime.now(),
                            maquinaria["hora_inicio"] != null
                                ? TimeOfDay.fromDateTime(maquinaria.horaInicio)
                                : null,
                          );
                      print('Selected time: $selectedTime');
                      if (selectedTime != null) {
                        var trcDate = ref
                            .read(selectedTurnaroundProvider.notifier)
                            .state
                            ?.fechaInicio;
                        final body = HoraInicioFinMaquinaria(
                          // ignore: use_build_context_synchronously
                          horaInicio:
                              CustomDateTimeFunctions.getDateTimeFromTimeOfDay(
                                trcDate,
                                selectedTime,
                              ),
                          horaFin: null,
                          id: maquinaria['id'],
                          tareaId: tarea.id,
                          tipo: 'Hora de Inicio',
                        );
                        final trcId = ref.read(trcIdProvider);
                        final response = await ref
                            .read(controlActividadesProvider(trcId).notifier)
                            .setHoraInicioFinMaquinaria(body);

                        // Show snackbar response
                        CustomSnackbar.showResponseSnackbar(
                          response.message,
                          response.success,
                          // ignore: use_build_context_synchronously
                          context,
                          isFixed: true,
                        );
                      }
                    },
                    child: SizedBox(
                      // width: 100,
                      child: Row(
                        children: [
                          Text(
                            'Hora de inicio',
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(fontWeight: FontWeight.w400),
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
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              (maquinaria['hora_inicio'] != null
                                      ? timeFormat.format(
                                          DateTime.parse(
                                            maquinaria['hora_inicio'],
                                          ),
                                        )
                                      : '')
                                  .toString(),
                              style: Theme.of(context).textTheme.titleSmall
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
                                .read(
                                  isLoadingControlActividadesProvider.notifier,
                                )
                                .update((state) => true);
                            // wait 3 seconds
                            // await Future.delayed(const Duration(seconds: 3));

                            final HoraInicioFinMaquinaria body =
                                HoraInicioFinMaquinaria(
                                  horaInicio: DateTime.now(),
                                  horaFin: null,
                                  id: maquinaria['id'],
                                  tareaId: tarea.id,
                                  tipo: 'Hora de Inicio',
                                );

                            final trcId = ref.read(trcIdProvider);
                            final response = await ref
                                .read(
                                  controlActividadesProvider(trcId).notifier,
                                )
                                .setHoraInicioFinMaquinaria(body);
                            // Show snackbar response
                            CustomSnackbar.showResponseSnackbar(
                              response.message,
                              response.success,
                              // ignore: use_build_context_synchronously
                              context,
                              isFixed: true,
                            );

                            ref
                                .read(
                                  isLoadingControlActividadesProvider.notifier,
                                )
                                .update((state) => false);
                          },
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                            padding: EdgeInsets.all(5),
                            fixedSize: const Size(45, 45),
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.primary, // <-- Button color
                            foregroundColor: Colors.red, // <-- Splash color
                          ),
                          child: Icon(
                            Icons.access_time,
                            color: Colors.white,
                            size: 35,
                          ),
                        ),
                ],
              ),
            ),

            // Hora final Maquinaria
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // ifLoading
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () async {
                      // Show time picker dialog
                      final selectedTime =
                          await CustomTimePickerDialog.showTimePickerDialog(
                            context,
                            maquinaria['hora_inicio'] ?? DateTime.now(),
                            maquinaria['hora_inicio'] != null
                                ? TimeOfDay.fromDateTime(maquinaria['hora_fin'])
                                : null,
                          );
                      print('Selected time: $selectedTime');
                      if (selectedTime != null) {
                        var trcDate = ref
                            .read(selectedTurnaroundProvider.notifier)
                            .state
                            ?.fechaInicio;
                        final HoraInicioFinMaquinaria
                        body = HoraInicioFinMaquinaria(
                          id: maquinaria['id'],
                          horaInicio: null,
                          // ignore: use_build_context_synchronously
                          horaFin:
                              CustomDateTimeFunctions.getDateTimeFromTimeOfDay(
                                trcDate,
                                selectedTime,
                              ),
                          tareaId: tarea.id,
                          tipo: 'Hora final',
                        );
                        final trcId = ref.read(trcIdProvider);
                        final response = await ref
                            .read(controlActividadesProvider(trcId).notifier)
                            .setHoraInicioFinMaquinaria(body);

                        // Show snackbar response
                        CustomSnackbar.showResponseSnackbar(
                          response.message,
                          response.success,
                          // ignore: use_build_context_synchronously
                          context,
                          isFixed: true,
                        );
                      }
                    },
                    child: SizedBox(
                      // width: 100,
                      child: Row(
                        children: [
                          Text(
                            'Hora final',
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(fontWeight: FontWeight.w400),
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
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              (maquinaria['hora_fin'] != null
                                      ? timeFormat.format(
                                          DateTime.parse(
                                            maquinaria['hora_fin'],
                                          ),
                                        )
                                      : '')
                                  .toString(),
                              style: Theme.of(context).textTheme.titleSmall
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
                                .read(
                                  isLoadingControlActividadesProvider.notifier,
                                )
                                .update((state) => true);
                            // wait 3 seconds
                            // await Future.delayed(const Duration(seconds: 3));

                            final body = HoraInicioFinMaquinaria(
                              horaInicio: null,
                              // horaInicio: TimeOfDay.now().format(context),
                              horaFin: DateTime.now(),
                              id: maquinaria['id'],
                              tareaId: tarea.id,
                              tipo: 'Hora final',
                            );

                            final trcId = ref.read(trcIdProvider);
                            final response = await ref
                                .read(
                                  controlActividadesProvider(trcId).notifier,
                                )
                                .setHoraInicioFinMaquinaria(body);
                            // Show snackbar response
                            CustomSnackbar.showResponseSnackbar(
                              response.message,
                              response.success,
                              // ignore: use_build_context_synchronously
                              context,
                              isFixed: true,
                            );

                            // final response = await setHoraInicio(
                            //   ref,
                            //   tarea.id,
                            //   DateTime.now(),
                            //   'Hora de Inicio',
                            // );
                            // CustomSnackbar.showResponseSnackbar(
                            //   response.message,
                            //   response.success,
                            //   // ignore: use_build_context_synchronously
                            //   context,
                            // );
                            ref
                                .read(
                                  isLoadingControlActividadesProvider.notifier,
                                )
                                .update((state) => false);
                          },
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                            padding: EdgeInsets.all(5),
                            fixedSize: const Size(45, 45),
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.primary, // <-- Button color
                            foregroundColor: Colors.red, // <-- Splash color
                          ),
                          child: Icon(
                            Icons.access_time,
                            color: Colors.white,
                            size: 35,
                          ),
                        ),
                ],
              ),
            ),

            // ******************************************
          ],
        );
      },
    );
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

class _TareaPasajerosView extends ConsumerWidget {
  final Tarea tarea;
  const _TareaPasajerosView({required this.tarea});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final turnaround = ref.watch(selectedTurnaroundProvider);

    return GestureDetector(
      onTap: () async {
        // Open pasajeros dialog
        // Set the initial values of the form fields in the provider
        // sets state to initial values

        ref.read(pasajerosFormProvider.notifier).setInitialValues(tarea);

        // print(ref.read(pasajerosFormProvider));
        // get pasajerosFormProvider state

        showDialog(
          // useRootNavigator: false, // to remove the dialog from the stack
          context: context,
          builder: (BuildContext context) {
            // ref.read(pasajerosFormProvider.notifier).setInitialValues(tarea);

            return PasajerosDialog(tarea: tarea);
          },
        );
      },

      child: Column(
        children: [
          if (turnaround?.fkVuelo.tipoServicio.id != 3)
            // Llegada
            _LlegadaPasajerosView(tarea: tarea),

          const Divider(thickness: 1),

          if (turnaround?.fkVuelo.tipoServicio.id != 4)
            // Salida
            _SalidaPasajeroView(tarea: tarea),

          if (turnaround?.fkVuelo.tipoServicio.id != 4)
            // Transito
            _TransitoPasajerosView(tarea: tarea),

          if (turnaround?.fkVuelo.tipoServicio.id != 4)
            // Inadmitidos
            _InadmitidosPasajerosView(tarea: tarea),

          if (turnaround?.fkVuelo.tipoServicio.id != 4)
            const Divider(thickness: 1),

          if (turnaround?.fkVuelo.tipoServicio.id != 4)
            // total
            _TotalPasajerosView(tarea: tarea),

          SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _TotalPasajerosView extends StatelessWidget {
  const _TotalPasajerosView({required this.tarea});

  final Tarea tarea;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // half width
        Flexible(flex: 3, child: Text('Total:')),
        Flexible(
          flex: 6,
          child: Row(
            children: [
              Expanded(
                child: PasajerosBoxContainer(
                  clase: 'C',
                  // total pasajeros = salida + transito - inadmitidos
                  cantidad:
                      tarea.pasajeros!['salida_ejecutivo']! +
                      tarea.pasajeros!['transito_ejecutivo']! -
                      tarea.pasajeros!['inadmitidos_ejecutivo']!,
                ),
              ),
              Expanded(
                child: PasajerosBoxContainer(
                  clase: 'Y',
                  cantidad:
                      tarea.pasajeros!['salida_economica']! +
                      tarea.pasajeros!['transito_economica']! -
                      tarea.pasajeros!['inadmitidos_economica']!,
                ),
              ),
              Expanded(
                child: PasajerosBoxContainer(
                  clase: 'I',
                  cantidad:
                      tarea.pasajeros!['salida_infante']! +
                      tarea.pasajeros!['transito_infante']! -
                      tarea.pasajeros!['inadmitidos_infante']!,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LlegadaPasajerosView extends StatelessWidget {
  const _LlegadaPasajerosView({required this.tarea});

  final Tarea tarea;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // half width
        Flexible(flex: 3, child: Text('Llegada:')),
        Flexible(
          flex: 6,
          child: Row(
            children: [
              Expanded(
                child: PasajerosBoxContainer(
                  clase: 'C',
                  cantidad: tarea.pasajeros!['llegada_ejecutivo']!,
                ),
              ),
              Expanded(
                child: PasajerosBoxContainer(
                  clase: 'Y',
                  cantidad: tarea.pasajeros!['llegada_economica']!,
                ),
              ),
              Expanded(
                child: PasajerosBoxContainer(
                  clase: 'I',
                  cantidad: tarea.pasajeros!['llegada_infante']!,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InadmitidosPasajerosView extends StatelessWidget {
  const _InadmitidosPasajerosView({required this.tarea});

  final Tarea tarea;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // half width
        Flexible(flex: 3, child: Text('Inadmitidos:')),
        Flexible(
          flex: 6,
          child: Row(
            children: [
              Expanded(
                child: PasajerosBoxContainer(
                  clase: 'C',
                  cantidad: tarea.pasajeros!['inadmitidos_ejecutivo']!,
                ),
              ),
              Expanded(
                child: PasajerosBoxContainer(
                  clase: 'Y',
                  cantidad: tarea.pasajeros!['inadmitidos_economica']!,
                ),
              ),
              Expanded(
                child: PasajerosBoxContainer(
                  clase: 'I',
                  cantidad: tarea.pasajeros!['inadmitidos_infante']!,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TransitoPasajerosView extends StatelessWidget {
  const _TransitoPasajerosView({required this.tarea});

  final Tarea tarea;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // half width
        Flexible(flex: 3, child: Text('Transito:')),
        Flexible(
          flex: 6,
          child: Row(
            children: [
              Expanded(
                child: PasajerosBoxContainer(
                  clase: 'C',
                  cantidad: tarea.pasajeros!['transito_ejecutivo']!,
                ),
              ),
              Expanded(
                child: PasajerosBoxContainer(
                  clase: 'Y',
                  cantidad: tarea.pasajeros!['transito_economica']!,
                ),
              ),
              Expanded(
                child: PasajerosBoxContainer(
                  clase: 'I',
                  cantidad: tarea.pasajeros!['transito_infante']!,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SalidaPasajeroView extends StatelessWidget {
  const _SalidaPasajeroView({required this.tarea});

  final Tarea tarea;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // half width
        Flexible(flex: 3, child: Text('Salida:')),
        Flexible(
          flex: 6,
          child: Row(
            children: [
              Expanded(
                child: PasajerosBoxContainer(
                  clase: 'C',
                  cantidad: tarea.pasajeros!['salida_ejecutivo']!,
                ),
              ),
              Expanded(
                child: PasajerosBoxContainer(
                  clase: 'Y',
                  cantidad: tarea.pasajeros!['salida_economica']!,
                ),
              ),
              Expanded(
                child: PasajerosBoxContainer(
                  clase: 'I',
                  cantidad: tarea.pasajeros!['salida_infante']!,
                ),
              ),
            ],
          ),
        ),
      ],
    );
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
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w400),
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
                      isFixed: true,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(5),
                    fixedSize: const Size(45, 45),
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.primary, // <-- Button color
                    foregroundColor: Colors.red, // <-- Splash color
                  ),
                  child: Icon(
                    Icons.photo_library_outlined,
                    color: Colors.white,
                    size: 35,
                  ),
                ),
                ElevatedButton(
                  // disable if isLoading
                  onPressed: () async {
                    final photoPath = await CameraGalleryServiceImpl()
                        .takePhoto();

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
                      isFixed: true,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(5),
                    fixedSize: const Size(45, 45),
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.primary, // <-- Button color
                    foregroundColor: Colors.red, // <-- Splash color
                  ),
                  child: Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.white,
                    size: 35,
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

class _ComentarioView extends ConsumerWidget {
  final Tarea tarea;
  const _ComentarioView({required this.tarea});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextEditingController textController = TextEditingController();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Comentarios:',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w400),
            ),
            ElevatedButton(
              // disable if isLoading
              onPressed:
                  (
                    // Open a dialog to write and submit the comment
                  ) async {
                    // set value of tarea.comentario to textController
                    textController.text = tarea.comentario ?? '';

                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Colors.white,
                          title: Text('Comentario'),
                          content: TextField(
                            controller: textController,
                            maxLines: null, // Allows for multiline input
                            minLines: 3,
                            keyboardType: TextInputType
                                .multiline, // Optimizes keyboard for multiline text

                            decoration: InputDecoration(
                              hintText: 'Escriba su comentario...',
                              border: null,
                              filled: true,
                              fillColor: Colors.grey[200],
                            ),
                          ),
                          actions: <Widget>[
                            FilledButton(
                              style: FilledButton.styleFrom(
                                // primary
                                backgroundColor: Colors.grey,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                textController.clear();
                              },
                              child: Text(
                                'Salir',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            CustomFilledButton(
                              text: 'Guardar',
                              // buttonColor: Colors.green,
                              onPressed: () async {
                                final ComentarioRequest body =
                                    ComentarioRequest(
                                      id: tarea.id,
                                      comentario: textController.text,
                                    );

                                print("Comentario: ${body.comentario}");
                                final trcId = ref
                                    .read(selectedTurnaroundProvider.notifier)
                                    .state!
                                    .id;
                                final response = await ref
                                    .read(
                                      controlActividadesProvider(
                                        trcId,
                                      ).notifier,
                                    )
                                    .setComentario(body);

                                // Show snackbar response
                                CustomSnackbar.showResponseSnackbar(
                                  response.message,
                                  response.success,
                                  // ignore: use_build_context_synchronously
                                  context,
                                  isFixed: true,
                                );

                                Navigator.pop(context);
                                textController.clear();
                              },
                            ),

                            // TextButton(
                            //   child: Text('Cancel'),
                            //   onPressed: () {
                            //     Navigator.of(context).pop(); // Close the dialog
                            //   },
                            // ),
                            // ElevatedButton(
                            //   child: Text('Submit'),
                            //   onPressed: () {
                            //     String submittedText = textController.text;
                            //     // Process the submitted text (e.g., save it, display it)
                            //     print('Submitted text: $submittedText');
                            //     Navigator.of(context).pop(); // Close the dialog
                            //     textController
                            //         .clear(); // Clear the text field after submission
                            //   },
                            // ),
                          ],
                        );
                      },
                    );
                  },
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                padding: EdgeInsets.all(5),
                fixedSize: const Size(45, 45),
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.primary, // <-- Button color
                foregroundColor: Colors.red, // <-- Splash color
              ),
              child: Icon(Icons.edit_note, color: Colors.white, size: 35),
            ),
          ],
        ),
        // Grey container to display the comment
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(tarea.comentario ?? ''),
        ),
        // Text(tarea.comentario ?? ''),
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
  const _CarouselWithIndicatorDemo({required this.images});

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
              behavior: HitTestBehavior.translucent,
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
  const _ComplicatedImageDemo({required this.images});

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
                      behavior: HitTestBehavior.translucent,
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

class _CustomTabBarHeaderItem extends StatelessWidget {
  final String title;
  const _CustomTabBarHeaderItem({required this.title});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Text(
        title,
        style: GoogleFonts.openSans().copyWith(
          fontWeight: FontWeight.w800,
          fontSize: 20,
        ),
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

// getDateTimeFromTimeOfDay(String date, TimeOfDay time) {
//   DateTime parsedDate = DateFormat('yyyy-MM-dd').parse(date);
//   return DateTime(
//     parsedDate.year,
//     parsedDate.month,
//     parsedDate.day,
//     time.hour,
//     time.minute,
//   );
// }
