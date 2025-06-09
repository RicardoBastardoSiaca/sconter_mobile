


import '../../domain/domain.dart';

class TurnaroundsRepositoryImpl extends TurnaroundsRepository {

  TurnaroundsDatasource datasource;

  TurnaroundsRepositoryImpl(this.datasource);


  @override
  Future<TurnaroundMain> getControlDeActividades(int id) {
    return datasource.getControlDeActividades(id);
  }

  @override
  Future<List<TurnaroundMain>> getTurnaroundsByDate(int year, int month, int day) {
    return datasource.getTurnaroundsByDate(year, month, day);
  }
}