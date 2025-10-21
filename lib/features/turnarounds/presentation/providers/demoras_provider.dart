import '../../../shared/shared.dart';
import '../../domain/domain.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers.dart';
// Provider

final demorasProvider = StateNotifierProvider<DemorasNotifier, DemorasState>((
  ref,
) {
  final turnaroundsRepository = ref.watch(turnaroundRepositoryProvider);
  // final selectedTrc = ref.watch(selectedTurnaroundProvider);

  return DemorasNotifier(turnaroundsRepository: turnaroundsRepository);
});

// Notifier

class DemorasNotifier extends StateNotifier<DemorasState> {
  // final int trcId;
  // final TurnaroundMain selectedTrc;
  final TurnaroundsRepository turnaroundsRepository;
  DemorasNotifier({
    // required this.trcId,
    // required this.selectedTrc,
    required this.turnaroundsRepository,
  }) : super(DemorasState.initial());

  Future<void> getDemorasByTrc(int trcId) async {
    state = state.copyWith(isLoading: true);
    try {
      final demoras = await turnaroundsRepository.getDemorasByTrc(trcId);
      state = state.copyWith(demoras: demoras, isLoading: false);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
    }
  }

  Future<void> getDemoras() async {
    state = state.copyWith(isLoading: true);
    try {
      final demoras = await turnaroundsRepository.getDemoras();
      state = state.copyWith(demoras: demoras, isLoading: false);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
    }
  }

  Future<void> getDemorasByAirline(int airlineId) async {
    state = state.copyWith(isLoading: true);
    try {
      final categorias = await turnaroundsRepository.getDemorasByAirline(
        airlineId,
      );
      state = state.copyWith(categorias: categorias, isLoading: false);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
    }
  }

  Future<SnackbarResponse> asignarDemora(Map<String, Object?> body) async {
    // Call the repository method to assign the delay
    final response = await turnaroundsRepository.asignarDemora(body);
    // Handle the response
    if (response.success) {
      // Successfully assigned delay
      // state = state.copyWith(demoras: [...state.demoras, response.data]);

      getDemorasByTrc(body['turnaround'] as int);

      return SnackbarResponse(success: true, message: response.message);
    } else {
      // Handle error
      state = state.copyWith(errorMessage: response.errorMessage);
      return SnackbarResponse(success: false, message: response.errorMessage);
    }
  }

  Future<SnackbarResponse> eliminarDemoraTrc(int demoraId) async {
    final response = await turnaroundsRepository.eliminarDemoraTrc(demoraId);
    if (response.success) {
      state = state.copyWith(
        demoras: state.demoras.where((d) => d.id != demoraId).toList(),
      );
      return SnackbarResponse(success: true, message: 'Demora eliminada');
    }
    return SnackbarResponse(
      success: response.success,
      message: 'Error al eliminar la demora',
    );
  }
}

// State

class DemorasState {
  final List<Demora> demoras;
  final List<DemoraCategoria>? categorias;
  final bool isLoading;
  final String? errorMessage;

  DemorasState({
    required this.demoras,
    this.categorias,
    required this.isLoading,
    this.errorMessage,
  });

  DemorasState copyWith({
    List<Demora>? demoras,
    List<DemoraCategoria>? categorias,
    bool? isLoading,
    String? errorMessage,
  }) {
    return DemorasState(
      demoras: demoras ?? this.demoras,
      categorias: categorias ?? this.categorias,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory DemorasState.initial() {
    return DemorasState(demoras: [], categorias: [], isLoading: false);
  }
}
