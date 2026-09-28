import 'dart:convert';

class DepartamentoPersonalResponse {
  final bool crear;
  final bool modificar;
  final int idTurnaround;
  final String fecha;
  final String horaI;
  final String horaF;
  final List<DepartamentoPersonal> areas;

  DepartamentoPersonalResponse({
    required this.crear,
    required this.modificar,
    required this.idTurnaround,
    required this.fecha,
    required this.horaI,
    required this.horaF,
    required this.areas,
  });

  factory DepartamentoPersonalResponse.fromJson(Map<String, dynamic> json) {
    return DepartamentoPersonalResponse(
      crear: json['crear'] as bool? ?? false,
      modificar: json['modificar'] as bool? ?? false,
      idTurnaround: json['id_turnaround'] as int? ?? 0,
      fecha: json['fecha'] as String? ?? '',
      horaI: json['horaI'] as String? ?? '',
      horaF: json['horaF'] as String? ?? '',
      areas: (json['areas'] as List<dynamic>?)
              ?.map((e) => DepartamentoPersonal.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'crear': crear,
      'modificar': modificar,
      'id_turnaround': idTurnaround,
      'fecha': fecha,
      'horaI': horaI,
      'horaF': horaF,
      'areas': areas.map((e) => e.toJson()).toList(),
    };
  }
}

class DepartamentoPersonal {
  final String nombreDepartamento;
  final List<PersonalDepartamento> personal;
  final List<PersonalDepartamento> gerentes;
  final List<PersonalDepartamento> supervisores;

  DepartamentoPersonal({
    required this.nombreDepartamento,
    required this.personal,
    required this.gerentes,
    required this.supervisores,
  });

  DepartamentoPersonal copyWith({
    String? nombreDepartamento,
    List<PersonalDepartamento>? personal,
    List<PersonalDepartamento>? gerentes,
    List<PersonalDepartamento>? supervisores,
  }) {
    return DepartamentoPersonal(
      nombreDepartamento: nombreDepartamento ?? this.nombreDepartamento,
      personal: personal ?? this.personal,
      gerentes: gerentes ?? this.gerentes,
      supervisores: supervisores ?? this.supervisores,
    );
  }

  factory DepartamentoPersonal.fromJson(Map<String, dynamic> json) {
    return DepartamentoPersonal(
      nombreDepartamento: json['nombre_departamento'] as String? ?? '',
      personal: (json['personal'] as List<dynamic>?)
              ?.map((e) => PersonalDepartamento.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      gerentes: (json['gerentes'] as List<dynamic>?)
              ?.map((e) => PersonalDepartamento.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      supervisores: (json['supervisores'] as List<dynamic>?)
              ?.map((e) => PersonalDepartamento.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre_departamento': nombreDepartamento,
      'personal': personal.map((e) => e.toJson()).toList(),
      'gerentes': gerentes.map((e) => e.toJson()).toList(),
      'supervisores': supervisores.map((e) => e.toJson()).toList(),
    };
  }
}

class PersonalDepartamento {
  final int id;
  final String erNombre;
  final String doNombre;
  final String erApellido;
  final String doApellido;
  final String nombre;
  final String cedula;
  final String correo;
  final String telefono;
  final String cargo;
  final int? indexPersonal;
  final bool ocupado;
  bool selected;

  PersonalDepartamento({
    required this.id,
    required this.erNombre,
    required this.doNombre,
    required this.erApellido,
    required this.doApellido,
    required this.nombre,
    required this.cedula,
    required this.correo,
    required this.telefono,
    required this.cargo,
    this.indexPersonal,
    required this.ocupado,
    required this.selected,
  });

  PersonalDepartamento copyWith({
    int? id,
    String? erNombre,
    String? doNombre,
    String? erApellido,
    String? doApellido,
    String? nombre,
    String? cedula,
    String? correo,
    String? telefono,
    String? cargo,
    int? indexPersonal,
    bool? ocupado,
    bool? selected,
  }) {
    return PersonalDepartamento(
      id: id ?? this.id,
      erNombre: erNombre ?? this.erNombre,
      doNombre: doNombre ?? this.doNombre,
      erApellido: erApellido ?? this.erApellido,
      doApellido: doApellido ?? this.doApellido,
      nombre: nombre ?? this.nombre,
      cedula: cedula ?? this.cedula,
      correo: correo ?? this.correo,
      telefono: telefono ?? this.telefono,
      cargo: cargo ?? this.cargo,
      indexPersonal: indexPersonal ?? this.indexPersonal,
      ocupado: ocupado ?? this.ocupado,
      selected: selected ?? this.selected,
    );
  }

  factory PersonalDepartamento.fromJson(Map<String, dynamic> json) {
    return PersonalDepartamento(
      id: json['id'] as int? ?? 0,
      erNombre: json['er_nombre'] as String? ?? '',
      doNombre: json['do_nombre'] as String? ?? '',
      erApellido: json['er_apellido'] as String? ?? '',
      doApellido: json['do_apellido'] as String? ?? '',
      nombre: json['nombre'] as String? ?? '',
      cedula: json['cedula'] as String? ?? '',
      correo: json['correo'] as String? ?? '',
      telefono: json['telefono'] as String? ?? '',
      cargo: json['cargo'] as String? ?? '',
      indexPersonal: json['index_personal'] as int?,
      ocupado: json['ocupado'] as bool? ?? false,
      selected: json['selected'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'er_nombre': erNombre,
      'do_nombre': doNombre,
      'er_apellido': erApellido,
      'do_apellido': doApellido,
      'nombre': nombre,
      'cedula': cedula,
      'correo': correo,
      'telefono': telefono,
      'cargo': cargo,
      'index_personal': indexPersonal,
      'ocupado': ocupado,
      'selected': selected,
    };
  }
}