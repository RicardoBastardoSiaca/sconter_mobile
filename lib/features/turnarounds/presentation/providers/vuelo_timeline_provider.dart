import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scounter_mobile/features/shared/domain/domain.dart';
import 'package:scounter_mobile/features/turnarounds/domain/domain.dart';
import 'package:scounter_mobile/features/turnarounds/presentation/providers/providers.dart';

class VueloTimelineState {
  final List<VueloCalendario> vuelos;
  final List<VueloLane> lanes;
  final bool isLoading;
  final DateTime startDate;
  final DateTime endDate;
  final double zoomLevel; // Valor entre 0.5 y 3.0 por ejemplo
  final Set<String> aerolineasFiltradas; // <-- Añadir esta línea
  final bool scrollInicialRealizado; // <--- NUEVA

  VueloTimelineState({
    this.vuelos = const [],
    this.lanes = const [],
    this.isLoading = false,
    required this.startDate,
    required this.endDate,
    this.zoomLevel = 1.0,
    this.aerolineasFiltradas = const {},
    this.scrollInicialRealizado = false, // Por defecto en false
  });

  VueloTimelineState copyWith({
    List<VueloCalendario>? vuelos,
    List<VueloLane>? lanes,
    bool? isLoading,
    DateTime? startDate,
    DateTime? endDate,
    double? zoomLevel,
    Set<String>? aerolineasFiltradas,
    bool? scrollInicialRealizado,
    // bool clearAerolineas = false, // Helper para poder resetear a null
  }) {
    return VueloTimelineState(
      vuelos: vuelos ?? this.vuelos,
      lanes: lanes ?? this.lanes,
      isLoading: isLoading ?? this.isLoading,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      zoomLevel: zoomLevel ?? this.zoomLevel,
        // 
      aerolineasFiltradas: aerolineasFiltradas ?? this.aerolineasFiltradas,
      scrollInicialRealizado: scrollInicialRealizado ?? this.scrollInicialRealizado,
    );
  }
}

class VueloTimelineNotifier extends StateNotifier<VueloTimelineState> {
  final TurnaroundsRepository turnaroundsRepository;
  VueloTimelineNotifier({required this.turnaroundsRepository}) : super(_initialState()){
    // Cargar datos iniciales
    getVuelosTimeline(
      VueloCalendarioRequest(
        start: state.startDate,
        end: state.endDate,
      ),
    );
  }

  static VueloTimelineState _initialState() {
    final now = DateTime.now();
    return VueloTimelineState(
      // startDate y endDate se inicializan con el primer y ultimo dia de la semana actual
        startDate: DateTime(now.year, now.month, now.day - now.weekday + 1), // Lunes de la semana actual
        endDate: DateTime(now.year, now.month, now.day - now.weekday + 7), // Domingo de la semana actual
      // startDate: DateTime(now.year, now.month, 1),
      // endDate: DateTime(now.year, now.month + 1, 0),
      isLoading: true, // Iniciamos en true para evitar el flash de "No hay vuelos"
    );
  }
  // static VueloTimelineState _initialState() {
  //   final now = DateTime.now();
  //   return VueloTimelineState(
  //     startDate: DateTime(now.year, now.month, 1),
  //     endDate: DateTime(now.year, now.month + 1, 0),
  //     isLoading: true, // Iniciamos en true para evitar el flash de "No hay vuelos"
  //   );
  // }

  Future<void> getVuelosTimeline(VueloCalendarioRequest body) async {
    state = state.copyWith(isLoading: true, startDate: body.start, endDate: body.end);

    try {
      final response = await turnaroundsRepository.getVuelosCalendario(body);

      // state = state.copyWith(vuelos: response, isLoading: false);
      setVuelos(response);
      // state = state.copyWith(scrollInicialRealizado: false);
      // Simulación de carga:
      // await Future.delayed(const Duration(seconds: 2));
      
      // state = state.copyWith(vuelos: [], isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false);
      // Manejar error
    }
  }

  // Navegación
  void moveToNextMonth() {
    final newStart = DateTime(state.startDate.year, state.startDate.month + 1, 1);
    final newEnd = DateTime(newStart.year, newStart.month + 1, 0);
    state = state.copyWith(startDate: newStart, endDate: newEnd);
    // Aquí es donde dispararás tu lógica de carga de datos
    // Al cambiar la fecha internamente, disparamos la carga
    getVuelosTimeline( VueloCalendarioRequest(
      start: newStart,
      end: newEnd,
    ));
  }

