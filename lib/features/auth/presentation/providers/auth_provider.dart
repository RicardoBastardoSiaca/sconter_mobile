

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turnaround_mobile/features/auth/domain/domain.dart';

import '../../infrastructure/infrastructure.dart';



// ! PROVIDER
final authProvider = StateNotifierProvider.autoDispose<AuthNotifier, AuthState>((ref) {

  final authRepository = AuthRepositoryImpl();
  return AuthNotifier(
    authRepository: authRepository
  );
});


//! NOTIFIER
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository authRepository ;
  AuthNotifier({
    required this.authRepository
  }): super( AuthState() );

  Future<void> loginUser ( String email, String password ) async {

    await Future.delayed( const Duration(milliseconds: 500) );

    try {
      final response = await authRepository.login(email, password);
      _setLoggedCredentials( response );
      
    } on CustomError catch (e) {
      logout( e.message );
    } catch (e) {
      logout( 'Algo salio mal' );
    }

    // final loginResponse = await authRepository.login(email, password);
    // state = state.copyWith( loginResponse: loginResponse, authStatus: AuthStatus.authenticated );
  }

  void registerUser ( String email, String password, String fullName ) {
    
  }

  void checkAuthStatus (  ) {

  }

  Future<void> logout ( [String errorMessage = ''] ) async {
    state = state.copyWith( 
      authStatus: AuthStatus.notAuthenticated, 
      loginResponse: null, 
      errorMessage: errorMessage, 
    );
  }
  _setLoggedCredentials ( AuthResponse loginResponse ) {
    // TODO: guardar el token en el dispositivo
    state = state.copyWith( 
      loginResponse: loginResponse, 
      authStatus: AuthStatus.authenticated, 
    );
  }
}

//! STATE

enum AuthStatus {
  checking,
  authenticated,
  notAuthenticated
}

class AuthState {
  final AuthStatus authStatus;
  final String errorMessage;
  final AuthResponse? loginResponse;

  AuthState({
    this.authStatus = AuthStatus.checking,
    this.errorMessage = '',
    this.loginResponse
  });

  copyWith({
    AuthStatus? authStatus,
    String? errorMessage,
    AuthResponse? loginResponse
  }) => AuthState(
    authStatus: authStatus ?? this.authStatus,
    errorMessage: errorMessage ?? this.errorMessage,
    loginResponse: loginResponse ?? this.loginResponse
  );
}

    // "token": "e81188af24f14d3d022f6c7f4fc12e9dce0388fb",
    // "value": true,
    // "username": "usuario@usuario.com",
    // "id": 1,
    // "rol": [
    //     1,
    //     2,
    //     3
    // ],
    // "imagen": "",
    // "cedula": "123456"



