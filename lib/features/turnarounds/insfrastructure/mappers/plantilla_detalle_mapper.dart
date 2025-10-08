import 'package:flutter/material.dart';

import '../../domain/domain.dart';

class PlantillaDetalleMapper {
  static Plantilla mapJsonToPlantillaDetalle(Map<String, dynamic> json) {
    return Plantilla.fromJson(json);
  }
}
