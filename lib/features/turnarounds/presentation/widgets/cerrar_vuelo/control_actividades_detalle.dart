import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../config/config.dart';
import '../../../domain/domain.dart';
import '../../providers/providers.dart';
import '../widgets.dart';

class ControlActividadesDetalle extends StatelessWidget {
  final ControlActividades? controlActividades;
  final TurnaroundMain? turnaround;
  const ControlActividadesDetalle({
    super.key,
    this.controlActividades,
    this.turnaround,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: _ControlActividadesView(
        controlActividades: controlActividades,
        turnaround: turnaround,
      ),
    );
  }
}

class _ControlActividadesView extends StatelessWidget {
  final ControlActividades? controlActividades;
  final TurnaroundMain? turnaround;
  const _ControlActividadesView({this.controlActividades, this.turnaround});

  @override
  Widget build(BuildContext context) {
    // map gerencias to a list of widgets
    final departamentos = controlActividades?.departamentos ?? [];
    return Column(
      children: [
        // map departamentos to a list of widgets with indexed widgets
        ...departamentos.asMap().entries.map((entry) {
          final indexDep = entry.key;
          final departamento = entry.value;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  departamento.nombreArea.toString(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              _ActividadesView(
                actividades: departamento.actividades,
                turnaround: turnaround,
              ),
            ],
          );
        }),
      ],
    );
  }
}

class _ActividadesView extends StatelessWidget {
  final List<Actividades>? actividades;
  final TurnaroundMain? turnaround;
  const _ActividadesView({this.actividades, this.turnaround});

  @override
  Widget build(BuildContext context) {
    return Column(
      // map actividades with index
      children: actividades!.asMap().entries.map((entry) {
        final indexAct = entry.key;
        final actividad = entry.value;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('${indexAct + 1}. ',
                overflow: TextOverflow.ellipsis, 
                style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary )),
                Text(actividad.nombreActividad.toString()),
              ],
            ),
            const SizedBox(height: 4),
            _TareasView(tareas: actividad.tareas, turnaround: turnaround, indexAct: indexAct),
          ],
        );
      }).toList(),
    );
  }
}

class _TareasView extends StatelessWidget {
  final List<Tarea>? tareas;
  final int indexAct;
  final TurnaroundMain? turnaround;
  const _TareasView({this.tareas, this.turnaround, required this.indexAct});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Column(
        children: [
          const SizedBox(height: 4),
          ...tareas!.asMap().entries.map((entry) {
            final indexTar = entry.key;
            final tarea = entry.value;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                switch (tarea.tipoId) {
                  2 => _TareaHoraView(tarea: tarea, indexTar: indexTar, indexAct: indexAct),
                  3 => _TareaHoraInicioFinView(
                    tarea: tarea,
                    indexTar: indexTar, indexAct: indexAct,
                  ),
                  1 => _TareaCantidadView(tarea: tarea, indexTar: indexTar, indexAct: indexAct),
                  4 => _TareaMaquinariaSinTiempoView(
                    tarea: tarea,
                    indexTar: indexTar, indexAct: indexAct,
                  ),
                  5 => _TareaMaquinariaConTiempoView(
                    tarea: tarea,
                    indexTar: indexTar, indexAct: indexAct,
                  ),
                  6 => _TareaTextoView(tarea: tarea, indexTar: indexTar, indexAct: indexAct),
                  7 => _TareaPasajerosView(
                    tarea: tarea,
                    turnaround: turnaround,
                    indexTar: indexTar, indexAct: indexAct,
                  ),
                  8 => _TareaExcesoEquipajeView(
                    tarea: tarea,
                    indexTar: indexTar, indexAct: indexAct,
                  ),
                  9 => _TareaITView(tarea: tarea, indexTar: indexTar, indexAct: indexAct),
                  10 => _TareaLimpiezaView(tarea: tarea, indexTar: indexTar, indexAct: indexAct),
                  // Default case
                  _ => _TareaHoraView(tarea: tarea, indexTar: indexTar, indexAct: indexAct),
                },
                // Image list display
                _TareaImagenView(tarea: tarea, indexTar: indexTar),

                _ComentarioView(tarea: tarea, indexTar: indexTar),

                // Divider
                Divider(thickness: 0.7, color: Colors.grey.shade400),
                
                const SizedBox(height: 10),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class _TareaHoraView extends StatelessWidget {
  final Tarea tarea;
  final int indexTar;
  final int indexAct;
  const _TareaHoraView({required this.tarea, required this.indexTar, required this.indexAct});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${indexAct + 1}.${indexTar + 1}. ${tarea.titulo}'),
        // Text('- ${tarea.titulo}'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: _horaRowView(tarea.horaInicio, 'Hora: '),
        ),
      ],
    );
  }
}

Padding _horaRowView(DateTime? hora, String label) {
  final timeFormat = DateFormat('HH:mm');
  return Padding(
    padding: const EdgeInsets.all(4.0),
    child: Row(
      children: [
        Text(label),
        Container(
          margin: const EdgeInsets.only(left: 8),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          constraints: const BoxConstraints(minWidth: 60),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            hora == null ? '' : timeFormat.format(hora),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    ),
  );
}

class _TareaHoraInicioFinView extends StatelessWidget {
  final Tarea tarea;
  final int indexTar;
  final int indexAct;
  const _TareaHoraInicioFinView({required this.tarea, required this.indexTar, required this.indexAct});

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('HH:mm');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${indexAct + 1}.${indexTar + 1}. ${tarea.titulo}'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              _horaRowView(tarea.horaInicio, 'Hora Inicio: '),
              _horaRowView(tarea.horaFin, 'Hora Fin: '),
            ],
          ),
        ),
      ],
    );
  }
}

