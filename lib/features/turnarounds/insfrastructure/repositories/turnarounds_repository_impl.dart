import 'package:turnaround_mobile/features/shared/shared.dart';

import '../../domain/domain.dart';

class TurnaroundsRepositoryImpl extends TurnaroundsRepository {
  TurnaroundsDatasource datasource;

  TurnaroundsRepositoryImpl(this.datasource);

  @override
  Future<ControlActividades> getControlDeActividades(int id) {
    return datasource.getControlDeActividades(id);
  }

  @override
  Future<List<TurnaroundMain>> getTurnaroundsByDate(
    int year,
    int month,
    int day,
  ) {
    return datasource.getTurnaroundsByDate(year, month, day);
  }

  @override
  Future<SimpleApiResponse> startOperations(int id) {
    return datasource.startOperations(id);
  }

  @override
  Future<SimpleApiResponse> setHoraInicio(
    int id,
    DateTime horaInicio,
    String tipo,
  ) {
    // TODO: implement setHoraInicio
    return datasource.setHoraInicio(id, horaInicio, tipo);
  }

  @override
  Future<SimpleApiResponse> setHoraInicioFin(
    int id,
    DateTime horaInicio,
    String tipo,
  ) {
    // TODO: implement setHoraInicioFin
    return datasource.setHoraInicioFin(id, horaInicio, tipo);
  }
}
