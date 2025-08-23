class Demora {
  final int categoria;
  final String descripcion;
  final String hora;
  final int id;
  final int idCodigoDemora;
  final int idTurnaround;
  final int identificador;

  Demora({
    required this.categoria,
    required this.descripcion,
    required this.hora,
    required this.id,
    required this.idCodigoDemora,
    required this.idTurnaround,
    required this.identificador,
  });

  factory Demora.fromJson(Map<String, dynamic> json) {
    return Demora(
      categoria: json['categoria'] as int,
      descripcion: json['descripcion'] as String,
      hora: json['hora'] as String,
      id: json['id'] as int,
      idCodigoDemora: json['id_codigo_demora'] as int,
      idTurnaround: json['id_turnaround'] as int,
      identificador: json['identificador'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categoria': categoria,
      'descripcion': descripcion,
      'hora': hora,
      'id': id,
      'id_codigo_demora': idCodigoDemora,
      'id_turnaround': idTurnaround,
      'identificador': identificador,
    };
  }
}

class DemoraCategoria {
  final String nombre;
  final int identificador;
  final List<DemoraCodigo> codigo;

  DemoraCategoria({
    required this.nombre,
    required this.identificador,
    required this.codigo,
  });

  factory DemoraCategoria.fromJson(Map<String, dynamic> json) {
    return DemoraCategoria(
      nombre: json['nombre'] as String,
      identificador: json['identificador'] as int,
      codigo: (json['codigo'] as List)
          .map((e) => DemoraCodigo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'identificador': identificador,
      'codigo': codigo.map((e) => e.toJson()).toList(),
    };
  }
}

class DemoraCodigo {
  final int codId;
  final int codIdentificadorNumero;
  final String codIdentificadorLetra;
  final String codIdentificadorLetraAdicional;
  final String codDescripcionEn;
  final String codDescripcionEs;

  DemoraCodigo({
    required this.codId,
    required this.codIdentificadorNumero,
    required this.codIdentificadorLetra,
    required this.codIdentificadorLetraAdicional,
    required this.codDescripcionEn,
    required this.codDescripcionEs,
  });

  factory DemoraCodigo.fromJson(Map<String, dynamic> json) {
    return DemoraCodigo(
      codId: json['cod_id'] as int,
      codIdentificadorNumero: json['cod_identificador_numero'] as int,
      codIdentificadorLetra: json['cod_identificador_letra'] as String,
      codIdentificadorLetraAdicional:
          json['cod_identificador_letra_adicional'] as String,
      codDescripcionEn: json['cod_descripcion_en'] as String,
      codDescripcionEs: json['cod_descripcion_es'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cod_id': codId,
      'cod_identificador_numero': codIdentificadorNumero,
      'cod_identificador_letra': codIdentificadorLetra,
      'cod_identificador_letra_adicional': codIdentificadorLetraAdicional,
      'cod_descripcion_en': codDescripcionEn,
      'cod_descripcion_es': codDescripcionEs,
    };
  }
}
