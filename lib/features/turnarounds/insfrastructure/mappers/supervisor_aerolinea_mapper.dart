import '../../domain/domain.dart';

class SupervisorUserMapper {
  static List<SupervisorUser> mapJsonListToSupervisorUsers(List<dynamic> json) {
    return json.map((e) => mapJsonToSupervisorUser(e)).toList();
  }

  static SupervisorUser mapJsonToSupervisorUser(Map<String, dynamic> json) {
    return SupervisorUser(
      id: json["id"],
      cedula: json["cedula"],
      correo: json["correo"],
      esAerolinea: json["es_aerolinea"],
      estatus: json["estatus"],
      idAerolinea: json["id_aerolinea"],
      idPersonal: json["id_personal"],
      idRol: json["id_rol"],
      imagen: json["imagen"] ?? '',
      nombre: json["nombre"],
      nombreAerolinea: json["nombre_aerolinea"],
      nombrePersonal: json["nombre_personal"],
      nombreRol: json["nombre_rol"],
      telefono: json["telefono"],
      ttpUsuario: json["ttpo_usuario"],
    );
  }
}
