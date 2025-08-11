// class CategoriaServiciosAdicionalesResponse {
//   List<CategoriaServicioAdicional> categoriasServiciosAdicionales = [];

//   CategoriaServiciosAdicionalesResponse({
//     required this.categoriasServiciosAdicionales,
//   });
// }

class CategoriaServicioAdicional {
  int id;
  TipoServicio tipoServicio;
  String titulo;
  bool isAdicional;
  int estatus;
  bool selected = false;

  CategoriaServicioAdicional({
    required this.id,
    required this.tipoServicio,
    required this.titulo,
    required this.isAdicional,
    required this.estatus,
  });

  factory CategoriaServicioAdicional.fromJson(Map<String, dynamic> json) {
    return CategoriaServicioAdicional(
      id: json['id'],
      tipoServicio: TipoServicio.fromJson(json['tipo_servicio']),
      titulo: json['titulo'],
      isAdicional: json['isadicional'],
      estatus: json['estatus'],
    );
  }
}

class Servicio {
  // Add properties and fromJson method as needed
  // For example:
  int id;
  TipoServicio tipoServicio;
  String titulo;
  bool isAdicional;
  int estatus;

  Servicio({
    required this.id,
    required this.tipoServicio,
    required this.titulo,
    required this.isAdicional,
    required this.estatus,
  });

  factory Servicio.fromJson(Map<String, dynamic> json) {
    return Servicio(
      id: json['id'],
      tipoServicio: TipoServicio.fromJson(json['tipo_servicio']),
      titulo: json['titulo'],
      isAdicional: json['isadicional'],
      estatus: json['estatus'],
    );
  }
}

class TipoServicio {
  // Add properties and fromJson method as needed
  // For example:
  int id;
  String nombre;

  TipoServicio({required this.id, required this.nombre});

  factory TipoServicio.fromJson(Map<String, dynamic> json) {
    return TipoServicio(id: json['id'], nombre: json['nombre']);
  }
}

class ServiciosAdicionalRequest {
  final List<int> ids_nuevos;
  final List<int> ids_eliminados;
  final int turnaround;

  ServiciosAdicionalRequest({
    required this.ids_nuevos,
    required this.ids_eliminados,
    required this.turnaround,
  });
}

class SetHoraServicioAdicionalRequest {
  final int id;
  final DateTime? horaInicio;
  final DateTime? horaFin;
  final String tipo;

  SetHoraServicioAdicionalRequest({
    required this.id,
    required this.horaInicio,
    required this.horaFin,
    required this.tipo,
  });
}
