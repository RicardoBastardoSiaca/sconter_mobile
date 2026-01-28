import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:turnaround_mobile/features/auth/domain/domain.dart';
import 'package:turnaround_mobile/features/auth/presentation/providers/providers.dart';
import 'package:turnaround_mobile/features/shared/shared.dart';
import 'package:turnaround_mobile/features/turnarounds/domain/domain.dart';
import 'package:turnaround_mobile/features/turnarounds/presentation/providers/providers.dart';

// import '../../../shared/shared.dart';
// import '../../domain/domain.dart';
// import '../providers/providers.dart';

// consumer statefull widget
class ControlActividadesServiciosMiscelaneosScreen
    extends ConsumerStatefulWidget {
  final int trcId;
  const ControlActividadesServiciosMiscelaneosScreen({
    super.key,
    required this.trcId,
  });

  @override
  ConsumerState<ControlActividadesServiciosMiscelaneosScreen> createState() =>
      _ControlActividadesServiciosMiscelaneosState();
}

class _ControlActividadesServiciosMiscelaneosState
    extends ConsumerState<ControlActividadesServiciosMiscelaneosScreen> {
  final key = GlobalKey<ExpandableFabState>();
  @override
  Widget build(BuildContext context) {
    final turnaround = ref.watch(selectedTurnaroundProvider);
    // Color
    final Color primaryColor = Theme.of(context).colorScheme.primary;

    final ControlActividades? controlActividades = ref
        .watch(controlActividadesProvider(widget.trcId))
        .controlActividades;

    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(onPressed: () {}, icon: Icon(Icons.ac_unit)),
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
        actions: [SizedBox(width: 60)],
      ),
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
          // if (turnaround?.estatus == 2)
          //   GestureDetector(
          //     onTap: () async {
          //       print('Firma del Supervisor pressed');

          //       await ref
          //           .read(supervisorAerolineaProvider.notifier)
          //           .getSupervisores();
          //       context.push('/firma-supervisor-screen');
          //     },
          //     child: Row(
          //       children: [
          //         Text(
          //           'Firma del Supervisor',
          //           style: Theme.of(context).textTheme.titleMedium?.copyWith(
          //             fontWeight: FontWeight.w600,
          //             // Rounded

          //             // color: Colors.white,
          //           ),
          //         ),
          //         SizedBox(width: 20),
          //         FloatingActionButton.small(
          //           heroTag: null,
          //           backgroundColor: primaryColor,
          //           onPressed: () {
          //             print('Firma del Supervisor pressed - BUTTON');
          //             context.push('/firma-supervisor-screen');
          //             // close bottom sheet
          //             // Navigator.pop(context);
          //           },
          //           shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.circular(50),
          //           ),
          //           child: Icon(Icons.edit, color: Colors.white),
          //         ),
          //       ],
          //     ),
          //   ),

          // Finalizar Turnaround if status < 2
          if (turnaround != null && turnaround.estatus < 3)
            GestureDetector(
              onTap: () async {
                // Rol Check
                if (!ref.read(authProvider).loginResponse!.hasPermission( Roles.cerrarOperacionesMiscelaneos) ) {
                  showCustomErrorSnackbar(  context, 'No tienes permiso para realizar esta accion.');
                  return;
                }
                print('Finalizar Turnaround pressed');

                bool respuesta = await ConfirmarDialog.mostrar(
                  context,
                  mensaje: "¿Desea finalizar el vuelo?",
                );

                if (respuesta) {
                  print("El usuario dijo: SI");
                  // Ejecuta aquí tu lógica de éxito
                  final response = await ref
                      .read(turnaroundProvider.notifier)
                      .finalizarVueloServicioMiscelaneo(turnaround.id);

                  // Custom snackbar to show message
                  if (response.success) {
                    if (context.mounted) {
                      CustomSnackbar.showSuccessSnackbar(response.message, context, );
                      Navigator.of(context).pop(); // Close the screen after successful closure
                      
                    }
                  } else {
                    if (context.mounted) {
                      CustomSnackbar.showErrorSnackbar('Error: ${response.message}', context);
                    }
                  }
                } else {
                  print("El usuario dijo: NO");
                }
              },
              child: Row(
                children: [
                  Text(
                    'Finalizar vuelo',
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
                      print('Finalizar Turnaround pressed - BUTTON');
                      context.push('/finalizar-turnaround-screen');
                      // close bottom sheet
                      // Navigator.pop(context);
                    },

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Icon(Icons.check_circle, color: Colors.white),
                  ),
                ],
              ),
            ),

          if (turnaround?.estatus == 2 ||
              turnaround?.estatus == 3 ||
              turnaround?.estatus == 7)
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
          if (turnaround?.estatus == 2 ||
              turnaround?.estatus == 3 ||
              turnaround?.estatus == 7)
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
          if (turnaround?.estatus == 2 ||
              turnaround?.estatus == 3 ||
              turnaround?.estatus == 7)
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

      body: _mainView(),
    );
  }
}

