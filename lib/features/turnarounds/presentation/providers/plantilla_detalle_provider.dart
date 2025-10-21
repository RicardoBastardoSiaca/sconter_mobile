import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/domain.dart';
import 'providers.dart';


// provider

final plantillaDetalleProvider = StateNotifierProvider<PlantillaDetalleNotifier, PlantillaDetalleState>((ref) {
  final turnaroundsRepository = ref.watch(turnaroundRepositoryProvider);
  return PlantillaDetalleNotifier(turnaroundsRepository: turnaroundsRepository);
});



// notifier

class PlantillaDetalleNotifier extends StateNotifier<PlantillaDetalleState> {
  
  final TurnaroundsRepository turnaroundsRepository;
  PlantillaDetalleNotifier({
    required this.turnaroundsRepository,
  }): super( PlantillaDetalleState() );

  Future<void> getPlantillaDetalleById(int id) {
    state = state.copyWith(isLoading: true);
    return turnaroundsRepository.getPlantillaDetalleById(id).then((plantilla) {
      state = state.copyWith(plantilla: plantilla, isLoading: false);
    }).catchError((error) {
      state = state.copyWith(isLoading: false);
      throw error;
    });
  }
  
}


// state

class PlantillaDetalleState{
  // final int id;
 final Plantilla? plantilla;
 final bool isLoading;
  final bool isSaving;
  PlantillaDetalleState({
    // required this.id,
    this.plantilla,
    this.isLoading = false,
    this.isSaving = false,
  });

  PlantillaDetalleState copyWith({
    // int? id,
    Plantilla? plantilla,
    bool? isLoading,
    bool? isSaving,
  }) => PlantillaDetalleState(
    // id: id ?? this.id,
    plantilla: plantilla ?? this.plantilla,
    isLoading: isLoading ?? this.isLoading,
    isSaving: isSaving ?? this.isSaving,
  );
}