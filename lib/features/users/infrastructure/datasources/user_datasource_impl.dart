import 'package:dio/dio.dart';
import 'package:turnaround_mobile/features/shared/domain/entities/simple_api_response.dart';
import 'package:turnaround_mobile/features/users/domain/datasources/user_datasource.dart';
import 'package:turnaround_mobile/features/users/domain/entities/user.dart';

import '../../../../config/config.dart';

class UserDatasourceImpl implements UserDatasource {
  late final Dio dio;
  final String accessToken;

  UserDatasourceImpl({required this.accessToken})
    : dio = Dio(
        BaseOptions(
          baseUrl: Environment.apiUrl,
          headers: {'Authorization': 'Bearer $accessToken'},
          contentType: Headers.jsonContentType,
          validateStatus: (int? status) {
            return status != null;
            // return status != null && status >= 200 && status < 300;
          },
        ),
      );

  @override
  Future<User> getUserById(int id) async {
    try {
      final response = await dio.get<Map<String, dynamic>>(
        '/usuarios/usuario_by_id/$id/?token=$accessToken',
      );
      print(response.data);
      if (response.statusCode == 200) {
        final user = User.fromJson(response.data!);
        return user;
      } else {
        throw Exception('Failed to load user: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching user: $e');
    }
  }

  @override
  Future<SimpleApiResponse> updateUser(FormData formData) async {
  return dio
        .put('/usuarios/api_usuario/?token=$accessToken', data: formData)
        .then((response) {
          print('Response from asignarDemora: $response');
          if (response.statusCode == 201 || response.statusCode == 200) {
            return SimpleApiResponse(
              message: 'Contraseña actualizada.',
              success: true,
            );
          } else {
            return SimpleApiResponse(
              message: 'Error al actualizar contraseña.',
              success: false,
            );
          }
        },
        onError: (error, stackTrace) {
          return SimpleApiResponse(
            message: 'Error al actualizar contraseña.',
            success: false,
          );
        });
  }
  
  //   try {
  //     dio.put('/usuarios/api_usuario/?token=$accessToken',data: formData,)
  //         .then((response) {
  //           print(response);
  //           if (response.statusCode == 201 || response.statusCode == 200) {
  //             return SimpleApiResponse(
  //               success: true,
  //               message: 'Contraseña actualizada',
  //             );
  //           } else {
  //             return SimpleApiResponse(
  //               success: false,
  //               message: 'Error al actualizar contraseña',
  //             );
  //             // return SimpleApiResponse(success: false, message: 'Error al actualizar el usuario: ${response.statusCode}');
  //             // throw Exception('Failed to update user: ${response.statusCode}');
  //           }
  //         });
  //   } catch (e) {
  //     return SimpleApiResponse(
  //       success: false,
  //       message: 'Error al actualizar contraseña',
  //     );
  //     // throw Exception('Error updating user: $e');
  //   }
    
  // }
  //   final response = await dio.put<Map<String, dynamic>>(
  //     '/usuarios/api_usuario/?token=$accessToken',
  //     data: formData,
  //   );
  //   print(response);
  //   if (response.statusCode == 201 || response.statusCode == 200) {
  //     return SimpleApiResponse(success: true, message: 'Usuario actualizado');
  //   } else {
  //     return SimpleApiResponse(success: false, message: 'Error al actualizar usuario');
  //     // return SimpleApiResponse(success: false, message: 'Error al actualizar el usuario: ${response.statusCode}');
  //     throw Exception('Failed to update user: ${response.statusCode}');

  //   }
  // } catch (e) {
  //       return SimpleApiResponse(success: false, message: 'Error al actualizar usuario');
  //   throw Exception('Error updating user: $e');
  // }
  //       print(response);
  //       if (response.statusCode == 201 || response.statusCode == 200) {
  //         return SimpleApiResponse(success: true, message: 'Contraseña actualizada');
  //       } else {
  //         return SimpleApiResponse(success: false, message: 'Error al actualizar contraseña');
  //         // return SimpleApiResponse(success: false, message: 'Error al actualizar la contraseña: ${response.statusCode}');
  //         throw Exception('Failed to update user: ${response.statusCode}');

  //       }
  //     });
  //   } catch (e) {
  //         return SimpleApiResponse(success: false, message: 'Error al actualizar contraseña');
  //     throw Exception('Error updating user: $e');
  //   }
  // }
}
