import '../../domain/domain.dart';

// lista de categorias de equipos de IT y Limpieza




class CategoriasEquiposItLimpiezaMapper {

  // List
  static List<CategoriaEquiposItLimpieza> mapJsonToListCategoriasEquiposItLimpieza(
    List<dynamic> jsonList,
  ) {
    return jsonList
        .map((json) => mapJsonToCategoriasEquiposItLimpieza(json))
        .toList();
  }

  // item
  static CategoriaEquiposItLimpieza mapJsonToCategoriasEquiposItLimpieza(
    Map<String, dynamic> json,
  ) {
    return CategoriaEquiposItLimpieza(
      nombreCategoria: json['nombre_categoria'] ?? '', 
      tipoCategoria: json['tipo_categoria'] ?? '', 
      equipos: List<EquipoItLimpieza>.from(
        json['equipos'].map((x) => mapJsonToEquipoLimpieza(x)),
      ),
      // categoriasEquiposIt:
            
    );
  }

  // CategoriaEquiposItLimpieza
  static EquipoItLimpieza mapJsonToEquipoLimpieza(
    Map<String, dynamic> json,
  ) {
    return EquipoItLimpieza(
      id: json['id'],
      identificador: json['identificador'],
      modelo: json['modelo'],
      estado: json['estado'],
      fkCategoria: json['fk_categoria'],
      categoriaNombre: json['categoria_nombre'],
      categoriaTipo: json['categoria_tipo'],
      imagen: json['imagen'],
      fkAerolinea: json['fk_aerolinea'],
      aerolineaNombre: json['aerolinea_nombre'], 
      selectedTask: false, 
      isSelected: false,
      
    );
  }
  // MaquinariaCategoriaEquipos
  }