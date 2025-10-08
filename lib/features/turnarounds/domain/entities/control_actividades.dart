// To parse this JSON data, do
//
//     final turnaroundControlActividades = turnaroundControlActividadesFromJson(jsonString);

// import 'dart:convert';

// TurnaroundControlActividades turnaroundControlActividadesFromJson(String str) => TurnaroundControlActividades.fromJson(json.decode(str));

// String turnaroundControlActividadesToJson(TurnaroundControlActividades data) => json.encode(data.toJson());

class ControlActividades {
  String? numeroDeVueloSalida;
  String aerolineaNombre;
  String? aerolineaImagen;
  String acReg;
  String? acType;
  String? icaoHex;
  String? entePagador;
  String numeroVueloIn;
  String? etdIn;
  String? etaIn;
  DateTime? etaFechaIn;
  String? numeroVueloOut;
  String? etdOut;
  String? etaOut;
  DateTime? etdFechaOut;
  int gate;
  int tipoVueloId;
  int tipoServicioId;
  String? lugarSalidaOaci;
  String? lugarDestinoOaci;
  String? lugarSalidaIata;
  String? lugarDestinoIata;
  dynamic identificador;
  String? numeroVueloLlegada;
  String? horaInicio;
  String? horaFin;
  DateTime? fechaInicio;
  DateTime? fechaFin;
  String? horaInicioReal;
  String? horaFinReal;
  DateTime? fechaInicioReal;
  DateTime? fechaFinReal;
  String? tiempoExtimado;
  List<Departamento>? departamentos;
  List<ServiciosAle>? serviciosAdicionales;
  List<ServiciosAle>? serviciosEspeciales;
  List<Sla>? sla;
  String estatusNombre;
  int estatusId;

  ControlActividades({
    required this.aerolineaNombre,
    required this.acReg,
    required this.numeroVueloIn,
    required this.gate,
    required this.tipoVueloId,
    required this.tipoServicioId,
    required this.estatusNombre,
    required this.estatusId,
    this.numeroDeVueloSalida,
    this.aerolineaImagen,
    this.acType,
    this.icaoHex,
    this.entePagador,
    this.etdIn,
    this.etaIn,
    this.etaFechaIn,
    this.numeroVueloOut,
    this.etdOut,
    this.etaOut,
    this.etdFechaOut,
    this.lugarSalidaOaci,
    this.lugarDestinoOaci,
    this.lugarSalidaIata,
    this.lugarDestinoIata,
    this.identificador,
    this.numeroVueloLlegada,
    this.horaInicio,
    this.horaFin,
    this.fechaInicio,
    this.fechaFin,
    this.horaInicioReal,
    this.horaFinReal,
    this.fechaInicioReal,
    this.fechaFinReal,
    this.tiempoExtimado,
    this.departamentos,
    this.serviciosAdicionales,
    this.serviciosEspeciales,
    this.sla,
  });

