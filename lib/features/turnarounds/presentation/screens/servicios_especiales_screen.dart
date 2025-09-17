import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../shared/shared.dart';
import '../../domain/domain.dart';
import '../providers/providers.dart';
// import 'package:turnaround_mobile/shared/shared.dart';

class ServiciosEspecialesScreen extends ConsumerWidget {
  const ServiciosEspecialesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Servicios Especiales')),
      body: _ServiciosEspecialesView(),
    );
  }
}

class _ServiciosEspecialesView extends ConsumerWidget {
  const _ServiciosEspecialesView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trcId = ref.watch(selectedTurnaroundProvider)!.id;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Agregar servicio especial:',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w400),
              ),
              ElevatedButton(
                // disable if isLoading
                onPressed: () async {
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
                  context.push('/asignar-servicios-especiales-screen');

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
                child: Icon(Icons.add, color: Colors.white, size: 35),
              ),
            ],
          ),

          const SizedBox(height: 16),
          // ListadoServicioEspecial
          Expanded(child: _ListadoServiciosEspeciales(trcId: trcId)),
        ],
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
    return ListView.builder(
      shrinkWrap: true,
      itemCount: serviciosEspeciales?.length,
      itemBuilder: (context, index) {
        final servicioEspecial = serviciosEspeciales![index];

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
                Text(
                  // servicioEspecial.descripcion,
                  " - Descripcion de servicio especial",
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
                ),
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
      },
    );
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
              onPressed:
                  (
                    // Open a dialog to write and submit the comment
                  ) async {
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

                                // getControlDeActividadesByTrcId(); from control actividades provider
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
                                    .getControlDeActividadesByTrcId();

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

                // getControlDeActividadesByTrcId(); from control actividades provider
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
                      .getControlDeActividadesByTrcId();
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
        .getControlDeActividadesByTrcId();
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

// ******************************************************************************************
// ******************************************************************************************
// ******************************************************************************************
// ******************************************************************************************
// ******************************************************************************************

// class _ServiciosEspecialesEquiposGseView extends StatelessWidget {
//   final ServiciosAle servicioEspecial;
//   const _ServiciosEspecialesEquiposGseView({required this.servicioEspecial});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
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
//               onPressed: () async {
//                 // ref.read(selectedTaskProvider.notifier).state = {
//                 //   "indexDep": indexDep,
//                 //   "indexAct": indexAct,
//                 //   "indexTarea": indexTar,
//                 //   "tareaId": tarea.id,
//                 // };
//                 // ref.read(selectedMaquinariasTaskProvider.notifier).state =
//                 //     tarea.maquinaria ?? [];

//                 // await ref
//                 //     .read(categoriasEquiposGseProvider.notifier)
//                 //     .getCategoriasEquiposGse();

//                 // print("asignar equipos gse");
//                 // context.push('/asignar-equipos-gse-control-actividades');

//                 // get control de actividades after close
//                 // await ref
//                 //     .read(controlDeActividadesProvider.notifier)
//                 //     .getControlDeActividadesByTrcId(trcId);
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

//         _ListadoMaquinariasConTiempoViewServiciosEspeciales(
//           maquinarias: servicioEspecial.maquinaria,
//         ),
//       ],
//     );
//   }
// }

// class _ListadoMaquinariasConTiempoViewServiciosEspeciales
//     extends ConsumerWidget {
//   final List<Maquinaria> maquinarias;
//   const _ListadoMaquinariasConTiempoViewServiciosEspeciales({
//     required this.maquinarias,
//   });

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final timeFormat = DateFormat('HH:mm');
//     bool isLoading = ref.watch(isLoadingControlActividadesProvider);
//     return ListView.builder(
//       shrinkWrap: true,
//       itemCount: maquinarias.length,
//       itemBuilder: (context, index) {
//         final maquinaria = maquinarias[index];
//         return Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Text(
//                   '${maquinaria.maquinariaIdentificador} - ${maquinaria.maquinariaModelo}',

//                   style: Theme.of(
//                     context,
//                   ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
//                 ),
//               ],
//             ),

//             // Hora de inicio Servicio
//             Padding(
//               padding: const EdgeInsets.only(left: 8),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   // ifLoading
//                   GestureDetector(
//                     behavior: HitTestBehavior.translucent,
//                     onTap: () async {
//                       // Show time picker dialog
//                       final selectedTime =
//                           await CustomTimePickerDialog.showTimePickerDialog(
//                             context,

//                             maquinaria.horaInicio ?? DateTime.now(),
//                             maquinaria.horaInicio != null
//                                 ? TimeOfDay.fromDateTime(
//                                     maquinaria.horaInicio ?? DateTime.now(),
//                                   )
//                                 : null,
//                           );
//                       print('Selected time: $selectedTime');
//                       if (selectedTime != null) {
//                         // var trcDate = ref
//                         //     .read(selectedTurnaroundProvider.notifier)
//                         //     .state
//                         //     ?.fechaInicio;
//                         // final body = HoraInicioFinMaquinaria(
//                         //   // ignore: use_build_context_synchronously
//                         //   horaInicio: getDateTimeFromTimeOfDay(
//                         //     trcDate,
//                         //     selectedTime,
//                         //   ),
//                         //   horaFin: null,
//                         //   id: maquinaria['id'],
//                         //   tareaId: tarea.id,
//                         //   tipo: 'Hora de Inicio',
//                         // );
//                         // final trcId = ref.read(trcIdProvider);
//                         // final response = await ref
//                         //     .read(controlActividadesProvider(trcId).notifier)
//                         //     .setHoraInicioFinMaquinaria(body);

//                         // // Show snackbar response
//                         // CustomSnackbar.showResponseSnackbar(
//                         //   response.message,
//                         //   response.success,
//                         //   // ignore: use_build_context_synchronously
//                         //   context,
//                         // );
//                       }
//                     },
//                     child: SizedBox(
//                       // width: 100,
//                       child: Row(
//                         children: [
//                           Text(
//                             'Hora de inicio',
//                             style: Theme.of(context).textTheme.titleSmall
//                                 ?.copyWith(fontWeight: FontWeight.w400),
//                           ),
//                           Container(
//                             margin: const EdgeInsets.only(left: 8),
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 8,
//                               vertical: 4,
//                             ),
//                             // min width: 100,
//                             constraints: const BoxConstraints(minWidth: 60),
//                             decoration: BoxDecoration(
//                               color: Colors.grey.shade200,
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: Text(
//                               (maquinaria.horaInicio != null
//                                       ? timeFormat.format(
//                                           maquinaria.horaInicio!,
//                                         )
//                                       : '')
//                                   .toString(),
//                               style: Theme.of(context).textTheme.titleSmall
//                                   ?.copyWith(fontWeight: FontWeight.w600),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),

//                   // Rounded button to set current time
//                   isLoading
//                       ? Padding(
//                           padding: const EdgeInsets.only(right: 8),
//                           child: SizedBox(
//                             height: 25.0,
//                             width: 25.0,
//                             child: Center(
//                               child: CircularProgressIndicator(
//                                 color: Theme.of(context).colorScheme.primary,
//                                 strokeWidth: 3.0,
//                               ),
//                             ),
//                           ),
//                         )
//                       : ElevatedButton(
//                           // disable if isLoading
//                           onPressed: () async {
//                             if (isLoading) return;

//                             // Show loading indicator
//                             // ref
//                             //     .read(
//                             //       isLoadingControlActividadesProvider.notifier,
//                             //     )
//                             //     .update((state) => true);
//                             // // wait 3 seconds
//                             // // await Future.delayed(const Duration(seconds: 3));

//                             // final HoraInicioFinMaquinaria body =
//                             //     HoraInicioFinMaquinaria(
//                             //       horaInicio: DateTime.now(),
//                             //       horaFin: null,
//                             //       id: maquinaria['id'],
//                             //       tareaId: tarea.id,
//                             //       tipo: 'Hora de Inicio',
//                             //     );

//                             // final trcId = ref.read(trcIdProvider);
//                             // final response = await ref
//                             //     .read(
//                             //       controlActividadesProvider(trcId).notifier,
//                             //     )
//                             //     .setHoraInicioFinMaquinaria(body);
//                             // // Show snackbar response
//                             // CustomSnackbar.showResponseSnackbar(
//                             //   response.message,
//                             //   response.success,
//                             //   // ignore: use_build_context_synchronously
//                             //   context,
//                             // );

//                             // ref
//                             //     .read(
//                             //       isLoadingControlActividadesProvider.notifier,
//                             //     )
//                             //     .update((state) => false);
//                           },
//                           style: ElevatedButton.styleFrom(
//                             shape: CircleBorder(),
//                             padding: EdgeInsets.all(5),
//                             fixedSize: const Size(45, 45),
//                             backgroundColor: Theme.of(
//                               context,
//                             ).colorScheme.primary, // <-- Button color
//                             foregroundColor: Colors.red, // <-- Splash color
//                           ),
//                           child: Icon(
//                             Icons.access_time,
//                             color: Colors.white,
//                             size: 35,
//                           ),
//                         ),
//                 ],
//               ),
//             ),

//             // Hora final Maquinaria
//             Padding(
//               padding: const EdgeInsets.only(left: 8),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   // ifLoading
//                   GestureDetector(
//                     behavior: HitTestBehavior.translucent,
//                     onTap: () async {
//                       // Show time picker dialog
//                       final selectedTime =
//                           await CustomTimePickerDialog.showTimePickerDialog(
//                             context,
//                             maquinaria.horaFin ?? DateTime.now(),
//                             maquinaria.horaFin != null
//                                 ? TimeOfDay.fromDateTime(
//                                     maquinaria.horaFin ?? DateTime.now(),
//                                   )
//                                 : null,
//                           );
//                       print('Selected time: $selectedTime');
//                       if (selectedTime != null) {
//                         // var trcDate = ref
//                         //     .read(selectedTurnaroundProvider.notifier)
//                         //     .state
//                         //     ?.fechaInicio;
//                         // final HoraInicioFinMaquinaria body =
//                         //     HoraInicioFinMaquinaria(
//                         //       id: maquinaria['id'],
//                         //       horaInicio: null,
//                         //       // ignore: use_build_context_synchronously
//                         //       horaFin: getDateTimeFromTimeOfDay(
//                         //         trcDate,
//                         //         selectedTime,
//                         //       ),
//                         //       tareaId: tarea.id,
//                         //       tipo: 'Hora final',
//                         //     );
//                         // final trcId = ref.read(trcIdProvider);
//                         // final response = await ref
//                         //     .read(controlActividadesProvider(trcId).notifier)
//                         //     .setHoraInicioFinMaquinaria(body);

//                         // // Show snackbar response
//                         // CustomSnackbar.showResponseSnackbar(
//                         //   response.message,
//                         //   response.success,
//                         //   // ignore: use_build_context_synchronously
//                         //   context,
//                         // );
//                       }
//                     },
//                     child: SizedBox(
//                       // width: 100,
//                       child: Row(
//                         children: [
//                           Text(
//                             'Hora final',
//                             style: Theme.of(context).textTheme.titleSmall
//                                 ?.copyWith(fontWeight: FontWeight.w400),
//                           ),
//                           Container(
//                             margin: const EdgeInsets.only(left: 8),
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 8,
//                               vertical: 4,
//                             ),
//                             // min width: 100,
//                             constraints: const BoxConstraints(minWidth: 60),
//                             decoration: BoxDecoration(
//                               color: Colors.grey.shade200,
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: Text(
//                               (maquinaria.horaFin != null
//                                       ? maquinaria.horaFin.toString()
//                                       : '')
//                                   .toString(),
//                               style: Theme.of(context).textTheme.titleSmall
//                                   ?.copyWith(fontWeight: FontWeight.w600),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),

//                   // Rounded button to set current time
//                   isLoading
//                       ? Padding(
//                           padding: const EdgeInsets.only(right: 8),
//                           child: SizedBox(
//                             height: 25.0,
//                             width: 25.0,
//                             child: Center(
//                               child: CircularProgressIndicator(
//                                 color: Theme.of(context).colorScheme.primary,
//                                 strokeWidth: 3.0,
//                               ),
//                             ),
//                           ),
//                         )
//                       : ElevatedButton(
//                           // disable if isLoading
//                           onPressed: () async {
//                             if (isLoading) return;
//                             // Show loading indicator
//                             // ref
//                             //     .read(
//                             //       isLoadingControlActividadesProvider.notifier,
//                             //     )
//                             //     .update((state) => true);
//                             // // wait 3 seconds
//                             // // await Future.delayed(const Duration(seconds: 3));

//                             // final body = HoraInicioFinMaquinaria(
//                             //   horaInicio: null,
//                             //   // horaInicio: TimeOfDay.now().format(context),
//                             //   horaFin: DateTime.now(),
//                             //   id: maquinaria['id'],
//                             //   tareaId: tarea.id,
//                             //   tipo: 'Hora final',
//                             // );

//                             // final trcId = ref.read(trcIdProvider);
//                             // final response = await ref
//                             //     .read(
//                             //       controlActividadesProvider(trcId).notifier,
//                             //     )
//                             //     .setHoraInicioFinMaquinaria(body);
//                             // // Show snackbar response
//                             // CustomSnackbar.showResponseSnackbar(
//                             //   response.message,
//                             //   response.success,
//                             //   // ignore: use_build_context_synchronously
//                             //   context,
//                             // );

//                             // ref
//                             //     .read(
//                             //       isLoadingControlActividadesProvider.notifier,
//                             //     )
//                             //     .update((state) => false);
//                           },
//                           style: ElevatedButton.styleFrom(
//                             shape: CircleBorder(),
//                             padding: EdgeInsets.all(5),
//                             fixedSize: const Size(45, 45),
//                             backgroundColor: Theme.of(
//                               context,
//                             ).colorScheme.primary, // <-- Button color
//                             foregroundColor: Colors.red, // <-- Splash color
//                           ),
//                           child: Icon(
//                             Icons.access_time,
//                             color: Colors.white,
//                             size: 35,
//                           ),
//                         ),
//                 ],
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