  // moveToPreviousWeek
    void moveToPreviousWeek() {
      final newStart = DateTime(state.startDate.year, state.startDate.month, state.startDate.day - 7);
      final newEnd = DateTime(state.endDate.year, state.endDate.month, state.endDate.day - 7);
      state = state.copyWith(startDate: newStart, endDate: newEnd);
  
      getVuelosTimeline( VueloCalendarioRequest(
        start: newStart,
        end: newEnd,
      ));
    }
  // moveToNextWeek
  void moveToNextWeek() {
    final newStart = DateTime(state.startDate.year, state.startDate.month, state.startDate.day + 7);
    final newEnd = DateTime(state.endDate.year, state.endDate.month, state.endDate.day + 7);
    state = state.copyWith(startDate: newStart, endDate: newEnd);
  
    getVuelosTimeline( VueloCalendarioRequest(
      start: newStart,
      end: newEnd,
    ));
  }

  void moveToPreviousMonth() {
    final newStart = DateTime(state.startDate.year, state.startDate.month - 1, 1);
    final newEnd = DateTime(newStart.year, newStart.month + 1, 0);
    state = state.copyWith(startDate: newStart, endDate: newEnd);

    getVuelosTimeline( VueloCalendarioRequest(
      start: newStart,
      end: newEnd,
    ));
  }

  void cambiarSemanaPorFecha(DateTime fechaSeleccionada) {
  // Usamos la extensión para calcular los límites reales
  final lunes = fechaSeleccionada.startOfWeek;
  final domingo = fechaSeleccionada.endOfWeek;

  // Actualizamos el estado con el nuevo rango (esto reactiva los selectors y llamadas al API)
  state = state.copyWith(
    startDate: lunes,
    endDate: domingo,
    // isLoading: true, // Si manejas un estado de carga
  );

  // Aquí disparas tu método actual para traer los vuelos del repositorio
  // _cargarVuelosParaRango(lunes, domingo);
  getVuelosTimeline( VueloCalendarioRequest(
    start: lunes,
    end: domingo,
  ));
}

  void setVuelos(List<VueloCalendario> nuevosVuelos) {
    state = state.copyWith(isLoading: true);
    final procesados = VueloLayoutHelper.asignarVuelosALanes(nuevosVuelos);
    state = state.copyWith(
      vuelos: nuevosVuelos,
      lanes: procesados,
      isLoading: false,
      zoomLevel: state.zoomLevel,
    );
  }

  void setZoom(double newScale) {
    // 1. Limitar el rango para que el cálculo no se desborde
    final double clampedZoom = newScale.clamp(0.5, 4.0);

    // 2. FILTRO CRÍTICO: Si el cambio es menor al 2%, ignoramos el evento
    // Esto reduce las reconstrucciones de 60 por segundo a unas 5 o 10.
    if ((state.zoomLevel - clampedZoom).abs() < 0.02) return;

    state = state.copyWith(zoomLevel: clampedZoom);
  }

//   void filtrarPorAerolinea(String? nombreAerolinea) {
//   if (nombreAerolinea == null) {
//     // Si es null, reseteamos el filtro para mostrar todas
//     state = state.copyWith(clearAerolinea: true);
//   } else {
//     state = state.copyWith(aerolineaFiltrada: nombreAerolinea);
//   }
// }

void toggleAerolineaFiltro(String nombreAerolinea) {
  final nuevasAerolineas = Set<String>.from(state.aerolineasFiltradas);
  
  if (nuevasAerolineas.contains(nombreAerolinea)) {
    nuevasAerolineas.remove(nombreAerolinea);
  } else {
    nuevasAerolineas.add(nombreAerolinea);
  }

  state = state.copyWith(aerolineasFiltradas: nuevasAerolineas);
}

// Resetea el filtro por completo
void limpiarFiltroAerolineas() {
  state = state.copyWith(aerolineasFiltradas: const {});
}

void marcarScrollComoRealizado() {
  state = state.copyWith(scrollInicialRealizado: true);
}

}

final vuelosTimelineProvider = StateNotifierProvider<VueloTimelineNotifier, VueloTimelineState>((ref) {
  final turnaroundsRepository = ref.watch(turnaroundRepositoryProvider);
  return VueloTimelineNotifier(turnaroundsRepository: turnaroundsRepository);
});


// bool _showNavigationHeader = true; // Por defecto se muestra