



import 'dart:convert';

import 'package:drift/drift.dart' as drift;

import '../../../../config/config.dart';
import '../../domain/domain.dart';
import '../mappers/mappers.dart';

class DriftRequestApiDatasource extends StoredRequestApiDataSource {

  final AppDatabase database;

// constructor with optional database parameter
  DriftRequestApiDatasource([AppDatabase? databaseToUse])
      : database = databaseToUse ?? db;


  @override
  Future<void> deleteApiRequestApi(int id) {
    // TODO: implement deleteApiRequestApi
    throw UnimplementedError();
  }

  @override
  Future<List<RequestApi>> getAllRequestApis() {
    // Contruir el query
    final query = database.select(database.apiCall);
    // Ejecutar el query
    final result = query.get();
    // Mapear el resultado a List<RequestApi>
    return result.then((rows) {
      return rows.map((row) => RequestApiMapper.fromJson(row.toJson())).toList();
    });
  }

  @override
  Future<RequestApi?> getRequestApiById(int id) {
    
    // Contruir el query
    final query = database.select(database.apiCall)..where((tbl) => tbl.id.equals(id));
    // Ejecutar el query
    final result = query.getSingleOrNull();
    // Mapear el resultado a RequestApi
    return result.then((row) {
      if (row == null) {
        return null;
      }
      return RequestApiMapper.fromJson(row.toJson());
    });
  }
  @override
  Future<void> saveRequestApi(RequestApi requestApi) async {

    await database.into(database.apiCall).insert(
      ApiCallCompanion.insert(
        id: drift.Value(requestApi.id),
        url: requestApi.url,
        method: requestApi.method,
        body: requestApi.body,
        headers: requestApi.headers == null
            ? drift.Value(null)
            : drift.Value(jsonEncode(requestApi.headers?.map((k, v) => MapEntry(k, v.toString())))), 
        timestamp: requestApi.timestamp,
        retryCount: drift.Value(requestApi.retryCount),
        isProcessing: drift.Value(requestApi.isProcessing),
      ),
    );
    

    // return database.into(database.apiCall).insertOnConflictUpdate(companion);
  }
} 
