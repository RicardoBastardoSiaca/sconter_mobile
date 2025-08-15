import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/domain.dart';
import 'providers.dart';

// Provider

final supervisorAerolineaProvider =
    StateNotifierProvider<
      SupervisorAerolineaNotifier,
      SupervisorAerolineaState
    >((ref) {
      final turnaroundsRepository = ref.watch(turnaroundRepositoryProvider);
      final idAerolinea = ref
          .watch(selectedTurnaroundProvider)!
          .fkVuelo
          .fkAerolinea
          .id;
      return SupervisorAerolineaNotifier(turnaroundsRepository, idAerolinea);
    });

// NOTIFIER

class SupervisorAerolineaNotifier
    extends StateNotifier<SupervisorAerolineaState> {
  SupervisorAerolineaNotifier(this.turnaroundsRepository, this.idAerolinea)
    : super(SupervisorAerolineaState());
  final int idAerolinea;
  final TurnaroundsRepository turnaroundsRepository;

  Future<void> getSupervisores() async {
    state = state.copyWith(isLoading: true);
    try {
      final supervisores = await turnaroundsRepository.getSupervisores(
        idAerolinea,
      );
      state = state.copyWith(supervisores: supervisores);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

// STATE

class SupervisorAerolineaState {
  final List<SupervisorUser> supervisores;
  final bool isLoading;
  final String? error;

  SupervisorAerolineaState({
    this.supervisores = const [],
    this.isLoading = false,
    this.error,
  });

  SupervisorAerolineaState copyWith({
    List<SupervisorUser>? supervisores,
    bool? isLoading,
    String? error,
  }) {
    return SupervisorAerolineaState(
      supervisores: supervisores ?? this.supervisores,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
// SupervisorUser