  // factory TurnaroundControlActividades.fromJson(Map<String, dynamic> json) => TurnaroundControlActividades(
  //     numeroDeVueloSalida: json["numero_de_vuelo_salida"],
  //     aerolineaNombre: json["aerolinea_nombre"],
  //     aerolineaImagen: json["aerolinea_imagen"],
  //     acReg: json["ac_reg"],
  //     acType: json["ac_type"],
  //     icaoHex: json["icao_hex"],
  //     entePagador: json["ente_pagador"],
  //     numeroVueloIn: json["numero_vuelo_in"],
  //     etdIn: json["ETD_in"],
  //     etaIn: json["ETA_in"],
  //     etaFechaIn: DateTime.parse(json["ETA_fecha_in"]).toLocal(),
  //     numeroVueloOut: json["numero_vuelo_out"],
  //     etdOut: json["ETD_out"],
  //     etaOut: json["ETA_out"],
  //     etdFechaOut: DateTime.parse(json["ETD_fecha_out"]).toLocal(),
  //     gate: json["gate"],
  //     tipoVueloId: json["tipo_vuelo_id"],
  //     tipoServicioId: json["tipo_servicio_id"],
  //     lugarSalidaOaci: json["lugar_salida_oaci"],
  //     lugarDestinoOaci: json["lugar_destino_oaci"],
  //     lugarSalidaIata: json["lugar_salida_iata"],
  //     lugarDestinoIata: json["lugar_destino_iata"],
  //     identificador: json["identificador"],
  //     numeroVueloLlegada: json["numero_vuelo_llegada"],
  //     horaInicio: json["hora_inicio"],
  //     horaFin: json["hora_fin"],
  //     fechaInicio: DateTime.parse(json["fecha_inicio"]).toLocal(),
  //     fechaFin: DateTime.parse(json["fecha_fin"]).toLocal(),
  //     horaInicioReal: json["hora_inicio_real"],
  //     horaFinReal: json["hora_fin_real"],
  //     fechaInicioReal: DateTime.parse(json["fecha_inicio_real"]).toLocal(),
  //     fechaFinReal: DateTime.parse(json["fecha_fin_real"]).toLocal(),
  //     tiempoExtimado: json["tiempo_extimado"],
  //     departamentos: List<Departamento>.from(json["departamentos"].map((x) => Departamento.fromJson(x))),
  //     serviciosAdicionales: List<ServiciosAle>.from(json["servicios_adicionales"].map((x) => ServiciosAle.fromJson(x))),
  //     serviciosEspeciales: List<ServiciosAle>.from(json["servicios_especiales"].map((x) => ServiciosAle.fromJson(x))),
  //     estatusNombre: json["estatus_nombre"],
  //     estatusId: json["estatus_id"],
  // );

  // Map<String, dynamic> toJson() => {
  //     "numero_de_vuelo_salida": numeroDeVueloSalida,
  //     "aerolinea_nombre": aerolineaNombre,
  //     "aerolinea_imagen": aerolineaImagen,
  //     "ac_reg": acReg,
  //     "ac_type": acType,
  //     "icao_hex": icaoHex,
  //     "ente_pagador": entePagador,
  //     "numero_vuelo_in": numeroVueloIn,
  //     "ETD_in": etdIn,
  //     "ETA_in": etaIn,
  //     "ETA_fecha_in": "${etaFechaIn.year.toString().padLeft(4, '0')}-${etaFechaIn.month.toString().padLeft(2, '0')}-${etaFechaIn.day.toString().padLeft(2, '0')}",
  //     "numero_vuelo_out": numeroVueloOut,
  //     "ETD_out": etdOut,
  //     "ETA_out": etaOut,
  //     "ETD_fecha_out": "${etdFechaOut.year.toString().padLeft(4, '0')}-${etdFechaOut.month.toString().padLeft(2, '0')}-${etdFechaOut.day.toString().padLeft(2, '0')}",
  //     "gate": gate,
  //     "tipo_vuelo_id": tipoVueloId,
  //     "tipo_servicio_id": tipoServicioId,
  //     "lugar_salida_oaci": lugarSalidaOaci,
  //     "lugar_destino_oaci": lugarDestinoOaci,
  //     "lugar_salida_iata": lugarSalidaIata,
  //     "lugar_destino_iata": lugarDestinoIata,
  //     "identificador": identificador,
  //     "numero_vuelo_llegada": numeroVueloLlegada,
  //     "hora_inicio": horaInicio,
  //     "hora_fin": horaFin,
  //     "fecha_inicio": "${fechaInicio.year.toString().padLeft(4, '0')}-${fechaInicio.month.toString().padLeft(2, '0')}-${fechaInicio.day.toString().padLeft(2, '0')}",
  //     "fecha_fin": "${fechaFin.year.toString().padLeft(4, '0')}-${fechaFin.month.toString().padLeft(2, '0')}-${fechaFin.day.toString().padLeft(2, '0')}",
  //     "hora_inicio_real": horaInicioReal,
  //     "hora_fin_real": horaFinReal,
  //     "fecha_inicio_real": "${fechaInicioReal.year.toString().padLeft(4, '0')}-${fechaInicioReal.month.toString().padLeft(2, '0')}-${fechaInicioReal.day.toString().padLeft(2, '0')}",
  //     "fecha_fin_real": "${fechaFinReal.year.toString().padLeft(4, '0')}-${fechaFinReal.month.toString().padLeft(2, '0')}-${fechaFinReal.day.toString().padLeft(2, '0')}",
  //     "tiempo_extimado": tiempoExtimado,
  //     "departamentos": List<dynamic>.from(departamentos.map((x) => x.toJson())),
  //     "servicios_adicionales": List<dynamic>.from(serviciosAdicionales.map((x) => x.toJson())),
  //     "servicios_especiales": List<dynamic>.from(serviciosEspeciales.map((x) => x.toJson())),
  //     "estatus_nombre": estatusNombre,
  //     "estatus_id": estatusId,
  // };
}

