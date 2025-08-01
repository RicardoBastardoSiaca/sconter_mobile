import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:turnaround_mobile/features/turnarounds/domain/entities/control_actividades.dart';

import '../../../shared/shared.dart';
import 'providers.dart';
// Provider

final pasajerosFormProvider =
    StateNotifierProvider<PasajerosFormNotifier, PasajerosFormState>((ref) {
      final trcId = ref.watch(selectedTurnaroundProvider)!.id;
      final savePasajerosCallback = ref
          .watch(controlActividadesProvider(trcId).notifier)
          .savePasajeros;

      return PasajerosFormNotifier(
        savePasajerosCallback: savePasajerosCallback,
      );
    });

// Notifier
class PasajerosFormNotifier extends StateNotifier<PasajerosFormState> {
  final Function savePasajerosCallback;

  PasajerosFormNotifier({required this.savePasajerosCallback})
    : super(PasajerosFormState());

  final formKey = GlobalKey<FormState>();

  onInadmitidosEconomicaChanged(int value) {
    final newInadmitidosEconomica = IntegerInput.dirty(value);
    state = state.copyWith(
      inadmitidosEconomica: newInadmitidosEconomica,
      isValid: Formz.validate([
        newInadmitidosEconomica,
        state.inadmitidosEjecutivo,
        state.inadmitidosInfante,
        state.llegadaEconomica,
        state.llegadaEjecutivo,
        state.llegadaInfante,
        state.salidaEconomica,
        state.salidaEjecutivo,
        state.salidaInfante,
        state.transitoEconomica,
        state.transitoEjecutivo,
        state.transitoInfante,
      ]),
    );
  }

  onInadmitidosEjecutivoChanged(int value) {
    final newInadmitidosEjecutivo = IntegerInput.dirty(value);
    state = state.copyWith(
      inadmitidosEjecutivo: newInadmitidosEjecutivo,
      isValid: Formz.validate([
        newInadmitidosEjecutivo,
        state.inadmitidosInfante,
        state.llegadaEconomica,
        state.llegadaEjecutivo,
        state.llegadaInfante,
        state.salidaEconomica,
        state.salidaEjecutivo,
        state.salidaInfante,
        state.transitoEconomica,
        state.transitoEjecutivo,
        state.transitoInfante,
      ]),
    );
  }

  onInadmitidosInfanteChanged(int value) {
    final newInadmitidosInfante = IntegerInput.dirty(value);
    state = state.copyWith(
      inadmitidosInfante: newInadmitidosInfante,
      isValid: Formz.validate([
        newInadmitidosInfante,
        state.llegadaEconomica,
        state.llegadaEjecutivo,
        state.llegadaInfante,
        state.salidaEconomica,
        state.salidaEjecutivo,
        state.salidaInfante,
        state.transitoEconomica,
        state.transitoEjecutivo,
        state.transitoInfante,
      ]),
    );
  }

  onLlegadaEconomicaChanged(int value) {
    final newLlegadaEconomica = IntegerInput.dirty(value);
    state = state.copyWith(
      llegadaEconomica: newLlegadaEconomica,
      isValid: Formz.validate([
        newLlegadaEconomica,
        state.llegadaEjecutivo,
        state.llegadaInfante,
        state.salidaEconomica,
        state.salidaEjecutivo,
        state.salidaInfante,
        state.transitoEconomica,
        state.transitoEjecutivo,
        state.transitoInfante,
      ]),
    );
  }

  onLlegadaEjecutivoChanged(int value) {
    // if (value < 0) return;
    // if (value > 999) return;
    final newLlegadaEjecutivo = IntegerInput.dirty(value);
    state = state.copyWith(
      llegadaEjecutivo: newLlegadaEjecutivo,
      isValid: Formz.validate([
        newLlegadaEjecutivo,
        state.llegadaInfante,
        state.salidaEconomica,
        state.salidaEjecutivo,
        state.salidaInfante,
        state.transitoEconomica,
        state.transitoEjecutivo,
        state.transitoInfante,
        state.llegadaEconomica,
      ]),
    );
  }

  onLlegadaInfanteChanged(int value) {
    final newLlegadaInfante = IntegerInput.dirty(value);
    state = state.copyWith(
      llegadaInfante: newLlegadaInfante,
      isValid: Formz.validate([
        newLlegadaInfante,
        state.salidaEconomica,
        state.salidaEjecutivo,
        state.salidaInfante,
        state.transitoEconomica,
        state.transitoEjecutivo,
        state.transitoInfante,
        state.llegadaEconomica,
        state.llegadaEjecutivo,
      ]),
    );
  }

