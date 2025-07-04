import 'package:turnaround_mobile/features/turnarounds/domain/entities/turnaround_main.dart';

import '../entities/control_actividades.dart';

abstract class TurnaroundsRepository {
  Future<List<TurnaroundMain>> getTurnaroundsByDate(
    int year,
    int month,
    int day,
  );

  Future<ControlActividades> getControlDeActividades(int id);

  // TODO Asignar Personal

  // TODO asignar Equipos GSE

  //
}