class _TareaCantidadView extends StatelessWidget {
  final Tarea tarea;
  final int indexTar;
  final int indexAct;
  const _TareaCantidadView({required this.tarea, required this.indexTar, required this.indexAct});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('${indexAct + 1}.${indexTar + 1}. ${tarea.titulo}'),
        Row(
          children: [
            Text('Cantidad: '),
            Container(
              margin: const EdgeInsets.only(left: 8),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              constraints: const BoxConstraints(minWidth: 60),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(tarea.numero?.toString() ?? ''),
            ),
          ],
        ),
      ],
    );
  }
}

class _TareaMaquinariaSinTiempoView extends StatelessWidget {
  final Tarea tarea;
  final int indexTar;
  final int indexAct;
  const _TareaMaquinariaSinTiempoView({
    required this.tarea,
    required this.indexTar,
    required this.indexAct,
  });

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('HH:mm');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${indexAct + 1}.${indexTar + 1}. ${tarea.titulo}'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // _horaRowView(tarea.horaInicio, 'Hora Inicio: '),
              // _horaRowView(tarea.horaFin, 'Hora Fin: '),
              Text('Maquinarias: '),
              ...(tarea.maquinaria?.asMap().entries.map((entry) {
                    final index = entry.key;
                    final maquinaria = entry.value;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${index + 1}. ${maquinaria['maquinaria_modelo']}',
                          ),
                          _horaRowView(
                            maquinaria['hora_inicio'] == null
                                ? null
                                : DateTime.parse(maquinaria['hora_inicio']),
                            'Hora Inicio: ',
                          ),
                          _horaRowView(
                            maquinaria['hora_fin'] == null
                                ? null
                                : DateTime.parse(maquinaria['hora_fin']),
                            'Hora Fin: ',
                          ),
                        ],
                      ),
                    );
                  }).toList() ??
                  []),
            ],
          ),
        ),
      ],
    );
  }
}

class _TareaMaquinariaConTiempoView extends StatelessWidget {
  final Tarea tarea;
  final int indexTar;
  final int indexAct;
  const _TareaMaquinariaConTiempoView({
    required this.tarea,
    required this.indexTar,
    required this.indexAct,
  });

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('HH:mm');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${indexAct + 1}.${indexTar + 1}. ${tarea.titulo}'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _horaRowView(tarea.horaInicio, 'Hora Inicio: '),
              _horaRowView(tarea.horaFin, 'Hora Fin: '),
              Text('Maquinarias: '),
              ...(tarea.maquinaria?.asMap().entries.map((entry) {
                    final index = entry.key;
                    final maquinaria = entry.value;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${index + 1}. ${maquinaria['maquinaria_modelo']}',
                          ),
                          _horaRowView(
                            maquinaria['hora_inicio'] == null
                                ? null
                                : DateTime.parse(maquinaria['hora_inicio']),
                            'Hora Inicio: ',
                          ),
                          _horaRowView(
                            maquinaria['hora_fin'] == null
                                ? null
                                : DateTime.parse(maquinaria['hora_fin']),
                            'Hora Fin: ',
                          ),
                        ],
                      ),
                    );
                  }).toList() ??
                  []),
            ],
          ),
        ),
      ],
    );
  }
}

