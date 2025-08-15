import 'package:dio/dio.dart';
import 'package:turnaround_mobile/config/config.dart';

import '../../domain/domain.dart';
import '../infrastructure.dart';

class AuthDataSourceImpl extends AuthDataSource {
  final dio = Dio(
    BaseOptions(
      baseUrl: Environment.apiUrl,
      // headers: {
      //   'Content-Type': 'application/json',
      // },
    ),
  );
  @override
  Future<AuthResponse> checkAuthStatus(String token) async {
    try {
      final response = await dio.post(
        '/usuarios/check_token/?token=$token',
        options: Options(headers: {'token': token}),
      );
      final loginResponse = LoginResponseMapper.loginResponseJsonToEntity(
        response.data,
      );
      return loginResponse;
    } on DioException catch (e) {
      // if (e.response?.statusCode == 401) throw WrongCredemtials();
      if (e.response?.statusCode == 401) {
        // throw CustomError(e.response?.data['mensaje'] ?? 'Credenciales inválidas');
        throw CustomError('Token incorrecto');
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError('Revise su conexión a internet');
      }
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<AuthResponse> login(String email, String password) async {
    try {
      final response = await dio.post(
        '/usuarios/login/',
        data: {'username': email, 'password': password},
      );
      final loginResponse = LoginResponseMapper.loginResponseJsonToEntity(
        response.data,
      );
      return loginResponse;
    } on DioException catch (e) {
      // if (e.response?.statusCode == 401) throw WrongCredemtials();
      if (e.response?.statusCode == 400) {
        // throw CustomError(e.response?.data['mensaje'] ?? 'Credenciales inválidas');
        throw CustomError('Credenciales inválidas');
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError('No hay conexión a internet');
      }
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<AuthResponse> register(
    String email,
    String password,
    String fullName,
  ) {
    // TODO: implement register
    throw UnimplementedError();
  }
}
