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

  @override
  Future<SimpleApiResponse> uploadImage(body) {
    return datasource.uploadImage(body);
  }

  @override
  Future<SimpleApiResponse> deleteImage(body) {
    return datasource.deleteImage(body);
  }

  @override
  Future<SimpleApiResponse> updateImage(body) {
    return datasource.updateImage(body);
  }

  @override
  Future<CategoriasEquiposGseResponse> getCategoriasEquiposGSE(
    int id,
    int idPlantilla,
    Map<String, dynamic> body,
  ) {
    return datasource.getCategoriasEquiposGSE(id, idPlantilla, body);
  }

  @override
  Future<SimpleApiResponse> asignarEquiposGSE(Map<String, dynamic> body) {
    return datasource.asignarEquiposGSE(body);
  }

  @override
  Future<SimpleApiResponse> asignarMaquinariasTareas(
    Map<String, dynamic> body,
  ) {
    return datasource.asignarMaquinariasTareas(body);
  }

  @override
  Future<SimpleApiResponse> setHoraInicioFinMaquinaria(
    HoraInicioFinMaquinaria body,
  ) {
    return datasource.setHoraInicioFinMaquinaria(body);
  }

  @override
  Future<SimpleApiResponse> setComentario(ComentarioRequest body) {
    return datasource.setComentario(body);
  }

  @override
  Future<SimpleApiResponse> setNumero(SetNumeroTareaRequest body) {
    return datasource.setNumero(body);
  }
}
