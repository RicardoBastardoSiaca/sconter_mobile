import 'package:flutter/material.dart';


class LeyendaColoresTurnarounds extends StatelessWidget {
  const LeyendaColoresTurnarounds({super.key});

  @override
  Widget build(BuildContext context) {
    // Definición de los datos de la leyenda
    final List<Map<String, dynamic>> legendItems = [
      {'text': 'No Abierto', 'color': Colors.white, 'borderColor': Colors.black54},
      {'text': 'En Proceso', 'color': Colors.yellow},
      {'text': 'Finalizado', 'color': Colors.green},
      {'text': 'Cerrado', 'color': Colors.blue},
      {'text': 'Aprobado', 'color': Colors.grey},
      {'text': 'Rechazado', 'color': Colors.red},
      {'text': 'Cancelado con ingreso', 'color': Colors.orange},
      // {'text': 'Cancelado', 'color': Colors.black12, 'description': 'No se usa el color null, se usa un gris muy claro o un color de fondo si no se requiere destacar.'},
      // {'text': 'Eliminado', 'color': Colors.black12, 'description': 'No se usa el color null, se usa un gris muy claro o un color de fondo si no se requiere destacar.'},
    ];

    return Container(
      padding: const EdgeInsets.only(
        left: 4.0,
        right: 4.0,
        top: 2.0,
        bottom: 4.0,
      ),
      // decoration: BoxDecoration(
      //   border: Border.lerp(
      //     Border.all(color: Colors.black12),
      //     Border.all(color: Colors.transparent),
      //     0.5,
      //   ),
      //   // (color: Colors.black12),
      //   borderRadius: BorderRadius.circular(8.0),
      // ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Ajusta la columna al contenido
        crossAxisAlignment: CrossAxisAlignment.start,
        children: legendItems.map((item) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Indicador de color
                Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                    color: item['color'] as Color,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: item['borderColor'] as Color? ?? Colors.black26, // Borde para distinguir colores muy claros (como blanco y los null simulados)
                      width: 1.0,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Texto de la leyenda
                Text(
                  '${item['text']}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}