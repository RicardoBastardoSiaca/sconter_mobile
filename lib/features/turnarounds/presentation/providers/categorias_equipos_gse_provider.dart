// State notifier Provider

// State
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/domain/domain.dart';
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
      "tipoAsignacion": 'tarea',
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

    // asignarMaquinariasTareas
  }

  Future<SnackbarResponse> asignarMaquinariasTareas(
    Map<String, dynamic> body,
  ) async {
    try {
      final SimpleApiResponse response = await turnaroundsRepository
          .asignarMaquinariasTareas(body);
      if (response.success) {
        // snackbar response
        // getCategoriasEquiposGse();
        return SnackbarResponse(message: 'Equipos asignados.', success: true);
      } else {
        return SnackbarResponse(
          message: 'Error al asignar los equipos.',
          success: false,
        );
      }
    } catch (e) {
      // print("Error deleting image: $e");
      return SnackbarResponse(
        message: 'Error al asignar los equipos.',
        success: false,
      );
    }
  }

  // Asignar Equipos GSE
  Future<SnackbarResponse> asignarEquiposGse(Map<String, dynamic> body) async {
    try {
      final response = await turnaroundsRepository.asignarEquiposGSE(body);
      if (response.success) {
        // snackbar response
        getCategoriasEquiposGse();
        return SnackbarResponse(
          message: 'Equipos GSE asignados.',
          success: true,
        );
      } else {
        return SnackbarResponse(
          message: 'Error al asignar los equipos GSE.',
          success: false,
        );
      }
    } catch (e) {
      // print("Error deleting image: $e");
      return SnackbarResponse(
        message: 'Ha ocurrido un error al asignar los equipos GSE.',
        success: false,
      );
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

// categoriasEquiposGse State Provider
final newCategoriasEquiposGseProvider =
    StateProvider<List<CategoriaEquiposGse>>((ref) {
      return [];
    });

final selectedTaskProvider = StateProvider<Map<String, int>>((ref) {
  return {};
});

final selectedMaquinariasTaskProvider = StateProvider<List<dynamic>>((ref) {
  return [];
});
