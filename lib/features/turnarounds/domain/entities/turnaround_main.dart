// To parse this JSON data, do
//
//     turnaroundMain = turnaroundMainFromJson(jsonString);

// import 'dart:convert';

// TurnaroundMain turnaroundMainFromJson(String str) => TurnaroundMain.fromJson(json.decode(str));

// String turnaroundMainToJson(TurnaroundMain data) => json.encode(data.toJson());

class TurnaroundMain {
  int id;
  dynamic identificador;
  FkVuelo fkVuelo;
  dynamic horaInicio;
  dynamic horaFin;
  dynamic fechaInicio;
  dynamic fechaFin;
  dynamic horaInicioReal;
  dynamic horaFinReal;
  dynamic fechaInicioReal;
  dynamic fechaFinReal;
  dynamic tiempoExtimado;
  dynamic comentario;
  int estatus;
  String nombreEstatus;
  dynamic charter;

  TurnaroundMain({
    required this.id,
    required this.identificador,
    required this.fkVuelo,
    required this.horaInicio,
    required this.horaFin,
    required this.fechaInicio,
    required this.fechaFin,
    required this.horaInicioReal,
    required this.horaFinReal,
    required this.fechaInicioReal,
    required this.fechaFinReal,
    required this.tiempoExtimado,
    required this.comentario,
    required this.estatus,
    required this.nombreEstatus,
    required this.charter,
  });

  // factory TurnaroundMain.fromJson(Map<String, dynamic> json) => TurnaroundMain(
  //     id: json["id"],
  //     identificador: json["identificador"],
  //     fkVuelo: FkVuelo.fromJson(json["fk_vuelo"]),
  //     horaInicio: json["hora_inicio"],
  //     horaFin: json["hora_fin"],
  //     fechaInicio: DateTime.parse(json["fecha_inicio"]),
  //     fechaFin: DateTime.parse(json["fecha_fin"]),
  //     horaInicioReal: json["hora_inicio_real"],
  //     horaFinReal: json["hora_fin_real"],
  //     fechaInicioReal: json["fecha_inicio_real"],
  //     fechaFinReal: json["fecha_fin_real"],
  //     tiempoExtimado: json["tiempo_extimado"],
  //     comentario: json["comentario"],
  //     estatus: json["estatus"],
  //     nombreEstatus: json["nombre_estatus"],
  //     charter: json["charter"],
  // );

  // Map<String, dynamic> toJson() => {
  //     "id": id,
  //     "identificador": identificador,
  //     "fk_vuelo": fkVuelo.toJson(),
  //     "hora_inicio": horaInicio,
  //     "hora_fin": horaFin,
  //     "fecha_inicio": "${fechaInicio.year.toString().padLeft(4, '0')}-${fechaInicio.month.toString().padLeft(2, '0')}-${fechaInicio.day.toString().padLeft(2, '0')}",
  //     "fecha_fin": "${fechaFin.year.toString().padLeft(4, '0')}-${fechaFin.month.toString().padLeft(2, '0')}-${fechaFin.day.toString().padLeft(2, '0')}",
  //     "hora_inicio_real": horaInicioReal,
  //     "hora_fin_real": horaFinReal,
  //     "fecha_inicio_real": fechaInicioReal,
  //     "fecha_fin_real": fechaFinReal,
  //     "tiempo_extimado": tiempoExtimado,
  //     "comentario": comentario,
  //     "estatus": estatus,
  //     "nombre_estatus": nombreEstatus,
  //     "charter": charter,
  // };
}

class FkVuelo {
  int id;
  String acReg;
  String acType;
  String? icaoHex;
  String entePagador;
  String numeroVueloIn;
  String? etdIn;
  String? etaIn;
  String? etaFechaIn;
  LugarDestino? lugarSalida;
  String? numeroVueloOut;
  String? etdOut;
  String? etaOut;
  String? etdFechaOut;
  LugarDestino? lugarDestino;
  int? gate;
  FkAerolinea fkAerolinea;
  FkPlantilla fkPlantilla;
  LugarDestino? stn;
  Tipo tipoVuelo;
  Tipo tipoServicio;
  bool bloquearModificacion;
  bool pasajerosTransito;
  bool claseEjecutiva;
  int estado;
  String? comentarioCancelado;
  Estatus estatus;

  FkVuelo({
    required this.id,
    required this.acReg,
    required this.acType,
    this.icaoHex,
    required this.entePagador,
    required this.numeroVueloIn,
    this.etdIn,
    this.etaIn,
    this.etaFechaIn,
    required this.lugarSalida,
    this.numeroVueloOut,
    this.etdOut,
    this.etaOut,
    this.etdFechaOut,
    this.lugarDestino,
    this.gate,
    required this.fkAerolinea,
    required this.fkPlantilla,
    this.stn,
    required this.tipoVuelo,
    required this.tipoServicio,
    required this.bloquearModificacion,
    required this.pasajerosTransito,
    required this.claseEjecutiva,
    required this.estado,
    this.comentarioCancelado,
    required this.estatus,
  });

