import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scounter_mobile/features/local_storage/local_storage.dart';
import 'package:scounter_mobile/features/shared/shared.dart';

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
      final localStorageRepository = ref.watch(localStorageRepositoryProvider);
      final ConnectivityService _connectivityService = ConnectivityService();
      
      return ServiciosAdicionalesNotifier(
        trcId: selectedTrc!.id,
        selectedTrc: selectedTrc,
        turnaroundsRepository: turnaroundsRepository,
        localStorageRepository: localStorageRepository,
        connectivityService: _connectivityService,
      );
    });

// Notifier
class ServiciosAdicionalesNotifier
    extends StateNotifier<ServiciosAdicionalesState> {
  final int trcId;
  final TurnaroundMain selectedTrc;
  final TurnaroundsRepository turnaroundsRepository;
  final StoredRequestApiRepository localStorageRepository;
  final ConnectivityService connectivityService;

  ServiciosAdicionalesNotifier({
    required this.trcId,
    required this.selectedTrc,
    required this.turnaroundsRepository,
    required this.localStorageRepository,
    required this.connectivityService,
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

          // ** No Internet connection check **
          final bool isConnected = await ConnectivityService().hasConnection;
          if (!isConnected) {
            // Save the api call for later

            final requestBody = {
              'id': body.id,
              'hora_inicio': body.horaInicio!.toUtc().toIso8601String(),
              'tipo': body.tipo,
            };

            localStorageRepository.saveRequestApi(
              RequestApi(
                id: DateTime.now().millisecondsSinceEpoch,
                url: '/servicios_adicionales/horainiciofin',
                method: 'POST',
                body: requestBody,
                timestamp: DateTime.now().millisecondsSinceEpoch,
              ),
            );

            return SnackbarResponse(
              message: 'Hora registrada. Sin conexión.',
              success: false,
              hasConnection: false,
            );
          }
          // ** No Internet connection check END **



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

          // ** No Internet connection check **
          final bool isConnected = await ConnectivityService().hasConnection;
          if (!isConnected) {
            // Save the api call for later
            final requestBody = {
            'id': body.id,
            'hora_fin': body.horaFin!.toUtc().toIso8601String(),
            'tipo': body.tipo,
          };

            localStorageRepository.saveRequestApi(
              RequestApi(
                id: DateTime.now().millisecondsSinceEpoch,
                url: '/servicios_adicionales/horainiciofin',
                method: 'POST',
                body: requestBody,
                timestamp: DateTime.now().millisecondsSinceEpoch,
              ),
            );

            return SnackbarResponse(
              message: 'Hora registrada. Sin conexión.',
              success: false,
              hasConnection: false,
            );
          }
          // ** No Internet connection check END **

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

      // TODO: No Internet check
          // ** No Internet connection check **
          final bool isConnected = await ConnectivityService().hasConnection;
          if (!isConnected) {
            // Save the api call for later
            final requestBody = {
              'id': body.id,
              'servicio_adicional_id': body.servicioAdicionalId,
              'hora_inicio': body.tipo == "Hora de Inicio"
                  ? body.horaInicio!.toUtc().toIso8601String()
                  : null,
              'hora_fin': body.tipo == "Hora final"
                  ? body.horaFin!.toUtc().toIso8601String()
                  : null,
              'tipo': body.tipo,
            };

            localStorageRepository.saveRequestApi(
              RequestApi(
                id: DateTime.now().millisecondsSinceEpoch,
                url: '/servicios_adicionales/maquinaria_con_hora',
                method: 'POST',
                body: requestBody,
                timestamp: DateTime.now().millisecondsSinceEpoch,
              ),
            );

            return SnackbarResponse(
              message: 'Hora registrada. Sin conexión.',
              success: false,
              hasConnection: false,
            );
          }
          // ** No Internet connection check END **

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
      // ** No Internet connection check **
          final bool isConnected = await ConnectivityService().hasConnection;
          if (!isConnected) {
            // Save the api call for later
            // final requestBody = {
            //   'id': body.id,
            //   'servicio_adicional_id': body.servicioAdicionalId,
            //   'hora_inicio': body.tipo == "Hora de Inicio"
            //       ? body.horaInicio!.toUtc().toIso8601String()
            //       : null,
            //   'hora_fin': body.tipo == "Hora final"
            //       ? body.horaFin!.toUtc().toIso8601String()
            //       : null,
            //   'tipo': body.tipo,
            // };

            localStorageRepository.saveRequestApi(
              RequestApi(
                id: DateTime.now().millisecondsSinceEpoch,
                url: '/servicios_adicionales/maquinaria_con_hora',
                method: 'POST',
                body: body,
                timestamp: DateTime.now().millisecondsSinceEpoch,
              ),
            );

            return SnackbarResponse(
              message: 'Hora registrada. Sin conexión.',
              success: false,
              hasConnection: false,
            );
          }
          // ** No Internet connection check END **
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
      // ** No Internet connection check **
          final bool isConnected = await ConnectivityService().hasConnection;
          if (!isConnected) {
            // Save the api call for later
            final requestBody = {
              'id': body.id,
              'comentario': body.comentario,
              'es_servicio_adicional': body.esServicioAdicional,
            };

            localStorageRepository.saveRequestApi(
              RequestApi(
                id: DateTime.now().millisecondsSinceEpoch,
                url: '/servicios_adicionales/maquinaria_con_hora',
                method: 'POST',
                body: requestBody,
                timestamp: DateTime.now().millisecondsSinceEpoch,
              ),
            );

            return SnackbarResponse(
              message: 'Hora registrada. Sin conexión.',
              success: false,
              hasConnection: false,
            );
          }
          // ** No Internet connection check END **
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
