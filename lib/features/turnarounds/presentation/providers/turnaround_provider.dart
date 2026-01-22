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
    // Capture the date we want to fetch to avoid race conditions when
    // multiple requests are made in quick succession. We don't rely on
    // `state.selectedDate` inside the async call because it may change
    // before the request completes.
    final DateTime requestDate = state.selectedDate;

    final turnarounds = await turnaroundsRepository.getTurnaroundsByDate(
      requestDate.year,
      requestDate.month,
      requestDate.day,
    );

    // Only apply the results if the selected date hasn't changed since
    // we made the request. This prevents older responses from overwriting
    // newer ones when users click back/forward quickly.
    if (state.selectedDate == requestDate) {
      state = state.copyWith(isLoading: false, turnarounds: turnarounds);
    }
  }

  Future<void> getServiciosMiscelaneos() async {
    // See note in getTurnarounds: capture the request date so that
    // out-of-order network responses don't clobber newer data.
    final DateTime requestDate = state.selectedDate;

    final serviciosMiscelaneos = await turnaroundsRepository.getServiciosMiscelaneosByDate(
      requestDate.year,
      requestDate.month,
      requestDate.day,
    );

    if (state.selectedDate == requestDate) {
      state = state.copyWith(isLoading: false, serviciosMiscelaneos: serviciosMiscelaneos);
    }
  } 

  // set new date and fetch turnarounds
  void setSelectedDate(DateTime date, [bool isServicioMiscelaneo = false]) {
    // Update the selected date immediately so UI reflects changes.
    state = state.copyWith(selectedDate: date);

    // Trigger fetch for the specific date. The fetch functions capture
    // the date at call time and will ignore any responses that don't
    // match the then-current selected date, avoiding race conditions.
    if (isServicioMiscelaneo) {
      getServiciosMiscelaneos();
    } else {
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
    return response;
  }
  Future<SimpleApiResponse> cerrarVueloervicioMiscelaneo(Map<String, Object?> body) async {
    final response = await turnaroundsRepository.cerrarVueloervicioMiscelaneo(body);
    if (response.success) {
      getServiciosMiscelaneos();
    }
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

// provider to write comments a simple string to modify
final comentarioProvider = StateProvider<String>((ref) {
  return '';
});