  onSalidaEconomicaChanged(int value) {
    final newSalidaEconomica = IntegerInput.dirty(value);
    state = state.copyWith(
      salidaEconomica: newSalidaEconomica,
      isValid: Formz.validate([
        newSalidaEconomica,
        state.salidaEjecutivo,
        state.salidaInfante,
        state.transitoEconomica,
        state.transitoEjecutivo,
        state.transitoInfante,
        state.llegadaEconomica,
        state.llegadaEjecutivo,
        state.llegadaInfante,
      ]),
    );
  }

  onSalidaEjecutivoChanged(int value) {
    final newSalidaEjecutivo = IntegerInput.dirty(value);
    state = state.copyWith(
      salidaEjecutivo: newSalidaEjecutivo,
      isValid: Formz.validate([
        newSalidaEjecutivo,
        state.salidaInfante,
        state.transitoEconomica,
        state.transitoEjecutivo,
        state.transitoInfante,
        state.llegadaEconomica,
        state.llegadaEjecutivo,
        state.llegadaInfante,
        state.salidaEconomica,
      ]),
    );
  }

  onSalidaInfanteChanged(int value) {
    final newSalidaInfante = IntegerInput.dirty(value);
    state = state.copyWith(
      salidaInfante: newSalidaInfante,
      isValid: Formz.validate([
        newSalidaInfante,
        state.transitoEconomica,
        state.transitoEjecutivo,
        state.transitoInfante,
        state.llegadaEconomica,
        state.llegadaEjecutivo,
        state.llegadaInfante,
        state.salidaEconomica,
        state.salidaEjecutivo,
      ]),
    );
  }

  onTransitoEconomicaChanged(int value) {
    final newTransitoEconomica = IntegerInput.dirty(value);
    state = state.copyWith(
      transitoEconomica: newTransitoEconomica,
      isValid: Formz.validate([
        newTransitoEconomica,
        state.transitoEjecutivo,
        state.transitoInfante,
        state.llegadaEconomica,
        state.llegadaEjecutivo,
        state.llegadaInfante,
        state.salidaEconomica,
        state.salidaEjecutivo,
        state.salidaInfante,
      ]),
    );
  }

  onTransitoEjecutivoChanged(int value) {
    final newTransitoEjecutivo = IntegerInput.dirty(value);
    state = state.copyWith(
      transitoEjecutivo: newTransitoEjecutivo,
      isValid: Formz.validate([
        newTransitoEjecutivo,
        state.transitoInfante,
        state.llegadaEconomica,
        state.llegadaEjecutivo,
        state.llegadaInfante,
        state.salidaEconomica,
        state.salidaEjecutivo,
        state.salidaInfante,
        state.transitoEconomica,
      ]),
    );
  }

  onTransitoInfanteChanged(int value) {
    final newTransitoInfante = IntegerInput.dirty(value);
    state = state.copyWith(
      transitoInfante: newTransitoInfante,
      isValid: Formz.validate([
        newTransitoInfante,
        state.llegadaEconomica,
        state.llegadaEjecutivo,
        state.llegadaInfante,
        state.salidaEconomica,
        state.salidaEjecutivo,
        state.salidaInfante,
        state.transitoEconomica,
        state.transitoEjecutivo,
      ]),
    );
  }

  onFormSubmitted() async {
    _touchEveryField();
    if (state.isValid) {
      state = state.copyWith(isPosting: true);
      await savePasajerosCallback();
      state = state.copyWith(isPosting: false, isFormPosted: true);
    }
  }

  // Future<void> getControlDeActividadesByTrcId() async {}

  _touchEveryField() {
    state = state.copyWith(
      inadmitidosEconomica: IntegerInput.dirty(
        state.inadmitidosEconomica.value,
      ),
      inadmitidosEjecutivo: IntegerInput.dirty(
        state.inadmitidosEjecutivo.value,
      ),
      inadmitidosInfante: IntegerInput.dirty(state.inadmitidosInfante.value),
      llegadaEconomica: IntegerInput.dirty(state.llegadaEconomica.value),
      llegadaEjecutivo: IntegerInput.dirty(state.llegadaEjecutivo.value),
      llegadaInfante: IntegerInput.dirty(state.llegadaInfante.value),
      salidaEconomica: IntegerInput.dirty(state.salidaEconomica.value),
      salidaEjecutivo: IntegerInput.dirty(state.salidaEjecutivo.value),
      salidaInfante: IntegerInput.dirty(state.salidaInfante.value),
      transitoEconomica: IntegerInput.dirty(state.transitoEconomica.value),
      transitoEjecutivo: IntegerInput.dirty(state.transitoEjecutivo.value),
      transitoInfante: IntegerInput.dirty(state.transitoInfante.value),
      isValid: Formz.validate([
        state.inadmitidosEconomica,
        state.inadmitidosEjecutivo,
        state.inadmitidosInfante,
        state.llegadaEconomica,
        state.llegadaEjecutivo,
        state.llegadaInfante,
        state.salidaEconomica,
        state.salidaEjecutivo,
        state.salidaInfante,
        state.transitoEconomica,
        state.transitoEjecutivo,
        state.transitoInfante,
      ]),
    );
  }

