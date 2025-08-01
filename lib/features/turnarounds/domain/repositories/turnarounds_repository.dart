import 'package:turnaround_mobile/features/shared/shared.dart';

import '../domain.dart';

abstract class TurnaroundsRepository {
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
  //
}
