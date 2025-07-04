import '../../domain/domain.dart';

class ControlActividadesMapper {
  static ControlActividades mapJsonToControlActividades(
    Map<String, dynamic> json,
  ) {
    return ControlActividades(
      numeroDeVueloSalida: json["numero_de_vuelo_salida"],
      aerolineaNombre: json["aerolinea_nombre"],
      aerolineaImagen: json["aerolinea_imagen"],
      acReg: json["ac_reg"],
      acType: json["ac_type"],
      icaoHex: json["icao_hex"],
      entePagador: json["ente_pagador"],
      numeroVueloIn: json["numero_vuelo_in"],
      etdIn: json["ETD_in"],
      etaIn: json["ETA_in"],
      etaFechaIn: DateTime.parse(json["ETA_fecha_in"]),
      numeroVueloOut: json["numero_vuelo_out"],
      etdOut: json["ETD_out"],
      etaOut: json["ETA_out"],
      etdFechaOut: DateTime.parse(json["ETD_fecha_out"]),
      gate: json["gate"],
      tipoVueloId: json["tipo_vuelo_id"],
      tipoServicioId: json["tipo_servicio_id"],
      lugarSalidaOaci: json["lugar_salida_oaci"],
      lugarDestinoOaci: json["lugar_destino_oaci"],
      lugarSalidaIata: json["lugar_salida_iata"],
      lugarDestinoIata: json["lugar_destino_iata"],
      identificador: json["identificador"],
      numeroVueloLlegada: json["numero_vuelo_llegada"],
      horaInicio: json["hora_inicio"],
      horaFin: json["hora_fin"],
      fechaInicio: DateTime.parse(json["fecha_inicio"]),
      fechaFin: DateTime.parse(json["fecha_fin"]),
      horaInicioReal: json["hora_inicio_real"],
      horaFinReal: json["hora_fin_real"],
      fechaInicioReal: DateTime.parse(json["fecha_inicio_real"]),
      fechaFinReal: DateTime.parse(json["fecha_fin_real"]),
      tiempoExtimado: json["tiempo_extimado"],
      departamentos: List<Departamento>.from(
        (json["departamentos"] as List).map((x) => mapJsonToDepartamento(x)),
      ),
      serviciosAdicionales: List<ServiciosAle>.from(
        json["servicios_adicionales"].map((x) => ServiciosAle.fromJson(x)),
      ),
      serviciosEspeciales: List<ServiciosAle>.from(
        json["servicios_especiales"].map((x) => ServiciosAle.fromJson(x)),
      ),
      estatusNombre: json["estatus_nombre"],
      estatusId: json["estatus_id"],
    );
  }

  static Departamento mapJsonToDepartamento(Map<String, dynamic> json) {
    return Departamento(
      index: json["index"],
      nombreArea: json["nombre_area"],
      actividades: List<Actividades>.from(
        (json["actividades"] as List).map((x) => mapJsonToActividades(x)),
      ),
      isDepartamentAproved: json["IsDepartamentAproved"],
      isAproved: json["IsAproved"],
      isSignatory: json["IsSignatory"],
    );
  }

  static Actividades mapJsonToActividades(Map<String, dynamic> json) {
    return Actividades(
      index: json["index"],
      nombreActividad: json["nombre_actividad"],
      tareas: List<Tarea>.from(
        (json["tareas"] as List).map((x) => mapJsonToTarea(x)),
      ),
      todasTareasHechas: json["todas_tareas_hechas"],
    );
  }

  static Tarea mapJsonToTarea(Map<String, dynamic> json) {
    return Tarea(
      id: json["id"],
      auxTiempoPromedio: json["aux_tiempo_promedio"],
      titulo: json["titulo"],
      primeraTarea: json["primera_tarea"],
      ultimaTarea: json["ultima_tarea"],
      horaInicio: json["hora_inicio"] == null
          ? null
          : DateTime.parse(json["hora_inicio"]),
      horaFin: json["hora_fin"] == null
          ? null
          : DateTime.parse(json["hora_fin"]),
      numero: json["numero"],
      texto: json["texto"],
      estatus: json["estatus"],
      comentario: json["comentario"],
      tipoNombre: tipoNombreValues.map[json["tipo_nombre"]]!,
      tipoId: json["tipo_id"],
      completado: json["completado"],
      numeroMedida: json["numero_medida"],
      unidadMedida: json["unidad_medida"],
      faseTarea: json["fase_tarea"],
      maquinaria: List<dynamic>.from(json["maquinaria"].map((x) => x)),
      imagen: json["imagen"] == null ? null : [mapJsonToImagen(json["imagen"])],
      pasajeros: Map.from(
        json["pasajeros"]!,
      ).map((k, v) => MapEntry<String, int>(k, v)),
      equipo: List<dynamic>.from(json["equipo"].map((x) => x)),
    );
  }

  static Imagen mapJsonToImagen(Map<String, dynamic> json) {
    return Imagen(id: json["id"], imagen: json["imagen"]);
  }

  static ServiciosAle mapJsonToServiciosAle(Map<String, dynamic> json) {
    return ServiciosAle(
      id: json["id"],
      titulo: json["titulo"],
      tipoId: json["tipo_id"],
      servicioId: json["servicio_id"],
      horaInicio: DateTime.parse(json["hora_inicio"]),
      horaFin: DateTime.parse(json["hora_fin"]),
      cantidad: json["cantidad"],
      comentario: json["comentario"],
      estatus: json["estatus"],
      fkTurnaroundId: json["fk_turnaround_id"],
      imagen: List<dynamic>.from(json["imagen"].map((x) => x)),
      maquinaria: List<Maquinaria>.from(
        json["maquinaria"].map((x) => mapJsonToMaquinaria(x)),
      ),
    );
  }

  static Maquinaria mapJsonToMaquinaria(Map<String, dynamic> json) {
    return Maquinaria(
      id: json["id"],
      maquinariaId: json["maquinaria_id"],
      maquinariaIdentificador: json["maquinaria_identificador"],
      maquinariaModelo: json["maquinaria_modelo"],
      horaInicio: DateTime.parse(json["hora_inicio"]),
      horaFin: DateTime.parse(json["hora_fin"]),
    );
  }
}
