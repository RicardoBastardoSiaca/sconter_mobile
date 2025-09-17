import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turnaround_mobile/features/turnarounds/presentation/providers/turnaround_repository_provider.dart';

import '../../../shared/shared.dart';
import '../../domain/domain.dart';

// Provider

final departamentoPersonalProvider =
    StateNotifierProvider.family<
      DepartamentoPersonalNotifier,
      DepartamentoPersonalState,
      int
    >((ref, trcId) {
      final turnaroundsRepository = ref.watch(turnaroundRepositoryProvider);
      return DepartamentoPersonalNotifier(
        trcId: trcId,
        turnaroundsRepository: turnaroundsRepository,
      );
    });

// Notifier

class DepartamentoPersonalNotifier
    extends StateNotifier<DepartamentoPersonalState> {
  final TurnaroundsRepository turnaroundsRepository;
  final int trcId;
  DepartamentoPersonalNotifier({
    required this.turnaroundsRepository,
    required this.trcId,
  }) : super(DepartamentoPersonalState.initial()) {
    // get departamentos con personal
    // getDepartamentosConPersonal(trcId);
  }

  // final TurnaroundsRepository turnaroundsRepository;

  Future<SimpleApiResponse> getDepartamentosConPersonal(int idTrc) async {
    state = state.copyWith(isLoading: true);
    try {
      final response = await turnaroundsRepository.getDepartamentosConPersonal(
        idTrc,
      );
      state = state.copyWith(departamentoPersonalResponse: response);
      state = state.copyWith(isLoading: false);
      return SimpleApiResponse(message: "", success: true);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      state = state.copyWith(isLoading: false);
      return SimpleApiResponse(message: "", success: false);
    } finally {
      state = state.copyWith(isLoading: false);

      // return SimpleApiResponse(message: "", success: false);
    }
  }

  // Asignar personal
  Future<SimpleApiResponse> asignarPersonal(Map<String, dynamic> body) async {
    state = state.copyWith(isLoading: true);
    try {
      final response = await turnaroundsRepository.asignarPersonal(body);
      state = state.copyWith(isLoading: false);
      return response;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return SimpleApiResponse(success: false, message: 'Error al asignar personal'); 
    }
  }
}

// State
class DepartamentoPersonalState {
  // final List<DepartamentoPersonal> departamentoPersonalList;
  final DepartamentoPersonalResponse? departamentoPersonalResponse;
  final bool isLoading;
  final String? errorMessage;

  DepartamentoPersonalState({
    required this.departamentoPersonalResponse,
    required this.isLoading,
    this.errorMessage,
  });

  // copyWith method
  DepartamentoPersonalState copyWith({
    DepartamentoPersonalResponse? departamentoPersonalResponse,
    bool? isLoading,
    String? errorMessage,
  }) {
    return DepartamentoPersonalState(
      departamentoPersonalResponse:
          departamentoPersonalResponse ?? this.departamentoPersonalResponse,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory DepartamentoPersonalState.fromJson(Map<String, dynamic> json) {
    return DepartamentoPersonalState(
      departamentoPersonalResponse: json['departamentoPersonalResponse'] != null
          ? DepartamentoPersonalResponse.fromJson(
              json['departamentoPersonalResponse'],
            )
          : null,
      isLoading: json['isLoading'] ?? false,
      errorMessage: json['errorMessage'],
    );
  }

  factory DepartamentoPersonalState.initial() {
    return DepartamentoPersonalState(
      departamentoPersonalResponse: null,
      isLoading: false,
    );
  }
}




// State de lista de booleanos para retornar personal seleccionado en dialogo
final selectedPersonalDialogProvider = StateProvider<List<bool>>((ref) {
  return [];
});