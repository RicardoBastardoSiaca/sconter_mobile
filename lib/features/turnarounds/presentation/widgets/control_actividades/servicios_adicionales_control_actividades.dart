import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:scounter_mobile/features/auth/domain/domain.dart';
import 'package:scounter_mobile/features/auth/presentation/providers/providers.dart';

import '../../../../shared/shared.dart';
import '../../../domain/domain.dart';
import '../../providers/providers.dart';


class ServiciosAdicionalesControlActividadesView extends ConsumerWidget {
  const ServiciosAdicionalesControlActividadesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trcId = ref.watch(selectedTurnaroundProvider)!.id;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Agregar servicio adicional:',
              overflow: TextOverflow.ellipsis,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w400),
            ),
            ElevatedButton(
              // disable if isLoading
              onPressed: () async {

                if (!ref.read(authProvider).loginResponse!.hasPermission( Roles.agregarServiciosAdicionales)
                  || !ref.read(authProvider).loginResponse!.hasPermission( Roles.agregarServiciosAdicionalesMiscelaneos)) {
                  showCustomErrorSnackbar(  context, 'No tienes permiso para realizar esta accion.');
                  return;
                }
                // TODO: passing selected servicios adicionales
                // ref.read(selectedMaquinariasTaskProvider.notifier).state =
                //     controlActividades?.serviciosAdicionales ?? [];
                // tarea.maquinaria ?? [];
        
                // await ref
                //     .read(categoriasEquiposGseProvider.notifier)
                //     .getCategoriasEquiposGse();
        
                // Get Servicios Adicionales
                await ref
                    .read(serviciosAdicionalesProvider.notifier)
                    .getServiciosAdicionales();
                // if (response == null) return;
                print("asignar equipos gse");
                context.push(
                  '/asignar-equipos-gse-servicios-adicionales-especiales',
                );
        
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
        
        // ListadoServicioAdicional
        Expanded(child: _ListadoServiciosAdicionales(trcId: trcId)),
      ],
    );
  }
}

class _ListadoServiciosAdicionales extends ConsumerWidget {
  final int trcId;
  const _ListadoServiciosAdicionales({required this.trcId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ControlActividades? controlActividades = ref
        .watch(controlActividadesProvider(trcId))
        .controlActividades;
    final serviciosAdicionales = controlActividades?.serviciosAdicionales;
    final timeFormat = DateFormat('HH:mm');
    bool isLoading = ref.watch(isLoadingControlActividadesProvider);
    print('Servicios adicionales: $serviciosAdicionales');
    return ListView.builder(
      shrinkWrap: true,
      itemCount: serviciosAdicionales?.length,
      itemBuilder: (context, index) {
        final servicioAdicional = serviciosAdicionales![index];

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

                    if (!ref.read(authProvider).loginResponse!.hasPermission( Roles.asignarMaquinaria)
                      || !ref.read(authProvider).loginResponse!.hasPermission( Roles.asignarMaquinariaMiscelaneos)) {
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
      },
    );
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
                    if (!ref.read(authProvider).loginResponse!.hasPermission( Roles.modificarControlDeActividades)
                        || !ref.read(authProvider).loginResponse!.hasPermission( Roles.modificarControlDeActividadesMiscelaneos)) {
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
                        // print('Hora inicio tapped');

                        // Rol Check
                        if (!ref.read(authProvider).loginResponse!.hasPermission( Roles.modificarControlDeActividades)
                            || !ref.read(authProvider).loginResponse!.hasPermission( Roles.modificarControlDeActividadesMiscelaneos)) {
                          showCustomErrorSnackbar(  context, 'No tienes permiso para realizar esta accion.');
                          return;
                        }

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
                                .getControlDeActividadesByTrcId();
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
                              if (isLoading) return;

                              // Rol Check
                              if (!ref.read(authProvider).loginResponse!.hasPermission( Roles.modificarControlDeActividades)
                                  || !ref.read(authProvider).loginResponse!.hasPermission( Roles.modificarControlDeActividadesMiscelaneos)) {
                                showCustomErrorSnackbar(  context, 'No tienes permiso para realizar esta accion.');
                                return;
                              }
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
                                    .getControlDeActividadesByTrcId();
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
                        if (!ref.read(authProvider).loginResponse!.hasPermission( Roles.modificarControlDeActividades)
                            || !ref.read(authProvider).loginResponse!.hasPermission( Roles.modificarControlDeActividadesMiscelaneos)) {
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
                                .getControlDeActividadesByTrcId();
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
                              if (isLoading) return;
                              // Show loading indicator

                              // Rol Check
                              if (!ref.read(authProvider).loginResponse!.hasPermission( Roles.modificarControlDeActividades)
                                  || !ref.read(authProvider).loginResponse!.hasPermission( Roles.modificarControlDeActividadesMiscelaneos)) {
                                showCustomErrorSnackbar(  context, 'No tienes permiso para realizar esta accion.');
                                return;
                              }

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
                                    .getControlDeActividadesByTrcId();
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
            // Show time picker dialog

            // Rol Check
            if (!ref.read(authProvider).loginResponse!.hasPermission( Roles.modificarControlDeActividades)
                || !ref.read(authProvider).loginResponse!.hasPermission( Roles.modificarControlDeActividadesMiscelaneos)) {
              showCustomErrorSnackbar(  context, 'No tienes permiso para realizar esta accion.');
              return;
            }

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
                  if (isLoading) return;
                  // Show loading indicator

                  // Rol Check
                  if (!ref.read(authProvider).loginResponse!.hasPermission( Roles.modificarControlDeActividades)
                      || !ref.read(authProvider).loginResponse!.hasPermission( Roles.modificarControlDeActividadesMiscelaneos)) {
                    showCustomErrorSnackbar(  context, 'No tienes permiso para realizar esta accion.');
                    return;
                  }

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
            if (!ref.read(authProvider).loginResponse!.hasPermission( Roles.modificarControlDeActividades)
                || !ref.read(authProvider).loginResponse!.hasPermission( Roles.modificarControlDeActividadesMiscelaneos)) {
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
                  if (isLoading) return;
                  // Show loading indicator

                  // Rol Check
                  if (!ref.read(authProvider).loginResponse!.hasPermission( Roles.modificarControlDeActividades)
                      || !ref.read(authProvider).loginResponse!.hasPermission( Roles.modificarControlDeActividadesMiscelaneos)) {
                    showCustomErrorSnackbar(  context, 'No tienes permiso para realizar esta accion.');
                    return;
                  }

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

// ******************************************************************************************
// ******************************************************************************************
// ******************************************************************************************
// ******************************************************************************************

Future<SnackbarResponse> setHoraInicioFinServicioAdicional(
  WidgetRef ref,
  int id,
  DateTime horaInicio,
  String tipo,
  BuildContext context,
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

// class _ServiciosAdicionalesEquiposGseView extends StatelessWidget {
//   final ServiciosAle servicioAdicional;
//   const _ServiciosAdicionalesEquiposGseView({required this.servicioAdicional});

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

//         _ListadoMaquinariasConTiempoViewServiciosAdicionales(
//           maquinarias: servicioAdicional.maquinaria,
//         ),
//       ],
//     );
//   }
// }

// class _ListadoMaquinariasConTiempoViewServiciosAdicionales
//     extends ConsumerWidget {
//   final List<Maquinaria> maquinarias;
//   const _ListadoMaquinariasConTiempoViewServiciosAdicionales({
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