class _TareaTextoView extends StatelessWidget {
  final Tarea tarea;
  final int indexTar;
  final int indexAct;
  const _TareaTextoView({required this.tarea, required this.indexTar, required this.indexAct});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${indexAct + 1}.${indexTar + 1}. ${tarea.titulo}'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(tarea.texto ?? ''),
        ),
      ],
    );
  }
}

class _TareaPasajerosView extends StatelessWidget {
  final Tarea tarea;
  final TurnaroundMain? turnaround;
  final int indexTar;
  final int indexAct;
  const _TareaPasajerosView({
    required this.tarea,
    this.turnaround,
    required this.indexTar,
    required this.indexAct,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('${indexAct + 1}.${indexTar + 1}. ${tarea.titulo}'),
        // if (turnaround?.fkVuelo.tipoServicio.id != 3)
          // Llegada
        _PasajerosRowView(tarea: tarea),

        const Divider(thickness: 1),

        // if (turnaround?.fkVuelo.tipoServicio.id != 4)
        //   // Salida
        //   _SalidaPasajeroView(tarea: tarea),

        // if (turnaround?.fkVuelo.tipoServicio.id != 4)
        //   // Transito
        //   _TransitoPasajerosView(tarea: tarea),

        // if (turnaround?.fkVuelo.tipoServicio.id != 4)
        //   // Inadmitidos
        //   _InadmitidosPasajerosView(tarea: tarea),

        // if (turnaround?.fkVuelo.tipoServicio.id != 4)
        //   const Divider(thickness: 1),

        // if (turnaround?.fkVuelo.tipoServicio.id != 4)
        //   // total
        //   _TotalPasajerosView(tarea: tarea),

        // SizedBox(height: 8),
      ],
    );
  }
}

class _TareaExcesoEquipajeView extends StatelessWidget {
  final Tarea tarea;
  final int indexTar;
  final int indexAct;
  const _TareaExcesoEquipajeView({required this.tarea, required this.indexTar, required this.indexAct});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${indexAct + 1}.${indexTar + 1}. ${tarea.titulo}'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Text('Exceso de equipaje: '),
              Container(
                margin: const EdgeInsets.only(left: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                constraints: const BoxConstraints(minWidth: 60),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(tarea.numero?.toString() ?? ''),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TareaITView extends StatelessWidget {
  final Tarea tarea;
  final int indexTar;
  final int indexAct;
  const _TareaITView({required this.tarea, required this.indexTar, required this.indexAct});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${indexAct + 1}.${indexTar + 1}. ${tarea.titulo}'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(tarea.texto ?? ''),
        ),
      ],
    );
  }
}

class _TareaLimpiezaView extends StatelessWidget {
  final Tarea tarea;
  final int indexTar;
  final int indexAct;
  const _TareaLimpiezaView({required this.tarea, required this.indexTar, required this.indexAct});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${indexAct + 1}.${indexTar + 1}. ${tarea.titulo}'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(tarea.texto ?? ''),
        ),
      ],
    );
  }
}

class _PasajerosRowView extends StatelessWidget {
  const _PasajerosRowView({required this.tarea});