class _mainView extends ConsumerWidget {
  const _mainView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center, // title
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Agregar servicio adicional:',
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  ElevatedButton(
                    // disable if isLoading
                    onPressed: () async {

                      // Rol Check
                      if (!ref.read(authProvider).loginResponse!.hasPermission( Roles.agregarServiciosAdicionalesMiscelaneos) ) {
                        showCustomErrorSnackbar(  context, 'No tienes permiso para realizar esta accion.');
                        return;
                      }
                      // Get Servicios Adicionales
                      await ref
                          .read(serviciosAdicionalesProvider.notifier)
                          .getServiciosAdicionales();
                      // if (response == null) return;
                      print("asignar equipos gse");
                      context.push(
                        '/asignar-equipos-gse-servicios-adicionales-especiales',
                      );
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
                    child: Icon(Icons.add, color: Colors.white, size: 35),
                  ),
                ],
              ),

              // ListadoServicioAdicional
              const SizedBox(height: 8),

              if (ref.read(isLoadingControlActividadesProvider))
                Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                )
              else
                _ListadoServiciosAdicionales(
                  trcId: ref.read(selectedTurnaroundProvider)!.id,
                ),

              // const SizedBox(height: 8),
              Divider(color: Colors.grey.shade400, thickness: 1),

              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Agregar servicio especial:',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  ElevatedButton(
                    // disable if isLoading
                    onPressed: () async {

                      // Rol Check
                      if (!ref.read(authProvider).loginResponse!.hasPermission( Roles.agregarServiciosEspecialesMiscelaneos) ) {
                        showCustomErrorSnackbar(  context, 'No tienes permiso para realizar esta accion.');
                        return;
                      }
                      
                      // TODO: passing selected servicios Especiales
                      // ref.read(selectedMaquinariasTaskProvider.notifier).state =
                      //     controlActividades?.serviciosEspeciales ?? [];
                      // tarea.maquinaria ?? [];

                      // await ref
                      //     .read(categoriasEquiposGseProvider.notifier)
                      //     .getCategoriasEquiposGse();

                      // Get Servicios Especiales
                      await ref
                          .read(serviciosAdicionalesProvider.notifier)
                          .getServiciosEspeciales();
                      // if (response == null) return;
                      print("asignar equipos gse");
                      // context.push('/asignar-servicios-especiales-turnaround');
                      context.push('/asignar-servicios-especiales-screen').then(
                        (_) async {
                          // get control de actividades after close
                          await ref
                              .read(
                                controlActividadesProvider(
                                  ref.read(selectedTurnaroundProvider)!.id,
                                ).notifier,
                              )
                              .getControlDeActividadesServicioMiscelaneoById();
                        },
                      );

                      // get control de actividades after close
                      // await ref
                      //     .read(controlDeActividadesProvider.notifier)
                      //     .getControlDeActividadesServicioMiscelaneoById(trcId);
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
                    child: Icon(Icons.add, color: Colors.white, size: 35),
                  ),
                ],
              ),

              if (ref.read(isLoadingControlActividadesProvider))
                Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                )
              else
                // const SizedBox(height: 8),
                // ListadoServicioEspecial
                _ListadoServiciosEspeciales(
                  trcId: ref.read(selectedTurnaroundProvider)!.id,
                ),

              // Bottom space
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}

class _ListadoServiciosEspeciales extends ConsumerWidget {
  final int trcId;
  const _ListadoServiciosEspeciales({required this.trcId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ControlActividades? controlActividades = ref
        .watch(controlActividadesProvider(trcId))
        .controlActividades;
    final serviciosEspeciales = controlActividades?.serviciosEspeciales;
    final timeFormat = DateFormat('HH:mm');
    bool isLoading = ref.watch(isLoadingControlActividadesProvider);
    print('Servicios Especiales: $serviciosEspeciales');
    if (serviciosEspeciales == null || serviciosEspeciales.isEmpty) {
      return Text(
        'No hay servicios especiales.',
        // style: Theme.of(context).textTheme.titleMedium,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w400),
      );
    }
    return Column(
      children: serviciosEspeciales.map((servicioEspecial) {
        // final servicioEspecial = serviciosEspeciales![index];

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  servicioEspecial.titulo,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                ),
                // Text(
                //   // servicioEspecial.descripcion,
                //   " - Descripcion de servicio especial",
                //   style: Theme.of(context).textTheme.labelMedium?.copyWith(
                //     fontWeight: FontWeight.w400,
                //   ),
                // ),
              ],
            ),

            servicioEspecial.tipoId != 1
                ? _HoraInicioServicioEspecialView(servicio: servicioEspecial)
                : const SizedBox.shrink(),
            servicioEspecial.tipoId != 1
                ? _HoraFinServicioEspecialView(servicio: servicioEspecial)
                : const SizedBox.shrink(),

            const SizedBox(height: 15),
            // Cantidad
            servicioEspecial.tipoId == 1
                ? _CantidadServicioEspecialView(servicio: servicioEspecial)
                : const SizedBox.shrink(),

            // Comentarios
            _ComentarioViewServiciosEspeciales(
              servicioEspecial: servicioEspecial,
            ),

            const SizedBox(height: 20),

            // Row(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   children: [
            //     Text(
            //       servicioEspecial.titulo,
            //       style: Theme.of(
            //         context,
            //       ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
            //     ),
            //   ],
            // ),
          ],
        );
      }).toList(),
    );

    // ListView.builder(
    //   shrinkWrap: true,
    //   itemCount: serviciosEspeciales?.length,
    //   itemBuilder: (context, index) {
    //     final servicioEspecial = serviciosEspeciales![index];

    //     return Column(
    //       children: [
    //         Row(
    //           mainAxisAlignment: MainAxisAlignment.start,
    //           children: [
    //             Text(
    //               servicioEspecial.titulo,
    //               style: Theme.of(
    //                 context,
    //               ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
    //             ),
    //             Text(
    //               // servicioEspecial.descripcion,
    //               " - Descripcion de servicio especial",
    //               style: Theme.of(context).textTheme.labelMedium?.copyWith(
    //                 fontWeight: FontWeight.w400,
    //               ),
    //             ),
    //           ],
    //         ),

    //         servicioEspecial.tipoId != 1
    //             ? _HoraInicioServicioEspecialView(servicio: servicioEspecial)
    //             : const SizedBox.shrink(),
    //         servicioEspecial.tipoId != 1
    //             ? _HoraFinServicioEspecialView(servicio: servicioEspecial)
    //             : const SizedBox.shrink(),

    //         const SizedBox(height: 15),
    //         // Cantidad
    //         servicioEspecial.tipoId == 1
    //             ? _CantidadServicioEspecialView(servicio: servicioEspecial)
    //             : const SizedBox.shrink(),

    //         // Comentarios
    //         _ComentarioViewServiciosEspeciales(
    //           servicioEspecial: servicioEspecial,
    //         ),

    //         const SizedBox(height: 20),

    //         // Row(
    //         //   mainAxisAlignment: MainAxisAlignment.start,
    //         //   children: [
    //         //     Text(
    //         //       servicioEspecial.titulo,
    //         //       style: Theme.of(
    //         //         context,
    //         //       ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
    //         //     ),
    //         //   ],
    //         // ),
    //       ],
    //     );
    //   },
    // );
  }
}

