import '../../domain/domain.dart';

class VuelosLineupListMapper {
  static List<VueloLineup> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => VuelosLineupMapper.fromJson(json)).toList();
  }
}

class VuelosLineupMapper {
  static VueloLineup fromJson(Map<String, dynamic> json) {
    return VueloLineup.fromJson(json);
  }
}