class Sla {
  final int id;
  final String descripcion;
  final String categoria;
  final int tareaPrincipal;
  final String horaDeComparacion;
  final String horaOperacion;
  final String tiempo;
  final String horaTarea;
  final bool operacion;
  final String resultado;
  final String tareaNombre;
  final bool aprobado;

  Sla({
    required this.id,
    required this.descripcion,
    required this.categoria,
    required this.tareaPrincipal,
    required this.horaDeComparacion,
    required this.horaOperacion,
    required this.tiempo,
    required this.horaTarea,
    required this.operacion,
    required this.resultado,
    required this.tareaNombre,
    required this.aprobado,
  });

  factory Sla.fromJson(Map<String, dynamic> json) {
    return Sla(
      id: json['trc_sla_id'] as int,
      descripcion: json['trc_sla_descripcion'] as String,
      categoria: json['trc_sla_categoria'] as String,
      tareaPrincipal: json['trc_sla_tarea_principal'] as int,
      horaDeComparacion: json['hora_de_comparacion'] as String,
      horaOperacion: json['hora_operacion'] as String,
      tiempo: json['tiempo'] as String,
      horaTarea: json['hora_tarea'] as String,
      operacion: json['operacion'] as bool,
      resultado: json['resultado'] as String,
      tareaNombre: json['tarea_nombre'] as String,
      aprobado: json['aprobado'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'trc_sla_id': id,
      'trc_sla_descripcion': descripcion,
      'trc_sla_categoria': categoria,
      'trc_sla_tarea_principal': tareaPrincipal,
      'hora_de_comparacion': horaDeComparacion,
      'hora_operacion': horaOperacion,
      'tiempo': tiempo,
      'hora_tarea': horaTarea,
      'operacion': operacion,
      'resultado': resultado,
      'tarea_nombre': tareaNombre,
      'aprobado': aprobado,
    };
  }
}

class Departamento {
  int index;
  String nombreArea;
  String nombreCorto;
  List<Actividades> actividades;
  bool isDepartamentAproved;
  bool isAproved;
  bool isSignatory;

  Departamento({
    required this.index,
    required this.nombreArea,
    required this.nombreCorto,
    required this.actividades,
    required this.isDepartamentAproved,
    required this.isAproved,
    required this.isSignatory,
  });

  // factory Departamento.fromJson(Map<String, dynamic> json) => Departamento(
  //     index: json["index"],
  //     nombreArea: json["nombre_area"],
  //     actividades: List<Actividade>.from(json["actividades"].map((x) => Actividade.fromJson(x))),
  //     isDepartamentAproved: json["IsDepartamentAproved"],
  //     isAproved: json["IsAproved"],
  //     isSignatory: json["IsSignatory"],
  // );

  // Map<String, dynamic> toJson() => {
  //     "index": index,
  //     "nombre_area": nombreArea,
  //     "actividades": List<dynamic>.from(actividades.map((x) => x.toJson())),
  //     "IsDepartamentAproved": isDepartamentAproved,
  //     "IsAproved": isAproved,
  //     "IsSignatory": isSignatory,
  // };
}

class Actividades {
  int index;
  String nombreActividad;
  List<Tarea>? tareas;
  bool todasTareasHechas;
  bool isExpanded;
  int tareasCompletadas;
  int tareasPendientes;
  int tareasTotales;

