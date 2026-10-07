import '../domain.dart';

class VueloLineup {
  final int id;
  final String? auxHora;
  final String? horaCulminacion;
  final String? auxFecha;
  final int? estacionId;
  final String? estacionNombre;
  final String? trcHoraInicio;
  final String? trcFechaInicio;
  final String? trcHoraFin;
  final String? trcFechaFin;
  final String? imagen;
  final int? aerolineaId;
  final String? aerolineaNombre;
  final String? aerolineaAbrev;
  final String? fechaInicio;
  final String? fechaFin;
  final String? estatusTrc;
  final String? estatusVuelo;
  final String? estatusColor;
  final String? numeroVuelo;
  final String? routing;
  final String? vueloHoraInicio;
  final String? vueloHoraFin;
  final String? lugarSalidaOaci;
  final String? lugarSalidaIata;
  final String? lugarDestinoOaci;
  final String? lugarDestinoIata;
  final String? horaInicio;
  final String? horaFin;

  // Usar estas
  final DateTime? horaInicioServicio;
  final DateTime? horaInicioServicioReal;
  final DateTime? horaFinServicio;
  final DateTime? horaFinServicioReal;

  final int? tipoServicio;
  final Map<String, AreaPersonal>? personal;
  final Terminal? terminal; // <-- Atributo para almacenar el objeto Terminal

  VueloLineup({
    required this.id,
    this.auxHora,
    this.horaCulminacion,
    this.auxFecha,
    this.estacionId,
    this.estacionNombre,
    this.trcHoraInicio,
    this.trcFechaInicio,
    this.trcHoraFin,
    this.trcFechaFin,
    this.imagen,
    this.aerolineaId,
    this.aerolineaNombre,
    this.aerolineaAbrev,
    this.fechaInicio,
    this.fechaFin,
    this.estatusTrc,
    this.estatusVuelo,
    this.estatusColor,
    this.numeroVuelo,
    this.routing,
    this.vueloHoraInicio,
    this.vueloHoraFin,
    this.lugarSalidaOaci,
    this.lugarSalidaIata,
    this.lugarDestinoOaci,
    this.lugarDestinoIata,
    this.horaInicio,
    this.horaFin,
    
    this.horaInicioServicio,
    this.horaInicioServicioReal,
    this.horaFinServicio,
    this.horaFinServicioReal,

    this.tipoServicio,
    this.personal,
    this.terminal,
  });

  factory VueloLineup.fromJson(Map<String, dynamic> json) {
    return VueloLineup(
      id: json['id'],
      auxHora: json['aux_hora'],
      horaCulminacion: json['hora_culminacion'],
      auxFecha: json['aux_fecha'],
      estacionId: json['estacion_id'],
      estacionNombre: json['estacion_nombre'],
      trcHoraInicio: json['trc_hora_inicio'],
      trcFechaInicio: json['trc_fecha_inicio'],
      trcHoraFin: json['trc_hora_fin'],
      trcFechaFin: json['trc_fecha_fin'],
      imagen: json['imagen'],
      aerolineaId: json['aerolinea_id'],
      aerolineaNombre: json['aerolinea_nombre'],
      aerolineaAbrev: json['aerolinea_abrev'],
      fechaInicio: json['fecha_inicio'],
      fechaFin: json['fecha_fin'],
      estatusTrc: json['estatus_trc'],
      estatusVuelo: json['estatus_vuelo'],
      estatusColor: json['estatus_color'],
      numeroVuelo: json['numero_vuelo'],
      routing: json['routing'],
      vueloHoraInicio: json['vuelo_hora_inicio'],
      vueloHoraFin: json['vuelo_hora_fin'],
      lugarSalidaOaci: json['lugar_salida_oaci'],
      lugarSalidaIata: json['lugar_salida_iata'],
      lugarDestinoOaci: json['lugar_destino_oaci'],
      lugarDestinoIata: json['lugar_destino_iata'],
      horaInicioServicio: json['hora_inicio_servicio'] != null
          ? DateTime.tryParse(json['hora_inicio_servicio'])
          : null,
      horaInicioServicioReal: json['hora_inicio_servicio_real'] != null
          ? DateTime.tryParse(json['hora_inicio_servicio_real'])
          : null,
      horaFinServicio: json['hora_fin_servicio'] != null
          ? DateTime.tryParse(json['hora_fin_servicio'])
          : null,
      horaFinServicioReal: json['hora_fin_servicio_real'] != null
          ? DateTime.tryParse(json['hora_fin_servicio_real'])
          : null,
      tipoServicio: json['tipo_servicio'],
      personal: json['personal'] != null
          ? (json['personal'] as Map<String, dynamic>).map(
              (key, value) => MapEntry(
                key,
                AreaPersonal.fromJson(value as Map<String, dynamic>),
              ),
            )
          : null,
      terminal: json['terminal'] != null
        ? Terminal.fromJson(json['terminal'])
        : null,
    );
  }
}

class AreaPersonal {
  final List<PersonalItem> gerente;
  final List<PersonalItem> supervisor;
  final List<PersonalItem> personal;

  AreaPersonal({
    this.gerente = const [],
    this.supervisor = const [],
    this.personal = const [],
  });

  factory AreaPersonal.fromJson(Map<String, dynamic> json) {
    return AreaPersonal(
      gerente: json['gerente'] != null
          ? List<PersonalItem>.from(
              json['gerente'].map((x) => PersonalItem.fromJson(x)))
          : [],
      supervisor: json['supervisor'] != null
          ? List<PersonalItem>.from(
              json['supervisor'].map((x) => PersonalItem.fromJson(x)))
          : [],
      personal: json['personal'] != null
          ? List<PersonalItem>.from(
              json['personal'].map((x) => PersonalItem.fromJson(x)))
          : [],
    );
  }
}

class PersonalItem {
  final int id;
  final int? perId;
  final String? per1erNombre;
  final String? per1erApellido;
  final String? per2doNombre;
  final String? per2doApellido;
  final String? perCargo;
  final String? nombreCompleto;
  final String? perArea;

  PersonalItem({
    required this.id,
    this.perId,
    this.per1erNombre,
    this.per1erApellido,
    this.per2doNombre,
    this.per2doApellido,
    this.perCargo,
    this.nombreCompleto,
    this.perArea,
  });

  factory PersonalItem.fromJson(Map<String, dynamic> json) {
    return PersonalItem(
      id: json['id'],
      perId: json['per_id'],
      per1erNombre: json['per_1er_nombre'],
      per1erApellido: json['per_1er_apellido'],
      per2doNombre: json['per_2do_nombre'],
      per2doApellido: json['per_2do_apellido'],
      perCargo: json['per_cargo'],
      nombreCompleto: json['nombre_completo'],
      perArea: json['per_area'],
    );
  }
}

class VueloLineupRequest {
  final DateTime start;
  final DateTime end;

  VueloLineupRequest({required this.start, required this.end});

  Map<String, dynamic> toJson() {
    return {
      'start_date': start.toIso8601String().split('T').first,
      'end_date': end.toIso8601String().split('T').first,
    };
  }
}