import '../../domain/domain.dart';

class DepartamentoPersonalResponseMapper {
  static DepartamentoPersonalResponse mapJsonToDepartamentoPersonalResponse(
    Map<String, dynamic> json,
  ) {
    return DepartamentoPersonalResponse(
      crear: json['crear'] as bool? ?? false,
      departamentosCerrar: _parseDepartamentosList(
        json['departamentos_cerrar'],
      ),
      departamentosFirma: _parseDepartamentosList(json['departamentos_firma']),
      departamentosPersonal: _parseDepartamentosList(
        json['departamentos_personal'],
      ),
      fecha: json['fecha'] as String? ?? '',
      gerenteTurno: _parseDepartamentosList(json['gerente_turno']),
      horaF: json['horaF'] as String? ?? '',
      horaI: json['horaI'] as String? ?? '',
      idTurnaround: json['id_turnaround'] as int? ?? 0,
      modificar: json['modificar'] as bool? ?? false,
      supervisor: _parseDepartamentosList(json['supervisor']),
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
      'departamentos_cerrar': response.departamentosCerrar
          .map((depto) => DepartamentoPersonalMapper.toJson(depto))
          .toList(),
      'departamentos_firma': response.departamentosFirma
          .map((depto) => DepartamentoPersonalMapper.toJson(depto))
          .toList(),
      'departamentos_personal': response.departamentosPersonal
          .map((depto) => DepartamentoPersonalMapper.toJson(depto))
          .toList(),
      'fecha': response.fecha,
      'gerente_turno': response.gerenteTurno
          .map((depto) => DepartamentoPersonalMapper.toJson(depto))
          .toList(),
      'horaF': response.horaF,
      'horaI': response.horaI,
      'id_turnaround': response.idTurnaround,
      'modificar': response.modificar,
      'supervisor': response.supervisor
          .map((depto) => DepartamentoPersonalMapper.toJson(depto))
          .toList(),
    };
  }
}

class DepartamentoPersonalMapper {
  static DepartamentoPersonal fromJson(Map<String, dynamic> json) {
    return DepartamentoPersonal(
      nombreDepartamento: json['nombre_departamento'] as String? ?? '',
      personal: _parsePersonalList(json['personal']),
    );
  }

  static List<PersonalDepartamento> _parsePersonalList(dynamic data) {
    if (data == null) return [];
    if (data is List) {
      return data
          .whereType<Map<String, dynamic>>()
          .map((item) => PersonalDepartamentoMapper.fromJson(item))
          .toList();
    }
    return [];
  }

  static Map<String, dynamic> toJson(DepartamentoPersonal departamento) {
    return {
      'nombre_departamento': departamento.nombreDepartamento,
      'personal': departamento.personal
          .map((persona) => PersonalDepartamentoMapper.toJson(persona))
          .toList(),
    };
  }
}

class PersonalDepartamentoMapper {
  static PersonalDepartamento fromJson(Map<String, dynamic> json) {
    return PersonalDepartamento(
      id: json['id'] as int? ?? 0,
      nombre: json['nombre'] as String? ?? '',
      cedula: json['cedula'] as String? ?? '',
      correo: json['correo'] as String? ?? '',
      telefono: json['telefono'] as String? ?? '',
      cargo: json['cargo'] as String? ?? '',
      ocupado: json['ocupado'] as bool? ?? false,
      selected: json['selected'] as bool? ?? false,
    );
  }

  static Map<String, dynamic> toJson(PersonalDepartamento personal) {
    return {
      'id': personal.id,
      'nombre': personal.nombre,
      'cedula': personal.cedula,
      'correo': personal.correo,
      'telefono': personal.telefono,
      'cargo': personal.cargo,
      'ocupado': personal.ocupado,
      'selected': personal.selected,
    };
  }
}
