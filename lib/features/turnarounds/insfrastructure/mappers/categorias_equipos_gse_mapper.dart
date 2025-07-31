import '../../domain/domain.dart';

class CategoriasEquiposGseMapper {
  static CategoriasEquiposGseResponse mapJsonToCategoriasEquiposGse(
    Map<String, dynamic> json,
  ) {
    return CategoriasEquiposGseResponse(
      // categoriasEquiposGse:
      crear: json['crear'],
      fecha: json['fecha'] ?? '',
      horaF: json['horaF'],
      horaI: json['horaI'],
      idTurnaround: json['id_turnaround'],
      modificar: json['modificar'],
      categoriasEquiposGse: List<CategoriaEquiposGse>.from(
        json['categoria_maquinaria'].map(
          (x) => mapJsonToCategoriaEquiposGse(x),
        ),
      ),
    );
  }

  // CategoriaEquiposGse

  static CategoriaEquiposGse mapJsonToCategoriaEquiposGse(
    Map<String, dynamic> json,
  ) {
    return CategoriaEquiposGse(
      idCategoria: json['id_categoria'],
      cantidadMaquinaria: json['cantidad_maquinaria'],
      categoriaNombre: json['categoria_nombre'],
      maquinarias: List<MaquinariaCategoriaEquipos>.from(
        json['maquinarias'].map((x) => mapJsonToMaquinariaCategoriaEquipos(x)),
      ),
    );
  }

  // MaquinariaCategoriaEquipos
  static MaquinariaCategoriaEquipos mapJsonToMaquinariaCategoriaEquipos(
    Map<String, dynamic> json,
  ) {
    return MaquinariaCategoriaEquipos(
      id: json['id'],
      combustible: json['combustible'],
      identificador: json['identificador'],
      modelo: json['modelo'],
      ocupado: json['ocupado'],
      selected: json['selected'],
      selectedTask: false,
    );
  }
}
