import '../../domain/domain.dart';

class DemoraMapper {
  static Demora mapJsonToDemora(Map<String, dynamic> json) {
    return Demora(
      categoria: json['categoria'],
      descripcion: json['descripcion'],
      hora: json['hora'],
      id: json['id'],
      idCodigoDemora: json['id_codigo_demora'],
      idTurnaround: json['id_turnaround'],
      identificador: json['identificador'],
    );
  }

  static List<Demora> mapJsonListToDemoras(List<dynamic> jsonList) {
    return jsonList.map((item) => mapJsonToDemora(item)).toList();
  }

  static List<DemoraCategoria> mapJsonListToCategorias(List<dynamic> jsonList) {
    return jsonList
        .map((item) => mapJsonToCategoria(item as Map<String, dynamic>))
        .toList();
  }

  static DemoraCategoria mapJsonToCategoria(Map<String, dynamic> json) {
    return DemoraCategoria(
      nombre: json['nombre'] as String,
      identificador: json['identificador'] as int,
      codigo: (json['codigo'] as List)
          .map((e) => mapJsonToDemoraCodigo(e as Map<String, dynamic>))
          .toList(),
    );
  }

  static DemoraCodigo mapJsonToDemoraCodigo(Map<String, dynamic> json) {
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
}