  Actividades({
    required this.index,
    required this.nombreActividad,
    required this.tareas,
    required this.todasTareasHechas,
    this.isExpanded = true,
    required this.tareasCompletadas,
    required this.tareasPendientes,
    required this.tareasTotales,
  });

  // factory Actividades.fromJson(Map<String, dynamic> json) => Actividades(
  //     index: json["index"],
  //     nombreActividad: json["nombre_actividad"],
  //     tareas: List<Tarea>.from(json["tareas"].map((x) => Tarea.fromJson(x))),
  //     todasTareasHechas: json["todas_tareas_hechas"],
  // );

  // Map<String, dynamic> toJson() => {
  //     "index": index,
  //     "nombre_actividad": nombreActividad,
  //     "tareas": List<dynamic>.from(tareas.map((x) => x.toJson())),
  //     "todas_tareas_hechas": todasTareasHechas,
  // };
}

class Tarea {
  int id;
  int? auxTiempoPromedio;
  String titulo;
  bool primeraTarea;
  bool ultimaTarea;
  DateTime? horaInicio;
  DateTime? horaFin;
  int? numero;
  String? texto;
  int estatus;
  String? comentario;
  TipoNombre tipoNombre;
  int tipoId;
  bool completado;
  int? numeroMedida;
  String? unidadMedida;
  String? faseTarea;
  List<dynamic>? maquinaria;
  List<Imagen>? imagen;
  Map<String, int>? pasajeros;
  List<dynamic>? equipo;
  bool isExpanded;

  Tarea({
    required this.id,
    this.auxTiempoPromedio,
    required this.titulo,
    required this.primeraTarea,
    required this.ultimaTarea,
    this.horaInicio,
    this.horaFin,
    this.numero,
    this.texto,
    required this.estatus,
    this.comentario,
    required this.tipoNombre,
    required this.tipoId,
    required this.completado,
    this.numeroMedida,
    this.unidadMedida,
    required this.faseTarea,
    this.maquinaria,
    this.imagen,
    this.pasajeros,
    this.equipo,
    this.isExpanded = true,
  });

  // factory Tarea.fromJson(Map<String, dynamic> json) => Tarea(
  //     id: json["id"],
  //     auxTiempoPromedio: json["aux_tiempo_promedio"],
  //     titulo: json["titulo"],
  //     primeraTarea: json["primera_tarea"],
  //     ultimaTarea: json["ultima_tarea"],
  //     horaInicio: json["hora_inicio"] == null ? null : DateTime.parse(json["hora_inicio"]).toLocal(),
  //     horaFin: json["hora_fin"] == null ? null : DateTime.parse(json["hora_fin"]).toLocal(),
  //     numero: json["numero"],
  //     texto: json["texto"],
  //     estatus: json["estatus"],
  //     comentario: comentarioValues.map[json["comentario"]]!,
  //     tipoNombre: tipoNombreValues.map[json["tipo_nombre"]]!,
  //     tipoId: json["tipo_id"],
  //     completado: json["completado"],
  //     numeroMedida: json["numero_medida"],
  //     unidadMedida: json["unidad_medida"],
  //     faseTarea: faseTareaValues.map[json["fase_tarea"]]!,
  //     maquinaria: List<dynamic>.from(json["maquinaria"].map((x) => x)),
  //     imagen: List<Imagen>.from(json["imagen"].map((x) => Imagen.fromJson(x))),
  //     pasajeros: Map.from(json["pasajeros"]!).map((k, v) => MapEntry<String, int>(k, v)),
  //     equipo: List<dynamic>.from(json["equipo"].map((x) => x)),
  // );

