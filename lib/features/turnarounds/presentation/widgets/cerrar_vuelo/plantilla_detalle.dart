import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/domain.dart';
import '../../providers/providers.dart';

class PlantillaDetalle extends StatelessWidget {
  final ControlActividades? controlActividades;
  final TurnaroundMain? turnaround;
  const PlantillaDetalle({super.key, this.controlActividades, this.turnaround});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: _PlantillaDetalleView());
  }
}

class _PlantillaDetalleView extends ConsumerWidget {
  final ControlActividades? controlActividades;
  final TurnaroundMain? turnaround;

  const _PlantillaDetalleView({this.controlActividades, this.turnaround});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    PlantillaDetalleState plantillaState = ref.watch(plantillaDetalleProvider);
    Plantilla? plantilla = plantillaState.plantilla;
    if (plantilla != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Nombre:', style: Theme.of(context).textTheme.bodySmall),
          // const SizedBox(height: 20),
          Text(
            plantilla.titulo,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              // color: Theme.of(context).colorScheme.primary,
            ),
          ),

          const SizedBox(height: 20),
          Text('Actividades:', style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 5),

          ...plantilla.actividad.asMap().entries.map((entry) {
            final indexAct = entry.key;
            final actividad = entry.value;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${indexAct+1}. ${actividad.titulo.toString()}', style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  // color: Theme.of(context).colorScheme.primary,
                  overflow: TextOverflow.ellipsis,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                _TareasView(tareas: actividad.tarea, turnaround: turnaround),
              ],
            );
          }),
        ],
      );
    } else {
      return Container();
    }
  }
}

class _TareasView extends StatelessWidget {
  final List<TareaPlantilla>? tareas;
  final TurnaroundMain? turnaround;
  const _TareasView({this.tareas, this.turnaround});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: tareas?.length ?? 0,
      itemBuilder: (context, index) {
        final tarea = tareas![index];
        return Row(
          children: [
            const SizedBox(width: 18),
            // const Icon(Icons.check, size: 16),
            Text(tarea.titulo, style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w400,
              // color: Theme.of(context).colorScheme.primary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        );
        // ListTile(
        //   dense: true,
        //   title: Text(tarea.titulo ?? ''),
        //   // subtitle: Column(
        //   //   crossAxisAlignment: CrossAxisAlignment.start,
        //   //   children: [
        //   //     if (tarea.descripcion != null) Text('Descripción: ${tarea.descripcion}'),
        //   //     if (tarea.tipoTarea != null) Text('Tipo de Tarea: ${tarea.tipoTarea}'),
        //   //     if (tarea.departamento != null) Text('Departamento: ${tarea.departamento}'),
        //   //     if (tarea.demora != null) Text('Demora Estimada: ${tarea.demora} mins'),
        //   //   ],
        //   // ),
        // );
      },
    );
  }
}
