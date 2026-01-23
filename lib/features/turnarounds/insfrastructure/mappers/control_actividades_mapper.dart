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
      etaFechaIn: json["ETA_fecha_in"] == null
          ? null
          : DateTime.parse(json["ETA_fecha_in"]).toLocal(),
      numeroVueloOut: json["numero_vuelo_out"],
      etdOut: json["ETD_out"],
      etaOut: json["ETA_out"],
      etdFechaOut: json["ETD_fecha_out"] == null
          ? null
          : DateTime.parse(json["ETD_fecha_out"]).toLocal(),
      gate: json["gate"],
      tipoVueloId: json["tipo_vuelo_id"],
      // Sometime tipo_servicio_id is not present in the json
      tipoServicioId: json.containsKey("tipo_servicio_id")
          ? json["tipo_servicio_id"]
          : 0,
      // tipoServicioId: json["tipo_servicio_id"] ?? 0,
      lugarSalidaOaci: json["lugar_salida_oaci"],
      lugarDestinoOaci: json["lugar_destino_oaci"],
      lugarSalidaIata: json["lugar_salida_iata"],
      lugarDestinoIata: json["lugar_destino_iata"],
      identificador: json["identificador"],
      numeroVueloLlegada: json["numero_vuelo_llegada"],
      horaInicio: json["hora_inicio"],
      horaFin: json["hora_fin"],
      fechaInicio: json["fecha_inicio"] == null
          ? null
          : DateTime.parse(json["fecha_inicio"]).toLocal(),
      fechaFin: json["fecha_fin"] == null
          ? null
          : DateTime.parse(json["fecha_fin"]).toLocal(),
      horaInicioReal: json["hora_inicio_real"],
      horaFinReal: json["hora_fin_real"],
      fechaInicioReal: json["fecha_inicio_real"] == null
          ? null
          : DateTime.parse(json["fecha_inicio_real"]).toLocal(),
      fechaFinReal: json["fecha_fin_real"] == null
          ? null
          : DateTime.parse(json["fecha_fin_real"]).toLocal(),
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
      sla: json["sla"] == null ? [] : List<Sla>.from(json["sla"].map((x) => Sla.fromJson(x))),
      estatusNombre: json["estatus_nombre"],
      estatusId: json["estatus_id"],
    );
  }

  static Departamento mapJsonToDepartamento(Map<String, dynamic> json) {
    return Departamento(
      index: json["index"],
      nombreArea: json["nombre_area"],
      nombreCorto: json["nombre_corto"],
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
      // tareas: List<Tarea>.from(
      //   (json["tareas"] as List).map((x) => mapJsonToTarea(x)),
      // ),
      tareas: (json["tareas"] as List)
          .asMap()
          .entries
          .map((entry) => mapJsonToTarea(entry.value, entry.key))
          .toList(),
      todasTareasHechas: json["todas_tareas_hechas"],
      tareasCompletadas: json["tareas_completadas"],
      tareasPendientes: json["tareas_pendientes"],
      tareasTotales: json["tareas_totales"],
    );
  }

  static Tarea mapJsonToTarea(Map<String, dynamic> json, int indexTarea) {
    return Tarea(
      id: json["id"],
      auxTiempoPromedio: json["aux_tiempo_promedio"],
      titulo: json["titulo"],
      primeraTarea: json["primera_tarea"],
      ultimaTarea: json["ultima_tarea"],
      horaInicio: json["hora_inicio"] == null
          ? null
          : DateTime.parse(json["hora_inicio"]).toLocal(),
      horaFin: json["hora_fin"] == null
          ? null
          : DateTime.parse(json["hora_fin"]).toLocal(),
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
      // imagen: json["imagen"] == null ? null : [mapJsonToImagen(json["imagen"])],
      // if list is empty, return an empty list
      imagen: json["imagen"].toList().isEmpty
          ? null
          : List<Imagen>.from(json["imagen"].map((x) => mapJsonToImagen(x, "${json["titulo"]} - ${indexTarea + 1}"))),
      pasajeros: json["pasajeros"] == null
          ? null
          : ConteoPasajeros.fromJson(json["pasajeros"]),
      // pasajeros: json["pasajeros"] == null
      //     ? null
      //     : Map.from(
      //         json["pasajeros"]!,
      //       ).map((k, v) => MapEntry<String, int>(k, v)),
      equipo: json["equipo"].toList().isEmpty
          ? null
          : List<dynamic>.from(json["equipo"].map((x) => x)),
    );
  }

  static Imagen mapJsonToImagen(Map<String, dynamic> json, String sharedMessage) {
    return Imagen(id: json["id"], imagen: json["imagen"], sharedMessage: json["shareMessage"]);
  }

  static ServiciosAle mapJsonToServiciosAle(Map<String, dynamic> json) {
    return ServiciosAle(
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
      horaInicio: json["hora_inicio"] == null
          ? null
          : DateTime.parse(json["hora_inicio"]).toLocal(),
      horaFin: json["hora_fin"] == null
          ? null
          : DateTime.parse(json["hora_fin"]).toLocal(),
    );
  }
}