  // Map<String, dynamic> toJson() => {
  //     "id": id,
  //     "aux_tiempo_promedio": auxTiempoPromedio,
  //     "titulo": titulo,
  //     "primera_tarea": primeraTarea,
  //     "ultima_tarea": ultimaTarea,
  //     "hora_inicio": horaInicio?.toIso8601String(),
  //     "hora_fin": horaFin?.toIso8601String(),
  //     "numero": numero,
  //     "texto": texto,
  //     "estatus": estatus,
  //     "comentario": comentarioValues.reverse[comentario],
  //     "tipo_nombre": tipoNombreValues.reverse[tipoNombre],
  //     "tipo_id": tipoId,
  //     "completado": completado,
  //     "numero_medida": numeroMedida,
  //     "unidad_medida": unidadMedida,
  //     "fase_tarea": faseTareaValues.reverse[faseTarea],
  //     "maquinaria": List<dynamic>.from(maquinaria.map((x) => x)),
  //     "imagen": List<dynamic>.from(imagen.map((x) => x.toJson())),
  //     "pasajeros": Map.from(pasajeros!).map((k, v) => MapEntry<String, dynamic>(k, v)),
  //     "equipo": List<dynamic>.from(equipo.map((x) => x)),
  // };
}

class Imagen {
  int id;
  String? imagen;

  Imagen({required this.id, required this.imagen});

  factory Imagen.fromJson(Map<String, dynamic> json) =>
      Imagen(id: json["id"], imagen: json["imagen"]);

  Map<String, dynamic> toJson() => {"id": id, "imagen": imagen};
}

enum TipoNombre {
  HORA,
  HORA_INICIO_Y_FIN,
  PASAJERO,
  MAQUINARIA_CON_TIEMPO,
  MAQUINARIA_SIN_TIEMPO,
  CANTIDAD,
  TEXTO,
  EQUIPAJE,
  EQUIPOS_IT,
  EQUIPO_DE_LIMPIEZA,
}

final tipoNombreValues = EnumValues({
  "Hora": TipoNombre.HORA,
  "Hora inicio y fin": TipoNombre.HORA_INICIO_Y_FIN,
  "Pasajero": TipoNombre.PASAJERO,
  "Maquinaria con tiempo":
      TipoNombre.MAQUINARIA_CON_TIEMPO, // Default case if empty
  "Maquinaria sin tiempo":
      TipoNombre.MAQUINARIA_SIN_TIEMPO, // Default case if empty
  "Cantidad": TipoNombre.CANTIDAD,
  "Texto": TipoNombre.TEXTO,
  "Equipaje": TipoNombre.EQUIPAJE,
  "Equipos IT": TipoNombre.EQUIPOS_IT,
  "Equipo De Limpieza": TipoNombre.EQUIPO_DE_LIMPIEZA,
});

class ServiciosAle {
  int id;
  String titulo;
  int tipoId;
  int servicioId;
  DateTime? horaInicio;
  DateTime? horaFin;
  int? cantidad;
  String? comentario;
  int estatus;
  int fkTurnaroundId;
  List<dynamic>? imagen;
  List<Maquinaria> maquinaria;

  ServiciosAle({
    required this.id,
    required this.titulo,
    required this.tipoId,
    required this.servicioId,
    required this.horaInicio,
    required this.horaFin,
    required this.cantidad,
    required this.comentario,
    required this.estatus,
    required this.fkTurnaroundId,
    required this.imagen,
    required this.maquinaria,
  });

  factory ServiciosAle.fromJson(Map<String, dynamic> json) => ServiciosAle(
    id: json["id"],
    titulo: json["titulo"],
    tipoId: json["tipo_id"],
    servicioId: json["servicio_id"],
    horaInicio: json["hora_inicio"] == null
        ? null
        : DateTime.parse(json["hora_inicio"]).toLocal(),
    horaFin: json["hora_fin"] == null
        ? null
        : DateTime.parse(json["hora_fin"]).toLocal(),
    cantidad: json["cantidad"],
    comentario: json["comentario"],
    estatus: json["estatus"],
    fkTurnaroundId: json["fk_turnaround_id"],
    imagen: List<dynamic>.from(json["imagen"].map((x) => x)),
    maquinaria: List<Maquinaria>.from(
      json["maquinaria"].map((x) => Maquinaria.fromJson(x)),
    ),
  );

