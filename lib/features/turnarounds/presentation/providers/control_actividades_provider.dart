import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/domain.dart';

final controlActividadesProvider = StateNotifierProvider.autoDispose
    .family<ControlActividadesNotifier, ControlActividadesState, int>((
      ref,
      trcId,
    ) {
      return ControlActividadesNotifier(trcId: trcId);
    });

// Notifier
class ControlActividadesNotifier
    extends StateNotifier<ControlActividadesState> {
  final int trcId;
  ControlActividadesNotifier({required this.trcId})
    : super(ControlActividadesState(id: trcId));
}

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
}
