


import 'package:turnaround_mobile/features/turnarounds/domain/entities/turnaround_main.dart';

abstract class TurnaroundsDatasource {

  Future<List<TurnaroundMain>> getTurnaroundsByDate( int year, int month, int day );

  Future<TurnaroundMain> getControlDeActividades( int id );


  // TODO Asignar Personal


  // TODO asignar Equipos GSE


  // 

}