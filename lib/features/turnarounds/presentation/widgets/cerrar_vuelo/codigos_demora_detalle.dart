import 'package:flutter/material.dart';

import '../../../domain/domain.dart';

class CodigosDemoraDetalle extends StatelessWidget {
  final List<Demora> demoras ;
  const CodigosDemoraDetalle({
    super.key, required this.demoras,
  });

  @override
  Widget build(BuildContext context) {
    return CodigosDemoraDetalleView(
      demoras: demoras,
    );
  }
}

class CodigosDemoraDetalleView extends StatelessWidget {
  final List<Demora> demoras ;
  const CodigosDemoraDetalleView({
    super.key, required this.demoras,
    
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: 
      demoras.isEmpty ? const Center(child: Text('No hay demoras')) : 
      Column(
        children: [

          ...demoras.asMap().entries.map((entry) {
            final index = entry.key;
            final demora = entry.value;
            return _DemoraListTile(demora: demora, index: index);
          })
          // Expanded(
          //   child: ListView.builder(
          //     itemCount: demoras.length,
          //     itemBuilder: (context, index) {
          //       final demora = demoras[index];
          //       return _DemoraListTile(demora: demora, index: index);
          //     },
          //   ),
          // ),
        
        ],
      ),
    );
  }
}

class _DemoraListTile extends StatelessWidget {
  const _DemoraListTile({required this.demora, required this.index});

  final Demora demora;
  final int index;

  @override
  Widget build(BuildContext context) {
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
            // Flexible(
            //   flex: 1,
            //   child: IconButton(
            //     icon: const Icon(Icons.delete, color: Colors.grey),
            //     onPressed: () {
            //       // Handle delete action
            //       // show dialog to confirm delete
            //       // showDialog(
            //       //   context: context,
            //       //   builder: (context) {
            //       //     return AlertDialog(
            //       //       title: const Text('Confirmar eliminación'),
            //       //       content: const Text(
            //       //         '¿Estás seguro de que deseas eliminar esta demora?',
            //       //       ),
            //       //       actions: [
            //       //         // 2 buttons that take half of the screen width
            //       //         TextButton(
            //       //           onPressed: () {
            //       //             Navigator.of(context).pop();
            //       //           },
            //       //           child: const Text('Cancelar'),
            //       //         ),
            //       //         TextButton(
            //       //           onPressed: () {
            //       //             // Perform delete action
            //       //             Navigator.of(context).pop();
            //       //           },
            //       //           child: const Text('Eliminar'),
            //       //         ),
            //       //       ],
            //       //     );
            //       //   },
            //       // );

            //       CustomDialog.showConfirmationDialog(
            //         context,
            //         'Confirmar eliminación',
            //         '¿Estás seguro de que deseas eliminar esta demora?',
            //         'Eliminar',
            //       ).then((confirmed) async {
            //         if (confirmed) {
            //           // Perform delete action
            //           final SnackbarResponse response = await ref
            //               .read(demorasProvider.notifier)
            //               .eliminarDemoraTrc(demora.id);

            //           // Show snackbar with response message
            //           CustomSnackbar.showResponseSnackbar(
            //             response.message,
            //             response.success,
            //             // ignore: use_build_context_synchronously
            //             context,
            //             isFixed: true,
            //           );
            //         }
            //       });
            //     },
            //   ),
            // ),

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
