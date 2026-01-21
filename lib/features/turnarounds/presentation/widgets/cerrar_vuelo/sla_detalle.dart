import 'package:flutter/material.dart';

import '../../../domain/entities/entities.dart';

class SlaDetalle extends StatelessWidget {
  final ControlActividades? controlActividades;
  final TurnaroundMain? turnaround;
  const SlaDetalle({super.key, this.controlActividades, this.turnaround});

  @override
  Widget build(BuildContext context) {
    return SlaDetalleView(controlActividades: controlActividades, turnaround: turnaround,);
  }
}

class SlaDetalleView extends StatelessWidget {
  final ControlActividades? controlActividades;
  final TurnaroundMain? turnaround;

  const SlaDetalleView({super.key, this.controlActividades, this.turnaround});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: 
      controlActividades?.sla == null ? const Text('No hay SLA asociados') :
      Column(
        children: [
          ...controlActividades!.sla!.asMap().entries.map((entry) {
            final index = entry.key;
            final sla = entry.value;
            return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  sla.aprobado 
                  ? const Icon(Icons.check_circle, color: Colors.green,)
                  : const Icon(Icons.cancel, color: Colors.red,),
                  const SizedBox(width: 4,),
                  Text('${index + 1}. ${sla.descripcion}', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18,),),
                ],
              ),
              // _rowView("Descripcion: ", sla.descripcion!),
              const SizedBox(height: 6,),
              _RowView("Tarea: ", sla.tareaNombre),
              const SizedBox(height: 4,),
              _RowView("Categoria: ", sla.categoria),
              const SizedBox(height: 4,),
              _RowView("Tiempo: ", sla.tiempo),
              const SizedBox(height: 4,),
              _RowView("Tiempos comparacion: ", sla.horaDeComparacion),
              const SizedBox(height: 4,),
              _RowView("Hora esperada: ", sla.horaOperacion),
              const SizedBox(height: 4,),
              _RowView("Hora operacion: ", sla.horaTarea),
              const SizedBox(height: 4,),
              _RowView("Diferencia: ", sla.resultado),
              const SizedBox(height: 16,),
              // const Divider(),
              // const SizedBox(height: 4,),
            ],
          );
          }),
        ],
      )
    );
  }
}
class _RowView extends StatelessWidget {
    final String label;
    final String value;
  const _RowView( this.label, this.value);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
    children: [
      Expanded(
        child: Text(label, style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                  fontSize: 20,
                )),
      ),
      // const Spacer(),
      Expanded(
        child: Text(value.trim().replaceAll(RegExp(r' \s+'), ' '), style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  fontSize: 18,
                )),
      ),
    ],
  );
  }
}