  void setInitialValues(Tarea tarea) {
    state = state.copyWith(
      inadmitidosEconomica: IntegerInput.dirty(
        tarea.pasajeros!['inadmitidosEconomica'],
      ),
      inadmitidosEjecutivo: IntegerInput.dirty(
        tarea.pasajeros!['inadmitidosEjecutivo'],
      ),
      inadmitidosInfante: IntegerInput.dirty(
        tarea.pasajeros!['inadmitidosInfante'],
      ),
      llegadaEconomica: IntegerInput.dirty(
        tarea.pasajeros!['llegadaEconomica'],
      ),
      llegadaEjecutivo: IntegerInput.dirty(
        tarea.pasajeros!['llegadaEjecutivo'],
      ),
      llegadaInfante: IntegerInput.dirty(tarea.pasajeros!['llegadaInfante']),
      salidaEconomica: IntegerInput.dirty(tarea.pasajeros!['salidaEconomica']),
      salidaEjecutivo: IntegerInput.dirty(tarea.pasajeros!['salidaEjecutivo']),
      salidaInfante: IntegerInput.dirty(tarea.pasajeros!['salidaInfante']),
      transitoEconomica: IntegerInput.dirty(
        tarea.pasajeros!['transitoEconomica'],
      ),
      transitoEjecutivo: IntegerInput.dirty(
        tarea.pasajeros!['transitoEjecutivo'],
      ),
      transitoInfante: IntegerInput.dirty(tarea.pasajeros!['transitoInfante']),
    );
  }
}

// State
class PasajerosFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;

  final IntegerInput inadmitidosEconomica;
  final IntegerInput inadmitidosEjecutivo;
  final IntegerInput inadmitidosInfante;
  final IntegerInput llegadaEconomica;
  final IntegerInput llegadaEjecutivo;
  final IntegerInput llegadaInfante;
  final IntegerInput salidaEconomica;
  final IntegerInput salidaEjecutivo;
  final IntegerInput salidaInfante;
  final IntegerInput transitoEconomica;
  final IntegerInput transitoEjecutivo;
  final IntegerInput transitoInfante;

  PasajerosFormState({
    this.isPosting = false,
    this.isFormPosted = false,
    this.isValid = false,
    this.inadmitidosEconomica = const IntegerInput.pure(),
    this.inadmitidosEjecutivo = const IntegerInput.pure(),
    this.inadmitidosInfante = const IntegerInput.pure(),
    this.llegadaEconomica = const IntegerInput.pure(),
    this.llegadaEjecutivo = const IntegerInput.pure(),
    this.llegadaInfante = const IntegerInput.pure(),
    this.salidaEconomica = const IntegerInput.pure(),
    this.salidaEjecutivo = const IntegerInput.pure(),
    this.salidaInfante = const IntegerInput.pure(),
    this.transitoEconomica = const IntegerInput.pure(),
    this.transitoEjecutivo = const IntegerInput.pure(),
    this.transitoInfante = const IntegerInput.pure(),
  });

  PasajerosFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    IntegerInput? inadmitidosEconomica,
    IntegerInput? inadmitidosEjecutivo,
    IntegerInput? inadmitidosInfante,
    IntegerInput? llegadaEconomica,
    IntegerInput? llegadaEjecutivo,
    IntegerInput? llegadaInfante,
    IntegerInput? salidaEconomica,
    IntegerInput? salidaEjecutivo,
    IntegerInput? salidaInfante,
    IntegerInput? transitoEconomica,
    IntegerInput? transitoEjecutivo,
    IntegerInput? transitoInfante,
  }) => PasajerosFormState(
    isPosting: isPosting ?? this.isPosting,
    isFormPosted: isFormPosted ?? this.isFormPosted,
    isValid: isValid ?? this.isValid,
    inadmitidosEconomica: inadmitidosEconomica ?? this.inadmitidosEconomica,
    inadmitidosEjecutivo: inadmitidosEjecutivo ?? this.inadmitidosEjecutivo,
    inadmitidosInfante: inadmitidosInfante ?? this.inadmitidosInfante,
    llegadaEconomica: llegadaEconomica ?? this.llegadaEconomica,
    llegadaEjecutivo: llegadaEjecutivo ?? this.llegadaEjecutivo,
    llegadaInfante: llegadaInfante ?? this.llegadaInfante,
    salidaEconomica: salidaEconomica ?? this.salidaEconomica,
    salidaEjecutivo: salidaEjecutivo ?? this.salidaEjecutivo,
    salidaInfante: salidaInfante ?? this.salidaInfante,
    transitoEconomica: transitoEconomica ?? this.transitoEconomica,
    transitoEjecutivo: transitoEjecutivo ?? this.transitoEjecutivo,
    transitoInfante: transitoInfante ?? this.transitoInfante,
  );
}
