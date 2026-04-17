import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';

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

  onEconomicaChanged(int value) {
    final newEconomica = IntegerInput.dirty(value);
    state = state.copyWith(
      economica: newEconomica,
      isValid: Formz.validate([
        newEconomica,
        state.ejecutivo,
        state.infante,
      ]),
    );
  }
  onEjecutivoChanged(int value) {
    final newEjecutivo = IntegerInput.dirty(value);
    state = state.copyWith(
      ejecutivo: newEjecutivo,
      isValid: Formz.validate([
        newEjecutivo,
        state.economica,
        state.infante,
      ]),
    );
  }
  onInfanteChanged(int value) {
    final newInfante = IntegerInput.dirty(value);
    state = state.copyWith(
      infante: newInfante,
      isValid: Formz.validate([
        newInfante,
        state.economica,
        state.ejecutivo,
      ]),
    );
  }

  // onInadmitidosEconomicaChanged(int value) {
  //   final newInadmitidosEconomica = IntegerInput.dirty(value);
  //   state = state.copyWith(
  //     inadmitidosEconomica: newInadmitidosEconomica,
  //     isValid: Formz.validate([
  //       newInadmitidosEconomica,
  //       state.inadmitidosEjecutivo,
  //       state.inadmitidosInfante,
  //       state.llegadaEconomica,
  //       state.llegadaEjecutivo,
  //       state.llegadaInfante,
  //       state.salidaEconomica,
  //       state.salidaEjecutivo,
  //       state.salidaInfante,
  //       state.transitoEconomica,
  //       state.transitoEjecutivo,
  //       state.transitoInfante,
  //     ]),
  //   );
  // }

  // onInadmitidosEjecutivoChanged(int value) {
  //   final newInadmitidosEjecutivo = IntegerInput.dirty(value);
  //   state = state.copyWith(
  //     inadmitidosEjecutivo: newInadmitidosEjecutivo,
  //     isValid: Formz.validate([
  //       newInadmitidosEjecutivo,
  //       state.inadmitidosInfante,
  //       state.llegadaEconomica,
  //       state.llegadaEjecutivo,
  //       state.llegadaInfante,
  //       state.salidaEconomica,
  //       state.salidaEjecutivo,
  //       state.salidaInfante,
  //       state.transitoEconomica,
  //       state.transitoEjecutivo,
  //       state.transitoInfante,
  //     ]),
  //   );
  // }

  // onInadmitidosInfanteChanged(int value) {
  //   final newInadmitidosInfante = IntegerInput.dirty(value);
  //   state = state.copyWith(
  //     inadmitidosInfante: newInadmitidosInfante,
  //     isValid: Formz.validate([
  //       newInadmitidosInfante,
  //       state.llegadaEconomica,
  //       state.llegadaEjecutivo,
  //       state.llegadaInfante,
  //       state.salidaEconomica,
  //       state.salidaEjecutivo,
  //       state.salidaInfante,
  //       state.transitoEconomica,
  //       state.transitoEjecutivo,
  //       state.transitoInfante,
  //     ]),
  //   );
  // }

  // onLlegadaEconomicaChanged(int value) {
  //   final newLlegadaEconomica = IntegerInput.dirty(value);
  //   state = state.copyWith(
  //     llegadaEconomica: newLlegadaEconomica,
  //     isValid: Formz.validate([
  //       newLlegadaEconomica,
  //       state.llegadaEjecutivo,
  //       state.llegadaInfante,
  //       state.salidaEconomica,
  //       state.salidaEjecutivo,
  //       state.salidaInfante,
  //       state.transitoEconomica,
  //       state.transitoEjecutivo,
  //       state.transitoInfante,
  //     ]),
  //   );
  // }

  // onLlegadaEjecutivoChanged(int value) {
  //   // if (value < 0) return;
  //   // if (value > 999) return;
  //   final newLlegadaEjecutivo = IntegerInput.dirty(value);
  //   state = state.copyWith(
  //     llegadaEjecutivo: newLlegadaEjecutivo,
  //     isValid: Formz.validate([
  //       newLlegadaEjecutivo,
  //       state.llegadaInfante,
  //       state.salidaEconomica,
  //       state.salidaEjecutivo,
  //       state.salidaInfante,
  //       state.transitoEconomica,
  //       state.transitoEjecutivo,
  //       state.transitoInfante,
  //       state.llegadaEconomica,
  //     ]),
  //   );
  // }

  // onLlegadaInfanteChanged(int value) {
  //   final newLlegadaInfante = IntegerInput.dirty(value);
  //   state = state.copyWith(
  //     llegadaInfante: newLlegadaInfante,
  //     isValid: Formz.validate([
  //       newLlegadaInfante,
  //       state.salidaEconomica,
  //       state.salidaEjecutivo,
  //       state.salidaInfante,
  //       state.transitoEconomica,
  //       state.transitoEjecutivo,
  //       state.transitoInfante,
  //       state.llegadaEconomica,
  //       state.llegadaEjecutivo,
  //     ]),
  //   );
  // }

  // onSalidaEconomicaChanged(int value) {
  //   final newSalidaEconomica = IntegerInput.dirty(value);
  //   state = state.copyWith(
  //     salidaEconomica: newSalidaEconomica,
  //     isValid: Formz.validate([
  //       newSalidaEconomica,
  //       state.salidaEjecutivo,
  //       state.salidaInfante,
  //       state.transitoEconomica,
  //       state.transitoEjecutivo,
  //       state.transitoInfante,
  //       state.llegadaEconomica,
  //       state.llegadaEjecutivo,
  //       state.llegadaInfante,
  //     ]),
  //   );
  // }

  // onSalidaEjecutivoChanged(int value) {
  //   final newSalidaEjecutivo = IntegerInput.dirty(value);
  //   state = state.copyWith(
  //     salidaEjecutivo: newSalidaEjecutivo,
  //     isValid: Formz.validate([
  //       newSalidaEjecutivo,
  //       state.salidaInfante,
  //       state.transitoEconomica,
  //       state.transitoEjecutivo,
  //       state.transitoInfante,
  //       state.llegadaEconomica,
  //       state.llegadaEjecutivo,
  //       state.llegadaInfante,
  //       state.salidaEconomica,
  //     ]),
  //   );
  // }

  // onSalidaInfanteChanged(int value) {
  //   final newSalidaInfante = IntegerInput.dirty(value);
  //   state = state.copyWith(
  //     salidaInfante: newSalidaInfante,
  //     isValid: Formz.validate([
  //       newSalidaInfante,
  //       state.transitoEconomica,
  //       state.transitoEjecutivo,
  //       state.transitoInfante,
  //       state.llegadaEconomica,
  //       state.llegadaEjecutivo,
  //       state.llegadaInfante,
  //       state.salidaEconomica,
  //       state.salidaEjecutivo,
  //     ]),
  //   );
  // }

  // onTransitoEconomicaChanged(int value) {
  //   final newTransitoEconomica = IntegerInput.dirty(value);
  //   state = state.copyWith(
  //     transitoEconomica: newTransitoEconomica,
  //     isValid: Formz.validate([
  //       newTransitoEconomica,
  //       state.transitoEjecutivo,
  //       state.transitoInfante,
  //       state.llegadaEconomica,
  //       state.llegadaEjecutivo,
  //       state.llegadaInfante,
  //       state.salidaEconomica,
  //       state.salidaEjecutivo,
  //       state.salidaInfante,
  //     ]),
  //   );
  // }

  // onTransitoEjecutivoChanged(int value) {
  //   final newTransitoEjecutivo = IntegerInput.dirty(value);
  //   state = state.copyWith(
  //     transitoEjecutivo: newTransitoEjecutivo,
  //     isValid: Formz.validate([
  //       newTransitoEjecutivo,
  //       state.transitoInfante,
  //       state.llegadaEconomica,
  //       state.llegadaEjecutivo,
  //       state.llegadaInfante,
  //       state.salidaEconomica,
  //       state.salidaEjecutivo,
  //       state.salidaInfante,
  //       state.transitoEconomica,
  //     ]),
  //   );
  // }

  // onTransitoInfanteChanged(int value) {
  //   final newTransitoInfante = IntegerInput.dirty(value);
  //   state = state.copyWith(
  //     transitoInfante: newTransitoInfante,
  //     isValid: Formz.validate([
  //       newTransitoInfante,
  //       state.llegadaEconomica,
  //       state.llegadaEjecutivo,
  //       state.llegadaInfante,
  //       state.salidaEconomica,
  //       state.salidaEjecutivo,
  //       state.salidaInfante,
  //       state.transitoEconomica,
  //       state.transitoEjecutivo,
  //     ]),
  //   );
  // }

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
    onEconomicaChanged(state.economica.value ?? 0);
    onEjecutivoChanged(state.ejecutivo.value ?? 0);
    onInfanteChanged(state.infante.value ?? 0);
  }

  // void setInitialValues(Tarea tarea) {
  //   state = state.copyWith(
  //     inadmitidosEconomica: IntegerInput.pure(
  //       tarea.pasajeros!['inadmitidos_economica'],
  //     ),
  //     inadmitidosEjecutivo: IntegerInput.pure(
  //       tarea.pasajeros!['inadmitidos_ejecutivo'],
  //     ),
  //     inadmitidosInfante: IntegerInput.pure(
  //       tarea.pasajeros!['inadmitidos_infante'],
  //     ),
  //     llegadaEconomica: IntegerInput.pure(
  //       tarea.pasajeros!['llegada_economica'],
  //     ),
  //     llegadaEjecutivo: IntegerInput.pure(
  //       tarea.pasajeros!['llegada_ejecutivo'],
  //     ),
  //     llegadaInfante: IntegerInput.pure(tarea.pasajeros!['llegada_infante']),
  //     salidaEconomica: IntegerInput.pure(tarea.pasajeros!['salida_economica']),
  //     salidaEjecutivo: IntegerInput.pure(tarea.pasajeros!['salida_ejecutivo']),
  //     salidaInfante: IntegerInput.pure(tarea.pasajeros!['salida_infante']),
  //     transitoEconomica: IntegerInput.pure(
  //       tarea.pasajeros!['transito_economica'],
  //     ),
  //     transitoEjecutivo: IntegerInput.pure(
  //       tarea.pasajeros!['transito_ejecutivo'],
  //     ),
  //     transitoInfante: IntegerInput.pure(tarea.pasajeros!['transito_infante']),

  //     isPosting: false,
  //     isFormPosted: false,
  //     isValid: false,
  //   );
  //   // print state
  //   print(state);
  // }

