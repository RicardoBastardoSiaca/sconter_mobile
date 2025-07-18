import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turnaround_mobile/features/shared/domain/domain.dart';

import '../../domain/domain.dart';
import 'providers.dart';
// import shared
// StateNotifierProvider

// Provider

final controlActividadesProvider =
    StateNotifierProvider.family<
      ControlActividadesNotifier,
      ControlActividadesState,
      int
    >((ref, trcId) {
      final turnaroundsRepository = ref.watch(turnaroundRepositoryProvider);
      return ControlActividadesNotifier(
        trcId: trcId,
        turnaroundsRepository: turnaroundsRepository,
      );
    });

// Notifier
class ControlActividadesNotifier
    extends StateNotifier<ControlActividadesState> {
  final TurnaroundsRepository turnaroundsRepository;
  final int trcId;
  ControlActividadesNotifier({
    required this.turnaroundsRepository,
    required this.trcId,
  }) : super(ControlActividadesState(id: trcId)) {
    getControlDeActividadesByTrcId();
  }

  Future<void> getControlDeActividadesByTrcId() async {
    print("getControlDeActividadesByTrcId: $trcId");
    state = state.copyWith(isLoading: true);
    try {
      final controlDeActividades = await turnaroundsRepository
          .getControlDeActividades(trcId);
      state = state.copyWith(
        controlActividades: controlDeActividades,
        isLoading: false,
      );
      // print("Control de Actividades: $controlDeActividades");
    } catch (e) {
      // print("Error getting control de actividades: $e");
      state = state.copyWith(isLoading: false);
    }
  }

  Future<SnackbarResponse> setHoraInicio(
    int id,
    DateTime horaInicio,
    String tipo,
  ) async {
    state = state.copyWith(isSaving: true);

    switch (tipo) {
      case 'Hora':
        try {
          final response = await turnaroundsRepository.setHoraInicio(
            id,
            horaInicio,
            tipo,
          );
          if (response.success) {
            getControlDeActividadesByTrcId();

            return SnackbarResponse(message: 'Hora registrada.', success: true);
            // Show success snackbar
            // ScaffoldMessenger.of(context).showSnackBar(
            //   const SnackBar(content: Text('Hora de inicio actualizada correctamente.')),
            // );
          } else {
            // print("Error al actualizar la hora de inicio: ${response.message}");
            return SnackbarResponse(
              message: 'Ha ocurrido un error.',
              success: false,
            );
          }
        } catch (e) {
          // print("Error setting hora de inicio: $e");
          return SnackbarResponse(
            message: 'Ha ocurrido un error.',
            success: false,
          );
        } finally {
          state = state.copyWith(isSaving: false);
        }
      case 'Hora de Inicio':
        try {
          final response = await turnaroundsRepository.setHoraInicioFin(
            id,
            horaInicio,
            tipo,
          );
          if (response.success) {
            getControlDeActividadesByTrcId();

            return SnackbarResponse(message: 'Hora registrada.', success: true);
            // Show success snackbar
            // ScaffoldMessenger.of(context).showSnackBar(
            //   const SnackBar(content: Text('Hora de inicio actualizada correctamente.')),
            // );
          } else {
            // print("Error al actualizar la hora de inicio: ${response.message}");
            return SnackbarResponse(
              message: 'Ha ocurrido un error.',
              success: false,
            );
          }
        } catch (e) {
          // print("Error setting hora de inicio: $e");
          return SnackbarResponse(
            message: 'Ha ocurrido un error.',
            success: false,
          );
        } finally {
          state = state.copyWith(isSaving: false);
        }
      case 'Hora final':
        try {
          final response = await turnaroundsRepository.setHoraInicioFin(
            id,
            horaInicio,
            tipo,
          );
          if (response.success) {
            getControlDeActividadesByTrcId();

            return SnackbarResponse(message: 'Hora registrada.', success: true);
            // Show success snackbar
            // ScaffoldMessenger.of(context).showSnackBar(
            //   const SnackBar(content: Text('Hora de inicio actualizada correctamente.')),
            // );
          } else {
            // print("Error al actualizar la hora de inicio: ${response.message}");
            return SnackbarResponse(
              message: 'Ha ocurrido un error.',
              success: false,
            );
          }
        } catch (e) {
          // print("Error setting hora de inicio: $e");
          return SnackbarResponse(
            message: 'Ha ocurrido un error.',
            success: false,
          );
        } finally {
          state = state.copyWith(isSaving: false);
        }
      default:
        // print("Unknown tipo: $tipo");
        return SnackbarResponse(message: 'Tipo no reconocido.', success: false);
    }
  }
}

// State
class ControlActividadesState {
  final int id;
  final ControlActividades? controlActividades;
  final bool isLoading;
  final bool isSaving;

  ControlActividadesState({
    required this.id,
    this.controlActividades,
    this.isLoading = true,
    this.isSaving = false,
  });

  ControlActividadesState copyWith({
    int? id,
    ControlActividades? controlActividades,
    bool? isLoading,
    bool? isSaving,
  }) => ControlActividadesState(
    id: id ?? this.id,
    controlActividades: controlActividades ?? this.controlActividades,
    isLoading: isLoading ?? this.isLoading,
    isSaving: isSaving ?? this.isSaving,
  );

  void getControlDeActividadesByTrcId() {}
}

// TurnaroundIdProvider
// final turnaroundIdProvider = StateProvider<int>((ref) {
//   return 0;
// });

// ControlActividades isLoading Provider
final isLoadingControlActividadesProvider = StateProvider<bool>((ref) {
  return false;
});
