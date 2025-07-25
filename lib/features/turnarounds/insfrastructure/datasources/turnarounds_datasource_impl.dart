import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:turnaround_mobile/config/constants/environment.dart';
import 'package:turnaround_mobile/features/shared/shared.dart';

import '../../domain/domain.dart';
import '../mappers/mappers.dart';

class TurnaroundsDatasourceImpl implements TurnaroundsDatasource {
  late final Dio dio;
  final String accessToken;

  TurnaroundsDatasourceImpl({required this.accessToken})
    : dio = Dio(
        BaseOptions(
          baseUrl: Environment.apiUrl,
          headers: {'Authorization': 'Bearer $accessToken'},
          contentType: Headers.jsonContentType,
          validateStatus: (int? status) {
            return status != null;
            // return status != null && status >= 200 && status < 300;
          },
        ),
      );

  @override
  Future<ControlActividades> getControlDeActividades(int id) async {
    // Variable de control de actividades
    // final List<TurnaroundMain> turnarounds = [];
    try {
      final response = await dio.get<Map<String, dynamic>>(
        '/plantillas/control_actividades_by_id/$id/?token=$accessToken',
      );
      print('Response from getControlDeActividades: ${response.data}');
      final ControlActividades controlActividades =
          ControlActividadesMapper.mapJsonToControlActividades(
            response.data ?? {} as Map<String, dynamic>,
          );
      return controlActividades;
    } catch (e) {
      throw Exception('Error fetching control de actividades: $e');
    }
  }

  @override
  Future<List<TurnaroundMain>> getTurnaroundsByDate(
    int year,
    int month,
    int day,
  ) async {
    final List<TurnaroundMain> turnarounds = [];
    try {
      final response = await dio.get<List>(
        '/turnarounds/$year-$month-$day/?token=$accessToken',
      );

      for (final item in response.data ?? []) {
        turnarounds.add(TurnaroundMainMapper.mapJsonToTurnaroundMain(item));
      }

      return turnarounds;
    } catch (e) {
      return turnarounds; // Return an empty list on error
      // throw Exception('Error fetching turnarounds: $e');
    }
  }

  @override
  Future<SimpleApiResponse> startOperations(int id) async {
    try {
      return dio
          .post(
            '/vuelos/comenzar_operaciones/?token=$accessToken',
            data: {'id': id},
          )
          .then((response) {
            if (response.statusCode == 200) {
              final data = response.data;
              return SimpleApiResponse(
                message: 'Se empezaron las Actividades!',
                success: true,
              );
            } else {
              return SimpleApiResponse(
                message: 'Algo salió mal, intente nuevamente.',
                success: false,
              );
            }
          });
    } catch (e) {
      return SimpleApiResponse(
        message: 'Algo salió mal, intente nuevamente.',
        success: false,
      );
      // throw Exception('Error al iniciar operaciones: $e');
    }
  }

  // *****************************************************************************************************
  // Set Hora de Inicio **********************************************************************************
  @override
  Future<SimpleApiResponse> setHoraInicio(
    int id,
    DateTime horaInicio,
    String tipo,
  ) async {
    try {
      // print('Setting Hora de Inicio: $horaInicio for ID: $id');

      // Restar 4 horas para hacer matches with the backend
      horaInicio = horaInicio.subtract(const Duration(hours: 4));

      return dio
          .post(
            '/control-actividades/horainicio/?token=$accessToken',
            data: {
              'id': id,
              'hora_inicio': horaInicio.toIso8601String(),
              'tipo': tipo,
            },
          )
          .then((response) {
            print('Response from setHoraInicio: $response');
            if (response.statusCode == 201) {
              // final data = response.data;
              // print('Response from setHoraInicio: $data');
              return SimpleApiResponse(
                message: 'Hora de inicio actualizada correctamente.',
                success: true,
              );
            } else {
              return SimpleApiResponse(
                message: 'Algo salió mal, intente nuevamente.',
                success: false,
              );
            }
          });
    } catch (e) {
      print('Error setting hora de inicio en datasource: $e');
      return SimpleApiResponse(
        message: 'Algo salió mal, intente nuevamente.',
        success: false,
      );
      // throw Exception('Error al establecer la hora de inicio: $e');
    }
  }

  // *****************************************************************************************************
  // Set Hora de Inicio **********************************************************************************
  @override
  Future<SimpleApiResponse> setHoraInicioFin(
    int id,
    DateTime horaInicio,
    String tipo,
  ) async {
    try {
      // print('Setting Hora de Inicio: $horaInicio for ID: $id');

      // Restar 4 horas para hacer matches with the backend
      horaInicio = horaInicio.subtract(const Duration(hours: 4));
      final Map<String, Object> data;
      tipo == 'Hora de Inicio'
          ? data = {
              'id': id,
              'hora_inicio': horaInicio.toIso8601String(),
              'tipo': tipo,
            }
          : data = {
              'id': id,
              'hora_fin': horaInicio.toIso8601String(),
              'tipo': tipo,
            };

      return dio
          .post(
            '/control-actividades/horainiciofin/?token=$accessToken',
            data: data,
          )
          .then((response) {
            print('Response from setHoraInicio: $response');
            if (response.statusCode == 201) {
              // final data = response.data;
              // print('Response from setHoraInicio: $data');
              return SimpleApiResponse(
                message: 'Hora de inicio actualizada correctamente.',
                success: true,
              );
            } else {
              return SimpleApiResponse(
                message: 'Algo salió mal, intente nuevamente.',
                success: false,
              );
            }
          });
    } catch (e) {
      print('Error setting hora de inicio en datasource: $e');
      return SimpleApiResponse(
        message: 'Algo salió mal, intente nuevamente.',
        success: false,
      );
      // throw Exception('Error al establecer la hora de inicio: $e');
    }
  }

  @override
  Future<SimpleApiResponse> uploadImage(body) {
    return dio
        .post('/control-actividades/imagen/?token=$accessToken', data: body)
        .then((response) {
          if (response.statusCode == 201) {
            return SimpleApiResponse(
              message: 'Imagen subida correctamente.',
              success: true,
            );
          } else {
            return SimpleApiResponse(
              message: 'Error al subir la imagen.',
              success: false,
            );
          }
        });
  }

  @override
  Future<SimpleApiResponse> deleteImage(body) {
    return dio
        .put('/control-actividades/imagen/?token=$accessToken', data: body)
        .then((response) {
          print('Response from deleteImage: $response');
          if (response.statusCode == 201) {
            return SimpleApiResponse(
              message: 'Imagen eliminada correctamente.',
              success: true,
            );
          } else {
            return SimpleApiResponse(
              message: 'Error al eliminar la imagen.',
              success: false,
            );
          }
        });
  }

  @override
  Future<SimpleApiResponse> updateImage(body) {
    // TODO: implement updateImage
    throw UnimplementedError();
  }

  @override
  Future<CategoriasEquiposGseResponse> getCategoriasEquiposGSE(
    int id,
    int idPlantilla,
    Map<String, dynamic> body,
  ) {
    return dio
        .post(
          '/maquinarias/lista_categoria_maquinaria/$idPlantilla/?token=$accessToken',
          data: body,
        )
        .then((response) {
          print('Response from getCategoriasEquiposGSE: $response');
          if (response.statusCode == 200) {
            final data = response.data;

            final CategoriasEquiposGseResponse categorias =
                CategoriasEquiposGseMapper.mapJsonToCategoriasEquiposGse(data);
            return categorias;
          } else {
            throw Exception('Error al obtener las categorias de equipos GSE.');
          }
        });
  }
}
