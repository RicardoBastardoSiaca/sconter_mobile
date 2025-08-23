import 'package:dio/src/form_data.dart';
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

  @override
  Future<SimpleApiResponse> savePasajeros(SavePasajerosRequest body) {
    return datasource.savePasajeros(body);
  }

  @override
  Future<List<CategoriaServicioAdicional>> getServiciosAdicionales() {
    return datasource.getServiciosAdicionales();
  }

  @override
  Future<SimpleApiResponse> saveServiciosAdicionales(
    ServiciosAdicionalRequest body,
  ) {
    return datasource.saveServiciosAdicionales(body);
  }

  @override
  Future<SimpleApiResponse> setHoraInicioServicioAdicional(
    SetHoraServicioAdicionalRequest body,
  ) {
    return datasource.setHoraInicioServicioAdicional(body);
  }

  @override
  Future<SimpleApiResponse> setHoraFinServicioAdicional(
    SetHoraServicioAdicionalRequest body,
  ) {
    return datasource.setHoraFinServicioAdicional(body);
  }

  @override
  Future<SimpleApiResponse> asignarMaquinariasSerivicioAdicional(
    Map<String, dynamic> body,
  ) {
    return datasource.asignarMaquinariasSerivicioAdicional(body);
  }

  @override
  Future setHoraMaquinariaServicioAdicional(
    HoraMaquinariaServicioAdicionalResponse body,
  ) {
    return datasource.setHoraMaquinariaServicioAdicional(body);
  }

  @override
  Future<SimpleApiResponse> setComentarioServicioAdicional(
    ComentarioServiciosAdicionalRequest body,
  ) {
    return datasource.setComentarioServicioAdicional(body);
  }

  @override
  Future<SimpleApiResponse> setComentarioServicioEspecial(
    ComentarioServiciosAdicionalRequest body,
  ) {
    return datasource.setComentarioServicioEspecial(body);
  }

  @override
  Future<List<CategoriaServicioAdicional>> getServiciosEspeciales() {
    return datasource.getServiciosEspeciales();
  }

  @override
  Future<SimpleApiResponse> saveServiciosEspeciales(
    ServiciosAdicionalRequest body,
  ) {
    return datasource.saveServiciosEspeciales(body);
  }

  @override
  Future<List<SupervisorUser>> getSupervisores(int idAerolinea) {
    return datasource.getSupervisores(idAerolinea);
  }

  @override
  Future firmaSupervisor(FormData formData) {
    return datasource.firmaSupervisor(formData);
  }

  @override
  Future getDemorasByTrc(int trcId) {
    return datasource.getDemorasByTrc(trcId);
  }

  @override
  Future getDemoras() {
    return datasource.getDemoras();
  }

  @override
  Future getDemorasByAirline(int airlineId) {
    return datasource.getDemorasByAirline(airlineId);
  }

  @override
  Future asignarDemora(Map<String, Object?> body) {
    return datasource.asignarDemora(body);
  }

  @override
  Future eliminarDemoraTrc(int demoraId) {
    return datasource.eliminarDemoraTrc(demoraId);
  }
}