  final Tarea tarea;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // half width
        // Flexible(flex: 3, child: Text('Total de pasajeros:')),
        Flexible(
          flex: 6,
          child: Row(
            children: [
              Expanded(
                child: PasajerosBoxContainer(
                  clase: 'C',
                  cantidad: tarea.pasajeros!.ejecutivo,
                ),
              ),
              Expanded(
                child: PasajerosBoxContainer(
                  clase: 'Y',
                  cantidad: tarea.pasajeros!.economica,
                ),
              ),
              Expanded(
                child: PasajerosBoxContainer(
                  clase: 'I',
                  cantidad: tarea.pasajeros!.infante,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
// class _LlegadaPasajerosView extends StatelessWidget {
//   const _LlegadaPasajerosView({required this.tarea});

//   final Tarea tarea;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         // half width
//         Flexible(flex: 3, child: Text('Llegada:')),
//         Flexible(
//           flex: 6,
//           child: Row(
//             children: [
//               Expanded(
//                 child: PasajerosBoxContainer(
//                   clase: 'C',
//                   cantidad: tarea.pasajeros!['llegada_ejecutivo']!,
//                 ),
//               ),
//               Expanded(
//                 child: PasajerosBoxContainer(
//                   clase: 'Y',
//                   cantidad: tarea.pasajeros!['llegada_economica']!,
//                 ),
//               ),
//               Expanded(
//                 child: PasajerosBoxContainer(
//                   clase: 'I',
//                   cantidad: tarea.pasajeros!['llegada_infante']!,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _InadmitidosPasajerosView extends StatelessWidget {
//   const _InadmitidosPasajerosView({required this.tarea});

//   final Tarea tarea;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         // half width
//         Flexible(flex: 3, child: Text('Inadmitidos:')),
//         Flexible(
//           flex: 6,
//           child: Row(
//             children: [
//               Expanded(
//                 child: PasajerosBoxContainer(
//                   clase: 'C',
//                   cantidad: tarea.pasajeros!['inadmitidos_ejecutivo']!,
//                 ),
//               ),
//               Expanded(
//                 child: PasajerosBoxContainer(
//                   clase: 'Y',
//                   cantidad: tarea.pasajeros!['inadmitidos_economica']!,
//                 ),
//               ),
//               Expanded(
//                 child: PasajerosBoxContainer(
//                   clase: 'I',
//                   cantidad: tarea.pasajeros!['inadmitidos_infante']!,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _TransitoPasajerosView extends StatelessWidget {
//   const _TransitoPasajerosView({required this.tarea});

//   final Tarea tarea;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         // half width
//         Flexible(flex: 3, child: Text('Transito:')),
//         Flexible(
//           flex: 6,
//           child: Row(
//             children: [
//               Expanded(
//                 child: PasajerosBoxContainer(
//                   clase: 'C',
//                   cantidad: tarea.pasajeros!['transito_ejecutivo']!,
//                 ),
//               ),
//               Expanded(
//                 child: PasajerosBoxContainer(
//                   clase: 'Y',
//                   cantidad: tarea.pasajeros!['transito_economica']!,
//                 ),
//               ),
//               Expanded(
//                 child: PasajerosBoxContainer(
//                   clase: 'I',
//                   cantidad: tarea.pasajeros!['transito_infante']!,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _SalidaPasajeroView extends StatelessWidget {
//   const _SalidaPasajeroView({required this.tarea});

//   final Tarea tarea;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         // half width
//         Flexible(flex: 3, child: Text('Salida:')),
//         Flexible(
//           flex: 6,
//           child: Row(
//             children: [
//               Expanded(
//                 child: PasajerosBoxContainer(
//                   clase: 'C',
//                   cantidad: tarea.pasajeros!['salida_ejecutivo']!,
//                 ),
//               ),
//               Expanded(
//                 child: PasajerosBoxContainer(
//                   clase: 'Y',
//                   cantidad: tarea.pasajeros!['salida_economica']!,
//                 ),
//               ),
//               Expanded(
//                 child: PasajerosBoxContainer(
//                   clase: 'I',
//                   cantidad: tarea.pasajeros!['salida_infante']!,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _TotalPasajerosView extends StatelessWidget {
//   const _TotalPasajerosView({required this.tarea});

//   final Tarea tarea;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         // half width
//         Flexible(flex: 3, child: Text('Total:')),
//         Flexible(
//           flex: 6,
//           child: Row(
//             children: [
//               Expanded(
//                 child: PasajerosBoxContainer(
//                   clase: 'C',
//                   // total pasajeros = salida + transito - inadmitidos
//                   cantidad:
//                       tarea.pasajeros!['salida_ejecutivo']! +
//                       tarea.pasajeros!['transito_ejecutivo']! -
//                       tarea.pasajeros!['inadmitidos_ejecutivo']!,
//                 ),
//               ),
//               Expanded(
//                 child: PasajerosBoxContainer(
//                   clase: 'Y',
//                   cantidad:
//                       tarea.pasajeros!['salida_economica']! +
//                       tarea.pasajeros!['transito_economica']! -
//                       tarea.pasajeros!['inadmitidos_economica']!,
//                 ),
//               ),
//               Expanded(
//                 child: PasajerosBoxContainer(
//                   clase: 'I',
//                   cantidad:
//                       tarea.pasajeros!['salida_infante']! +
//                       tarea.pasajeros!['transito_infante']! -
//                       tarea.pasajeros!['inadmitidos_infante']!,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

class _TareaImagenView extends StatelessWidget {
  final Tarea tarea;
  final int indexTar;
  const _TareaImagenView({required this.tarea, required this.indexTar});

  @override
  Widget build(BuildContext context) {
    return tarea.imagen == null || tarea.imagen!.isEmpty
        ? const SizedBox.shrink()
        : Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Imágenes:',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  // Camera icon
                  // Row(
                  //   // mainAxisAlignment: MainAxisAlignment.start,
                  //   children: [
                  //     ElevatedButton(
                  //       // disable if isLoading
                  //       onPressed: () async {
                  //         final photoPath = await CameraGalleryServiceImpl()
                  //             .selectPhoto();

                  //         if (photoPath == null) {
                  //           return;
                  //         }

                  //         // add image to tarea provider
                  //         // ref.read(controlActividadesProvider(trcId).notifier)
                  //         //     .addImage(photoPath);

                  //         // Upload image
                  //         final response = await ref
                  //             .read(controlActividadesProvider(trcId).notifier)
                  //             .uploadImage(photoPath, tarea.id);

                  //         if (response == null) {
                  //           return;
                  //         }
                  //         // Show snackbar response
                  //         CustomSnackbar.showResponseSnackbar(
                  //           response.message,
                  //           response.success,
                  //           // ignore: use_build_context_synchronously
                  //           context,
                  //           isFixed: true,
                  //         );
                  //       },
                  //       style: ElevatedButton.styleFrom(
                  //         shape: CircleBorder(),
                  //         padding: EdgeInsets.all(5),
                  //         fixedSize: const Size(45, 45),
                  //         backgroundColor: Theme.of(
                  //           context,
                  //         ).colorScheme.primary, // <-- Button color
                  //         foregroundColor: Colors.red, // <-- Splash color
                  //       ),
                  //       child: Icon(
                  //         Icons.photo_library_outlined,
                  //         color: Colors.white,
                  //         size: 35,
                  //       ),
                  //     ),
                  //     ElevatedButton(
                  //       // disable if isLoading
                  //       onPressed: () async {
                  //         final photoPath = await CameraGalleryServiceImpl()
                  //             .takePhoto();

                  //         if (photoPath == null) {
                  //           return;
                  //         }

                  //         // Upload image
                  //         final response = await ref
                  //             .read(controlActividadesProvider(trcId).notifier)
                  //             .uploadImage(photoPath, tarea.id);

                  //         if (response == null) {
                  //           return;
                  //         }
                  //         // Show snackbar response
                  //         CustomSnackbar.showResponseSnackbar(
                  //           response.message,
                  //           response.success,
                  //           // ignore: use_build_context_synchronously
                  //           context,
                  //           isFixed: true,
                  //         );
                  //       },
                  //       style: ElevatedButton.styleFrom(
                  //         shape: CircleBorder(),
                  //         padding: EdgeInsets.all(5),
                  //         fixedSize: const Size(45, 45),
                  //         backgroundColor: Theme.of(
                  //           context,
                  //         ).colorScheme.primary, // <-- Button color
                  //         foregroundColor: Colors.red, // <-- Splash color
                  //       ),
                  //       child: Icon(
                  //         Icons.camera_alt_outlined,
                  //         color: Colors.white,
                  //         size: 35,
                  //       ),
                  //     ),
                  //   ],
                  // ),
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
                        // context.push('/image-fullscreen-carousel');

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

class _ComentarioView extends ConsumerWidget {
  final Tarea tarea;
  final int indexTar;
  const _ComentarioView({required this.tarea, required this.indexTar});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextEditingController textController = TextEditingController();

    return tarea.comentario == null || tarea.comentario!.isEmpty
        ? Container()
        : Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Comentarios:',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
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
