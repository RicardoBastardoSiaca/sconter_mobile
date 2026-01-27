

class AuthResponse {
  final String token;
  final int id;
  final String name;
  final String username;
  final String cedula;
  final String? imagen;
  final List<int> rol;
  final bool value;

  AuthResponse({
    required this.token,
    required this.name,
    required this.username,
    required this.cedula,
    required this.id,
    required this.imagen, 
    required this.rol, 
    required this.value,
  });

  // Getter para obtener los roles como Enums de Dart
  List<Roles> get rolesList => rol
      .map((id) => Roles.fromId(id))
      .whereType<Roles>() // Filtra nulos por si el backend manda un ID que no conoces
      .toList();
      
  // Método útil para verificar permisos rápidamente
  bool hasPermission(Roles roleToCheck) {
    return rol.contains(roleToCheck.id);
  }
  
}



enum Roles {
  // Perfil
  crearPerfil(1),
  modificarPerfil(2),
  eliminarPerfil(3),
  consultarPerfil(4),

  // Personal
  crearPersonal(5),
  modificarPersonal(6),
  eliminarPersonal(7),
  consultarPersonal(8),

  // Usuario
  crearUsuario(9),
  modificarUsuario(10),
  eliminarUsuario(11),
  consultarUsuario(12),

  // Cargo
  crearCargo(13),
  modificarCargo(14),
  eliminarCargo(15),
  consultarCargo(16),

  // Dirección
  crearDireccion(17),
  modificarDireccion(18),
  eliminarDireccion(19),
  consultarDireccion(20),

  // Gerencia
  crearGerencia(21),
  modificarGerencia(22),
  eliminarGerencia(23),
  consultarGerencia(24),

  // Plantilla
  crearPlantilla(25),
  modificarPlantilla(26),
  eliminarPlantilla(27),
  consultarPlantilla(28),

  // Actividad
  crearActividad(29),
  modificarActividad(30),
  eliminarActividad(31),
  consultarActividad(32),

  // Tarea
  crearTarea(33),
  modificarTarea(34),
  eliminarTarea(35),
  consultarTarea(36),

  // Maquinaria
  crearMaquinaria(37),
  modificarMaquinaria(38),
  eliminarMaquinaria(39),
  consultarMaquinaria(40),

  // Código de Demora
  crearCodigoDeDemora(41),
  modificarCodigoDeDemora(42),
  eliminarCodigoDeDemora(43),
  consultarCodigoDeDemora(44),

  // Servicio Adicional
  crearServicioAdicional(45),
  modificarServicioAdicional(46),
  eliminarServicioAdicional(47),
  consultarServicioAdicional(48),

  // Servicio Especial
  crearServicioEspecial(49),
  modificarServicioEspecial(50),
  eliminarServicioEspecial(51),
  consultarServicioEspecial(52),

  // Vuelo
  crearVuelo(53),
  modificarVuelo(54),
  eliminarVuelo(55),
  consultarVuelo(56),

  // Aerolínea
  crearAerolinea(57),
  modificarAerolinea(58),
  eliminarAerolinea(59),
  consultarAerolinea(60),

  // Aeropuerto
  crearAeropuerto(61),
  modificarAeropuerto(62),
  eliminarAeropuerto(63),
  consultarAeropuerto(64),

  // Operaciones y TRC
  asignarMaquinaria(65),
  asignarPersonal(66),
  empezarOperaciones(67),
  cerrarOperaciones(68),
  firmaDeSupervisor(69),
  aprobacionDelTRC(70),
  agregarDemoras(71),
  agregarServiciosAdicionales(72),
  agregarServiciosEspeciales(73),
  consultarControlDeActividades(74),
  modificarControlDeActividades(75),
  consultarGerenciaDeServicioAlPasajero(76),
  consultarGerenciaDeDespachoDeVuelo(77),
  consultarGerenciaDeOperaciones(78),
  eliminarTRC(79),
  consultarTodasLasGerencias(80),
  consultarReporteGerencial(81),
  consultarReporteAdministrativo(82),

  // Misceláneos
  crearVueloMiscelaneos(83),
  modificarVueloMiscelaneos(84),
  eliminarVueloMiscelaneos(85),
  consultarVueloMiscelaneos(86),
  asignarMaquinariaMiscelaneos(87),
  asignarPersonalMiscelaneos(88),
  empezarOperacionesMiscelaneos(89),
  cerrarOperacionesMiscelaneos(90),
  firmaDeSupervisorMiscelaneos(91),
  aprobacionDelTRCMiscelaneos(92),
  // El ID 93 no está en tu lista original
  agregarServiciosAdicionalesMiscelaneos(94),
  agregarServiciosEspecialesMiscelaneos(95),
  consultarControlDeActividadesMiscelaneos(96),
  modificarControlDeActividadesMiscelaneos(97);

  final int id;
  const Roles(this.id);

  /// Convierte un ID numérico en un valor del Enum
  static Roles? fromId(int id) {
    try {
      return Roles.values.firstWhere((role) => role.id == id);
    } catch (_) {
      return null; // Retorna null si el ID no existe
    }
  }
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