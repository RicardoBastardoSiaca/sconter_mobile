

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turnaround_mobile/features/auth/domain/domain.dart';
import 'package:turnaround_mobile/features/shared/infrastructure/services/key_value_storage_service.dart';
import 'package:turnaround_mobile/features/shared/infrastructure/services/key_value_storage_service_impl.dart';

import '../../infrastructure/infrastructure.dart';



// ! PROVIDER
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {

  final authRepository = AuthRepositoryImpl();
  final KeyValueStorageService keyValueStorageService = KeyValueStorageServiceImpl();

  return AuthNotifier(
    authRepository: authRepository,
    keyValueStorageService: keyValueStorageService
  );
});


//! NOTIFIER
class AuthNotifier extends StateNotifier<AuthState> {

  final AuthRepository authRepository ;
  final KeyValueStorageService keyValueStorageService;
  
  AuthNotifier({
    required this.authRepository,
    required this.keyValueStorageService
  }): super( AuthState() ){
    // Cuando se crea la primera instancia
    checkAuthStatus();
  }

  Future<void> loginUser ( String email, String password ) async {

    await Future.delayed( const Duration(milliseconds: 500) );

    try {
      final response = await authRepository.login(email, password);
      _setLoggedCredentials( response );
      
    } on CustomError catch (e) {
      logout( e.message );
    } catch (e) {
      logout( );
    }

    // final loginResponse = await authRepository.login(email, password);
    // state = state.copyWith( loginResponse: loginResponse, authStatus: AuthStatus.authenticated );
  }

  void registerUser ( String email, String password, String fullName ) {
    
  }

  void checkAuthStatus (  ) async{
    final token = await keyValueStorageService.getValue<String>('token');

    if( token == null ) return logout();

    try {
      final user = await authRepository.checkAuthStatus(token);
      _setLoggedCredentials(user);

    } catch (e) {
      logout();
    }
  }

  Future<void> logout ( [String errorMessage = ''] ) async {

    await keyValueStorageService.removeKey('token');
    
    state = state.copyWith( 
      authStatus: AuthStatus.notAuthenticated, 
      authResponse: null, 
      errorMessage: errorMessage, 
    );
  }
  _setLoggedCredentials ( AuthResponse authResponse ) async  {

    await keyValueStorageService.setKeyValue('token', authResponse.token);

    state = state.copyWith( 
      authResponse: authResponse, 
      authStatus: AuthStatus.authenticated, 
      errorMessage: ''
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
    AuthResponse? authResponse
  }) => AuthState(
    authStatus: authStatus ?? this.authStatus,
    errorMessage: errorMessage ?? this.errorMessage,
    loginResponse: authResponse ?? loginResponse
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



