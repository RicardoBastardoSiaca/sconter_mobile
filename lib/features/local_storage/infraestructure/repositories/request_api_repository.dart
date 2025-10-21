


import '../../domain/domain.dart';

class RequestApiRepositoryImpl extends StoredRequestApiRepository {

  final StoredRequestApiDataSource dataSource;

  RequestApiRepositoryImpl({required this.dataSource});

  @override
  Future<void> deleteApiRequestApi(int id) {
    return dataSource.deleteApiRequestApi(id);
  }

  @override
  Future<List<RequestApi>> getAllRequestApis() {
    return dataSource.getAllRequestApis();
  }

  @override
  Future<RequestApi?> getRequestApiById(int id) {
    return dataSource.getRequestApiById(id);
  }

  @override
  Future<void> saveRequestApi(RequestApi requestApi) {
    return dataSource.saveRequestApi(requestApi);
  }
}
