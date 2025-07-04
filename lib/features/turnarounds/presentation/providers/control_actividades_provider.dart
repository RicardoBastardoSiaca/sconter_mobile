import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/domain.dart';
import 'providers.dart';

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
  }) : super(ControlActividadesState(id: trcId));

  Future<void> getControlDeActividadesByTrcId() async {
    state = state.copyWith(isLoading: true);
    try {
      final controlDeActividades = await turnaroundsRepository
          .getControlDeActividades(trcId);
      state = state.copyWith(
        controlActividades: controlDeActividades,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
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
