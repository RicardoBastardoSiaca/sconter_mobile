import 'package:flutter/material.dart';
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

  Future<void> getServiciosMiscelaneos() async {
    if (state.isLoading) return;
    // state = state.copyWith(isLoading: true);

    final serviciosMiscelaneos = await turnaroundsRepository.getServiciosMiscelaneosByDate(
      state.selectedDate.year,
      state.selectedDate.month,
      state.selectedDate.day,
    );
    // if (turnarounds.isEmpty) {
    //   state = state.copyWith(isLoading: false);
    //   return;
    // }
    state = state.copyWith(isLoading: false, serviciosMiscelaneos: serviciosMiscelaneos);
  } 

  // set new date and fetch turnarounds
  void setSelectedDate(DateTime date, [bool isServicioMiscelaneo = false]) {
    if (isServicioMiscelaneo) {
      state = state.copyWith(selectedDate: date);
      getServiciosMiscelaneos();
    } else {
      state = state.copyWith(selectedDate: date);
      getTurnarounds();
    }
  }

  // void setSelectedDate(DateTime date) {
  //   state = state.copyWith(selectedDate: date);
  //   getTurnarounds();
  // }
  // void setSelectedDate(DateTime date) {
  //   state = state.copyWith(selectedDate: date);
  //   getTurnarounds();
  // }

  // iniciar operaciones
  Future<SimpleApiResponse> iniciarOperaciones(int id) async {
    final response = await turnaroundsRepository.startOperations(id);

    if (response.success) {
      getTurnarounds();
    }

    return response;
  }
  // iniciar operaciones
  Future<SimpleApiResponse> iniciarOperacionesServiciosMiscelaneos(int id) async {
    final response = await turnaroundsRepository.iniciarOperacionesServicioMiscelaneo(id);

    if (response.success) {
      getServiciosMiscelaneos();
    }

    return response;
  }

  Future<SimpleApiResponse> cerrarVuelo(Map<String, Object?> body) async {
    final response = await turnaroundsRepository.cerrarVuelo(body);
    if (response.success) {
      getTurnarounds();
    // snackbar to show message
    
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text(response.message)),
      // );
    }
    // 

    


    return response;
  }

  Future<SimpleApiResponse> finalizarVueloServicioMiscelaneo(int id) async {
    final response = await turnaroundsRepository.finalizarVueloServicioMiscelaneo(id);
    if (response.success) {
      getServiciosMiscelaneos();
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
  final List<TurnaroundMain> serviciosMiscelaneos;

  TurnaroundState({
    DateTime? selectedDate,
    DateTime? startDate,
    DateTime? endDate,
    this.isLoading = false,
    this.turnarounds = const [],
    this.serviciosMiscelaneos = const [],
  }) : selectedDate = selectedDate ?? DateTime.now(),
       startDate = startDate ?? DateTime.now(),
       endDate = endDate ?? DateTime.now();

  TurnaroundState copyWith({
    DateTime? selectedDate,
    DateTime? startDate,
    DateTime? endDate,
    bool? isLoading,
    List<TurnaroundMain>? turnarounds,
    List<TurnaroundMain>? serviciosMiscelaneos,
  }) {
    return TurnaroundState(
      selectedDate: selectedDate ?? this.selectedDate,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isLoading: isLoading ?? this.isLoading,
      turnarounds: turnarounds ?? this.turnarounds,
      serviciosMiscelaneos: serviciosMiscelaneos ?? this.serviciosMiscelaneos,
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
