import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
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
  final Set<String> aerolineasFiltradas;
  final bool scrollInicialRealizado;

  VueloTimelineState({
    this.vuelos = const [],
    this.lanes = const [],
    this.isLoading = false,
    required this.startDate,
    required this.endDate,
    this.zoomLevel = 1.0,
    this.aerolineasFiltradas = const {},
    this.scrollInicialRealizado = false,
  });

  // --- GETTERS DEDUCIDOS DE COMPATIBILIDAD CON LA UI ---

  /// Devuelve el ancho por hora escalado según el zoomLevel
  double get anchoHora => 80.0 * zoomLevel;

  /// Retorna lista vacía para mantener compatibilidad si la UI evalúa excepciones
  List<String> get fechasOmitidas => const [];

  /// Agrupa dinámicamente la lista de vuelos por fecha en formato 'yyyy-MM-dd'
  /// Agrupa dinámicamente la lista de vuelos por fecha en formato 'yyyy-MM-dd'
  Map<String, List<VueloCalendario>> get vuelosPorDia {
    final Map<String, List<VueloCalendario>> mapa = {};

    // Inicializamos el mapa con los días dentro del rango (startDate -> endDate)
    DateTime cursor = startDate;
    while (!cursor.isAfter(endDate)) {
      final key = DateFormat('yyyy-MM-dd').format(cursor);
      mapa[key] = [];
      cursor = cursor.add(const Duration(days: 1));
    }

    // Agrupamos los vuelos disponibles
    for (final vuelo in vuelos) {
      // Usamos 'aerolineaNombre' en lugar de 'aerolinea'
      if (aerolineasFiltradas.isNotEmpty &&
          !aerolineasFiltradas.contains(vuelo.aerolineaNombre)) {
        continue;
      }

      // Usamos 'auxFecha' o 'fechaInicio' de la entidad VueloCalendario
      String fechaClave = vuelo.auxFecha;
      if (fechaClave.isEmpty && vuelo.fechaInicio != null) {
        try {
          final parsed = DateTime.parse(vuelo.fechaInicio!);
          fechaClave = DateFormat('yyyy-MM-dd').format(parsed);
        } catch (_) {
          fechaClave = DateFormat('yyyy-MM-dd').format(startDate);
        }
      }

      if (mapa.containsKey(fechaClave)) {
        mapa[fechaClave]!.add(vuelo);
      } else if (fechaClave.isNotEmpty) {
        mapa[fechaClave] = [vuelo];
      }
    }

    return mapa;
  }

  VueloTimelineState copyWith({
    List<VueloCalendario>? vuelos,
    List<VueloLane>? lanes,
    bool? isLoading,
    DateTime? startDate,
    DateTime? endDate,
    double? zoomLevel,
    Set<String>? aerolineasFiltradas,
    bool? scrollInicialRealizado,
  }) {
    return VueloTimelineState(
      vuelos: vuelos ?? this.vuelos,
      lanes: lanes ?? this.lanes,
      isLoading: isLoading ?? this.isLoading,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      zoomLevel: zoomLevel ?? this.zoomLevel,
      aerolineasFiltradas: aerolineasFiltradas ?? this.aerolineasFiltradas,
      scrollInicialRealizado: scrollInicialRealizado ?? this.scrollInicialRealizado,
    );
  }
}

class VueloTimelineNotifier extends StateNotifier<VueloTimelineState> {
  final TurnaroundsRepository turnaroundsRepository;

  VueloTimelineNotifier({required this.turnaroundsRepository}) : super(_initialState()) {
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
      startDate: DateTime(now.year, now.month, now.day - now.weekday + 1), // Lunes
      endDate: DateTime(now.year, now.month, now.day - now.weekday + 7),   // Domingo
      isLoading: true,
    );
  }

  Future<void> getVuelosTimeline(VueloCalendarioRequest body) async {
    state = state.copyWith(isLoading: true, startDate: body.start, endDate: body.end);

    try {
      final response = await turnaroundsRepository.getVuelosCalendario(body);
      setVuelos(response);
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  /// Refresca los datos usando las fechas del rango actual
  void cargarDatos() {
    getVuelosTimeline(
      VueloCalendarioRequest(
        start: state.startDate,
        end: state.endDate,
      ),
    );
  }

  void setVuelos(List<VueloCalendario> nuevosVuelos) {
    final procesados = VueloLayoutHelper.asignarVuelosALanes(nuevosVuelos);
    state = state.copyWith(
      vuelos: nuevosVuelos,
      lanes: procesados,
      isLoading: false,
    );
  }

  // --- MÉTODOS DE SCROLL ---

  void marcarScrollComoRealizado() {
    state = state.copyWith(scrollInicialRealizado: true);
  }

  void resetScrollInicial() {
    state = state.copyWith(scrollInicialRealizado: false);
  }

  // --- NAVEGACIÓN Y RANGOS ---

  void moveToNextMonth() {
    final newStart = DateTime(state.startDate.year, state.startDate.month + 1, 1);
    final newEnd = DateTime(newStart.year, newStart.month + 1, 0);
    getVuelosTimeline(VueloCalendarioRequest(start: newStart, end: newEnd));
  }

  void moveToPreviousMonth() {
    final newStart = DateTime(state.startDate.year, state.startDate.month - 1, 1);
    final newEnd = DateTime(newStart.year, newStart.month + 1, 0);
    getVuelosTimeline(VueloCalendarioRequest(start: newStart, end: newEnd));
  }

  void moveToPreviousWeek() {
    final newStart = DateTime(state.startDate.year, state.startDate.month, state.startDate.day - 7);
    final newEnd = DateTime(state.endDate.year, state.endDate.month, state.endDate.day - 7);
    getVuelosTimeline(VueloCalendarioRequest(start: newStart, end: newEnd));
  }

  void moveToNextWeek() {
    final newStart = DateTime(state.startDate.year, state.startDate.month, state.startDate.day + 7);
    final newEnd = DateTime(state.endDate.year, state.endDate.month, state.endDate.day + 7);
    getVuelosTimeline(VueloCalendarioRequest(start: newStart, end: newEnd));
  }

  void cambiarSemanaPorFecha(DateTime fechaSeleccionada) {
    final lunes = fechaSeleccionada.startOfWeek;
    final domingo = fechaSeleccionada.endOfWeek;
    getVuelosTimeline(VueloCalendarioRequest(start: lunes, end: domingo));
  }

  // --- FILTROS Y ZOOM ---

  void setZoom(double newScale) {
    final double clampedZoom = newScale.clamp(0.5, 4.0);
    if ((state.zoomLevel - clampedZoom).abs() < 0.02) return;
    state = state.copyWith(zoomLevel: clampedZoom);
  }

  void toggleAerolineaFiltro(String nombreAerolinea) {
    final nuevasAerolineas = Set<String>.from(state.aerolineasFiltradas);
    if (nuevasAerolineas.contains(nombreAerolinea)) {
      nuevasAerolineas.remove(nombreAerolinea);
    } else {
      nuevasAerolineas.add(nombreAerolinea);
    }
    state = state.copyWith(aerolineasFiltradas: nuevasAerolineas);
  }

  void limpiarFiltroAerolineas() {
    state = state.copyWith(aerolineasFiltradas: const {});
  }
}

final vuelosTimelineProvider = StateNotifierProvider<VueloTimelineNotifier, VueloTimelineState>((ref) {
  final turnaroundsRepository = ref.watch(turnaroundRepositoryProvider);
  return VueloTimelineNotifier(turnaroundsRepository: turnaroundsRepository);
});