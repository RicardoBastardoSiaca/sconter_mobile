

import '../../domain/domain.dart';

class LoginResponseMapper {

  static AuthResponse loginResponseJsonToEntity(Map<String, dynamic> json) => AuthResponse(
    token: json['token'], 
    username: json['username'], 
    cedula: json['cedula'], 
    id: json['id'], 
    rol: List<int>.from(json['rol']), 
    imagen: json['imagen'],
    value: json['value'], 

  );
}