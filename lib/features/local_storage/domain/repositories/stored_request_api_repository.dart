

import '../entities/entities.dart';

abstract class StoredRequestApiRepository {
  Future<void> saveRequestApi(RequestApi requestApi);
  Future<void> saveRequestWithFiles(RequestApi requestApi);
  Future<RequestApi?> getRequestApiById(int id);
  Future<List<RequestApi>> getAllRequestApis();
  Future<void> deleteApiRequestApi(int id);
}
