import 'package:turnaround_mobile/features/turnarounds/domain/domain.dart';

abstract class TurnaroundsDatasource {
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
