import 'package:scounter_mobile/config/config.dart';

import '../../domain/domain.dart';

class TurnaroundMainMapper {
  static TurnaroundMain mapJsonToTurnaroundMain(Map<String, dynamic> json) {
    return TurnaroundMain(
      id: json['id'],
      identificador: json['identificador'],
      fkVuelo: mapJsonToFkVuelo(json['fk_vuelo']),
      horaInicio: json['hora_inicio'],
      horaFin: json['hora_fin'],
      fechaInicio: json['fecha_inicio'],
      fechaFin: json['fecha_fin'],
      horaInicioReal: json['hora_inicio_real'],
      horaFinReal: json['hora_fin_real'],
      fechaInicioReal: json['fecha_inicio_real'],
      fechaFinReal: json['fecha_fin_real'],
      tiempoExtimado: json['tiempo_extimado'],
      fechaServicioInicio: json['fecha_servicio_inicio'],
      fechaServicioFin: json['fecha_servicio_fin'],
      horaServicioInicio: json['hora_servicio_inicio'],
      horaServicioFin: json['hora_servicio_fin'],
      horaInicioServicio: json['hora_inicio_servicio'],
      horaInicioServicio_: json['hora_inicio_servicio_'],
      horaFinServicio: json['hora_fin_servicio'],
      horaFinServicio_: json['hora_fin_servicio_'],
      comentario: json['comentario'],
      estatus: json['estatus'],
      nombreEstatus: json['nombre_estatus'],
      charter: json['charter'],

      // MAPEO DE POSICIONES
      posiciones: _parsePosicionesCounter(json['posicion']),

      // NUEVO: MAPEO DE PUERTA
      puerta: _parsePuerta(json['puerta']),
    );
  }

  // Método auxiliar para parsear el arreglo/objeto de puerta
  static PuertaResponse? _parsePuerta(dynamic rawPuerta) {
    if (rawPuerta == null) return null;

    // Si viene como una lista/arreglo (e.g. [{ "id": 1, "puerta": 1 }])
    if (rawPuerta is List && rawPuerta.isNotEmpty) {
      final firstItem = rawPuerta.first;
      if (firstItem is Map<String, dynamic>) {
        return mapJsonToPuertaResponse(firstItem);
      }
    }

    // Por retrocompatibilidad, si en algún momento llega como un solo Map
    if (rawPuerta is Map<String, dynamic>) {
      return mapJsonToPuertaResponse(rawPuerta);
    }

    return null;
  }

  // Mapper individual para Puerta
  static PuertaResponse mapJsonToPuertaResponse(Map<String, dynamic> json) {
    return PuertaResponse(
      id: json['id'],
      puerta: json['puerta'],
    );
  }

  // ...resto del mapper

  // Mapea la lista completa recibida de la API a una lista de objetos Puerta
static List<Puerta> mapJsonToPuertas(List<dynamic> json) {
  return json.map((e) => mapJsonToPuerta(e)).toList();
}

// Mapea un solo elemento del JSON al objeto Puerta
static Puerta mapJsonToPuerta(Map<String, dynamic> json) {
  return Puerta(
    id: json['pue_equ_id'],
    terminal: json['terminal'],
    nombre: json['pue_nombre'],
    fkTerminal: json['pue_terminal_fk'],
  );
}



  // Método auxiliar adaptado para retornar List<PosicionCounter>?
  static List<PosicionCounter>? _parsePosicionesCounter(dynamic rawPosicion) {
    if (rawPosicion == null) return null;

    // Caso 1: La API devuelve una lista de objetos
    if (rawPosicion is List) {
      return rawPosicion
          .whereType<Map<String, dynamic>>()
          .map((item) => mapJsonToPosicionCounter(item))
          .toList();
    }

    // Caso 2: La API devuelve un solo objeto Map (fallback/retrocompatibilidad)
    if (rawPosicion is Map<String, dynamic>) {
      return [mapJsonToPosicionCounter(rawPosicion)];
    }

    return null;
  }

  static ServicioMiscelaneo mapJsonToTServicioMiscelaneo(Map<String, dynamic> json) {
    return ServicioMiscelaneo(
      id: json['id'],
      identificador: json['identificador'],
      fkVuelo: mapJsonToFkVuelo(json['fk_vuelo']),
      horaInicio: json['hora_inicio'],
      horaFin: json['hora_fin'],
      fechaInicio: json['fecha_inicio'],
      fechaFin: json['fecha_fin'],
      horaInicioReal: json['hora_inicio_real'],
      horaFinReal: json['hora_fin_real'],
      fechaInicioReal: json['fecha_inicio_real'],
      fechaFinReal: json['fecha_fin_real'],
      tiempoExtimado: json['tiempo_extimado'],
      comentario: json['comentario'],
      estatus: json['estatus'],
      nombreEstatus: json['nombre_estatus'],
      charter: json['charter'],
    );
  }

