


import 'package:dio/dio.dart';
import 'package:turnaround_mobile/config/constants/environment.dart';

import '../../domain/domain.dart';
import '../mappers/mappers.dart';

class TurnaroundsDatasourceImpl implements TurnaroundsDatasource {

  late final Dio dio;
  final String accessToken;

  TurnaroundsDatasourceImpl({
    required this.accessToken
    }) : dio = Dio(
      BaseOptions(
        baseUrl: Environment.apiUrl,
        headers: {'Authorization': 'Bearer $accessToken'},
      )
    );



  @override
  Future<TurnaroundMain> getControlDeActividades(int id) {
    // TODO: implement getControlDeActividades
    throw UnimplementedError();
  }

  @override
  Future<List<TurnaroundMain>> getTurnaroundsByDate(int year, int month, int day) async {
    final response = await dio.get<List>('/turnarounds/$year-$month-$day/?token=$accessToken');
    final List< TurnaroundMain> turnarounds 
    = [];
    // final turnarounds = TurnaroundsMapper.turnaroundsJsonToEntity(response.data ?? []);

    for (final item in response.data ?? []) {
      turnarounds.add(TurnaroundMainMapper.mapJsonToTurnaroundMain(item));
    }

    return turnarounds;
    
  }
 } 