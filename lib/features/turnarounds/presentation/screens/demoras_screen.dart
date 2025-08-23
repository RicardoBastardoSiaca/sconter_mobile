import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:turnaround_mobile/features/shared/widgets/widgets.dart';
import 'package:turnaround_mobile/features/turnarounds/domain/domain.dart';
import 'package:turnaround_mobile/features/turnarounds/presentation/providers/providers.dart';

import '../../../shared/shared.dart';

class DemorasScreen extends StatelessWidget {
  const DemorasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Demoras', style: Theme.of(context).textTheme.titleMedium),
        centerTitle: true,
      ),
      body: const _DemorasView(),
    );
  }
}

class _DemorasView extends ConsumerWidget {
  const _DemorasView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final turnaround = ref.watch(selectedTurnaroundProvider);
    // final controlActividades = ref.watch(controlActividadesProvider(turnaround!.id));
    final List<Demora> demoras = ref.watch(demorasProvider).demoras;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Agregar Demora:',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w400),
              ),
              ElevatedButton(
                // disable if isLoading
                onPressed: () async {
                  // TODO: passing selected servicios adicionales
                  // ref.read(selectedMaquinariasTaskProvider.notifier).state =
                  //     controlActividades?.serviciosAdicionales ?? [];
                  // tarea.maquinaria ?? [];

                  // await ref
                  //     .read(categoriasEquiposGseProvider.notifier)
                  //     .getCategoriasEquiposGse();

                  // Get Demoras
                  await ref
                      .read(demorasProvider.notifier)
                      .getDemorasByAirline(turnaround!.fkVuelo.fkAerolinea.id);
                  // await ref
                  //     .read(serviciosAdicionalesProvider.notifier)
                  //     .getServiciosAdicionales();
                  // if (response == null) return;
                  context.push('/asignar-demoras-screen');

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

          const SizedBox(height: 12),
          if (demoras.isEmpty)
            const Center(child: Text('No hay demoras registradas.')),
          if (demoras.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: demoras.length,
                itemBuilder: (context, index) {
                  final demora = demoras[index];
                  return _DemoraListTile(demora: demora, index: index);
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _DemoraListTile extends ConsumerWidget {
  const _DemoraListTile({super.key, required this.demora, required this.index});

  final Demora demora;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 1,
              child: Text(
                '${index + 1}',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            Flexible(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text(
                  //   "Identificador",
                  //   style: Theme.of(context).textTheme.bodySmall,
                  // ),
                  _demoraValueContainer(
                    context,
                    demora.identificador.toString(),
                    "Identificador",
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _demoraValueContainer(
                    context,
                    demora.hora.substring(0, 5),
                    "Tiempo",
                  ),
                ],
              ),
            ),
            // delete icon
            Flexible(
              flex: 1,
              child: IconButton(
                icon: const Icon(Icons.delete, color: Colors.grey),
                onPressed: () {
                  // Handle delete action
                  // show dialog to confirm delete
                  // showDialog(
                  //   context: context,
                  //   builder: (context) {
                  //     return AlertDialog(
                  //       title: const Text('Confirmar eliminación'),
                  //       content: const Text(
                  //         '¿Estás seguro de que deseas eliminar esta demora?',
                  //       ),
                  //       actions: [
                  //         // 2 buttons that take half of the screen width
                  //         TextButton(
                  //           onPressed: () {
                  //             Navigator.of(context).pop();
                  //           },
                  //           child: const Text('Cancelar'),
                  //         ),
                  //         TextButton(
                  //           onPressed: () {
                  //             // Perform delete action
                  //             Navigator.of(context).pop();
                  //           },
                  //           child: const Text('Eliminar'),
                  //         ),
                  //       ],
                  //     );
                  //   },
                  // );

                  CustomDialog.showConfirmationDialog(
                    context,
                    'Confirmar eliminación',
                    '¿Estás seguro de que deseas eliminar esta demora?',
                    'Eliminar',
                  ).then((confirmed) async {
                    if (confirmed) {
                      // Perform delete action
                      final SnackbarResponse response = await ref
                          .read(demorasProvider.notifier)
                          .eliminarDemoraTrc(demora.id);

                      // Show snackbar with response message
                      CustomSnackbar.showResponseSnackbar(
                        response.message,
                        response.success,
                        // ignore: use_build_context_synchronously
                        context,
                        isFixed: true,
                      );
                    }
                  });
                },
              ),
            ),
            // Expanded(
            //   child: ListTile(
            //     title: Text(demora.descripcion),
            //     subtitle: Text('Tiempo de demora: ${demora.hora}'),
            //     trailing: IconButton(
            //       icon: const Icon(Icons.delete, color: Colors.red),
            //       onPressed: () {
            //         // return ListTile(
            //         //   number list as leading
            //         //   leading: Text('${index + 1}'),
            //         //   leading: Icon(Icons.hourglass_empty, color: Colors.red),
            //         //   title: Text(demora.descripcion),
            //         //   subtitle: Text('Tiempo de demora: ${demora.hora}'),
            //         // );
            //       },
            //     ),
            //   ),
            // ),
          ],
        ),

        const SizedBox(height: 8),
      ],
    );
  }

  _demoraValueContainer(BuildContext context, String value, String label) {
    return Column(
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        Container(
          // took all horizontal available space
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(value, style: Theme.of(context).textTheme.titleMedium),
          ),
        ),
      ],
    );
  }
}

// class DemoraValueContainer extends StatelessWidget {
//   final String label;
//   final String value;
//   const DemoraValueContainer({
//     super.key,
//     required this.label,
//     required this.value,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Text(label, style: Theme.of(context).textTheme.bodyMedium),
//         Container(
//           padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//           margin: const EdgeInsets.symmetric(vertical: 2),
//           decoration: BoxDecoration(
//             color: Theme.of(context).colorScheme.secondaryContainer,
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Center(
//             child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
//           ),
//         ),
//       ],
//     );
//   }
// }
