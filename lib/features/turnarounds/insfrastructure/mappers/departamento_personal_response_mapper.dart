import '../../domain/domain.dart';

class DepartamentoPersonalResponseMapper {
  static DepartamentoPersonalResponse mapJsonToDepartamentoPersonalResponse(
    Map<String, dynamic> json,
  ) {
    return DepartamentoPersonalResponse(
      crear: json['crear'] as bool? ?? false,
      modificar: json['modificar'] as bool? ?? false,
      idTurnaround: json['id_turnaround'] as int? ?? 0,
      fecha: json['fecha'] as String? ?? '',
      horaI: json['horaI'] as String? ?? '',
      horaF: json['horaF'] as String? ?? '',
      areas: _parseDepartamentosList(json['areas']),
    );
  }

  static List<DepartamentoPersonal> _parseDepartamentosList(dynamic data) {
    if (data == null) return [];
    if (data is List) {
      return data
          .whereType<Map<String, dynamic>>()
          .map((item) => DepartamentoPersonalMapper.fromJson(item))
          .toList();
    }
    return [];
  }

  static Map<String, dynamic> toJson(DepartamentoPersonalResponse response) {
    return {
      'crear': response.crear,
      'modificar': response.modificar,
      'id_turnaround': response.idTurnaround,
      'fecha': response.fecha,
      'horaI': response.horaI,
      'horaF': response.horaF,
      'areas': response.areas
          .map((depto) => DepartamentoPersonalMapper.toJson(depto))
          .toList(),
    };
  }
}

class DepartamentoPersonalMapper {
  static DepartamentoPersonal fromJson(Map<String, dynamic> json) {
    return DepartamentoPersonal(
      nombreDepartamento: json['nombre_departamento'] as String? ?? '',
      personal: _parseList(json['personal']),
      gerentes: _parseList(json['gerentes']),
      supervisores: _parseList(json['supervisores']),
    );
  }

  static List<PersonalDepartamento> _parseList(dynamic data) {
    if (data == null || data is! List) return [];
    return data
        .whereType<Map<String, dynamic>>()
        .map((item) => PersonalDepartamentoMapper.fromJson(item))
        .toList();
  }

  static Map<String, dynamic> toJson(DepartamentoPersonal departamento) {
    return {
      'nombre_departamento': departamento.nombreDepartamento,
      'personal': departamento.personal
          .map((persona) => PersonalDepartamentoMapper.toJson(persona))
          .toList(),
      'gerentes': departamento.gerentes
          .map((persona) => PersonalDepartamentoMapper.toJson(persona))
          .toList(),
      'supervisores': departamento.supervisores
          .map((persona) => PersonalDepartamentoMapper.toJson(persona))
          .toList(),
    };
  }
}

class PersonalDepartamentoMapper {
  static PersonalDepartamento fromJson(Map<String, dynamic> json) {
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

  static Map<String, dynamic> toJson(PersonalDepartamento personal) {
    return {
      'id': personal.id,
      'er_nombre': personal.erNombre,
      'do_nombre': personal.doNombre,
      'er_apellido': personal.erApellido,
      'do_apellido': personal.doApellido,
      'nombre': personal.nombre,
      'cedula': personal.cedula,
      'correo': personal.correo,
      'telefono': personal.telefono,
      'cargo': personal.cargo,
      'index_personal': personal.indexPersonal,
      'ocupado': personal.ocupado,
      'selected': personal.selected,
    };
  }
}