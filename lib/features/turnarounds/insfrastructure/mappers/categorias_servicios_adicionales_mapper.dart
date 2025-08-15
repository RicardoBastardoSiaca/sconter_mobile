import '../../domain/domain.dart';

class CategoriasServiciosAdicionalesMapper {
  static List<CategoriaServicioAdicional>
  mapJsonListToCategoriasServiciosAdicionales(List<dynamic> json) {
    return json.map((e) => mapJsonToCategoriasServiciosAdicionales(e)).toList();
  }

  static CategoriaServicioAdicional mapJsonToCategoriasServiciosAdicionales(
    Map<String, dynamic> json,
  ) {
    return CategoriaServicioAdicional(
      id: json["id"],
      tipoServicio: mapJsonToTipo(json["tipo_servicio"]),
      titulo: json["titulo"],
      isAdicional: json["isadicional"],
      estatus: json["estatus"],
    );
  }

  static TipoServicio mapJsonToTipo(Map<String, dynamic> json) {
    return TipoServicio(
      id: json["id"],
      nombre: json["nombre"],
      servicios_adicionales: json["servicios_adicionales"],
    );
  }
}
