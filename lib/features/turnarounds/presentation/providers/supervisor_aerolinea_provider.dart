import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/shared.dart';
import '../../domain/domain.dart';
import 'providers.dart';

// Provider

final supervisorAerolineaProvider =
    StateNotifierProvider<
      SupervisorAerolineaNotifier,
      SupervisorAerolineaState
    >((ref) {
      final turnaroundsRepository = ref.watch(turnaroundRepositoryProvider);
      final idAerolinea = ref
          .watch(selectedTurnaroundProvider)!
          .fkVuelo
          .fkAerolinea
          .id;
      return SupervisorAerolineaNotifier(turnaroundsRepository, idAerolinea);
    });

// NOTIFIER

class SupervisorAerolineaNotifier
    extends StateNotifier<SupervisorAerolineaState> {
  SupervisorAerolineaNotifier(this.turnaroundsRepository, this.idAerolinea)
    : super(SupervisorAerolineaState());
  final int idAerolinea;
  final TurnaroundsRepository turnaroundsRepository;

  Future<void> getSupervisores() async {
    state = state.copyWith(isLoading: true);
    try {
      final supervisores = await turnaroundsRepository.getSupervisores(
        idAerolinea,
      );
      state = state.copyWith(supervisores: supervisores);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
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
      // 'documento': await MultipartFile.fromFile(photoPath, filename: photoPath),
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
        // getControlDeActividadesByTrcId();
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
}

// STATE

class SupervisorAerolineaState {
  final List<SupervisorUser> supervisores;
  final bool isLoading;
  final String? error;

  SupervisorAerolineaState({
    this.supervisores = const [],
    this.isLoading = false,
    this.error,
  });

  SupervisorAerolineaState copyWith({
    List<SupervisorUser>? supervisores,
    bool? isLoading,
    String? error,
  }) {
    return SupervisorAerolineaState(
      supervisores: supervisores ?? this.supervisores,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
// SupervisorUser