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
      return database.delete(database.requestApiRow).go();
    }
    // delete by id
    return (database.delete(
      database.requestApiRow,
    )..where((tbl) => tbl.id.equals(id))).go();
  }

  @override
  Future<List<RequestApi>> getAllRequestApis() async {
    // // Contruir el query
    // final query = database.select(database.requestApis);
    // // Ejecutar el query
    // final result = query.get();
    // // Mapear el resultado a List<RequestApi>
    // return result.then((rows) {
    //   return rows.map((row) => RequestApiMapper.fromJson(row.toJson())).toList();
    // });

    final requestApis = database.requestApiRow;
    final requestFiles = database.requestFileRow;

    // Use a join query to get requests with their files in one query
    final query =
        database.select(requestApis).join([
            leftOuterJoin(
              requestFiles,
              requestFiles.requestId.equalsExp(requestApis.id),
            ),
          ])
          ..where(requestApis.isProcessing.equals(false))
          ..orderBy([OrderingTerm(expression: requestApis.timestamp)]);

    final results = await query.get();

    // Group files by request ID
    final requestsMap = <int, RequestApi>{};
    final filesMap = <int, List<RequestFile>>{};

    for (final row in results) {
      final requestRow = row.readTable(requestApis);
      final fileRow = row.readTableOrNull(requestFiles);

      // Create or get the request
      if (!requestsMap.containsKey(requestRow.id)) {
        requestsMap[requestRow.id] = _rowToRequestApi(requestRow, []);
      }

      // Add file if it exists
      if (fileRow != null) {
        final requestFile = _rowToRequestFile(fileRow);
        filesMap.putIfAbsent(requestRow.id, () => []).add(requestFile);
      }
    }

    // Assign files to their respective requests
    for (final requestId in requestsMap.keys) {
      final request = requestsMap[requestId]!;
      final files = filesMap[requestId] ?? [];
      requestsMap[requestId] = request.copyWith(
        files: files.isNotEmpty ? files : null,
      );
    }

    return requestsMap.values.toList();
  }

  @override
  Future<RequestApi?> getRequestApiById(int id) {
    // Contruir el query
    final query = database.select(database.requestApiRow)
      ..where((tbl) => tbl.id.equals(id));
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
      await database
          .into(database.requestApiRow)
          .insert(
            RequestApiRowCompanion.insert(
              id: drift.Value(requestApi.id),
              url: requestApi.url,
              method: requestApi.method,
              body: mapToValueString(requestApi.body),
              headers: requestApi.headers == null
                  ? drift.Value(null)
                  : drift.Value(
                      jsonEncode(
                        requestApi.headers?.map(
                          (k, v) => MapEntry(k, v.toString()),
                        ),
                      ),
                    ),
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

  @override
  Future<void> saveRequestWithFiles(RequestApi requestApi) {
    return database.transaction(() async {
      // First, insert the main RequestApi
      final requestId = await database
          .into(database.requestApiRow)
          .insert(
            RequestApiRowCompanion.insert(
              id: drift.Value(requestApi.id),
              url: requestApi.url,
              method: requestApi.method,
              body: mapToValueString(requestApi.body),
              headers: requestApi.headers == null
                  ? drift.Value(null)
                  : drift.Value(
                      jsonEncode(
                        requestApi.headers?.map(
                          (k, v) => MapEntry(k, v.toString()),
                        ),
                      ),
                    ),
              timestamp: requestApi.timestamp,
              retryCount: drift.Value(requestApi.retryCount),
              isProcessing: drift.Value(requestApi.isProcessing),
              isMultipart: drift.Value(true),
            ),
          );

      // Then, insert associated files if any
      if (requestApi.files != null && requestApi.files!.isNotEmpty) {
        for (var file in requestApi.files!) {
          await database
              .into(database.requestFileRow)
              .insert(
                RequestFileRowCompanion.insert(
                  requestId: requestId,
                  filePath: file.filePath,
                  fieldName: file.fieldName,
                  fileName: file.fileName,
                  mimeType: file.mimeType,
                ),
              );
        }
      }
    });
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








// Helper methods to convert between rows and domain objects
  RequestApi _rowToRequestApi(RequestApiRowData row, List<RequestFile> files) {
    return RequestApi(
      id: row.id,
      url: row.url,
      method: row.method,
      headers: row.headers != null ? JsonDecoder().convert(row.headers!) : null,
      body: row.body != null ? JsonDecoder().convert(row.body!) : null,
      timestamp: row.timestamp,
      retryCount: row.retryCount,
      isProcessing: row.isProcessing,
      isMultipart: row.isMultipart,
      files: files.isNotEmpty ? files : null,
    );
  }

  RequestFile _rowToRequestFile(RequestFileRowData row) {
    return RequestFile(
      filePath: row.filePath,
      fieldName: row.fieldName,
      fileName: row.fileName,
      mimeType: row.mimeType,
    );
  }
// }