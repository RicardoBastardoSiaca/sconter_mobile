

import 'package:scounter_mobile/features/auth/domain/domain.dart';

import '../infrastructure.dart';

class AuthRepositoryImpl implements AuthRepository {

  final AuthDataSource dataSource;

  AuthRepositoryImpl({
      AuthDataSource? dataSource
    }) : dataSource = dataSource ?? AuthDataSourceImpl();

@override
  Future<AuthResponse> checkAuthStatus(String token) {
    return dataSource.checkAuthStatus(token);
  }

  @override
  Future<AuthResponse> login(String email, String password) {
    return dataSource.login(email, password);
  }

  @override
  Future<AuthResponse> register(String email, String password, String fullName) {
    // TODO: implement register
    throw UnimplementedError();
  }
}