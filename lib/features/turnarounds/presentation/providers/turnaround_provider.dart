import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/domain.dart';
import 'turnaround_repository_provider.dart';

// StateNotifierProvider

// Provider

final turnaroundProvider = StateNotifierProvider<TurnaroundNotifier, TurnaroundState>((ref) {

  final turnaroundsRepository = ref.watch(turnaroundRepositoryProvider);
  return TurnaroundNotifier(
    turnaroundsRepository: turnaroundsRepository
  );
});




// Notifier

class TurnaroundNotifier extends StateNotifier<TurnaroundState> {

  final TurnaroundsRepository turnaroundsRepository;

  TurnaroundNotifier({
    required this.turnaroundsRepository
     
  }) : super(TurnaroundState());

  Future<void> getTurnarounds() async {

    // if (state.isLoading) return;
    // state = state.copyWith(isLoading: true);

    final turnarounds = await turnaroundsRepository.getTurnaroundsByDate(
      state.selectedDate.year, state.selectedDate.month, state.selectedDate.day
      );
    state = state.copyWith(
      isLoading: false, 
      turnarounds: turnarounds 
    );

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
    this.turnarounds =const [],
  })  : selectedDate = selectedDate ?? DateTime.now(),
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
