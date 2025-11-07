



import 'dart:convert';

import 'package:drift/drift.dart' as drift;
import 'package:drift/drift.dart';

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
    // if -1 delete all
    if (id == -1) {
      return database.delete(database.apiCall).go();
    }
    // delete by id
    return (database.delete(database.apiCall)..where((tbl) => tbl.id.equals(id))).go();
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

try {
    await database.into(database.apiCall).insert(
      ApiCallCompanion.insert(
        id: drift.Value(requestApi.id),
        url: requestApi.url,
        method: requestApi.method,
        body: mapToValueString( requestApi.body),
        headers: requestApi.headers == null
            ? drift.Value(null)
            : drift.Value(jsonEncode(requestApi.headers?.map((k, v) => MapEntry(k, v.toString())))), 
        timestamp: requestApi.timestamp,
        retryCount: drift.Value(requestApi.retryCount),
        isProcessing: drift.Value(requestApi.isProcessing),
      ),
    );
  
} catch (e) {
  print('Error saving RequestApi: $e');
}
    

    // return database.into(database.apiCall).insertOnConflictUpdate(companion);
  }

  
} 


Value<String?> mapToValueString(Map<String, dynamic> map) {
  try {
    if (map.isEmpty) {
      return const Value(null);
    }
    
    // Convert map to JSON string using dart:convert
    final jsonString = json.encode(map);
    return Value(jsonString);
  } catch (e) {
    // Handle JSON encoding errors
    return const Value(null);
  }
}

Map<String, dynamic>? stringToMap(String? jsonString) {
  try {
    if (jsonString == null || jsonString.isEmpty) {
      return null;
    }
    // Decode JSON string to Map using dart:convert
    final Map<String, dynamic> map = json.decode(jsonString);
    return map;
  } catch (e) {
    // Handle JSON decoding errors
    return null;
  }
}