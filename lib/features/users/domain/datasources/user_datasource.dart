import 'package:dio/dio.dart';

import '../../../shared/shared.dart';
import '../entities/user.dart';

abstract class UserDatasource {

  Future<User> getUserById(int id);

  Future<SimpleApiResponse> updateUser(FormData formData);
}
//   Future<SimpleApiResponse> login(String username, String password);

//   Future<SimpleApiResponse> changePassword(
//     String currentPassword,
//     String newPassword,
//   );

//   Future<SimpleApiResponse> resetPassword(String email);
// }
//   );

//   Future<List<User>> getAllUsers();

//   Future<User> getUserById(int id);
// }