  // factory FkVuelo.fromJson(Map<String, dynamic> json) => FkVuelo(
  //     id: json["id"],
  //     acReg: json["ac_reg"],
  //     acType: json["ac_type"],
  //     icaoHex: json["icao_hex"],
  //     entePagador: json["ente_pagador"],
  //     numeroVueloIn: json["numero_vuelo_in"],
  //     etdIn: json["ETD_in"],
  //     etaIn: json["ETA_in"],
  //     etaFechaIn: DateTime.parse(json["ETA_fecha_in"]),
  //     lugarSalida: LugarDestino.fromJson(json["lugar_salida"]),
  //     numeroVueloOut: json["numero_vuelo_out"],
  //     etdOut: json["ETD_out"],
  //     etaOut: json["ETA_out"],
  //     etdFechaOut: DateTime.parse(json["ETD_fecha_out"]),
  //     lugarDestino: LugarDestino.fromJson(json["lugar_destino"]),
  //     gate: json["gate"],
  //     fkAerolinea: FkAerolinea.fromJson(json["fk_aerolinea"]),
  //     fkPlantilla: FkPlantilla.fromJson(json["fk_plantilla"]),
  //     stn: LugarDestino.fromJson(json["stn"]),
  //     tipoVuelo: Tipo.fromJson(json["tipo_vuelo"]),
  //     tipoServicio: Tipo.fromJson(json["tipo_servicio"]),
  //     bloquearModificacion: json["bloquear_modificacion"],
  //     pasajerosTransito: json["pasajerosTransito"],
  //     claseEjecutiva: json["claseEjecutiva"],
  //     estado: json["estado"],
  //     comentarioCancelado: json["comentario_cancelado"],
  //     estatus: Estatus.fromJson(json["estatus"]),
  // );

  // Map<String, dynamic> toJson() => {
  //     "id": id,
  //     "ac_reg": acReg,
  //     "ac_type": acType,
  //     "icao_hex": icaoHex,
  //     "ente_pagador": entePagador,
  //     "numero_vuelo_in": numeroVueloIn,
  //     "ETD_in": etdIn,
  //     "ETA_in": etaIn,
  //     "ETA_fecha_in": "${etaFechaIn.year.toString().padLeft(4, '0')}-${etaFechaIn.month.toString().padLeft(2, '0')}-${etaFechaIn.day.toString().padLeft(2, '0')}",
  //     "lugar_salida": lugarSalida.toJson(),
  //     "numero_vuelo_out": numeroVueloOut,
  //     "ETD_out": etdOut,
  //     "ETA_out": etaOut,
  //     "ETD_fecha_out": "${etdFechaOut.year.toString().padLeft(4, '0')}-${etdFechaOut.month.toString().padLeft(2, '0')}-${etdFechaOut.day.toString().padLeft(2, '0')}",
  //     "lugar_destino": lugarDestino.toJson(),
  //     "gate": gate,
  //     "fk_aerolinea": fkAerolinea.toJson(),
  //     "fk_plantilla": fkPlantilla.toJson(),
  //     "stn": stn.toJson(),
  //     "tipo_vuelo": tipoVuelo.toJson(),
  //     "tipo_servicio": tipoServicio.toJson(),
  //     "bloquear_modificacion": bloquearModificacion,
  //     "pasajerosTransito": pasajerosTransito,
  //     "claseEjecutiva": claseEjecutiva,
  //     "estado": estado,
  //     "comentario_cancelado": comentarioCancelado,
  //     "estatus": estatus.toJson(),
  // };
}

class Estatus {
  String id;
  String nombre;
  String descripcion;
  String color;

  Estatus({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.color,
  });

  // factory Estatus.fromJson(Map<String, dynamic> json) => Estatus(
  //     id: json["id"],
  //     nombre: json["nombre"],
  //     descripcion: json["descripcion"],
  //     color: json["color"],
  // );

  // Map<String, dynamic> toJson() => {
  //     "id": id,
  //     "nombre": nombre,
  //     "descripcion": descripcion,
  //     "color": color,
  // };
}

class FkAerolinea {
  int id;
  String nombre;
  String aka;
  // String correo;
  // String? correoSecundario;
  // String correoAdmin;
  // String? correoAdminSecundario;
  // String telefono;
  // String? telefonoSecundario;
  String pais;
  String ciudad;
  String codigoIata;
  String codigoOaci;
  bool codigoDemoraLista;
  bool codigoDemoraEu;
  String? imagen;
  String? imagenLogo;
  bool estatus;

