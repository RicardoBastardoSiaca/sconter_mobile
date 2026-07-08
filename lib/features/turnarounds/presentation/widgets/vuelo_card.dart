import 'package:flutter/material.dart';
import 'package:scounter_mobile/features/turnarounds/domain/domain.dart';
import 'package:scounter_mobile/features/turnarounds/presentation/widgets/widgets.dart';

class VueloCard extends StatelessWidget {
  final VueloCalendario vuelo;

  const VueloCard({super.key, required this.vuelo});

  // En vuelo_card.dart
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Disparamos el diálogo pasando el contexto y el objeto del vuelo seleccionado
        showDialog(
          context: context,
          builder: (BuildContext context) => VueloDetalleDialog(vuelo: vuelo),
        );
      },
      child: Container(
        // ... decoración igual ...
        decoration: BoxDecoration(
          // Usamos el color que viene del backend o uno por defecto
          color: _parseColor(vuelo.estatusColor).withOpacity(0.8),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black26),
        ),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Text(
          // "${vuelo.numeroVuelo} | ${vuelo.lugarSalidaIata}-${vuelo.lugarDestinoIata}",
          vuelo.numeroVuelo,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 10.5, // Subió de 8.5 a 10.5
            color: Colors.black87,
            height: 1.0, // Evita que la fuente "empuje" los bordes del contenedor
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Color _parseColor(String? colorString) {
    if (colorString == null || colorString.isEmpty) return Colors.blue;

    // 1. Diccionario para nombres de colores comunes que envía el backend
    final Map<String, Color> coloresNombrados = {
      'verde': Colors.green,
      'rojo': Colors.red,
      'azul': Colors.blue,
      'amarillo': Colors.yellow,
      'naranja': Colors.orange,
      'gris': Colors.grey,
      'morado': Colors.purple,
      // Agrega aquí otros que use tu backend
      'blanco': Colors.white,
    };

    // Limpiamos el string (quitar espacios y poner en minúsculas)
    final String cleanColor = colorString.trim().toLowerCase();

    // 2. Si es un nombre conocido, lo devolvemos
    if (coloresNombrados.containsKey(cleanColor)) {
      return coloresNombrados[cleanColor]!;
    }

    // 3. Si no es nombre, intentamos procesarlo como Hexadecimal
    try {
      String hex = cleanColor.replaceAll('#', '');
      if (hex.length == 6) hex = 'FF$hex'; // Añadir opacidad si no la trae
      return Color(int.parse(hex, radix: 16));
    } catch (e) {
      // Si falla todo, devolvemos un color por defecto para no romper la app
      return Colors.grey;
    }
  }
}
