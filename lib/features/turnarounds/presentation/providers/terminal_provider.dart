import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scounter_mobile/features/turnarounds/domain/domain.dart';

import 'providers.dart';

class TerminalState {
  final List<Terminal> terminales; 
  final bool isLoading;

  TerminalState({
    this.terminales = const [],
    this.isLoading = false,
  });

  TerminalState copyWith({
    List<Terminal>? terminales,
    bool? isLoading,
  }) {
    return TerminalState(
      terminales: terminales ?? this.terminales,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class TerminalNotifier extends StateNotifier<TerminalState> {
  final TurnaroundsRepository turnaroundsRepository;

  TerminalNotifier({required this.turnaroundsRepository}) : super(TerminalState());

  Future<void> getTerminales() async {
    // Si la lista ya contiene datos, omitimos la llamada al repositorio
    // if (state.terminales.isNotEmpty) return;

    state = state.copyWith(isLoading: true);

    try {
      final List<Terminal> terminales = await turnaroundsRepository.getTerminalesList();
      state = state.copyWith(
        terminales: terminales,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }
}

// Declaración del Provider
final terminalProvider = StateNotifierProvider<TerminalNotifier, TerminalState>((ref) {
  final turnaroundsRepository = ref.watch(turnaroundRepositoryProvider);
  return TerminalNotifier(
    turnaroundsRepository: turnaroundsRepository,
  );
});

// Provider para manejar la terminal seleccionada (null = Todas las terminales)
final selectedTerminalFilterProvider = StateProvider<Terminal?>((ref) => null);

