import 'package:turnaround_mobile/config/config.dart';

import '../../domain/domain.dart';

class TurnaroundMainMapper {
  static TurnaroundMain mapJsonToTurnaroundMain(Map<String, dynamic> json) {
    return TurnaroundMain(
      id: json['id'],
      identificador: json['identificador'],
      // fkVuelo map
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

      // auth Response
    );
  }
  static ServicioMiscelaneo mapJsonToTServicioMiscelaneo(Map<String, dynamic> json) {
    return ServicioMiscelaneo(
      id: json['id'],
      identificador: json['identificador'],
      // fkVuelo map
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

      // auth Response
    );
  }


  // fkVuelo
  static FkVuelo mapJsonToFkVuelo(Map<String, dynamic> json) {
    return FkVuelo(
      id: json['id'],
      acReg: json['ac_reg'],
      acType: json['ac_type'],
      icaoHex: json['icao_hex'],
      entePagador: json['ente_pagador'],
      numeroVueloIn: json['numero_vuelo_in'],
      etdIn: json['ETD_in'],
      etaIn: json['ETA_in'],
      etaFechaIn: json['ETA_fecha_in'],
      lugarSalida: json['lugar_salida'] == null
          ? null
          : mapJsonToLugarDestino(json['lugar_salida']), //json['lugar_salida'],
      numeroVueloOut: json['numero_vuelo_out'],
      etdOut: json['ETD_out'],
      etaOut: json['ETA_out'],
      etdFechaOut: json['ETD_fecha_out'],
      lugarDestino: json['lugar_destino'] == null
          ? null
          : mapJsonToLugarDestino(
              json['lugar_destino'],
            ), //json['lugar_destino'],
      gate: json['gate'],
      fkAerolinea: mapJsonToFkAerolinea(json['fk_aerolinea']),
      // fkPlantilla: mapJsonToFkPlantilla(json['fk_plantilla']),
      fkPlantilla: json['fk_plantilla'] == null 
          ? null
          : mapJsonToFkPlantilla(json['fk_plantilla']),
      stn: mapJsonToLugarDestino(json['stn']), //json['stn'],
      tipoVuelo: mapJsonToTipo(json['tipo_vuelo']), //json['tipo_vuelo'],
      tipoServicio: json['tipo_servicio'] == null
          ? null
          : mapJsonToTipo(json['tipo_servicio'],), //json['tipo_servicio'],
      bloquearModificacion: json['bloquear_modificacion'],
      pasajerosTransito: json['pasajerosTransito'],
      claseEjecutiva: json['claseEjecutiva'],
      estado: json['estado'],
      comentarioCancelado: json['comentario_cancelado'],
      estatus: mapJsonToEstatus(json['estatus']), //json['estatus'],
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

  // FK Erolinea
  static FkAerolinea mapJsonToFkAerolinea(Map<String, dynamic> json) {
    return FkAerolinea(
      id: json['id'],
      nombre: json['nombre'],
      aka: json['aka'],
      // correo: json['correo'],
      // correoSecundario: json['correo_secundario'],
      // correoAdmin: json['correo_admin'],
      // correoAdminSecundario: json['correo_admin_secundario'],
      // telefono: json['telefono'],
      // telefonoSecundario: json['telefono_secundario'],
      pais: json['pais'],
      ciudad: json['ciudad'],
      codigoIata: json['codigo_iata'],
      codigoOaci: json['codigo_oaci'],
      codigoDemoraLista: json['codigo_demora_lista'],
      codigoDemoraEu: json['codigo_demora_eu'],
      imagen:
          '${Environment.apiUrl}/aerolineas${json['imagen']}', //json['imagen']',
      imagenLogo: json['imagen_logo'],
      estatus: json['estatus'],
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

  // Estatu
  static Estatus mapJsonToEstatus(Map<String, dynamic> json) {
    return Estatus(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      color: json['color'] ?? 'blanco', //json['color'],
    );
  }
}
