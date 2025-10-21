



import '../entities/entities.dart';

abstract class StoredRequestApiDataSource {
  Future<void> saveRequestApi(RequestApi requestApi);
  Future<RequestApi?> getRequestApiById(int id);
  Future<List<RequestApi>> getAllRequestApis();
  Future<void> deleteApiRequestApi(int id);
}


// abstract class DataSource {
//   Future<void> saveData(String key, String value);
//   Future<String?> getData(String key);
//   Future<void> deleteData(String key);
// }
