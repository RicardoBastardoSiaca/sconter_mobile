import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../domain/domain.dart';

class ServiciosDetalle extends StatelessWidget {
  final ControlActividades? controlActividades;
  final TurnaroundMain? turnaround;
  const ServiciosDetalle({super.key, this.controlActividades, this.turnaround});

  @override
  Widget build(BuildContext context) {
    return ServiciosDetalleView(controlActividades: controlActividades, turnaround: turnaround,);
  }
}

class ServiciosDetalleView extends StatelessWidget {
  final ControlActividades? controlActividades;
  final TurnaroundMain? turnaround;
  const ServiciosDetalleView({
    super.key,
    this.controlActividades,
    this.turnaround,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ServiciosAdicionalesView(
            controlActividades: controlActividades,
            turnaround: turnaround,
          ),
          SizedBox(height: 20,),
          _ServiciosEspecialesView(controlActividades: controlActividades, turnaround: turnaround,)
        ],
      ),
    );
  }
}

class _ServiciosEspecialesView extends StatelessWidget {
  final ControlActividades? controlActividades;
  final TurnaroundMain? turnaround;
  const _ServiciosEspecialesView({
    this.controlActividades,
    this.turnaround,
  });

  @override
  Widget build(BuildContext context) {
   final theme = Theme.of(context);
   if (controlActividades == null) {
      return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(child: Text('Servicios especiales', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.primary),)),
        const SizedBox(height: 8,),
        const Text('No hay servicios especiales')
      ],
    );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(child: Text('Servicios especiales', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.primary),)),
        const SizedBox(height: 8,),
        controlActividades!.serviciosEspeciales!.isEmpty
            ? Text('No hay servicios especiales')
            : const SizedBox(),
        ...controlActividades!.serviciosEspeciales!.asMap().entries.map((
          entry,
        ) {
          final index = entry.key;
          final servicio = entry.value;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${index + 1}. ${servicio.titulo}', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),),
              // _horaRowView(servicio.horaInicio, 'Hora Inicio'),
              // _horaRowView(servicio.horaFin, 'Hora Fin'),
_cantidadRowView(servicio.cantidad, 'Cantidad'),
              servicio.comentario == null ? const SizedBox() : 
              _comentarioRowView(servicio.comentario, 'Comentario'),
              SizedBox(height: 8,),

              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 16.0,),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Text('Maquinarias: '),
              // ...(servicio.maquinaria.asMap().entries.map((entry) {
              //   final index = entry.key;
              //   final maquinaria = entry.value;
              //   return Padding(
              //     padding: const EdgeInsets.symmetric(horizontal: 16.0),
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         const SizedBox(height: 4,),
              //         Text(maquinaria.maquinariaModelo),
              //         _horaRowView(maquinaria.horaInicio, 'Hora Inicio: '),
              //         _horaRowView(maquinaria.horaFin, 'Hora Fin: '),
              //       ],
              //     ),
              //   );
              // }))
              //     ],
              //   ),
              // ),
              // _horaRowView(servicio['hora_fin'] == null ? null : DateTime.parse(servicio['hora_fin']), 'Hora Fin: '),
            ],
          );
          // return _ServicioAdicionalView(controlActividades: controlActividades, turnaround: turnaround,);
        }),
      ],
    );
  }
}
class _ServiciosAdicionalesView extends StatelessWidget {
  final ControlActividades? controlActividades;
  final TurnaroundMain? turnaround;
  const _ServiciosAdicionalesView({
    this.controlActividades,
    this.turnaround,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (controlActividades == null) {
      return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(child: Text('Servicios especiales', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.primary),)),
        const SizedBox(height: 8,),
        const Text('No hay servicios especiales')
      ],
    );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(child: Text('Servicios adicionales', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.primary),)),
        const SizedBox(height: 8,),
        (controlActividades == null || controlActividades!.serviciosAdicionales!.isEmpty)
            ? Text('No hay servicios adicionales')
            : const SizedBox(),
         ...controlActividades!.serviciosAdicionales!.asMap().entries.map((
          entry,
        ) {
          final index = entry.key;
          final servicio = entry.value;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${index + 1}. ${servicio.titulo}', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),),
              _horaRowView(servicio.horaInicio, 'Hora Inicio'),
              _horaRowView(servicio.horaFin, 'Hora Fin'),
              // _cantidadRowView(servicio.cantidad, 'Cantidad'),
              // _comentarioRowView(servicio.comentario, 'Comentario'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0,),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Maquinarias: '),
              ...(servicio.maquinaria.asMap().entries.map((entry) {
                final index = entry.key;
                final maquinaria = entry.value;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4,),
                      Text(maquinaria.maquinariaModelo),
                      _horaRowView(maquinaria.horaInicio, 'Hora Inicio: '),
                      _horaRowView(maquinaria.horaFin, 'Hora Fin: '),
                    ],
                  ),
                );
              }))
                  ],
                ),
              
              
              ),
              // _horaRowView(servicio['hora_fin'] == null ? null : DateTime.parse(servicio['hora_fin']), 'Hora Fin: '),
            ],
          );
          // return _ServicioAdicionalView(controlActividades: controlActividades, turnaround: turnaround,);
        }),
      ],
    );
  }
}

class _ServicioAdicionalView extends StatelessWidget {
  final ControlActividades? controlActividades;
  final TurnaroundMain? turnaround;
  const _ServicioAdicionalView({
    this.controlActividades, this.turnaround,
  });

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

Padding _horaRowView(DateTime? hora, String label) {
  final timeFormat = DateFormat('HH:mm');
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
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
          child: Text(hora == null ? '' : timeFormat.format(hora), style: const TextStyle(fontWeight: FontWeight.bold),),
        ),
      ],
    ),
  );
}



Padding _cantidadRowView(int? cantidad, String label) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
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
          child: Text(cantidad?.toString() ?? '', style: const TextStyle(fontWeight: FontWeight.bold),),
        ),
      ],
    ),
  );
}

// comentarios
Padding _comentarioRowView(String? comentario, String label) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              // take all available space
              // width: double.maxFinite,
              // margin: const EdgeInsets.only(left: 8),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              constraints: const BoxConstraints(minWidth: 240),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(comentario?.toString() ?? '', style: const TextStyle(fontWeight: FontWeight.bold),),
            ),
          ],
        ),
      ],
    ),
  );
}
