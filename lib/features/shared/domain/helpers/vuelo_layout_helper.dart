import '../../../turnarounds/domain/domain.dart';
// import '../../domain/entities/vuelo_calendario.dart';
// import '../../domain/entities/vuelo_lane.dart';

class VueloLayoutHelper {
  
  static List<VueloLane> asignarVuelosALanes(List<VueloCalendario> vuelos) {
    // 1. Agrupamos por Día + Aerolínea para saber qué vuelos compiten por el mismo espacio
    Map<String, List<VueloCalendario>> grupos = {};
    for (var v in vuelos) {
      String key = "${v.auxFecha}_${v.aerolineaNombre}";
      grupos.putIfAbsent(key, () => []).add(v);
    }

    List<VueloLane> allLanes = [];

    grupos.forEach((key, vuelosDelGrupo) {
      // 2. Ordenamos por hora de inicio (indispensable para el algoritmo de empaquetado)
      vuelosDelGrupo.sort((a, b) => a.horaInicio.compareTo(b.horaInicio));

      // Tracks representa las "sub-filas" dentro de una misma aerolínea
      List<List<VueloCalendario>> tracks = [];

      for (var vuelo in vuelosDelGrupo) {
        bool ubicado = false;
        
        for (var track in tracks) {
          // AQUÍ ES DONDE VA LA LÓGICA:
          // Si el vuelo puede entrar en este track sin chocar con los que ya están...
          if (puedeEntrarEnTrack(vuelo, track)) {
            track.add(vuelo);
            ubicado = true;
            break;
          }
        }
        
        // Si chocó con todos los tracks existentes, creamos una nueva sub-fila
        if (!ubicado) {
          tracks.add([vuelo]);
        }
      }

      // 3. Mapeamos los resultados a nuestra entidad de Dominio
      for (int i = 0; i < tracks.length; i++) {
        final partes = key.split('_');
        final dateStr = partes.isNotEmpty ? partes[0] : '';
        DateTime? parsedDate;
        try {
          parsedDate = DateTime.parse(dateStr);
        } catch (_) {
          parsedDate = null;
        }

        final diaSemanaName = parsedDate != null ? _weekdayName(parsedDate.weekday) : '';
        final diaNumeroStr = parsedDate != null ? parsedDate.day.toString().padLeft(2, '0') : (dateStr.split('-').lastWhere((_) => true, orElse: () => ''));

        allLanes.add(VueloLane(
          dia: dateStr,
          diaSemana: diaSemanaName,
          diaNumero: diaNumeroStr,
          aerolineaNombre: partes.length > 1 ? partes[1] : '',
          subFilaIndex: i,
          vuelos: tracks[i],
        ));
      }
    });

    return allLanes;
  }

  static String _weekdayName(int weekday) {
    const Map<int, String> names = {
      1: 'lunes',
      2: 'martes',
      3: 'miércoles',
      4: 'jueves',
      5: 'viernes',
      6: 'sábado',
      7: 'domingo',
    };
    return names[weekday] ?? '';
  }

  // Comprueba si un vuelo colisiona con CUALQUIERA de los vuelos que ya están en esa fila
  static bool puedeEntrarEnTrack(VueloCalendario nuevo, List<VueloCalendario> existentes) {
    double nStart = timeToDouble(nuevo.horaInicio);
    double nEnd = timeToDouble(nuevo.horaFin);

    for (var e in existentes) {
      double eStart = timeToDouble(e.horaInicio);
      double eEnd = timeToDouble(e.horaFin);
      
      // Fórmula de colisión de intervalos
      if (nStart < eEnd && nEnd > eStart) return false;
    }
    return true;
  }

  // Helper para convertir "HH:mm" a valor numérico (ej: "01:30" -> 1.5)
  static double timeToDouble(String? hora) {
    if (hora == null || hora.isEmpty) return 0.0;
    try {
      final partes = hora.split(':');
      final h = double.parse(partes[0]);
      final m = double.parse(partes[1]) / 60;
      return h + m;
    } catch (e) {
      return 0.0;
    }
  }
}