class _ComentarioViewServiciosEspeciales extends ConsumerWidget {
  const _ComentarioViewServiciosEspeciales({required this.servicioEspecial});

  final ServiciosAle servicioEspecial;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextEditingController textController = TextEditingController();
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Comentarios',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w400),
            ),

            ElevatedButton(
              // disable if isLoading
              onPressed:() async {

                // Rol Check
                if (!ref.read(authProvider).loginResponse!.hasPermission( Roles.modificarControlDeActividadesMiscelaneos) ) {
                  showCustomErrorSnackbar(  context, 'No tienes permiso para realizar esta accion.');
                  return;
                }
                    // Open a dialog to write and submit the comment
                    // set value of tarea.comentario to textController
                    textController.text = servicioEspecial.comentario ?? '';

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
                                final ComentarioServiciosAdicionalRequest body =
                                    ComentarioServiciosAdicionalRequest(
                                      id: servicioEspecial.id,
                                      comentario: textController.text,
                                      esServicioAdicional: false,
                                    );

                                print("Comentario: ${body.comentario}");

                                // Call the API to update the comment
                                final response = await ref
                                    .read(serviciosAdicionalesProvider.notifier)
                                    .setComentarioServicioAdicional(body);

                                // Show snackbar response
                                CustomSnackbar.showResponseSnackbar(
                                  response.message,
                                  response.success,
                                  // ignore: use_build_context_synchronously
                                  context,
                                  isFixed: true,
                                );

                                // getControlDeActividadesServicioMiscelaneoById(); from control actividades provider
                                ref
                                    .read(
                                      controlActividadesProvider(
                                        ref
                                            .read(
                                              selectedTurnaroundProvider
                                                  .notifier,
                                            )
                                            .state!
                                            .id,
                                      ).notifier,
                                    )
                                    .getControlDeActividadesServicioMiscelaneoById();

                                Navigator.pop(context);
                                textController.clear();
                              },
                            ),
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

        //  Grey container to display the comment
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(servicioEspecial.comentario ?? ''),
        ),
      ],
    );
  }
}

