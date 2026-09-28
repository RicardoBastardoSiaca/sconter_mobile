import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scounter_mobile/features/turnarounds/domain/domain.dart';

import '../../../shared/domain/domain.dart';
import 'providers.dart';

class CounterState {
  final List<Counter> counters;
  final bool isLoading;

  CounterState({
    this.counters = const [],
    this.isLoading = false,
  });

  CounterState copyWith({
    List<Counter>? counters,
    bool? isLoading,
  }) {
    return CounterState(
      counters: counters ?? this.counters,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class CounterNotifier extends StateNotifier<CounterState> {
  final TurnaroundsRepository turnaroundsRepository;

  CounterNotifier({required this.turnaroundsRepository}) : super(CounterState());

  Future<void> getCounters(int idTerminal) async {
    state = state.copyWith(isLoading: true);

    try {
      // TODO: Realiza aquí tu llamada a la API o repositorio
      // Ejemplo de respuesta simulada:
      final List<Counter> counters = await turnaroundsRepository.getCountersList(
        idTerminal,
      );
      state = state.copyWith(
        counters: counters, // Reemplaza [] con la lista obtenida
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
      // Opcional: Manejo de errores o propagación
    }
  }

  // Método para guardar/asignar los counters
  Future<SimpleApiResponse> asignarCounters({
    required int turnaroundId,
    required List<int> posicionIds,
  }) async {
    try {
      final body = {
        'turnaround_id': turnaroundId,
        'posicion_ids': posicionIds,
      };

      // Llamada al repositorio correspondiente
      final response = await turnaroundsRepository.asignarCounters(body);
      return response;
    } catch (e) {
      return SimpleApiResponse(
        success: false,
        message: 'Error al asignar counters: ${e.toString()}',
      );
    }
  }
}

// Declaración del Provider
final counterProvider = StateNotifierProvider<CounterNotifier, CounterState>((ref) {
  final turnaroundsRepository = ref.watch(turnaroundRepositoryProvider);
  return CounterNotifier(
    turnaroundsRepository: turnaroundsRepository,
  );
});