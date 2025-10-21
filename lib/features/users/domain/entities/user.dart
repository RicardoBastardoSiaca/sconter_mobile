class User {
  final int id;
  final String nombrePersonal;
  final String idPersonal;
  final List<int> sucursal;
  final String nombre;
  final String cedula;
  final String correo;
  final String telefono;
  final String estatus;
  final String nombreRol;
  final int idRol;
  final bool esAerolinea;
  final String idAerolinea;
  final String nombreAerolinea;
  final String ttpUsuario;
  final String imagen;

  User({
    required this.id,
    required this.nombrePersonal,
    required this.idPersonal,
    required this.sucursal,
    required this.nombre,
    required this.cedula,
    required this.correo,
    required this.telefono,
    required this.estatus,
    required this.nombreRol,
    required this.idRol,
    required this.esAerolinea,
    required this.idAerolinea,
    required this.nombreAerolinea,
    required this.ttpUsuario,
    required this.imagen,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      nombrePersonal: json['nombre_personal'] as String? ?? '',
      idPersonal: json['id_personal']?.toString() ?? '',
      sucursal: (json['sucursal'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          [],
      nombre: json['nombre'] as String? ?? '',
      cedula: json['cedula'] as String? ?? '',
      correo: json['correo'] as String? ?? '',
      telefono: json['telefono'] as String? ?? '',
      estatus: json['estatus'] as String? ?? '',
      nombreRol: json['nombre_rol'] as String? ?? '',
      idRol: (json['id_rol'] is String)
          ? int.tryParse(json['id_rol']) ?? 0
          : (json['id_rol'] as num?)?.toInt() ?? 0,
      esAerolinea: json['es_aerolinea'] as bool? ?? false,
      idAerolinea: json['id_aerolinea']?.toString() ?? '',
      nombreAerolinea: json['nombre_aerolinea'] as String? ?? '',
      ttpUsuario: json['ttpo_usuario'] as String? ?? '',
      imagen: json['imagen'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre_personal': nombrePersonal,
      'id_personal': idPersonal,
      'sucursal': sucursal,
      'nombre': nombre,
      'cedula': cedula,
      'correo': correo,
      'telefono': telefono,
      'estatus': estatus,
      'nombre_rol': nombreRol,
      'id_rol': idRol,
      'es_aerolinea': esAerolinea,
      'id_aerolinea': idAerolinea,
      'nombre_aerolinea': nombreAerolinea,
      'ttpo_usuario': ttpUsuario,
      'imagen': imagen,
    };
  }

  User copyWith({
    int? id,
    String? nombrePersonal,
    String? idPersonal,
    List<int>? sucursal,
    String? nombre,
    String? cedula,
    String? correo,
    String? telefono,
    String? estatus,
    String? nombreRol,
    int? idRol,
    bool? esAerolinea,
    String? idAerolinea,
    String? nombreAerolinea,
    String? ttpUsuario,
    String? imagen,
  }) {
    return User(
      id: id ?? this.id,
      nombrePersonal: nombrePersonal ?? this.nombrePersonal,
      idPersonal: idPersonal ?? this.idPersonal,
      sucursal: sucursal ?? this.sucursal,
      nombre: nombre ?? this.nombre,
      cedula: cedula ?? this.cedula,
      correo: correo ?? this.correo,
      telefono: telefono ?? this.telefono,
      estatus: estatus ?? this.estatus,
      nombreRol: nombreRol ?? this.nombreRol,
      idRol: idRol ?? this.idRol,
      esAerolinea: esAerolinea ?? this.esAerolinea,
      idAerolinea: idAerolinea ?? this.idAerolinea,
      nombreAerolinea: nombreAerolinea ?? this.nombreAerolinea,
      ttpUsuario: ttpUsuario ?? this.ttpUsuario,
      imagen: imagen ?? this.imagen,
    );
  }

  @override
  String toString() {
    return 'PersonalUsuario(id: $id, nombre: $nombre, cedula: $cedula, correo: $correo)';
  }
}
// class PersonalUsuario {
//   final int id;
//   final String nombrePersonal;
//   final String idPersonal;
//   final List<int> sucursal;
//   final String nombre;
//   final String cedula;
//   final String correo;
//   final String telefono;
//   final String estatus;
//   final String nombreRol;
//   final int idRol;
//   final bool esAerolinea;
//   final String idAerolinea;
//   final String nombreAerolinea;
//   final String ttpUsuario;
//   final String imagen;

//   PersonalUsuario({
//     required this.id,
//     required this.nombrePersonal,
//     required this.idPersonal,
//     required this.sucursal,
//     required this.nombre,
//     required this.cedula,
//     required this.correo,
//     required this.telefono,
//     required this.estatus,
//     required this.nombreRol,
//     required this.idRol,
//     required this.esAerolinea,
//     required this.idAerolinea,
//     required this.nombreAerolinea,
//     required this.ttpUsuario,
//     required this.imagen,
//   });

//   factory PersonalUsuario.fromJson(Map<String, dynamic> json) {
//     return PersonalUsuario(
//       id: json['id'] as int,
//       nombrePersonal: json['nombre_personal'] as String? ?? '',
//       idPersonal: json['id_personal']?.toString() ?? '',
//       sucursal: (json['sucursal'] as List<dynamic>?)
//               ?.map((e) => (e as num).toInt())
//               .toList() ??
//           [],
//       nombre: json['nombre'] as String? ?? '',
//       cedula: json['cedula'] as String? ?? '',
//       correo: json['correo'] as String? ?? '',
//       telefono: json['telefono'] as String? ?? '',
//       estatus: json['estatus'] as String? ?? '',
//       nombreRol: json['nombre_rol'] as String? ?? '',
//       idRol: (json['id_rol'] is String)
//           ? int.tryParse(json['id_rol']) ?? 0
//           : (json['id_rol'] as num?)?.toInt() ?? 0,
//       esAerolinea: json['es_aerolinea'] as bool? ?? false,
//       idAerolinea: json['id_aerolinea']?.toString() ?? '',
//       nombreAerolinea: json['nombre_aerolinea'] as String? ?? '',
//       ttpUsuario: json['ttpo_usuario'] as String? ?? '',
//       imagen: json['imagen'] as String? ?? '',
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'nombre_personal': nombrePersonal,
//       'id_personal': idPersonal,
//       'sucursal': sucursal,
//       'nombre': nombre,
//       'cedula': cedula,
//       'correo': correo,
//       'telefono': telefono,
//       'estatus': estatus,
//       'nombre_rol': nombreRol,
//       'id_rol': idRol,
//       'es_aerolinea': esAerolinea,
//       'id_aerolinea': idAerolinea,
//       'nombre_aerolinea': nombreAerolinea,
//       'ttpo_usuario': ttpUsuario,
//       'imagen': imagen,
//     };
//   }

//   User copyWith({
//     int? id,
//     String? nombrePersonal,
//     String? idPersonal,
//     List<int>? sucursal,
//     String? nombre,
//     String? cedula,
//     String? correo,
//     String? telefono,
//     String? estatus,
//     String? nombreRol,
//     int? idRol,
//     bool? esAerolinea,
//     String? idAerolinea,
//     String? nombreAerolinea,
//     String? ttpUsuario,
//     String? imagen,
//   }) {
//     return User(
//       id: id ?? this.id,
//       nombrePersonal: nombrePersonal ?? this.nombrePersonal,
//       idPersonal: idPersonal ?? this.idPersonal,
//       sucursal: sucursal ?? this.sucursal,
//       nombre: nombre ?? this.nombre,
//       cedula: cedula ?? this.cedula,
//       correo: correo ?? this.correo,
//       telefono: telefono ?? this.telefono,
//       estatus: estatus ?? this.estatus,
//       nombreRol: nombreRol ?? this.nombreRol,
//       idRol: idRol ?? this.idRol,
//       esAerolinea: esAerolinea ?? this.esAerolinea,
//       idAerolinea: idAerolinea ?? this.idAerolinea,
//       nombreAerolinea: nombreAerolinea ?? this.nombreAerolinea,
//       ttpUsuario: ttpUsuario ?? this.ttpUsuario,
//       imagen: imagen ?? this.imagen,
//     );
//   }

//   @override
//   String toString() {
//     return 'PersonalUsuario(id: $id, nombre: $nombre, cedula: $cedula, correo: $correo)';
//   }
// }