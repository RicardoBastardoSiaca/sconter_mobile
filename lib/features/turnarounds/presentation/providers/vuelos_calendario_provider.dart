import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scounter_mobile/features/turnarounds/domain/domain.dart';
import 'package:scounter_mobile/features/turnarounds/presentation/providers/providers.dart';

// Clase que representa el estado de la pantalla de vuelos
class VuelosState {
  final List<VueloCalendario> vuelos;
  final bool isLoading;
  final DateTime startDate;
  final DateTime endDate;

  VuelosState({
    required this.vuelos,
    required this.isLoading,
    required this.startDate,
    required this.endDate,
  });

  // Método copyWith para actualizar el estado inmutablemente
  VuelosState copyWith({
    List<VueloCalendario>? vuelos,
    bool? isLoading,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return VuelosState(
      vuelos: vuelos ?? this.vuelos,
      isLoading: isLoading ?? this.isLoading,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}

// El Notifier que maneja la lógica
class VuelosNotifier extends StateNotifier<VuelosState> {
  final TurnaroundsRepository turnaroundsRepository;
  VuelosNotifier({required this.turnaroundsRepository})
      : super(VuelosState(
          vuelos: [],
          isLoading: false,
          startDate: DateTime.now().subtract(const Duration(days: 30)),
          endDate: DateTime.now().add(const Duration(days: 30)),
        ));

  // Método para cargar vuelos (puedes completarlo con tu API)
  Future<void> fetchVuelos(VueloCalendarioRequest body) async {
    state = state.copyWith(isLoading: true, startDate: body.start, endDate: body.end);

    try {
      final response = await turnaroundsRepository.getVuelosCalendario(body);

      state = state.copyWith(vuelos: response, isLoading: false);
      
      // Simulación de carga:
      // await Future.delayed(const Duration(seconds: 2));
      
      // state = state.copyWith(vuelos: [], isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false);
      // Manejar error
    }
  }

  // Método para actualizar fechas y recargar
  void updateDateRange(VueloCalendarioRequest body) {
    state = state.copyWith(startDate: body.start, endDate: body.end);
    fetchVuelos(body);
  }
}

// El Provider que será escuchado por la UI
final vuelosCalendarioProvider = StateNotifierProvider<VuelosNotifier, VuelosState>((ref) {
  final turnaroundsRepository = ref.watch(turnaroundRepositoryProvider);
  return VuelosNotifier(turnaroundsRepository: turnaroundsRepository);
});