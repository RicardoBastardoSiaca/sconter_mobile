


import 'package:dio/src/form_data.dart';
import 'package:scounter_mobile/features/shared/domain/entities/simple_api_response.dart';
import 'package:scounter_mobile/features/users/domain/datasources/user_datasource.dart';
import 'package:scounter_mobile/features/users/domain/entities/user.dart';

import '../../domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  UserDatasource datasource;
  UserRepositoryImpl(this.datasource);

  @override
  Future<User> getUserById(int id) {
    return datasource.getUserById(id);
  }

  @override
  Future<SimpleApiResponse> updateUser(FormData formData) {
    return datasource.updateUser(formData);
  }
}