  // fkVuelo
  static FkVuelo mapJsonToFkVuelo(Map<String, dynamic> json) {
    return FkVuelo(
      id: json['id'],
      acReg: json['ac_reg'] ?? '',
      acType: json['ac_type'] ?? '',
      icaoHex: json['icao_hex'],
      entePagador: json['ente_pagador'] ?? '',
      numeroVueloIn: json['numero_vuelo_in'] ?? '',
      etdIn: json['ETD_in'],
      etaIn: json['ETA_in'],
      etaFechaIn: json['ETA_fecha_in'],
      lugarSalida: json['lugar_salida'] == null
          ? null
          : mapJsonToLugarDestino(json['lugar_salida']),
      numeroVueloOut: json['numero_vuelo_out'],
      etdOut: json['ETD_out'],
      etaOut: json['ETA_out'],
      etdFechaOut: json['ETD_fecha_out'],
      lugarDestino: json['lugar_destino'] == null
          ? null
          : mapJsonToLugarDestino(json['lugar_destino']),
      gate: json['gate'],
      fkAerolinea: mapJsonToFkAerolinea(json['fk_aerolinea']),
      fkPlantilla: json['fk_plantilla'] == null 
          ? null
          : mapJsonToFkPlantilla(json['fk_plantilla']),
      stn: json['stn'] == null
          ? null
          : mapJsonToLugarDestino(json['stn']),
      tipoVuelo: mapJsonToTipo(json['tipo_vuelo']),
      tipoServicio: json['tipo_servicio'] == null
          ? null
          : mapJsonToTipo(json['tipo_servicio']),
      bloquearModificacion: json['bloquear_modificacion'],
      pasajerosTransito: json['pasajerosTransito'],
      claseEjecutiva: json['claseEjecutiva'],
      estado: json['estado'],
      comentarioCancelado: json['comentario_cancelado'],
      estatus: mapJsonToEstatus(json['estatus']),
      horaFinServicio: json['hora_fin_servicio'],
      horaFinServicio_: json['hora_fin_servicio_'],
      horaInicioServicio: json['hora_inicio_servicio'],
      horaInicioServicio_: json['hora_inicio_servicio_'],
      matricula: json['matricula'],
      operadoPor: json['operado_por'],
      terminal: json['terminal'],
      vistaIaim: json['vista_iaim'],
    );
  }

  // PosicionCounter
  static PosicionCounter mapJsonToPosicionCounter(Map<String, dynamic> json) {
    return PosicionCounter(
      id: json['id'],
      posicion: json['posicion'],
    );
  }

  // Lista de counters
  static List<Counter> mapJsonToCounters(List<dynamic> json) {
    return json.map((e) => mapJsonToCounter(e)).toList();
  }

  // Counter mapper
  static Counter mapJsonToCounter(Map<String, dynamic> json) {
    return Counter(
      id: json['pos_id'],
      terminal: json['terminal'],
      nombre: json['pos_nombre'],
      numero: json['pos_numero'],
      fkTerminal: json['pos_terminal_fk'],
    );
  }

  // LugarDestino
  static LugarDestino mapJsonToLugarDestino(Map<String, dynamic> json) {
    return LugarDestino(
      id: json['id'],
      codigoIata: json['codigo_iata'],
      codigoOaci: json['codigo_oaci'],
      ciudad: json['ciudad'],
      pais: json['pais'],
      aeropuerto: json['aeropuerto'],
      aka: json['aka'],
      estacion: json['estacion'],
      estatus: json['estatus'],
    );
  }

  // Estacion mapper
  static Estacion mapJsonToEstacion(Map<String, dynamic> json) {
    return Estacion(
      id: json['sur_id'],
      nombre: json['sur_nombre'],
      personaResponsable: json['sur_persona_responsable'] ?? '',
      telefono: json['sur_telefono'] ?? '',
      correoResponsable: json['sur_correo_responsable'] ?? '',
      estatus: json['sur_estatus'] ?? true,
      aeropuerto: json['sur_aeropuerto'],
    );
  }

  // Estaciones mapper
  static List<Estacion> mapJsonToEstaciones(List<dynamic> json) {
    return json.map((e) => mapJsonToEstacion(e)).toList();
  }

  // FK Aerolinea
  static FkAerolinea mapJsonToFkAerolinea(Map<String, dynamic> json) {
    return FkAerolinea(
      id: json['id'],
      nombre: json['nombre'],
      aka: json['aka'],
      pais: json['pais'],
      ciudad: json['ciudad'],
      codigoIata: json['codigo_iata'],
      codigoOaci: json['codigo_oaci'],
      codigoDemoraLista: json['codigo_demora_lista'],
      codigoDemoraEu: json['codigo_demora_eu'],
      imagen: '${Environment.apiUrl}/aerolineas${json['imagen']}',
      imagenLogo: json['imagen_logo'],
      estatus: json['estatus'],
      hasSupervisor: json['has_supervisor'],
    );
  }

  // FkPlantilla
  static FkPlantilla mapJsonToFkPlantilla(Map<String, dynamic> json) {
    return FkPlantilla(
      id: json['id'],
      titulo: json['titulo'],
      tiempoExtimado: json['tiempo_extimado'],
      tiempoPermitido: json['tiempo_permitido'],
      estatus: json['estatus'],
    );
  }

  // TIPO
  static Tipo mapJsonToTipo(Map<String, dynamic> json) {
    return Tipo(id: json['id'], nombre: json['nombre']);
  }

// TERMINALES mapper
  static List<Terminal> mapJsonToTerminales(List<dynamic> json) {
    return json.map((e) => mapJsonToTerminal(e)).toList();
  }
  // TERMINAL
  static Terminal mapJsonToTerminal(Map<String, dynamic> json) {
    return Terminal(id: json['ter_id'], nombre: json['ter_nombre']);
  }

  // Estatus
  static Estatus mapJsonToEstatus(Map<String, dynamic> json) {
    return Estatus(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      color: json['color'] ?? 'blanco',
    );
  }
}