  FkAerolinea({
    required this.id,
    required this.nombre,
    required this.aka,
    // required this.correo,
    // this.correoSecundario,
    // required this.correoAdmin,
    // this.correoAdminSecundario,
    // required this.telefono,
    // this.telefonoSecundario,
    required this.pais,
    required this.ciudad,
    required this.codigoIata,
    required this.codigoOaci,
    required this.codigoDemoraLista,
    required this.codigoDemoraEu,
    this.imagen = '',
    this.imagenLogo = '',
    required this.estatus,
  });

  // factory FkAerolinea.fromJson(Map<String, dynamic> json) => FkAerolinea(
  //     id: json["id"],
  //     nombre: json["nombre"],
  //     aka: json["aka"],
  //     correo: json["correo"],
  //     correoSecundario: json["correo_secundario"],
  //     correoAdmin: json["correo_admin"],
  //     correoAdminSecundario: json["correo_admin_secundario"],
  //     telefono: json["telefono"],
  //     telefonoSecundario: json["telefono_secundario"],
  //     pais: json["pais"],
  //     ciudad: json["ciudad"],
  //     codigoIata: json["codigo_iata"],
  //     codigoOaci: json["codigo_oaci"],
  //     codigoDemoraLista: json["codigo_demora_lista"],
  //     codigoDemoraEu: json["codigo_demora_eu"],
  //     imagen: json["imagen"],
  //     imagenLogo: json["imagen_logo"],
  //     estatus: json["estatus"],
  // );

  // Map<String, dynamic> toJson() => {
  //     "id": id,
  //     "nombre": nombre,
  //     "aka": aka,
  //     "correo": correo,
  //     "correo_secundario": correoSecundario,
  //     "correo_admin": correoAdmin,
  //     "correo_admin_secundario": correoAdminSecundario,
  //     "telefono": telefono,
  //     "telefono_secundario": telefonoSecundario,
  //     "pais": pais,
  //     "ciudad": ciudad,
  //     "codigo_iata": codigoIata,
  //     "codigo_oaci": codigoOaci,
  //     "codigo_demora_lista": codigoDemoraLista,
  //     "codigo_demora_eu": codigoDemoraEu,
  //     "imagen": imagen,
  //     "imagen_logo": imagenLogo,
  //     "estatus": estatus,
  // };
}

class FkPlantilla {
  int id;
  String titulo;
  String tiempoExtimado;
  dynamic tiempoPermitido;
  bool estatus;

  FkPlantilla({
    required this.id,
    required this.titulo,
    required this.tiempoExtimado,
    required this.tiempoPermitido,
    required this.estatus,
  });

  // factory FkPlantilla.fromJson(Map<String, dynamic> json) => FkPlantilla(
  //     id: json["id"],
  //     titulo: json["titulo"],
  //     tiempoExtimado: json["tiempo_extimado"],
  //     tiempoPermitido: json["tiempo_permitido"],
  //     estatus: json["estatus"],
  // );

  // Map<String, dynamic> toJson() => {
  //     "id": id,
  //     "titulo": titulo,
  //     "tiempo_extimado": tiempoExtimado,
  //     "tiempo_permitido": tiempoPermitido,
  //     "estatus": estatus,
  // };
}

class LugarDestino {
  int id;
  String codigoIata;
  String codigoOaci;
  String ciudad;
  String pais;
  String aeropuerto;
  String aka;
  bool estacion;
  bool estatus;

  LugarDestino({
    required this.id,
    required this.codigoIata,
    required this.codigoOaci,
    required this.ciudad,
    required this.pais,
    required this.aeropuerto,
    required this.aka,
    required this.estacion,
    required this.estatus,
  });

  // factory LugarDestino.fromJson(Map<String, dynamic> json) => LugarDestino(
  //     id: json["id"],
  //     codigoIata: json["codigo_iata"],
  //     codigoOaci: json["codigo_oaci"],
  //     ciudad: json["ciudad"],
  //     pais: json["pais"],
  //     aeropuerto: json["aeropuerto"],
  //     aka: json["aka"],
  //     estacion: json["estacion"],
  //     estatus: json["estatus"],
  // );

  // Map<String, dynamic> toJson() => {
  //     "id": id,
  //     "codigo_iata": codigoIata,
  //     "codigo_oaci": codigoOaci,
  //     "ciudad": ciudad,
  //     "pais": pais,
  //     "aeropuerto": aeropuerto,
  //     "aka": aka,
  //     "estacion": estacion,
  //     "estatus": estatus,
  // };
}

class Tipo {
  int id;
  String nombre;

  Tipo({required this.id, required this.nombre});

  // factory Tipo.fromJson(Map<String, dynamic> json) => Tipo(
  //     id: json["id"],
  //     nombre: json["nombre"],
  // );

  // Map<String, dynamic> toJson() => {
  //     "id": id,
  //     "nombre": nombre,
  // };
}