class _CantidadServicioEspecialView extends ConsumerWidget {
  final ServiciosAle servicio;
  const _CantidadServicioEspecialView({required this.servicio});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isLoading = ref.watch(isLoadingControlActividadesProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Text('Cantidad: '),
        // Text(servicio.cantidad.toString()),
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () async {

            // Rol Check
                if (!ref.read(authProvider).loginResponse!.hasPermission( Roles.modificarControlDeActividadesMiscelaneos) ) {
                  showCustomErrorSnackbar(  context, 'No tienes permiso para realizar esta accion.');
                  return;
                }
            final result = await showNumberInputDialog(
              context: context,
              title: '${servicio.titulo} - Cantidad',
              initialValue: servicio.cantidad?.toString() ?? '',
            );

            if (result != null) {
              final cantidad = int.tryParse(result);
              if (cantidad != null) {
                // Call the API to update the comment

                final body = {"id": servicio.id, "cantidad": cantidad};
                print("Cantidad: $cantidad");
                final response = await ref
                    .read(serviciosAdicionalesProvider.notifier)
                    .setCantidadServicioEspecial(body);

                // Show snackbar response
                CustomSnackbar.showResponseSnackbar(
                  response.message,
                  response.success,
                  // ignore: use_build_context_synchronously
                  context,
                  isFixed: true,
                );

                // getControlDeActividadesServicioMiscelaneoById(); from control actividades provider
                if (response.success) {
                  ref
                      .read(
                        controlActividadesProvider(
                          ref
                              .read(selectedTurnaroundProvider.notifier)
                              .state!
                              .id,
                        ).notifier,
                      )
                      .getControlDeActividadesServicioMiscelaneoById();
                }
              }
            }
          },
          child: SizedBox(
            // width: 100,
            child: Row(
              children: [
                Text(
                  'Cantidad: ',
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
                  child: Text(
                    (servicio.cantidad != null
                            ? servicio.cantidad.toString()
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

          //   Container(
          //     padding: const EdgeInsets.all(10),
          //     margin: const EdgeInsets.symmetric(vertical: 10),
          //     decoration: BoxDecoration(
          //       color: Colors.grey.shade200,
          //       borderRadius: BorderRadius.circular(10),
          //     ),
          //     child: Text(servicio.cantidad.toString()),
          // )
        ),
      ],
    );
  }
}

class _HoraInicioServicioEspecialView extends ConsumerWidget {
  final ServiciosAle servicio;
  const _HoraInicioServicioEspecialView({required this.servicio});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timeFormat = DateFormat('HH:mm');
    bool isLoading = ref.watch(isLoadingControlActividadesProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // ifLoading
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () async {

            // Rol Check
                if (!ref.read(authProvider).loginResponse!.hasPermission( Roles.modificarControlDeActividadesMiscelaneos) ) {
                  showCustomErrorSnackbar(  context, 'No tienes permiso para realizar esta accion.');
                  return;
                }
            // Show time picker dialog
            final selectedTime =
                await CustomTimePickerDialog.showTimePickerDialog(
                  context,
                  // ref,
                  servicio.horaInicio ?? DateTime.now(),
                  servicio.horaInicio != null
                      ? TimeOfDay.fromDateTime(servicio.horaInicio!)
                      : null,
                );
            // print('Selected time: $selectedTime');
            if (selectedTime != null) {
              // final SnackbarResponse response =
              await _setHoraInicioFinServicioEspecial(
                ref,
                // servicio.id,
                servicio.id,
                DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day,
                  selectedTime.hour,
                  selectedTime.minute,
                  0,
                ),
                'Hora de Inicio',
                // ignore: use_build_context_synchronously
                context,
              );

              // Show snackbar response
              // CustomSnackbar.showResponseSnackbar(
              //   response.message,
              //   response.success,
              //   // ignore: use_build_context_synchronously
              //   context,
              //   isFixed: true,
              // );
            }
          },
          child: SizedBox(
            // width: 100,
            child: Row(
              children: [
                Text(
                  'Hora de inicio',
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
                  child: Text(
                    (servicio.horaInicio != null
                            ? timeFormat.format(servicio.horaInicio!)
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

                  // Rol Check
                if (!ref.read(authProvider).loginResponse!.hasPermission( Roles.modificarControlDeActividadesMiscelaneos) ) {
                  showCustomErrorSnackbar(  context, 'No tienes permiso para realizar esta accion.');
                  return;
                }
                  // Show loading indicator
                  ref
                      .read(isLoadingControlActividadesProvider.notifier)
                      .update((state) => true);
                  // wait 3 seconds
                  // await Future.delayed(const Duration(seconds: 3));
                  final response = await _setHoraInicioFinServicioEspecial(
                    ref,
                    servicio.id,
                    DateTime.now(),
                    'Hora de Inicio',
                    context,
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
                child: Icon(Icons.access_time, color: Colors.white, size: 35),
              ),
      ],
    );
  }
}

class _HoraFinServicioEspecialView extends ConsumerWidget {
  final ServiciosAle servicio;
  const _HoraFinServicioEspecialView({required this.servicio});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timeFormat = DateFormat('HH:mm');
    bool isLoading = ref.watch(isLoadingControlActividadesProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // ifLoading
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () async {

            // Rol Check
                if (!ref.read(authProvider).loginResponse!.hasPermission( Roles.modificarControlDeActividadesMiscelaneos) ) {
                  showCustomErrorSnackbar(  context, 'No tienes permiso para realizar esta accion.');
                  return;
                }
            // Show time picker dialog
            final selectedTime =
                await CustomTimePickerDialog.showTimePickerDialog(
                  context,
                  // ref,
                  servicio.horaFin ?? DateTime.now(),
                  servicio.horaFin != null
                      ? TimeOfDay.fromDateTime(servicio.horaFin!)
                      : null,
                );
            // print('Selected time: $selectedTime');
            if (selectedTime != null) {
              // final SnackbarResponse response =
              await _setHoraInicioFinServicioEspecial(
                ref,
                // servicio.id,
                servicio.id,
                DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day,
                  selectedTime.hour,
                  selectedTime.minute,
                  0,
                ),
                'Hora fin',
                // ignore: use_build_context_synchronously
                context,
              );

              // Show snackbar response
              // CustomSnackbar.showResponseSnackbar(
              //   response.message,
              //   response.success,
              //   // ignore: use_build_context_synchronously
              //   context,
              //   isFixed: true,
              // );
            }
          },
          child: SizedBox(
            // width: 100,
            child: Row(
              children: [
                Text(
                  'Hora final',
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
                  child: Text(
                    (servicio.horaFin != null
                            ? timeFormat.format(servicio.horaFin!)
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

                  // Rol Check
                  if (!ref.read(authProvider).loginResponse!.hasPermission( Roles.modificarControlDeActividadesMiscelaneos) ) {
                    showCustomErrorSnackbar(  context, 'No tienes permiso para realizar esta accion.');
                    return;
                  }
                  
                  if (isLoading) return;
                  // Show loading indicator
                  ref
                      .read(isLoadingControlActividadesProvider.notifier)
                      .update((state) => true);
                  // wait 3 seconds
                  // await Future.delayed(const Duration(seconds: 3));
                  final response = await _setHoraInicioFinServicioEspecial(
                    ref,
                    servicio.id,
                    DateTime.now(),
                    'Hora fin',
                    context,
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
                child: Icon(Icons.access_time, color: Colors.white, size: 35),
              ),
      ],
    );
  }
}

// ******************************************************************************************
// ******************************************************************************************
// ******************************************************************************************
// ******************************************************************************************

Future<SnackbarResponse> _setHoraInicioFinServicioEspecial(
  WidgetRef ref,
  int id,
  DateTime horaInicio,
  String tipo,
  BuildContext context,
) async {
  final body = SetHoraServicioAdicionalRequest(
    horaInicio: horaInicio,
    horaFin: horaInicio,
    tipo: tipo,
    id: id,
  );
  final response = await ref
      .read(serviciosAdicionalesProvider.notifier)
      .setHoraInicioServicioAdicional(body);

  if (response.success) {
    // Update the control de actividades
    ref
        .read(
          controlActividadesProvider(
            ref.read(selectedTurnaroundProvider)!.id,
          ).notifier,
        )
        .getControlDeActividadesServicioMiscelaneoById();
    // Show snackbar response
    CustomSnackbar.showSuccessSnackbar(
      response.message,
      // ignore: use_build_context_synchronously
      context,
      isFixed: true,
    );
  } else {
    // Show error snackbar
    CustomSnackbar.showErrorSnackbar(
      response.message,
      // ignore: use_build_context_synchronously
      context,
      isFixed: true,
    );
  }

  return response;
  // Optionally, you can show a snackbar or a dialog to confirm the action
  // ScaffoldMessenger.of(context).showSnackBar(
  //   const SnackBar(content: Text('Hora de inicio actualizada correctamente.')),
  // );
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

//******************************************************************************************************************************************
//******************************************************************************************************************************************
//******************************************************************************************************************************************
//******************************************************************************************************************************************
//******************************************************************************************************************************************
//******************************************************************************************************************************************
//******************************************************************************************************************************************
//******************************************************************************************************************************************
//******************************************************************************************************************************************
//******************************************************************************************************************************************
//******************************************************************************************************************************************
//******************************************************************************************************************************************
//******************************************************************************************************************************************

class _ListadoServiciosAdicionales extends ConsumerWidget {
  final int trcId;
  const _ListadoServiciosAdicionales({required this.trcId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ControlActividades? controlActividades = ref
        .watch(controlActividadesProvider(trcId))
        .controlActividades;
    final serviciosAdicionales = controlActividades?.serviciosAdicionales;
    // final timeFormat = DateFormat('HH:mm');
    // bool isLoading = ref.watch(isLoadingControlActividadesProvider);
    print('Servicios adicionales: $serviciosAdicionales');
    if (serviciosAdicionales == null || serviciosAdicionales.isEmpty) {
      return Center(
        child: Text(
          'No hay servicios adicionales.',
          // style: Theme.of(context).textTheme.titleMedium,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w400),
        ),
      );
    }
    return Column(
      children: serviciosAdicionales.map((servicioAdicional) {
        // final servicioEspecial = serviciosEspeciales![index];
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  servicioAdicional.titulo,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            _HoraInicioServicioAdicionalView(servicio: servicioAdicional),
            _HoraFinServicioAdicionalView(servicio: servicioAdicional),

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

                    // Rol Check
                      if (!ref.read(authProvider).loginResponse!.hasPermission( Roles.modificarControlDeActividadesMiscelaneos) ) {
                        showCustomErrorSnackbar(  context, 'No tienes permiso para realizar esta accion.');
                        return;
                      }
                      
                    await ref
                        .read(categoriasEquiposGseProvider.notifier)
                        .getCategoriasEquiposGse();

                    // Maquinarias asignadas a servicios adicionales
                    // El servico adicional seleccionado
                    // turnaround
                    // tipo de asignacion

                    // No se usa
                    final data = AsignarEquiposDialogData(
                      // maquinarias: servicioAdicional.maquinaria,
                      servicioAdicional: servicioAdicional,
                      turnaround: ref.read(selectedTurnaroundProvider),
                      tipoAsignacion: "servicioAdicional",
                    );

                    ref
                        .read(asignarEquiposDialogDataProvider.notifier)
                        .state = AsignarEquiposDialogData(
                      // maquinarias: servicioAdicional.maquinaria,
                      servicioAdicional: servicioAdicional,
                      turnaround: ref.read(selectedTurnaroundProvider),
                      tipoAsignacion: "servicioAdicional",
                    );

                    // {
                    //   // "maquinarias": servicioAdicional.maquinaria,
                    //   "servicioAdicional": servicioAdicional,
                    //   "turnaround": ref.read(selectedTurnaroundProvider),
                    //   "tipoAsignacion": "servicioAdicional",
                    // };

                    print("asignar equipos gse");
                    // context.push('/asignar-equipos-gse-control-actividades',
                    // Push with GoRouter with extra data
                    context.push(
                      '/asignar-equipos-gse-servicios-control-actividades',
                      extra: data,
                    );
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

            _ListadoMaquinariasConTiempoViewServiciosAdicionales(
              servicioAdicional: servicioAdicional,
              // maquinarias: servicioAdicional.maquinaria,
            ),

            // Comentarios
            _ComentarioViewServiciosAdicionales(
              servicioAdicional: servicioAdicional,
            ),

            const SizedBox(height: 20),

            // Row(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   children: [
            //     Text(
            //       servicioAdicional.titulo,
            //       style: Theme.of(
            //         context,
            //       ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
            //     ),
            //   ],
            // ),
          ],
        );
      }).toList(),
    );
    // ListView.builder(
    //   shrinkWrap: true,
    //   itemCount: serviciosAdicionales?.length,
    //   itemBuilder: (context, index) {
    //     final servicioAdicional = serviciosAdicionales![index];

    //     return Column(
    //       children: [
    //         Row(
    //           mainAxisAlignment: MainAxisAlignment.start,
    //           children: [
    //             Text(
    //               servicioAdicional.titulo,
    //               style: Theme.of(
    //                 context,
    //               ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
    //             ),
    //           ],
    //         ),
    //         _HoraInicioServicioAdicionalView(servicio: servicioAdicional),
    //         _HoraFinServicioAdicionalView(servicio: servicioAdicional),

    //         Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           children: [
    //             Text(
    //               'Equipos GSE',
    //               style: Theme.of(
    //                 context,
    //               ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w400),
    //             ),
    //             ElevatedButton(
    //               // disable if isLoading
    //               // Aca mismo es
    //               onPressed: () async {
    //                 await ref
    //                     .read(categoriasEquiposGseProvider.notifier)
    //                     .getCategoriasEquiposGse();

    //                 // Maquinarias asignadas a servicios adicionales
    //                 // El servico adicional seleccionado
    //                 // turnaround
    //                 // tipo de asignacion

    //                 // No se usa
    //                 final data = AsignarEquiposDialogData(
    //                   // maquinarias: servicioAdicional.maquinaria,
    //                   servicioAdicional: servicioAdicional,
    //                   turnaround: ref.read(selectedTurnaroundProvider),
    //                   tipoAsignacion: "servicioAdicional",
    //                 );

    //                 ref
    //                     .read(asignarEquiposDialogDataProvider.notifier)
    //                     .state = AsignarEquiposDialogData(
    //                   // maquinarias: servicioAdicional.maquinaria,
    //                   servicioAdicional: servicioAdicional,
    //                   turnaround: ref.read(selectedTurnaroundProvider),
    //                   tipoAsignacion: "servicioAdicional",
    //                 );

    //                 // {
    //                 //   // "maquinarias": servicioAdicional.maquinaria,
    //                 //   "servicioAdicional": servicioAdicional,
    //                 //   "turnaround": ref.read(selectedTurnaroundProvider),
    //                 //   "tipoAsignacion": "servicioAdicional",
    //                 // };

    //                 print("asignar equipos gse");
    //                 // context.push('/asignar-equipos-gse-control-actividades',
    //                 // Push with GoRouter with extra data
    //                 context.push(
    //                   '/asignar-equipos-gse-servicios-control-actividades',
    //                   extra: data,
    //                 );
    //               },
    //               style: ElevatedButton.styleFrom(
    //                 shape: CircleBorder(),
    //                 padding: EdgeInsets.all(5),
    //                 fixedSize: const Size(45, 45),
    //                 backgroundColor: Theme.of(
    //                   context,
    //                 ).colorScheme.primary, // <-- Button color
    //                 // foregroundColor: Colors.red, // <-- Splash color
    //               ),
    //               child: Icon(Icons.agriculture, color: Colors.white, size: 35),
    //             ),
    //           ],
    //         ),

    //         _ListadoMaquinariasConTiempoViewServiciosAdicionales(
    //           servicioAdicional: servicioAdicional,
    //           // maquinarias: servicioAdicional.maquinaria,
    //         ),

    //         // Comentarios
    //         _ComentarioViewServiciosAdicionales(
    //           servicioAdicional: servicioAdicional,
    //         ),

    //         const SizedBox(height: 20),

    //         // Row(
    //         //   mainAxisAlignment: MainAxisAlignment.start,
    //         //   children: [
    //         //     Text(
    //         //       servicioAdicional.titulo,
    //         //       style: Theme.of(
    //         //         context,
    //         //       ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
    //         //     ),
    //         //   ],
    //         // ),
    //       ],
    //     );
    //   },
    // );
  }
}

class _ComentarioViewServiciosAdicionales extends ConsumerWidget {
  const _ComentarioViewServiciosAdicionales({required this.servicioAdicional});

  final ServiciosAle servicioAdicional;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextEditingController textController = TextEditingController();
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Comentarios',
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

                    // Rol Check
                if (!ref.read(authProvider).loginResponse!.hasPermission( Roles.modificarControlDeActividadesMiscelaneos) ) {
                  showCustomErrorSnackbar(  context, 'No tienes permiso para realizar esta accion.');
                  return;
                }
                    // set value of tarea.comentario to textController
                    textController.text = servicioAdicional.comentario ?? '';

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
                                final ComentarioServiciosAdicionalRequest body =
                                    ComentarioServiciosAdicionalRequest(
                                      id: servicioAdicional.id,
                                      comentario: textController.text,
                                      esServicioAdicional: true,
                                    );

                                print("Comentario: ${body.comentario}");

                                // Call the API to update the comment
                                final response = await ref
                                    .read(serviciosAdicionalesProvider.notifier)
                                    .setComentarioServicioAdicional(body);

                                // Show snackbar response
                                CustomSnackbar.showResponseSnackbar(
                                  response.message,
                                  response.success,
                                  // ignore: use_build_context_synchronously
                                  context,
                                  isFixed: true,
                                );

                                // getControlDeActividadesServicioMiscelaneoById(); from control actividades provider
                                ref
                                    .read(
                                      controlActividadesProvider(
                                        ref
                                            .read(
                                              selectedTurnaroundProvider
                                                  .notifier,
                                            )
                                            .state!
                                            .id,
                                      ).notifier,
                                    )
                                    .getControlDeActividadesServicioMiscelaneoById();

                                Navigator.pop(context);
                                textController.clear();
                              },
                            ),
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

        //  Grey container to display the comment
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(servicioAdicional.comentario ?? ''),
        ),
      ],
    );
  }
}

class _ListadoMaquinariasConTiempoViewServiciosAdicionales
    extends ConsumerWidget {
  final ServiciosAle servicioAdicional;
  final List<Maquinaria> maquinarias;

  _ListadoMaquinariasConTiempoViewServiciosAdicionales({
    // required this.maquinarias,
    required this.servicioAdicional,
  }) : maquinarias = servicioAdicional.maquinaria;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timeFormat = DateFormat('HH:mm');
    bool isLoading = ref.watch(isLoadingControlActividadesProvider);
    final selectedTrc = ref.watch(selectedTurnaroundProvider.notifier).state;

    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: maquinarias.length,
      itemBuilder: (context, index) {
        final maquinaria = maquinarias[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '${maquinaria.maquinariaIdentificador} - ${maquinaria.maquinariaModelo}',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
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

                        // Rol Check
                        if (!ref.read(authProvider).loginResponse!.hasPermission( Roles.modificarControlDeActividadesMiscelaneos) ) {
                          showCustomErrorSnackbar(  context, 'No tienes permiso para realizar esta accion.');
                          return;
                        }
                        // print('Hora inicio tapped');
                        // Show time picker dialog
                        final selectedTime =
                            await CustomTimePickerDialog.showTimePickerDialog(
                              context,
                              maquinaria.horaInicio ?? DateTime.now(),
                              maquinaria.horaInicio != null
                                  ? TimeOfDay.fromDateTime(
                                      maquinaria.horaInicio!,
                                    )
                                  : null,
                            );
                        // print('Selected time: $selectedTime');
                        if (selectedTime != null) {
                          final trcDate = selectedTrc!.fechaInicio;

                          final horaInicio =
                              CustomDateTimeFunctions.getDateTimeFromTimeOfDay(
                                trcDate,
                                selectedTime,
                              );

                          final body = HoraMaquinariaServicioAdicionalResponse(
                            id: maquinaria.id,
                            servicioAdicionalId: servicioAdicional.id,
                            horaInicio: horaInicio,
                            tipo: 'Hora de Inicio',
                            isServicioMiscelaneo: true,
                          );

                          final response = await ref
                              .read(serviciosAdicionalesProvider.notifier)
                              .setHoraMaquinariaServicioAdicional(body);

                          if (response.success) {
                            CustomSnackbar.showSuccessSnackbar(
                              response.message,
                              // ignore: use_build_context_synchronously
                              context,
                              isFixed: true,
                            );

                            // Get control de actividades
                            ref
                                .read(
                                  controlActividadesProvider(
                                    selectedTrc.id,
                                  ).notifier,
                                )
                                .getControlDeActividadesServicioMiscelaneoById();
                          } else {
                            CustomSnackbar.showErrorSnackbar(
                              response.message,
                              // ignore: use_build_context_synchronously
                              context,
                              isFixed: true,
                            );
                          }
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
                                (maquinaria.horaInicio != null
                                        ? timeFormat.format(
                                            maquinaria.horaInicio!,
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

                              // Rol Check
                              if (!ref.read(authProvider).loginResponse!.hasPermission( Roles.modificarControlDeActividadesMiscelaneos) ) {
                                showCustomErrorSnackbar(  context, 'No tienes permiso para realizar esta accion.');
                                return;
                              }
                              
                              if (isLoading) return;
                              // Show loading indicator
                              ref
                                  .read(
                                    isLoadingControlActividadesProvider
                                        .notifier,
                                  )
                                  .update((state) => true);
                              // wait 3 seconds
                              // await Future.delayed(const Duration(seconds: 3));

                              final body =
                                  HoraMaquinariaServicioAdicionalResponse(
                                    id: maquinaria.id,
                                    servicioAdicionalId: servicioAdicional.id,
                                    horaInicio: DateTime.now(),
                                    tipo: 'Hora de Inicio',
                                  );

                              final response = await ref
                                  .read(serviciosAdicionalesProvider.notifier)
                                  .setHoraMaquinariaServicioAdicional(body);

                              if (response.success) {
                                CustomSnackbar.showSuccessSnackbar(
                                  response.message,
                                  // ignore: use_build_context_synchronously
                                  context,
                                  isFixed: true,
                                );

                                // Get control de actividades
                                ref
                                    .read(
                                      controlActividadesProvider(
                                        selectedTrc!.id,
                                      ).notifier,
                                    )
                                    .getControlDeActividadesServicioMiscelaneoById();
                              } else {
                                CustomSnackbar.showErrorSnackbar(
                                  response.message,
                                  // ignore: use_build_context_synchronously
                                  context,
                                  isFixed: true,
                                );
                              }
                              ref
                                  .read(
                                    isLoadingControlActividadesProvider
                                        .notifier,
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

                        // Rol Check
                        if (!ref.read(authProvider).loginResponse!.hasPermission( Roles.modificarControlDeActividadesMiscelaneos) ) {
                          showCustomErrorSnackbar(  context, 'No tienes permiso para realizar esta accion.');
                          return;
                        }
                        
                        // Show time picker dialog
                        final selectedTime =
                            await CustomTimePickerDialog.showTimePickerDialog(
                              context,
                              maquinaria.horaFin ?? DateTime.now(),
                              maquinaria.horaFin != null
                                  ? TimeOfDay.fromDateTime(maquinaria.horaFin!)
                                  : null,
                            );
                        // print('Selected time: $selectedTime');
                        if (selectedTime != null) {
                          // obteniendo fecha del trc
                          final trcDate =
                              selectedTrc!.fechaInicio ?? selectedTrc.fechaFin;

                          final horaFin =
                              CustomDateTimeFunctions.getDateTimeFromTimeOfDay(
                                trcDate,
                                selectedTime,
                              );

                          final body = HoraMaquinariaServicioAdicionalResponse(
                            id: maquinaria.id,
                            servicioAdicionalId: servicioAdicional.id,
                            // horaInicio: horaInicio,
                            horaFin: horaFin,
                            tipo: 'Hora final',
                          );

                          final response = await ref
                              .read(serviciosAdicionalesProvider.notifier)
                              .setHoraMaquinariaServicioAdicional(body);

                          if (response.success) {
                            CustomSnackbar.showSuccessSnackbar(
                              response.message,
                              // ignore: use_build_context_synchronously
                              context,
                              isFixed: true,
                            );

                            // Get control de actividades
                            ref
                                .read(
                                  controlActividadesProvider(
                                    selectedTrc.id,
                                  ).notifier,
                                )
                                .getControlDeActividadesServicioMiscelaneoById();
                          } else {
                            CustomSnackbar.showErrorSnackbar(
                              response.message,
                              // ignore: use_build_context_synchronously
                              context,
                              isFixed: true,
                            );
                          }
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
                                (maquinaria.horaFin != null
                                        ? timeFormat.format(maquinaria.horaFin!)
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

                              // Rol Check
                              if (!ref.read(authProvider).loginResponse!.hasPermission( Roles.modificarControlDeActividadesMiscelaneos) ) {
                                showCustomErrorSnackbar(  context, 'No tienes permiso para realizar esta accion.');
                                return;
                              }
                              
                              if (isLoading) return;
                              // Show loading indicator
                              ref
                                  .read(
                                    isLoadingControlActividadesProvider
                                        .notifier,
                                  )
                                  .update((state) => true);
                              // wait 3 seconds
                              // await Future.delayed(const Duration(seconds: 3));

                              final body =
                                  HoraMaquinariaServicioAdicionalResponse(
                                    id: maquinaria.id,
                                    servicioAdicionalId: servicioAdicional.id,
                                    horaInicio: DateTime.now(),
                                    horaFin: DateTime.now(),
                                    tipo: 'Hora final',
                                  );

                              final response = await ref
                                  .read(serviciosAdicionalesProvider.notifier)
                                  .setHoraMaquinariaServicioAdicional(body);

                              if (response.success) {
                                CustomSnackbar.showSuccessSnackbar(
                                  response.message,
                                  // ignore: use_build_context_synchronously
                                  context,
                                  isFixed: true,
                                );

                                // Get control de actividades
                                ref
                                    .read(
                                      controlActividadesProvider(
                                        selectedTrc!.id,
                                      ).notifier,
                                    )
                                    .getControlDeActividadesServicioMiscelaneoById();
                              } else {
                                CustomSnackbar.showErrorSnackbar(
                                  response.message,
                                  // ignore: use_build_context_synchronously
                                  context,
                                  isFixed: true,
                                );
                              }
                              ref
                                  .read(
                                    isLoadingControlActividadesProvider
                                        .notifier,
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
          ),
        );

        // ListTile(
        //   title: Text(
        //     '${maquinaria.maquinariaIdentificador} - ${maquinaria.maquinariaModelo}',

        //     style: Theme.of(
        //       context,
        //     ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        //   ),
        // );
      },
    );
  }
}

class _HoraInicioServicioAdicionalView extends ConsumerWidget {
  final ServiciosAle servicio;
  const _HoraInicioServicioAdicionalView({required this.servicio});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timeFormat = DateFormat('HH:mm');
    bool isLoading = ref.watch(isLoadingControlActividadesProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // ifLoading
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () async {
            // Rol Check
                if (!ref.read(authProvider).loginResponse!.hasPermission( Roles.modificarControlDeActividadesMiscelaneos) ) {
                  showCustomErrorSnackbar(  context, 'No tienes permiso para realizar esta accion.');
                  return;
                }
            // Show time picker dialog
            final selectedTime =
                await CustomTimePickerDialog.showTimePickerDialog(
                  context,
                  // ref,
                  servicio.horaInicio ?? DateTime.now(),
                  servicio.horaInicio != null
                      ? TimeOfDay.fromDateTime(servicio.horaInicio!)
                      : null,
                );
            // print('Selected time: $selectedTime');
            if (selectedTime != null) {
              // final SnackbarResponse response =
              await setHoraInicioFinServicioAdicional(
                ref,
                // servicio.id,
                servicio.id,
                DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day,
                  selectedTime.hour,
                  selectedTime.minute,
                  0,
                ),
                'Hora de Inicio',
                // ignore: use_build_context_synchronously
                context,
              );

              // Show snackbar response
              // CustomSnackbar.showResponseSnackbar(
              //   response.message,
              //   response.success,
              //   // ignore: use_build_context_synchronously
              //   context,
              //   isFixed: true,
              // );
            }
          },
          child: SizedBox(
            // width: 100,
            child: Row(
              children: [
                Text(
                  'Hora de inicio',
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
                  child: Text(
                    (servicio.horaInicio != null
                            ? timeFormat.format(servicio.horaInicio!)
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

                  // Rol Check
                if (!ref.read(authProvider).loginResponse!.hasPermission( Roles.modificarControlDeActividadesMiscelaneos) ) {
                  showCustomErrorSnackbar(  context, 'No tienes permiso para realizar esta accion.');
                  return;
                }

                  if (isLoading) return;
                  // Show loading indicator
                  ref
                      .read(isLoadingControlActividadesProvider.notifier)
                      .update((state) => true);
                  // wait 3 seconds
                  // await Future.delayed(const Duration(seconds: 3));
                  final response = await setHoraInicioFinServicioAdicional(
                    ref,
                    servicio.id,
                    DateTime.now(),
                    'Hora de Inicio',
                    context,
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
                child: Icon(Icons.access_time, color: Colors.white, size: 35),
              ),
      ],
    );
  }
}

class _HoraFinServicioAdicionalView extends ConsumerWidget {
  final ServiciosAle servicio;
  const _HoraFinServicioAdicionalView({required this.servicio});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timeFormat = DateFormat('HH:mm');
    bool isLoading = ref.watch(isLoadingControlActividadesProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // ifLoading
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () async {

            // Rol Check
                if (!ref.read(authProvider).loginResponse!.hasPermission( Roles.modificarControlDeActividadesMiscelaneos) ) {
                  showCustomErrorSnackbar(  context, 'No tienes permiso para realizar esta accion.');
                  return;
                }

            // Show time picker dialog
            final selectedTime =
                await CustomTimePickerDialog.showTimePickerDialog(
                  context,
                  // ref,
                  servicio.horaFin ?? DateTime.now(),
                  servicio.horaFin != null
                      ? TimeOfDay.fromDateTime(servicio.horaFin!)
                      : null,
                );
            // print('Selected time: $selectedTime');
            if (selectedTime != null) {
              // final SnackbarResponse response =
              await setHoraInicioFinServicioAdicional(
                ref,
                // servicio.id,
                servicio.id,
                DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day,
                  selectedTime.hour,
                  selectedTime.minute,
                  0,
                ),
                'Hora fin',
                // ignore: use_build_context_synchronously
                context,
              );

              // Show snackbar response
              // CustomSnackbar.showResponseSnackbar(
              //   response.message,
              //   response.success,
              //   // ignore: use_build_context_synchronously
              //   context,
              //   isFixed: true,
              // );
            }
          },
          child: SizedBox(
            // width: 100,
            child: Row(
              children: [
                Text(
                  'Hora final',
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
                  child: Text(
                    (servicio.horaFin != null
                            ? timeFormat.format(servicio.horaFin!)
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
                  // Rol Check
                if (!ref.read(authProvider).loginResponse!.hasPermission( Roles.modificarControlDeActividadesMiscelaneos) ) {
                  showCustomErrorSnackbar(  context, 'No tienes permiso para realizar esta accion.');
                  return;
                }
                  if (isLoading) return;
                  // Show loading indicator
                  ref
                      .read(isLoadingControlActividadesProvider.notifier)
                      .update((state) => true);
                  // wait 3 seconds
                  // await Future.delayed(const Duration(seconds: 3));
                  final response = await setHoraInicioFinServicioAdicional(
                    ref,
                    servicio.id,
                    DateTime.now(),
                    'Hora fin',
                    context,
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
                child: Icon(Icons.access_time, color: Colors.white, size: 35),
              ),
      ],
    );
  }
}

Future<SnackbarResponse> setHoraInicioFinServicioAdicional(
  WidgetRef ref,
  int id,
  DateTime horaInicio,
  String tipo,
  BuildContext context,

  // optional bool
) async {
  // transform horaInicio to the format required by the API '2025-07-16T19:23:18.861Z'
  // final String formattedDate = DateFormat('yyyy-MM-ddTHH:mm:ss').format(horaInicio);
  // const formattedDate = new Date( this.myForm.value.fecha.getFullYear() + '-' + (this.myForm.value.fecha.getMonth() + 1) + '-' + this.myForm.value.fecha.getDate() + ' ' + this.myForm.value.hora + ':' +'00' );

  // Call the repository method to set horaInicio
  // final trcId = ref.read(trcIdProvider);
  final body = SetHoraServicioAdicionalRequest(
    horaInicio: horaInicio,
    horaFin: horaInicio,
    tipo: tipo, 
    id: id,
    isServicioMiscelaneo: true,
  );
  final response = await ref
      .read(serviciosAdicionalesProvider.notifier)
      .setHoraInicioServicioAdicional(body);

  if (response.success) {
    // Update the control de actividades
    ref
        .read(
          controlActividadesProvider(
            ref.read(selectedTurnaroundProvider)!.id,
          ).notifier,
        )
        .getControlDeActividadesServicioMiscelaneoById();
    // Show snackbar response
    CustomSnackbar.showSuccessSnackbar(
      response.message,
      // ignore: use_build_context_synchronously
      context,
      isFixed: true,
    );
  } else {
    // Show error snackbar
    CustomSnackbar.showErrorSnackbar(
      response.message,
      // ignore: use_build_context_synchronously
      context,
      isFixed: true,
    );
  }

  return response;
  // Optionally, you can show a snackbar or a dialog to confirm the action
  // ScaffoldMessenger.of(context).showSnackBar(
  //   const SnackBar(content: Text('Hora de inicio actualizada correctamente.')),
  // );
}