bool isTotalPassagersValid() {
    // Since the validation logic is not implemented, we return true for now.
    return true;
  }
//   bool isTotalPassagersValid() {
//     bool ejecutivo =
//         (state.llegadaEjecutivo.value! +
//             state.transitoEjecutivo.value! -
//             state.inadmitidosEjecutivo.value!) >=
//         0;
//     bool economica =
//         (state.llegadaEconomica.value! +
//             state.transitoEconomica.value! -
//             state.inadmitidosEconomica.value!) >=
//         0;
//     bool infante =
//         (state.llegadaInfante.value! +
//             state.transitoInfante.value! -
//             state.inadmitidosInfante.value!) >=
//         0;

//     //     0;
//     return ejecutivo && economica && infante;
//   }
}

// Validate Funtion to cehck total passagers is a positive number, if the form id (Salida + transito - inadmitidos > 0  )

// State
class PasajerosFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;

  final IntegerInput economica;
  final IntegerInput ejecutivo;
  final IntegerInput infante;


  PasajerosFormState({
    this.isPosting = false,
    this.isFormPosted = false,
    this.isValid = false,
    this.economica = const IntegerInput.pure(),
    this.ejecutivo = const IntegerInput.pure(),
    this.infante = const IntegerInput.pure(),
   
  });

  PasajerosFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    IntegerInput? economica,
    IntegerInput? ejecutivo,
    IntegerInput? infante,
  }) {
    return PasajerosFormState(
      isPosting: isPosting ?? this.isPosting,
      isFormPosted: isFormPosted ?? this.isFormPosted,
      isValid: isValid ?? this.isValid,
      economica: economica ?? this.economica,
      ejecutivo: ejecutivo ?? this.ejecutivo,
      infante: infante ?? this.infante,
    );
  } 
}
