import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scounter_mobile/features/turnarounds/domain/domain.dart';

import '../../../shared/domain/domain.dart';
import 'providers.dart';

class PuertaState {
  final List<Puerta> puertas; // O la clase del modelo de puertas que utilices
  final bool isLoading;

  PuertaState({
    this.puertas = const [],
    this.isLoading = false,
  });

  PuertaState copyWith({
    List<Puerta>? puertas,
    bool? isLoading,
  }) {
    return PuertaState(
      puertas: puertas ?? this.puertas,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class PuertaNotifier extends StateNotifier<PuertaState> {
  final TurnaroundsRepository turnaroundsRepository;

  PuertaNotifier({required this.turnaroundsRepository}) : super(PuertaState());

  Future<void> getPuertas(int idTerminal) async {
    state = state.copyWith(isLoading: true);

    try {
      final List<Puerta> puertas = await turnaroundsRepository.getPuertasList(
        idTerminal,
      );
      state = state.copyWith(
        puertas: puertas,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  // Método para guardar/asignar una única puerta
  Future<SimpleApiResponse> asignarPuerta({
    required int turnaroundId,
    required int puertaId,
  }) async {
    try {
      final body = {
        'turnaround_id': turnaroundId,
        'puerta_id': puertaId,
      };

      final response = await turnaroundsRepository.asignarPuerta(body);
      return response;
    } catch (e) {
      return SimpleApiResponse(
        success: false,
        message: 'Error al asignar la puerta: ${e.toString()}',
      );
    }
  }
}

// Declaración del Provider
final puertaProvider = StateNotifierProvider<PuertaNotifier, PuertaState>((ref) {
  final turnaroundsRepository = ref.watch(turnaroundRepositoryProvider);
  return PuertaNotifier(
    turnaroundsRepository: turnaroundsRepository,
  );
});