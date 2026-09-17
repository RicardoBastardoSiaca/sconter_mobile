import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scounter_mobile/features/turnarounds/domain/domain.dart';
import 'package:scounter_mobile/features/turnarounds/presentation/providers/providers.dart';



class VuelosLineupState {
  final List<VueloLineup> vuelos;
  final bool isLoading;
  final DateTime startDate;
  final DateTime endDate;

  VuelosLineupState({
    required this.vuelos,
    required this.isLoading,
    required this.startDate,
    required this.endDate,
  });

  // Método copyWith para actualizar el estado inmutablemente
  VuelosLineupState copyWith({
    List<VueloLineup>? vuelos,
    bool? isLoading,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return VuelosLineupState(
      vuelos: vuelos ?? this.vuelos,
      isLoading: isLoading ?? this.isLoading,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
} 

class VuelosLineupNotifier extends StateNotifier<VuelosLineupState> {
  final TurnaroundsRepository turnaroundsRepository;
  VuelosLineupNotifier({required this.turnaroundsRepository})
      : super(VuelosLineupState(
          vuelos: [],
          isLoading: false,
          startDate: DateTime.now().subtract(const Duration(days: 30)),
          endDate: DateTime.now().add(const Duration(days: 30)),
        ));

  // Método para cargar vuelos (puedes completarlo con tu API)
  Future<void> fetchVuelos(VueloLineupRequest body) async {
    state = state.copyWith(isLoading: true, startDate: body.start, endDate: body.end);

    try {
      final response = await turnaroundsRepository.getVuelosLineup(body);

      state = state.copyWith(vuelos: response, isLoading: false);
      
      // Simulación de carga:
      // await Future.delayed(const Duration(seconds: 2));
      
      // state = state.copyWith(vuelos: [], isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  void updateDateRange(VueloLineupRequest body) {
    state = state.copyWith(startDate: body.start, endDate: body.end);
    fetchVuelos(body);
  }
}

final vuelosLineupProvider = StateNotifierProvider<VuelosLineupNotifier, VuelosLineupState>((ref) {
  final turnaroundsRepository = ref.watch(turnaroundRepositoryProvider);
  return VuelosLineupNotifier(turnaroundsRepository: turnaroundsRepository);
});