  // Map<String, dynamic> toJson() => {
  //   "id": id,
  //   "titulo": titulo,
  //   "tipo_id": tipoId,
  //   "servicio_id": servicioId,
  //   "hora_inicio": horaInicio?.toIso8601String(),
  //   "hora_fin": horaFin?.toIso8601String(),
  //   "cantidad": cantidad,
  //   "comentario": comentario,
  //   "estatus": estatus,
  //   "fk_turnaround_id": fkTurnaroundId,
  //   "imagen": List<dynamic>.from((imagen ?? []).map((x) => x)),
  //   "maquinaria": List<dynamic>.from(maquinaria.map((x) => x.toJson())),
  // };
}

class Maquinaria {
  int id;
  int maquinariaId;
  String maquinariaIdentificador;
  String maquinariaModelo;
  DateTime? horaInicio;
  DateTime? horaFin;

  Maquinaria({
    required this.id,
    required this.maquinariaId,
    required this.maquinariaIdentificador,
    required this.maquinariaModelo,
    required this.horaInicio,
    required this.horaFin,
  });

  factory Maquinaria.fromJson(Map<String, dynamic> json) => Maquinaria(
    id: json["id"],
    maquinariaId: json["maquinaria_id"],
    maquinariaIdentificador: json["maquinaria_identificador"],
    maquinariaModelo: json["maquinaria_modelo"],
    horaInicio: json["hora_inicio"] == null
        ? null
        : DateTime.parse(json["hora_inicio"]).toLocal(),
    horaFin: json["hora_fin"] == null
        ? null
        : DateTime.parse(json["hora_fin"]).toLocal(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "maquinaria_id": maquinariaId,
    "maquinaria_identificador": maquinariaIdentificador,
    "maquinaria_modelo": maquinariaModelo,
    "hora_inicio": horaInicio?.toIso8601String(),
    "hora_fin": horaFin?.toIso8601String(),
  };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}

// Responses Entities
class HoraInicioFinMaquinaria {
  DateTime? horaInicio;
  DateTime? horaFin;
  int id;
  int tareaId;
  String tipo;

  HoraInicioFinMaquinaria({
    this.horaInicio,
    this.horaFin,
    required this.id,
    required this.tareaId,
    required this.tipo,
  });

  // factory HoraInicioFinMaquinaria.fromJson(Map<String, dynamic> json) =>
  //     HoraInicioFinMaquinaria(
  //       horaInicio: DateTime.parse(json["horaInicio"]).toLocal(),
  //       horaFin: DateTime.parse(json["horaFin"]).toLocal(),
  //       id: json["id"],
  //       tareaId: json["tareaId"],
  //       tipo: json["tipo"],
  //     );
}

class ComentarioRequest {
  int id;
  String comentario;

  ComentarioRequest({required this.id, required this.comentario});
}

class SetNumeroTareaRequest {
  int id;
  int numero;

  SetNumeroTareaRequest({required this.id, required this.numero});
}

class SavePasajerosRequest {
  int id;
  int llegadaEjecutivo;
  int llegadaEconomica;
  int llegadaInfante;
  int transitoEjecutivo;
  int transitoEconomica;
  int transitoInfante;
  int salidaEjecutivo;
  int salidaEconomica;
  int salidaInfante;
  int inadmitidosEjecutivo;
  int inadmitidosEconomica;
  int inadmitidosInfante;

  SavePasajerosRequest({
    required this.id,
    required this.llegadaEjecutivo,
    required this.llegadaEconomica,
    required this.llegadaInfante,
    required this.transitoEjecutivo,
    required this.transitoEconomica,
    required this.transitoInfante,
    required this.salidaEjecutivo,
    required this.salidaEconomica,
    required this.salidaInfante,
    required this.inadmitidosEjecutivo,
    required this.inadmitidosEconomica,
    required this.inadmitidosInfante,
  });
}
