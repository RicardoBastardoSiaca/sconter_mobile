// import 'package:turnaround_mobile/config/config.dart';
import '../../domain/domain.dart';


// List mapper
class VuelosCalendarioListMapper {
  static List<VueloCalendario> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => VuelosCalendarioMapper.fromJson(json)).toList();
  }
}
class VuelosCalendarioMapper {
  static VueloCalendario fromJson(Map<String, dynamic> json) {
    return VueloCalendario(
      id: json['id'] ?? 0,
      auxFecha: json['aux_fecha'] ?? '', // Nuevo campo
      trcHoraInicio: json['trc_hora_inicio'],
      trcFechaInicio: json['trc_fecha_inicio'],
      trcHoraFin: json['trc_hora_fin'],
      trcFechaFin: json['trc_fecha_fin'],
      aerolineaId: json['aerolinea_id'] ?? 0,
      aerolineaNombre: json['aerolinea_nombre'] ?? '',
      imagen: json['imagen'] ?? '',
      imagenLogo: json['imagen_logo'] ?? '', // Corregido el typo del JSON original
      fechaInicio: json['fecha_inicio'],
      fechaFin: json['fecha_fin'],
      estatusTrc: json['estatus_trc'] ?? '',
      estatusVuelo: json['estatus_vuelo'] ?? '',
      estatusColor: json['estatus_color'] ?? '', // Nuevo campo
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
    );
  }

  static List<VueloCalendario> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((item) => fromJson(item)).toList();
  }
}