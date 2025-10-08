class Plantilla {
  final int id;
  final String titulo;
  final String tiempoExtimado;
  final int idSucursal;
  final String nombreSucursal;
  final String tiempoPermitido;
  final List<ActividadPlantilla> actividad;
  final List<CategoriaMaquinaria> categoriaMaquinaria;
  final List<ReportePlantilla> reportes;

  Plantilla({
    required this.id,
    required this.titulo,
    required this.tiempoExtimado,
    required this.idSucursal,
    required this.nombreSucursal,
    required this.tiempoPermitido,
    required this.actividad,
    required this.categoriaMaquinaria,
    required this.reportes,
  });

  factory Plantilla.fromJson(Map<String, dynamic> json) {
    return Plantilla(
      id: json['id'] as int,
      titulo: json['titulo'] as String,
      tiempoExtimado: json['tiempo_extimado'] as String,
      idSucursal: json['id_sucursal'] as int,
      nombreSucursal: json['nombre_sucursal'] as String,
      tiempoPermitido: json['tiempo_permitido'] as String,
      actividad: (json['actividad'] as List)
          .map((e) => ActividadPlantilla.fromJson(e as Map<String, dynamic>))
          .toList(),
      categoriaMaquinaria: (json['categoria_maquinaria'] as List)
          .map((e) => CategoriaMaquinaria.fromJson(e as Map<String, dynamic>))
          .toList(),
      reportes: (json['reportes'] as List)
          .map((e) => ReportePlantilla.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'tiempo_extimado': tiempoExtimado,
      'id_sucursal': idSucursal,
      'nombre_sucursal': nombreSucursal,
      'tiempo_permitido': tiempoPermitido,
      'actividad': actividad.map((e) => e.toJson()).toList(),
      'categoria_maquinaria': categoriaMaquinaria.map((e) => e.toJson()).toList(),
      'reportes': reportes.map((e) => e.toJson()).toList(),
    };
  }
}

class ActividadPlantilla {
  final int id;
  final int index;
  final int fkActividad;
  final String titulo;
  final List<TareaPlantilla> tarea;

  ActividadPlantilla({
    required this.id,
    required this.index,
    required this.fkActividad,
    required this.titulo,
    required this.tarea,
  });

  factory ActividadPlantilla.fromJson(Map<String, dynamic> json) {
    return ActividadPlantilla(
      id: json['id'] as int,
      index: json['index'] as int,
      fkActividad: json['fk_actividad'] as int,
      titulo: json['titulo'] as String,
      tarea: (json['tarea'] as List)
          .map((e) => TareaPlantilla.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'index': index,
      'fk_actividad': fkActividad,
      'titulo': titulo,
      'tarea': tarea.map((e) => e.toJson()).toList(),
    };
  }
}

class TareaPlantilla {
  final int id;
  final int index;
  final int fkTarea;
  final bool esPrimeraActividad;
  final bool esUltimaActividad;
  final String fase;
  final String tipo;
  final int tipoId;
  final String titulo;

  TareaPlantilla({
    required this.id,
    required this.index,
    required this.fkTarea,
    required this.esPrimeraActividad,
    required this.esUltimaActividad,
    required this.fase,
    required this.tipo,
    required this.tipoId,
    required this.titulo,
  });

  factory TareaPlantilla.fromJson(Map<String, dynamic> json) {
    return TareaPlantilla(
      id: json['id'] as int,
      index: json['index'] as int,
      fkTarea: json['fk_tarea'] as int,
      esPrimeraActividad: json['esPrimeraActividad'] as bool,
      esUltimaActividad: json['esUltimaActividad'] as bool,
      fase: json['fase'] as String,
      tipo: json['tipo'] as String,
      tipoId: json['tipo_id'] as int,
      titulo: json['titulo'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'index': index,
      'fk_tarea': fkTarea,
      'esPrimeraActividad': esPrimeraActividad,
      'esUltimaActividad': esUltimaActividad,
      'fase': fase,
      'tipo': tipo,
      'tipo_id': tipoId,
      'titulo': titulo,
    };
  }
}

class CategoriaMaquinaria {
  final int cantidad;
  final int fkCategoria;
  final String nombreCategoria;

  CategoriaMaquinaria({
    required this.cantidad,
    required this.fkCategoria,
    required this.nombreCategoria,
  });

  factory CategoriaMaquinaria.fromJson(Map<String, dynamic> json) {
    return CategoriaMaquinaria(
      cantidad: json['cantidad'] as int,
      fkCategoria: json['fk_categoria'] as int,
      nombreCategoria: json['nombre_categoria'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cantidad': cantidad,
      'fk_categoria': fkCategoria,
      'nombre_categoria': nombreCategoria,
    };
  }
}

class ReportePlantilla {
  final int id;
  final String nombre;
  final List<TareaReporte> tareas;

  ReportePlantilla({
    required this.id,
    required this.nombre,
    required this.tareas,
  });

  factory ReportePlantilla.fromJson(Map<String, dynamic> json) {
    return ReportePlantilla(
      id: json['id'] as int,
      nombre: json['nombre'] as String,
      tareas: (json['tareas'] as List)
          .map((e) => TareaReporte.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'tareas': tareas.map((e) => e.toJson()).toList(),
    };
  }
}

class TareaReporte {
  final int index;
  final int id;
  final String titulo;
  final bool seleccion;
  final bool selected;

  TareaReporte({
    required this.index,
    required this.id,
    required this.titulo,
    required this.seleccion,
    required this.selected,
  });

  factory TareaReporte.fromJson(Map<String, dynamic> json) {
    return TareaReporte(
      index: json['index'] as int,
      id: json['id'] as int,
      titulo: json['titulo'] as String,
      seleccion: json['seleccion'] as bool,
      selected: json['selected'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'id': id,
      'titulo': titulo,
      'seleccion': seleccion,
      'selected': selected,
    };
  }
}