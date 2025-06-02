

import '../domain.dart';

abstract class AuthRepository {
  Future<AuthResponse> login(String email, String password);
  Future<AuthResponse> register(String email, String password, String fullName);
  Future<AuthResponse> checkAuthStatus( String token );
}