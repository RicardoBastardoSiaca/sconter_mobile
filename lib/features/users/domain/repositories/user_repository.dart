import 'package:dio/src/form_data.dart';

import '../../../shared/shared.dart';
import '../entities/user.dart';

abstract class UserRepository {
  Future<User> getUserById(int id);

  Future<SimpleApiResponse> updateUser(FormData formData);
}
