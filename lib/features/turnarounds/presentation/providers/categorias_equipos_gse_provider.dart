// State notifier Provider

// State
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/domain.dart';
import 'providers.dart';

// Provider

final categoriasEquiposGseProvider =
    StateNotifierProvider<
      CategoriasEquiposGseNotifier,
      CategoriasEquiposGseState
    >((ref) {
      final turnaroundsRepository = ref.watch(turnaroundRepositoryProvider);
      final selectedTrc = ref.watch(selectedTurnaroundProvider);
      // final selectedTrcId = ref.watch(trcIdProvider);
      final selectedTrcId = selectedTrc?.id ?? 0;
      final idPlantilla = selectedTrc?.fkVuelo.fkPlantilla.id ?? 0;
      final horaI = selectedTrc!.fkVuelo.etaIn?.substring(0, 5) ?? '';
      final horaF = selectedTrc.fkVuelo.etdOut?.substring(0, 5) ?? '';
      final fecha =
          selectedTrc.fkVuelo.etaFechaIn ??
          selectedTrc.fkVuelo.etdFechaOut ??
          '';

      return CategoriasEquiposGseNotifier(
        idPlantilla,
        turnaroundsRepository: turnaroundsRepository,
        trcId: selectedTrcId,
        horaI: horaI,
        horaF: horaF,
        fecha: fecha,
      );
    });

// Notifier

class CategoriasEquiposGseNotifier
    extends StateNotifier<CategoriasEquiposGseState> {
  final int trcId;
  final int idPlantilla;
  final String horaI;
  final String horaF;
  final String fecha;
  final TurnaroundsRepository turnaroundsRepository;

  CategoriasEquiposGseNotifier(
    this.idPlantilla, {
    required this.turnaroundsRepository,
    required this.trcId,
    required this.horaI,
    required this.horaF,
    required this.fecha,
  }) : super(CategoriasEquiposGseState(id: trcId));

  Future<void> getCategoriasEquiposGse() async {
    // print("getControlDeActividadesByTrcId: $trcId");
    // state = state.copyWith(isLoading: true);
    final body = {
      "id_turnaround": trcId,
      "horaI": horaI,
      "horaF": horaF,
      "fecha": fecha,
    };
    try {
      final categoriasEquiposGseResponse = await turnaroundsRepository
          .getCategoriasEquiposGSE(trcId, idPlantilla, body);
      state = state.copyWith(
        categoriasEquiposGseResponse: categoriasEquiposGseResponse,
        isLoading: false,
      );
      print("Categorias Equipos GSE: $categoriasEquiposGseResponse");
      // print("Control de Actividades: $controlDeActividades");
    } catch (e) {
      // print("Error getting control de actividades: $e");
      print('Error $e');
      // state = state.copyWith(isLoading: false);
    }
  }
}

class CategoriasEquiposGseState {
  late final int id;
  final CategoriasEquiposGseResponse? categoriasEquiposGseResponse;
  final bool isLoading;
  final bool isSaving;

  CategoriasEquiposGseState({
    required this.id,
    this.categoriasEquiposGseResponse,
    this.isLoading = false,
    this.isSaving = false,
  });

  CategoriasEquiposGseState copyWith({
    int? id,
    CategoriasEquiposGseResponse? categoriasEquiposGseResponse,
    bool? isLoading,
    bool? isSaving,
  }) => CategoriasEquiposGseState(
    id: id ?? this.id,
    categoriasEquiposGseResponse:
        categoriasEquiposGseResponse ?? this.categoriasEquiposGseResponse,
    isLoading: isLoading ?? this.isLoading,
    isSaving: isSaving ?? this.isSaving,
  );

  // void getControlDeActividadesByTrcId() {}
}
