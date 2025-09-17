import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turnaround_mobile/features/shared/shared.dart';

import '../../domain/domain.dart';
import 'providers.dart';

// Provider
final serviciosAdicionalesProvider =
    StateNotifierProvider<
      ServiciosAdicionalesNotifier,
      ServiciosAdicionalesState
    >((ref) {
      final turnaroundsRepository = ref.watch(turnaroundRepositoryProvider);
      final selectedTrc = ref.watch(selectedTurnaroundProvider);

      return ServiciosAdicionalesNotifier(
        trcId: selectedTrc!.id,
        selectedTrc: selectedTrc,
        turnaroundsRepository: turnaroundsRepository,
      );
    });

// Notifier
class ServiciosAdicionalesNotifier
    extends StateNotifier<ServiciosAdicionalesState> {
  final int trcId;
  final TurnaroundMain selectedTrc;
  final TurnaroundsRepository turnaroundsRepository;

  ServiciosAdicionalesNotifier({
    required this.trcId,
    required this.selectedTrc,
    required this.turnaroundsRepository,
  }) : super(
         ServiciosAdicionalesState(id: trcId, categoriasEquiposGseResponse: []),
       );

  Future<void> getServiciosAdicionales() async {
    try {
      state = state.copyWith(isLoading: true);
      final result = await turnaroundsRepository.getServiciosAdicionales();
      if (result.isNotEmpty) {
        state = state.copyWith(
          categoriasEquiposGseResponse: result,
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> getServiciosEspeciales() async {
    try {
      state = state.copyWith(isLoading: true);
      final result = await turnaroundsRepository.getServiciosEspeciales();
      if (result.isNotEmpty) {
        state = state.copyWith(
          categoriasEquiposGseResponse: result,
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<SnackbarResponse> saveServiciosAdicionales(
    ServiciosAdicionalRequest body,
  ) async {
    try {
      state = state.copyWith(isSaving: true);
      final SimpleApiResponse result = await turnaroundsRepository
          .saveServiciosAdicionales(body);
      state = state.copyWith(isSaving: false);
      if (!result.success) {
        return SnackbarResponse(message: result.message, success: false);
      }

      return SnackbarResponse(message: result.message, success: true);
    } catch (e) {
      state = state.copyWith(isSaving: false);
      return SnackbarResponse(
        message: 'Error al guardar los servicios adicionales',
        success: false,
      );
    }
  }

  Future<SnackbarResponse> setHoraInicioServicioAdicional(
    SetHoraServicioAdicionalRequest body,
  ) async {
    state = state.copyWith(isSaving: true);

    switch (body.tipo) {
      // case 'Hora':
      //   try {
      //     final response = await turnaroundsRepository.setHoraInicio(
      //       id,
      //       horaInicio,
      //       tipo,
      //     );
      //     if (response.success) {
      //       getControlDeActividadesByTrcId();

      //       return SnackbarResponse(message: 'Hora registrada.', success: true);
      //       // Show success snackbar
      //       // ScaffoldMessenger.of(context).showSnackBar(
      //       //   const SnackBar(content: Text('Hora de inicio actualizada correctamente.')),
      //       // );
      //     } else {
      //       // print("Error al actualizar la hora de inicio: ${response.message}");
      //       return SnackbarResponse(
      //         message: 'Ha ocurrido un error.',
      //         success: false,
      //       );
      //     }
      //   } catch (e) {
      //     // print("Error setting hora de inicio: $e");
      //     return SnackbarResponse(
      //       message: 'Ha ocurrido un error.',
      //       success: false,
      //     );
      //   } finally {
      //     state = state.copyWith(isSaving: false);
      //   }
      case 'Hora de Inicio':
        try {
          final response = await turnaroundsRepository
              .setHoraInicioServicioAdicional(body);
          if (response.success) {
            // get control de actividades
            // getControlDeActividadesByTrcId(); from control actividades provider

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
      case 'Hora fin':
        try {
          final response = await turnaroundsRepository
              .setHoraFinServicioAdicional(body);
          if (response.success) {
            // getControlDeActividadesByTrcId(); from control actividades provider

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

  Future<SnackbarResponse> setHoraMaquinariaServicioAdicional(
    HoraMaquinariaServicioAdicionalResponse body,
  ) async {
    state = state.copyWith(isSaving: true);
    try {
      final response = await turnaroundsRepository
          .setHoraMaquinariaServicioAdicional(body);
      if (response.success) {
        // get control de actividades
        // getControlDeActividadesByTrcId(); from control actividades provider

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
      return SnackbarResponse(message: 'Ha ocurrido un error.', success: false);
    } finally {
      state = state.copyWith(isSaving: false);
    }
  }

  
  Future<SnackbarResponse> setCantidadServicioEspecial(
    Map<String, Object?> body,
  ) async {
    state = state.copyWith(isSaving: true);
    
    try {
      final response = await turnaroundsRepository
          .setCantidadServicioAdicional(body);
      if (response.success) {
        return SnackbarResponse(message: 'Cantidad registrada.', success: true);
        // getControlDeActividadesByTrcId(); from control actividades provider
      } else {
        // print("Error al actualizar la hora de inicio: ${response.message}");
        return SnackbarResponse(
          message: 'Ha ocurrido un error.',
          success: false,
        );
      }
    } catch (e) {
      // print("Error setting hora de inicio: $e");
      return SnackbarResponse(message: 'Ha ocurrido un error.', success: false);
    } finally {
      state = state.copyWith(isSaving: false);
    }
  }

  Future<SnackbarResponse> setComentarioServicioAdicional(
    ComentarioServiciosAdicionalRequest body,
  ) async {
    state = state.copyWith(isSaving: true);
    try {
      final response = await turnaroundsRepository
          .setComentarioServicioAdicional(body);
      if (response.success) {
        return SnackbarResponse(
          message: 'Comentario registrado.',
          success: true,
        );
        // getControlDeActividadesByTrcId(); from control actividades provider
      } else {
        // print("Error al actualizar la hora de inicio: ${response.message}");
        return SnackbarResponse(
          message: 'Ha ocurrido un error.',
          success: false,
        );
      }
    } catch (e) {
      // print("Error setting hora de inicio: $e");
      return SnackbarResponse(message: 'Ha ocurrido un error.', success: false);
    } finally {
      state = state.copyWith(isSaving: false);
    }
  }

  Future<SnackbarResponse> saveServiciosEspeciales(
    ServiciosAdicionalRequest body,
  ) async {
    try {
      state = state.copyWith(isSaving: true);
      final SimpleApiResponse result = await turnaroundsRepository
          .saveServiciosEspeciales(body);
      state = state.copyWith(isSaving: false);
      if (!result.success) {
        return SnackbarResponse(message: result.message, success: false);
      }

      return SnackbarResponse(message: result.message, success: true);
    } catch (e) {
      state = state.copyWith(isSaving: false);
      return SnackbarResponse(
        message: 'Error al guardar los servicios adicionales',
        success: false,
      );
    }
  }
}

// State
class ServiciosAdicionalesState {
  late final int id;
  final List<CategoriaServicioAdicional> categoriasEquiposGseResponse;
  final bool isLoading;
  final bool isSaving;

  ServiciosAdicionalesState({
    required this.id,
    required this.categoriasEquiposGseResponse,
    this.isLoading = false,
    this.isSaving = false,
  });

  ServiciosAdicionalesState copyWith({
    int? id,
    List<CategoriaServicioAdicional>? categoriasEquiposGseResponse,
    bool? isLoading,
    bool? isSaving,
  }) {
    return ServiciosAdicionalesState(
      id: id ?? this.id,
      categoriasEquiposGseResponse:
          categoriasEquiposGseResponse ?? this.categoriasEquiposGseResponse,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}

// class AsignarEquiposDialogDataNotifier extends StateNotifier<AsignarEquiposDialogData> {
//   AsignarEquiposDialogDataNotifier(): super(AsignarEquiposDialogData(servicioAdicional: null, turnaround: null, tipoAsignacion: ''));

// }

final asignarEquiposDialogDataProvider =
    StateProvider<AsignarEquiposDialogData>((ref) {
      return AsignarEquiposDialogData(
        servicioAdicional: null,
        turnaround: null,
        tipoAsignacion: '',
      );
    });

// AsignarEquiposDialogData
