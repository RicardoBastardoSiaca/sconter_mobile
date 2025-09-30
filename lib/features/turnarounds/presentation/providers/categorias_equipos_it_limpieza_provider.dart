

// State notifier Provider

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/shared.dart';
import '../../domain/domain.dart';
import 'providers.dart';


// provider

final categoriasEquiposItLimpiezaProvider = StateNotifierProvider<CategoriasEquiposItLimpiezaNotifier, CategoriasEquiposItLimpiezaState>((ref) {
  final turnaroundsRepository = ref.watch(turnaroundRepositoryProvider);
  // final selectedTrc = ref.watch(selectedTurnaroundProvider);
  // final selectedTrcId = selectedTrc?.id ?? 0;
  // final idPlantilla = selectedTrc?.fkVuelo.fkPlantilla.id ?? 0;
  // final horaI = selectedTrc!.fkVuelo.etaIn?.substring(0, 5) ?? '';
  // final horaF = selectedTrc.fkVuelo.etdOut?.substring(0, 5) ?? '';
  // final fecha =
  //     selectedTrc.fkVuelo.etaFechaIn ??
  //     selectedTrc.fkVuelo.etdFechaOut ??
  //     '';

  return CategoriasEquiposItLimpiezaNotifier(
    turnaroundsRepository: turnaroundsRepository,
    // trcId: selectedTrcId,
    // idPlantilla: idPlantilla,
    // horaI: horaI,
    // horaF: horaF,
    // fecha: fecha,
  ); 
});


// notifier

class CategoriasEquiposItLimpiezaNotifier extends StateNotifier<CategoriasEquiposItLimpiezaState> {
  
  // final int trcId;
  // final int idPlantilla;
  // final String horaI;
  // final String horaF;
  // final String fecha;
  final TurnaroundsRepository turnaroundsRepository;

  CategoriasEquiposItLimpiezaNotifier(
     {
    required this.turnaroundsRepository,
    // required this.trcId,
  }) : super(CategoriasEquiposItLimpiezaState());

  Future<void> getCategoriasEquiposItLimpieza() async {
    // print("getControlDeActividadesByTrcId: $trcId");

    try {
      state = state.copyWith(isLoading: true, errorMessage: '');
      final categoriasEquiposItLimpiezaResponse =
          await turnaroundsRepository.getCategoriasEquiposIt();

      state = state.copyWith(
        isLoading: false,
        equiposIt: categoriasEquiposItLimpiezaResponse,
        // equipoLimpieza: categoriasEquiposItLimpiezaResponse.equipoLimpieza,
      );
    }  catch (e) {
      state = state.copyWith(
          isLoading: false, errorMessage: 'Error inesperado: $e');
    }
  }

  Future<SnackbarResponse> asignarEquiposItLimpiezaTareas(Map<String, Object> body) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: '');
      final response = await turnaroundsRepository.asignarEquiposItLimpiezaTareas(body);

      state = state.copyWith(
        isLoading: false,
      );

      return SnackbarResponse(message: 'Equipos asignados', success: true);
    }  catch (e) {
      state = state.copyWith(
          isLoading: false, errorMessage: 'Error inesperado: $e');
      return SnackbarResponse(message: 'Error inesperado: $e', success: false);
    }
  }
  
}




// State


class CategoriasEquiposItLimpiezaState {
  // final int id;
  final bool isLoading;
  final String errorMessage;
  final List<CategoriaEquiposItLimpieza> equiposIt;
  final List<CategoriaEquiposItLimpieza> equipoLimpieza;

  CategoriasEquiposItLimpiezaState({
    // required this.id,
    this.isLoading = false,
    this.errorMessage = '',
    this.equiposIt = const [],
    this.equipoLimpieza = const [],
  });

  CategoriasEquiposItLimpiezaState copyWith({
    int? id,
    bool? isLoading,
    String? errorMessage,
    List<CategoriaEquiposItLimpieza>? equiposIt,
    List<CategoriaEquiposItLimpieza>? equipoLimpieza,
  }) {
    return CategoriasEquiposItLimpiezaState(
      // id: id ?? this.id,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      equiposIt: equiposIt ?? this.equiposIt,
      equipoLimpieza: equipoLimpieza ?? this.equipoLimpieza
    );
  }
}


final selectedEquiposIdsProvider = StateProvider<List<int>>((ref) {
  return [];
});


