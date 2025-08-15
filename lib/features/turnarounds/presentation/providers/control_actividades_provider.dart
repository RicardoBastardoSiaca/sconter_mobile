import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
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

  Future<SnackbarResponse> setHoraInicioFinMaquinaria(
    HoraInicioFinMaquinaria body,
  ) async {
    try {
      final response = await turnaroundsRepository.setHoraInicioFinMaquinaria(
        body,
      );
      if (response.success) {
        getControlDeActividadesByTrcId();
        return SnackbarResponse(message: 'Hora registrada.', success: true);
      } else {
        return SnackbarResponse(
          message: 'Ha ocurrido un error.',
          success: false,
        );
      }
    } catch (e) {
      return SnackbarResponse(message: 'Ha ocurrido un error.', success: false);
    }
  }

  void addImage(String? photoPath) {
    // print("Adding image: $photoPath");
    if (photoPath == null || photoPath.isEmpty) {
      // print("No photo path provided.");
      return;
    }
    // print("Adding image to control actividades: $photoPath");
  }

  Future<SnackbarResponse?> uploadImage(String? photoPath, int id) async {
    // With FormData
    if (photoPath == null || photoPath.isEmpty) {
      // print("No photo path provided for upload.");
      return null;
    }

    final body = {'id': id, 'tipo': 'imagen'};
    final image = File(photoPath);

    FormData formData = FormData();
    formData = FormData.fromMap({
      'documento': await MultipartFile.fromFile(photoPath, filename: photoPath),
      'formato': 'documento',
      'nombre': 'avatar',
      'type': image.path.split('.').last,
      // 'encryptedBody': json.encode(body),
      'encryptedBody': EncryptDecrypt().encryptUsingAES256(json.encode(body)),
    });

    try {
      final response = await turnaroundsRepository.uploadImage(formData);
      if (response.success) {
        getControlDeActividadesByTrcId();
        return SnackbarResponse(message: 'Imagen subida.', success: true);
      } else {
        // print("Error uploading image: ${response.message}");
        return SnackbarResponse(
          message: 'Error al subir la imagen.',
          success: false,
        );
      }
    } catch (e) {
      // Handle any errors that occur during the upload
      return SnackbarResponse(
        message: 'Error al subir la imagen.',
        success: false,
      );
      // print("Error uploading image: $e");
    }
  }

  void updateImage(String? photoPath) {}

  Future<SnackbarResponse> deleteImage(int id) async {
    final body = {'id': id, 'tipo': 'imagen'};

    try {
      final response = await turnaroundsRepository.deleteImage(body);
      if (response.success) {
        // snackbar response
        getControlDeActividadesByTrcId();
        return SnackbarResponse(message: 'Imagen eliminada.', success: true);
      } else {
        return SnackbarResponse(
          message: 'Error al eliminar la imagen.',
          success: false,
        );
      }
    } catch (e) {
      // print("Error deleting image: $e");
      return SnackbarResponse(
        message: 'Ha ocurrido un error al eliminar la imagen.',
        success: false,
      );
    } finally {
      state = state.copyWith(isSaving: false);
    }
  }

  Future<SnackbarResponse> setComentario(ComentarioRequest body) async {
    try {
      final response = await turnaroundsRepository.setComentario(body);
      if (response.success) {
        getControlDeActividadesByTrcId();
        return SnackbarResponse(
          message: 'Comentario registrado.',
          success: true,
        );
      } else {
        return SnackbarResponse(
          message: 'Ha ocurrido un error.',
          success: false,
        );
      }
    } catch (e) {
      return SnackbarResponse(message: 'Ha ocurrido un error.', success: false);
    }
  }

  Future<SnackbarResponse> setNumero(SetNumeroTareaRequest body) async {
    try {
      final response = await turnaroundsRepository.setNumero(body);
      if (response.success) {
        getControlDeActividadesByTrcId();
        return SnackbarResponse(message: 'Número registrado.', success: true);
      } else {
        return SnackbarResponse(
          message: 'Ha ocurrido un error.',
          success: false,
        );
      }
    } catch (e) {
      return SnackbarResponse(message: 'Ha ocurrido un error.', success: false);
    }
  }

  Future<SnackbarResponse> savePasajeros(SavePasajerosRequest body) async {
    try {
      final response = await turnaroundsRepository.savePasajeros(body);
      if (response.success) {
        getControlDeActividadesByTrcId();
        return SnackbarResponse(
          message: 'Pasajeros registrados.',
          success: true,
        );
      } else {
        return SnackbarResponse(
          message: 'Ha ocurrido un error.',
          success: false,
        );
      }
    } catch (e) {
      return SnackbarResponse(message: 'Ha ocurrido un error.', success: false);
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

  // void getControlDeActividadesByTrcId() {}
}

// TurnaroundIdProvider
// final turnaroundIdProvider = StateProvider<int>((ref) {
//   return 0;
// });

// ControlActividades isLoading Provider
final isLoadingControlActividadesProvider = StateProvider<bool>((ref) {
  return false;
});

// Images List Provider
final imagesListProvider = StateProvider<CustomFullscreenCarouselData>((ref) {
  return CustomFullscreenCarouselData(imagenes: [], index: 0);
});

// Custom Data Class for Fullscreen Carousel
class CustomFullscreenCarouselData {
  late final List<Imagen> imagenes; // List of Imagen imagen;
  late final int index;
  CustomFullscreenCarouselData({required this.imagenes, required this.index});
}
