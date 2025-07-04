import 'package:dio/dio.dart';
import 'package:turnaround_mobile/config/constants/environment.dart';

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
        ),
      );

  @override
  Future<ControlActividades> getControlDeActividades(int id) {
    try {
      return dio
          .get<Map<String, dynamic>>(
            '/plantillas/control-control_actividades_by_id/$id/?token=$accessToken',
          )
          .then((response) {
            final controlActividades =
                ControlActividadesMapper.mapJsonToControlActividades(
                  response.data ?? {},
                );
            return controlActividades;
          });
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
}
