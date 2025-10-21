import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turnaround_mobile/features/shared/domain/entities/entities.dart';

import '../../domain/domain.dart';
import 'turnaround_repository_provider.dart';

// StateNotifierProvider

// Provider

final turnaroundProvider =
    StateNotifierProvider<TurnaroundNotifier, TurnaroundState>((ref) {
      final turnaroundsRepository = ref.watch(turnaroundRepositoryProvider);
      return TurnaroundNotifier(turnaroundsRepository: turnaroundsRepository);
    });

// Notifier

class TurnaroundNotifier extends StateNotifier<TurnaroundState> {
  final TurnaroundsRepository turnaroundsRepository;

  TurnaroundNotifier({required this.turnaroundsRepository})
    : super(TurnaroundState());

  Future<void> getTurnarounds() async {
    if (state.isLoading) return;
    // state = state.copyWith(isLoading: true);

    final turnarounds = await turnaroundsRepository.getTurnaroundsByDate(
      state.selectedDate.year,
      state.selectedDate.month,
      state.selectedDate.day,
    );
    // if (turnarounds.isEmpty) {
    //   state = state.copyWith(isLoading: false);
    //   return;
    // }
    state = state.copyWith(isLoading: false, turnarounds: turnarounds);
  }

  // set new date and fetch turnarounds
  void setSelectedDate(DateTime date) {
    state = state.copyWith(selectedDate: date);
    getTurnarounds();
  }

  // iniciar operaciones
  Future<SimpleApiResponse> iniciarOperaciones(int id) async {
    final response = await turnaroundsRepository.startOperations(id);

    if (response.success) {
      getTurnarounds();
    }

    return response;
  }

  Future<SimpleApiResponse> cerrarVuelo(Map<String, Object?> body) async {
    final response = await turnaroundsRepository.cerrarVuelo(body);
    if (response.success) {
      getTurnarounds();
    }
    return response;
  }
}

// STATE

class TurnaroundState {
  final DateTime selectedDate;
  final DateTime startDate;
  final DateTime endDate;
  final bool isLoading;
  final List<TurnaroundMain> turnarounds;

  TurnaroundState({
    DateTime? selectedDate,
    DateTime? startDate,
    DateTime? endDate,
    this.isLoading = false,
    this.turnarounds = const [],
  }) : selectedDate = selectedDate ?? DateTime.now(),
       startDate = startDate ?? DateTime.now(),
       endDate = endDate ?? DateTime.now();

  TurnaroundState copyWith({
    DateTime? selectedDate,
    DateTime? startDate,
    DateTime? endDate,
    bool? isLoading,
    List<TurnaroundMain>? turnarounds,
  }) {
    return TurnaroundState(
      selectedDate: selectedDate ?? this.selectedDate,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isLoading: isLoading ?? this.isLoading,
      turnarounds: turnarounds ?? this.turnarounds,
    );
  }
}

// TrcIdProvider
final trcIdProvider = StateProvider<int>((ref) {
  return 0;
});

// TODO: Selected Date Provider
final selectedDateProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});

// TODO: Selected Turnaround Provider
final selectedTurnaroundProvider = StateProvider<TurnaroundMain?>((ref) {
  return null;
});
