import 'package:dio/dio.dart';
import 'package:turnaround_mobile/features/shared/shared.dart';
import 'package:turnaround_mobile/features/turnarounds/domain/domain.dart';

abstract class TurnaroundsDatasource {
  Future<List<TurnaroundMain>> getTurnaroundsByDate(
    int year,
    int month,
    int day,
  );

  Future<ControlActividades> getControlDeActividades(int id);

  // Iniciar operaciones
  Future<SimpleApiResponse> startOperations(int id);

  Future<SimpleApiResponse> setHoraInicio(
    int id,
    DateTime horaInicio,
    String tipo,
  );

  Future<SimpleApiResponse> setHoraInicioFin(
    int id,
    DateTime horaInicio,
    String tipo,
  );

  // Images
  Future<SimpleApiResponse> uploadImage(body);

  Future<SimpleApiResponse> updateImage(body);

  Future<SimpleApiResponse> deleteImage(body);

  // TODO Asignar Personal

  // get Categorias Equipos GSE
  Future<CategoriasEquiposGseResponse> getCategoriasEquiposGSE(
    int id,
    int idPlantilla,
    Map<String, dynamic> body,
  );

  Future<SimpleApiResponse> asignarEquiposGSE(Map<String, dynamic> body);

  Future<SimpleApiResponse> asignarMaquinariasTareas(Map<String, dynamic> body);

  Future<SimpleApiResponse> setHoraInicioFinMaquinaria(
    HoraInicioFinMaquinaria body,
  );

  Future<SimpleApiResponse> setComentario(ComentarioRequest body);

  Future<SimpleApiResponse> setNumero(SetNumeroTareaRequest body);

  Future<SimpleApiResponse> savePasajeros(SavePasajerosRequest body);

  // Service Adicionales
  Future<List<CategoriaServicioAdicional>> getServiciosAdicionales();

  Future<SimpleApiResponse> saveServiciosAdicionales(
    ServiciosAdicionalRequest body,
  );

  Future<SimpleApiResponse> setHoraInicioServicioAdicional(
    SetHoraServicioAdicionalRequest body,
  );
  Future<SimpleApiResponse> setHoraFinServicioAdicional(
    SetHoraServicioAdicionalRequest body,
  );

  Future<SimpleApiResponse> asignarMaquinariasSerivicioAdicional(
    Map<String, dynamic> body,
  );

  Future setHoraMaquinariaServicioAdicional(
    HoraMaquinariaServicioAdicionalResponse body,
  );

  Future<SimpleApiResponse> setComentarioServicioAdicional(
    ComentarioServiciosAdicionalRequest body,
  );

  Future<SimpleApiResponse> setComentarioServicioEspecial(
    ComentarioServiciosAdicionalRequest body,
  );

  Future<List<CategoriaServicioAdicional>> getServiciosEspeciales();

  Future<SimpleApiResponse> saveServiciosEspeciales(
    ServiciosAdicionalRequest body,
  );

  Future<List<SupervisorUser>> getSupervisores(int idAerolinea);

  Future firmaSupervisor(FormData formData);

  // Demoras
  Future getDemorasByTrc(int trcId);

  Future getDemoras();

  Future getDemorasByAirline(int airlineId);

  Future asignarDemora(Map<String, Object?> body);

  Future eliminarDemoraTrc(int demoraId);

  // Departamento con personal TRC
  Future getDepartamentosConPersonal(int idTrc);

  // Asignar personal en main
  Future<SimpleApiResponse> asignarPersonal(Map<String, dynamic> body);

  Future<SimpleApiResponse> cerrarVuelo(Map<String, Object?> body);

  Future<SimpleApiResponse> setCantidadServicioAdicional(Map<String, Object?> body);

  Future getCategoriasEquiposIt();

  Future<SimpleApiResponse> asignarEquiposItLimpiezaTareas(Map<String, Object> body);
}
