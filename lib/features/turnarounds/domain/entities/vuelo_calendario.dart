import 'dart:convert';

class VueloCalendario {
  final int id;
  final String auxFecha; // Nuevo campo
  final String? trcHoraInicio;
  final String? trcFechaInicio;
  final String? trcHoraFin;
  final String? trcFechaFin;
  final int aerolineaId;
  final String aerolineaNombre;
  final String imagen;
  final String imagenLogo;
  final String? fechaInicio;
  final String? fechaFin;
  final String estatusTrc;
  final String estatusVuelo;
  final String? estatusColor; // Nuevo campo
  final String numeroVuelo;
  final String routing;
  final String vueloHoraInicio;
  final String vueloHoraFin;
  final String lugarSalidaOaci;
  final String lugarSalidaIata;
  final String lugarDestinoOaci;
  final String lugarDestinoIata;
  final String horaInicio;
  final String horaFin;
  final int estacionId;
  final String estacionNombre;
  final String auxHoraInicioReal;
  final String auxHoraFinReal;
  final int? gate;

  VueloCalendario({
    required this.id,
    required this.auxFecha,
    this.trcHoraInicio,
    this.trcFechaInicio,
    this.trcHoraFin,
    this.trcFechaFin,
    required this.aerolineaId,
    required this.aerolineaNombre,
    required this.imagen,
    required this.imagenLogo,
    this.fechaInicio,
    this.fechaFin,
    required this.estatusTrc,
    required this.estatusVuelo,
    this.estatusColor,
    required this.numeroVuelo,
    required this.routing,
    required this.vueloHoraInicio,
    required this.vueloHoraFin,
    required this.lugarSalidaOaci,
    required this.lugarSalidaIata,
    required this.lugarDestinoOaci,
    required this.lugarDestinoIata,
    required this.horaInicio,
    required this.horaFin,
    required this.estacionId,
    required this.estacionNombre,
    required this.auxHoraInicioReal,
    required this.auxHoraFinReal,
    this.gate,
  });

  /// Mapper Externo: Convierte un Map (JSON) a una instancia de VueloCalendario
  factory VueloCalendario.fromJson(Map<String, dynamic> json) {
    return VueloCalendario(
      id: json['id'] ?? 0,
      auxFecha: json['aux_fecha'] ?? '',
      trcHoraInicio: json['trc_hora_inicio'],
      trcFechaInicio: json['trc_fecha_inicio'],
      trcHoraFin: json['trc_hora_fin'],
      trcFechaFin: json['trc_fecha_fin'],
      aerolineaId: json['aerolinea_id'] ?? 0,
      aerolineaNombre: json['aerolinea_nombre'] ?? '',
      imagen: json['imagen'] ?? '',
      imagenLogo:
          json['imagen_logo'] ?? '', // Corregido el typo del JSON original
      fechaInicio: json['fecha_inicio'],
      fechaFin: json['fecha_fin'],
      estatusTrc: json['estatus_trc'] ?? '',
      estatusVuelo: json['estatus_vuelo'] ?? '',
      estatusColor: json['estatus_color'] ?? '',
      numeroVuelo: json['numero_vuelo'] ?? '',
      routing: json['routing'] ?? '',
      vueloHoraInicio: json['vuelo_hora_inicio'] ?? '',
      vueloHoraFin: json['vuelo_hora_fin'] ?? '',
      lugarSalidaOaci: json['lugar_salida_oaci'] ?? '',
      lugarSalidaIata: json['lugar_salida_iata'] ?? '',
      lugarDestinoOaci: json['lugar_destino_oaci'] ?? '',
      lugarDestinoIata: json['lugar_destino_iata'] ?? '',
      horaInicio: json['hora_inicio'] ?? '',
      horaFin: json['hora_fin'] ?? '',
      estacionId: json['estacion_id'] ?? 0,
      estacionNombre: json['estacion_nombre'] ?? '',
      auxHoraInicioReal: json['aux_hora_inicio_real'] ?? '',
      auxHoraFinReal: json['aux_hora_fin_real'] ?? '',
      gate: json['gate'] ,
    );
  }

  /// Método para convertir la clase de vuelta a JSON (Opcional)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'trc_hora_inicio': trcHoraInicio,
      'trc_fecha_inicio': trcFechaInicio,
      'trc_hora_fin': trcHoraFin,
      'trc_fecha_fin': trcFechaFin,
      'aerolinea_id': aerolineaId,
      'aerolinea_nombre': aerolineaNombre,
      'imagen': imagen,
      'imagen_logo': imagenLogo,
      'fecha_inicio': fechaInicio,
      'fecha_fin': fechaFin,
      'estatus_trc': estatusTrc,
      'estatus_vuelo': estatusVuelo,
      'numero_vuelo': numeroVuelo,
      'routing': routing,
      'vuelo_hora_inicio': vueloHoraInicio,
      'vuelo_hora_fin': vueloHoraFin,
      'lugar_salida_oaci': lugarSalidaOaci,
      'lugar_salida_iata': lugarSalidaIata,
      'lugar_destino_oaci': lugarDestinoOaci,
      'lugar_destino_iata': lugarDestinoIata,
      'hora_inicio': horaInicio,
      'hora_fin': horaFin,
      'estacion_id': estacionId,
      'estacion_nombre': estacionNombre,
      'aux_hora_inicio_real': auxHoraInicioReal,
      'aux_hora_fin_real': auxHoraFinReal,
      'gate': gate,
    };
  }
}

// Request model
class VueloCalendarioRequest {
  final DateTime start;
  final DateTime end;

  VueloCalendarioRequest({required this.start, required this.end});

  Map<String, dynamic> toJson() {
    return {
      'start_date': start.toIso8601String(),
      'end_date': end.toIso8601String(),
    };
  }
}

// *********************************************************************************************************
// *********************************************************************************************************

// import 'vuelo_calendario.dart'; // Tu entidad existente

class VueloLane {
  final String dia;
  final String diaSemana;
  final String diaNumero;
  final String aerolineaNombre;
  final int
  subFilaIndex; // Para saber si es la 1era, 2da o 3ra fila de esa aerolínea
  final List<VueloCalendario> vuelos;

  VueloLane({
    required this.dia,
    required this.diaSemana,
    required this.diaNumero,
    required this.aerolineaNombre,
    required this.subFilaIndex,
    required this.vuelos,
  });
}

// Función para agrupar los datos del backend
// List<Lane> generarLanes(List<VueloCalendario> vuelos) {
//   Map<String, Lane> mapLanes = {};

//   for (var vuelo in vuelos) {
//     // Creamos una llave única por Día + Aerolínea
//     // Si necesitas que una misma aerolínea tenga varias filas si hay choques,
//     // puedes añadir un índice al final de la llave.
//     String key = "${vuelo.auxFecha}_${vuelo.aerolineaNombre}";
    
//     if (!mapLanes.containsKey(key)) {
//       mapLanes[key] = Lane(
//         dia: vuelo.auxFecha,
//         aerolineaNombre: vuelo.aerolineaNombre,
//         vuelos: [],
//       );
//     }
//     mapLanes[key]!.vuelos.add(vuelo);
//   }
//   return mapLanes.values.toList();
// }


