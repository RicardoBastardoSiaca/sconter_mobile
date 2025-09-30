

class CategoriaEquiposItLimpieza {
  final String nombreCategoria;
  final String tipoCategoria;
  final List<EquipoItLimpieza> equipos;

  CategoriaEquiposItLimpieza({
    required this.nombreCategoria,
    required this.tipoCategoria,
    required this.equipos,
  });

  factory CategoriaEquiposItLimpieza.fromJson(Map<String, dynamic> json) {
    return CategoriaEquiposItLimpieza(
      nombreCategoria: json['nombre_categoria'] ?? '',
      tipoCategoria: json['tipo_categoria'] ?? '',
      equipos: (json['equipos'] as List<dynamic>?)
          ?.map((equipoJson) => EquipoItLimpieza.fromJson(equipoJson))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre_categoria': nombreCategoria,
      'tipo_categoria': tipoCategoria,
      'equipos': equipos.map((equipo) => equipo.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'CategoriaEquiposItLimpieza{nombreCategoria: $nombreCategoria, tipoCategoria: $tipoCategoria, equipos: $equipos}';
  }

  CategoriaEquiposItLimpieza copyWith({
    String? nombreCategoria,
    String? tipoCategoria,
    List<EquipoItLimpieza>? equipos,
  }) {
    return CategoriaEquiposItLimpieza(
      nombreCategoria: nombreCategoria ?? this.nombreCategoria,
      tipoCategoria: tipoCategoria ?? this.tipoCategoria,
      equipos: equipos ?? this.equipos,
    );
  }
}

class EquipoItLimpieza {
  final int id;
  final String identificador;
  final String modelo;
  final bool estado;
  final int fkCategoria;
  final String categoriaNombre;
  final String categoriaTipo;
  final String imagen;
  final String fkAerolinea;
  final String aerolineaNombre;
  final bool selectedTask;
  bool isSelected = false;

  EquipoItLimpieza({
    required this.id,
    required this.identificador,
    required this.modelo,
    required this.estado,
    required this.fkCategoria,
    required this.categoriaNombre,
    required this.categoriaTipo,
    required this.imagen,
    required this.fkAerolinea,
    required this.aerolineaNombre,
    required this.selectedTask,
    required this.isSelected,
  });

  factory EquipoItLimpieza.fromJson(Map<String, dynamic> json) {
    return EquipoItLimpieza(
      id: json['id'] ?? 0,
      identificador: json['identificador'] ?? '',
      modelo: json['modelo'] ?? '',
      estado: json['estado'] ?? false,
      fkCategoria: json['fk_categoria'] ?? 0,
      categoriaNombre: json['categoria_nombre'] ?? '',
      categoriaTipo: json['categoria_tipo'] ?? '',
      imagen: json['imagen'] ?? '',
      fkAerolinea: json['fk_aerolinea'] ?? '',
      aerolineaNombre: json['aerolinea_nombre'] ?? '',
      selectedTask: json['selectedTask'] ?? false,
      isSelected: json['isSelected'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'identificador': identificador,
      'modelo': modelo,
      'estado': estado,
      'fk_categoria': fkCategoria,
      'categoria_nombre': categoriaNombre,
      'categoria_tipo': categoriaTipo,
      'imagen': imagen,
      'fk_aerolinea': fkAerolinea,
      'aerolinea_nombre': aerolineaNombre,
      'selectedTask': selectedTask,
    };
  }

  @override
  String toString() {
    return 'Equipo{id: $id, identificador: $identificador, modelo: $modelo, estado: $estado, selectedTask: $selectedTask}';
  }

  EquipoItLimpieza copyWith({
    int? id,
    String? identificador,
    String? modelo,
    bool? estado,
    int? fkCategoria,
    String? categoriaNombre,
    String? categoriaTipo,
    String? imagen,
    String? fkAerolinea,
    String? aerolineaNombre,
    bool? selectedTask,
  }) {
    return EquipoItLimpieza(
      id: id ?? this.id,
      identificador: identificador ?? this.identificador,
      modelo: modelo ?? this.modelo,
      estado: estado ?? this.estado,
      fkCategoria: fkCategoria ?? this.fkCategoria,
      categoriaNombre: categoriaNombre ?? this.categoriaNombre,
      categoriaTipo: categoriaTipo ?? this.categoriaTipo,
      imagen: imagen ?? this.imagen,
      fkAerolinea: fkAerolinea ?? this.fkAerolinea,
      aerolineaNombre: aerolineaNombre ?? this.aerolineaNombre,
      selectedTask: selectedTask ?? this.selectedTask,
      isSelected: isSelected,
    );
  }
}