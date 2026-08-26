import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:scounter_mobile/features/turnarounds/domain/domain.dart';

Color obtenerColorPorEstatus(VueloCalendario item) {
  final colorNombre = item.estatusColor?.toLowerCase().trim() ?? '';

  switch (colorNombre) {
    case 'verde':
      return const Color(0xFF81C784); // Verde claro / Finalizado

    case 'amarillo':
      return const Color(0xFFFFF176); // Amarillo / En Proceso

    case 'naranja':
      return const Color(0xFFFFB74D); // Naranja / Demorado

    case 'rojo':
      return const Color(0xFFE57373); // Rojo / Cancelado

    case 'azul':
      return const Color(0xFF64B5F6); // Azul / Programado

    case 'gris':
      return const Color(0xFFE0E0E0); // Gris / Sin datos

    case 'blanco':
      return Colors.white;

    default:
      // Si estatusColor viene nulo o no coincide, asigna el verde por defecto
      return const Color(0xFFAED581);
  }
}