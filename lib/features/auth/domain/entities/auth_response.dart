

class AuthResponse {
  final String token;
  final int id;
  final String username;
  final String cedula;
  final String? imagen;
  final List<int> rol;
  final bool value;

  AuthResponse({
    required this.token,
    required this.username,
    required this.cedula,
    required this.id,
    required this.imagen, 
    required this.rol, 
    required this.value,
  });
  
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




// "token": "8b6a856e80154d7f1891cab9da5ea943fe440a37",
// "value": true,
// "username": "usuario@usuario.com",
// "id": 1,
// "cedula": "123456"