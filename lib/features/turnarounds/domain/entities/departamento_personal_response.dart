// Create all necessary mappers to map JSON data to the DepartamentoPersonalResponse entity.

class DepartamentoPersonalResponse {
  final bool crear;
  final List<DepartamentoPersonal> departamentosCerrar;
  final List<DepartamentoPersonal> departamentosFirma;
  final List<DepartamentoPersonal> departamentosPersonal;
  final String fecha;
  final List<DepartamentoPersonal> gerenteTurno;
  final String horaF;
  final String horaI;
  final int idTurnaround;
  final bool modificar;
  final List<DepartamentoPersonal> supervisor;

  DepartamentoPersonalResponse({
    required this.crear,
    required this.departamentosCerrar,
    required this.departamentosFirma,
    required this.departamentosPersonal,
    required this.fecha,
    required this.gerenteTurno,
    required this.horaF,
    required this.horaI,
    required this.idTurnaround,
    required this.modificar,
    required this.supervisor,
  });

  factory DepartamentoPersonalResponse.fromJson(Map<String, dynamic> json) {
    return DepartamentoPersonalResponse(
      crear: json['crear'] as bool,
      departamentosCerrar:
          json['departamentos_cerrar'] as List<DepartamentoPersonal>,
      departamentosFirma:
          json['departamentos_firma'] as List<DepartamentoPersonal>,
      departamentosPersonal:
          json['departamentos_personal'] as List<DepartamentoPersonal>,
      fecha: json['fecha'] as String,
      gerenteTurno: json['gerente_turno'] as List<DepartamentoPersonal>,
      horaF: json['horaF'] as String,
      horaI: json['horaI'] as String,
      idTurnaround: json['id_turnaround'] as int,
      modificar: json['modificar'] as bool,
      supervisor: json['supervisor'] as List<DepartamentoPersonal>,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'crear': crear,
      'departamentos_cerrar': departamentosCerrar,
      'departamentos_firma': departamentosFirma,
      'departamentos_personal': departamentosPersonal,
      'fecha': fecha,
      'gerente_turno': gerenteTurno,
      'horaF': horaF,
      'horaI': horaI,
      'id_turnaround': idTurnaround,
      'modificar': modificar,
      'supervisor': supervisor,
    };
  }
}

class DepartamentoPersonal {
  final String nombreDepartamento;
  final List<PersonalDepartamento> personal;

  DepartamentoPersonal({
    required this.nombreDepartamento,
    required this.personal,
  });

  DepartamentoPersonal copyWith({
    String? nombreDepartamento,
    List<PersonalDepartamento>? personal,
  }) {
    return DepartamentoPersonal(
      nombreDepartamento: nombreDepartamento ?? this.nombreDepartamento,
      personal: personal ?? this.personal,
    );
  }

  factory DepartamentoPersonal.fromJson(Map<String, dynamic> json) {
    return DepartamentoPersonal(
      nombreDepartamento: json['nombre_departamento'] as String,
      personal: (json['personal'] as List)
          .map((e) => PersonalDepartamento.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre_departamento': nombreDepartamento,
      'personal': personal.map((e) => e.toJson()).toList(),
    };
  }
}

class PersonalDepartamento {
  final int id;
  final String nombre;
  final String cedula;
  final String correo;
  final String telefono;
  final String cargo;
  final bool ocupado;
  bool selected;

  PersonalDepartamento({
    required this.id,
    required this.nombre,
    required this.cedula,
    required this.correo,
    required this.telefono,
    required this.cargo,
    required this.ocupado,
    required this.selected,
  });

  PersonalDepartamento copyWith({
    int? id,
    String? nombre,
    String? cedula,
    String? correo,
    String? telefono,
    String? cargo,
    bool? ocupado,
    bool? selected,
  }) {
    return PersonalDepartamento(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      cedula: cedula ?? this.cedula,
      correo: correo ?? this.correo,
      telefono: telefono ?? this.telefono,
      cargo: cargo ?? this.cargo,
      ocupado: ocupado ?? this.ocupado,
      selected: selected ?? this.selected,
    );
  }

  factory PersonalDepartamento.fromJson(Map<String, dynamic> json) {
    return PersonalDepartamento(
      id: json['id'] as int,
      nombre: json['nombre'] as String,
      cedula: json['cedula'] as String,
      correo: json['correo'] as String,
      telefono: json['telefono'] as String,
      cargo: json['cargo'] as String,
      ocupado: json['ocupado'] as bool,
      selected: json['selected'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'cedula': cedula,
      'correo': correo,
      'telefono': telefono,
      'cargo': cargo,
      'ocupado': ocupado,
      'selected': selected,
    };
  }
}
