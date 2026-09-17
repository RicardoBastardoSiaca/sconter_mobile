import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scounter_mobile/features/turnarounds/domain/domain.dart';
import 'package:scounter_mobile/features/turnarounds/presentation/providers/providers.dart';




// Provider
final ciudadesProvider = StateNotifierProvider<CiudadesNotifier, CiudadesState>((ref) {
  final turnaroundsRepository = ref.watch(turnaroundRepositoryProvider);
  return CiudadesNotifier(
    turnaroundsRepository: turnaroundsRepository,
  );
});


// Notifier
class CiudadesNotifier extends StateNotifier<CiudadesState> {
  final TurnaroundsRepository turnaroundsRepository;
  CiudadesNotifier({required this.turnaroundsRepository}) : super(CiudadesState(isLoading: true, ciudades: [],));

  void cargarCiudades(List<LugarDestino> ciudades) {
    // state = state.copyWith(ciudades: ciudades, isLoading: false);

    try {
      // TODO Terminar de cargar ciudades
    } catch (e) {
      
    print('Error $e');
      // state = state.copyWith(isLoading: false);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  // Future<List<Estacion>> getEstaciones() async {

  //   try {
  //     final getEstacionesResponse = await turnaroundsRepository.getEstaciones();
  //     return getEstacionesResponse;
  //   } catch (e) {
      
  //     print('Error $e');
  //     return [];
  //     // state = state.copyWith(isLoading: false);
  //   } finally {
  //     state = state.copyWith(isLoading: false);
  //   }
  // }

  // Cargar estaciones y guardarlas en el estado
  Future<void> cargarEstaciones() async {
    // Si ya existen estaciones cargadas, no volvemos a consultar la API
    if (state.estaciones.isNotEmpty) return;

    state = state.copyWith(isLoading: true);
    try {
      final estacionesRes = await turnaroundsRepository.getEstaciones();
      state = state.copyWith(estaciones: estacionesRes, isLoading: false);
    } catch (e) {
      print('Error al cargar estaciones: $e');
      state = state.copyWith(isLoading: false);
    }
  }
}


// state

// State
class CiudadesState {
  final bool isLoading;
  final List<LugarDestino> ciudades;
  final List<Estacion> estaciones; // <--- Agregar estaciones al estado

  CiudadesState({
    required this.isLoading,
    required this.ciudades,
    this.estaciones = const [],
  });

  CiudadesState copyWith({
    List<LugarDestino>? ciudades,
    List<Estacion>? estaciones,
    bool? isLoading,
  }) {
    return CiudadesState(
      isLoading: isLoading ?? this.isLoading,
      ciudades: ciudades ?? this.ciudades,
      estaciones: estaciones ?? this.estaciones,
    );
  }
}