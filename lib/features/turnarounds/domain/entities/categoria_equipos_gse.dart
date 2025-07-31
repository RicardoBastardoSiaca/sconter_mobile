class CategoriasEquiposGseResponse {
  List<CategoriaEquiposGse> categoriasEquiposGse = [];
  bool crear;
  String fecha;
  String horaF;
  String horaI;
  int idTurnaround;
  bool modificar;

  CategoriasEquiposGseResponse({
    required this.categoriasEquiposGse,
    required this.crear,
    required this.fecha,
    required this.horaF,
    required this.horaI,
    required this.idTurnaround,
    required this.modificar,
  });
}

class CategoriaEquiposGse {
  final int idCategoria;
  final int cantidadMaquinaria;
  final String categoriaNombre;
  List<MaquinariaCategoriaEquipos> maquinarias;

  CategoriaEquiposGse({
    required this.idCategoria,
    required this.cantidadMaquinaria,
    required this.categoriaNombre,
    required this.maquinarias,
  });
}

class MaquinariaCategoriaEquipos {
  int id;
  String combustible;
  String identificador;
  String modelo;
  bool ocupado;
  bool selected;
  bool? selectedTask;

  MaquinariaCategoriaEquipos({
    required this.id,
    required this.combustible,
    required this.identificador,
    required this.modelo,
    required this.ocupado,
    required this.selected,
    required this.selectedTask,
  });

  // factory Maquinaria.fromJson(Map<String, dynamic> json) => Maquinaria(
  //   id: json["id"],
  //   maquinariaId: json["maquinaria_id"],
  //   maquinariaIdentificador: json["maquinaria_identificador"],
  //   maquinariaModelo: json["maquinaria_modelo"],
  //   horaInicio: DateTime.parse(json["hora_inicio"]),
  //   horaFin: DateTime.parse(json["hora_fin"]),
  // );

  // Map<String, dynamic> toJson() => {
  //   "id": id,
  //   "maquinaria_id": maquinariaId,
  //   "maquinaria_identificador": maquinariaIdentificador,
  //   "maquinaria_modelo": maquinariaModelo,
  //   "hora_inicio": horaInicio.toIso8601String(),
  //   "hora_fin": horaFin.toIso8601String(),
  // };
}
