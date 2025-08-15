class SupervisorUser {
  final int id;
  final String cedula;
  final String correo;
  final bool esAerolinea;
  final String estatus;
  final int idAerolinea;
  final String idPersonal;
  final int idRol;
  final String? imagen;
  final String nombre;
  final String nombreAerolinea;
  final String nombrePersonal;
  final String nombreRol;
  final String telefono;
  final String ttpUsuario;

  SupervisorUser({
    required this.id,
    required this.cedula,
    required this.correo,
    required this.esAerolinea,
    required this.estatus,
    required this.idAerolinea,
    required this.idPersonal,
    required this.idRol,
    required this.imagen,
    required this.nombre,
    required this.nombreAerolinea,
    required this.nombrePersonal,
    required this.nombreRol,
    required this.telefono,
    required this.ttpUsuario,
  });

  factory SupervisorUser.fromJson(Map<String, dynamic> json) {
    return SupervisorUser(
      id: json['id'] as int,
      cedula: json['cedula'] as String,
      correo: json['correo'] as String,
      esAerolinea: json['es_aerolinea'] as bool,
      estatus: json['estatus'] as String,
      idAerolinea: json['id_aerolinea'] as int,
      idPersonal: json['id_personal'] as String,
      idRol: json['id_rol'] as int,
      imagen: json['imagen'] as String? ?? '',
      nombre: json['nombre'] as String,
      nombreAerolinea: json['nombre_aerolinea'] as String,
      nombrePersonal: json['nombre_personal'] as String,
      nombreRol: json['nombre_rol'] as String,
      telefono: json['telefono'] as String,
      ttpUsuario: json['ttpo_usuario'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cedula': cedula,
      'correo': correo,
      'es_aerolinea': esAerolinea,
      'estatus': estatus,
      'id_aerolinea': idAerolinea,
      'id_personal': idPersonal,
      'id_rol': idRol,
      'imagen': imagen,
      'nombre': nombre,
      'nombre_aerolinea': nombreAerolinea,
      'nombre_personal': nombrePersonal,
      'nombre_rol': nombreRol,
      'telefono': telefono,
      'ttpo_usuario': ttpUsuario,
    };
  }
}
