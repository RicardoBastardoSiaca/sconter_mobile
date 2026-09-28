import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scounter_mobile/features/turnarounds/presentation/providers/providers.dart';

import '../../../shared/shared.dart';
import '../../domain/domain.dart';

import 'package:change_case/change_case.dart';

class AsignarPersonalScreen extends ConsumerStatefulWidget {
  const AsignarPersonalScreen({super.key});

  @override
  ConsumerState<AsignarPersonalScreen> createState() =>
      _AsignarPersonalScreenState();
}

class _AsignarPersonalScreenState extends ConsumerState<AsignarPersonalScreen> {
  List<DepartamentoPersonal> areasLocales = [];
  
  // Declaración de los Sets de IDs iniciales por categoría
  Set<int> initialPersonalIds = {};
  Set<int> initialGerenteIds = {};
  Set<int> initialSupervisorIds = {};

  bool _isInitialized = false;
  final Map<String, bool> _expandedAreas = {};

  void _cargarDatos() {
    final selectedTurnaroundId = ref.read(selectedTurnaroundProvider)?.id;
    if (selectedTurnaroundId == null) return;

    final estado = ref.read(departamentoPersonalProvider(selectedTurnaroundId));
    final response = estado.departamentoPersonalResponse;

    if (response != null && !_isInitialized) {
      areasLocales = response.areas.map((area) {
        return area.copyWith(
          personal: area.personal.map((p) => p.copyWith()).toList(),
          gerentes: area.gerentes.map((g) => g.copyWith()).toList(),
          supervisores: area.supervisores.map((s) => s.copyWith()).toList(),
        );
      }).toList();

      for (var area in areasLocales) {
        _expandedAreas[area.nombreDepartamento] = true;
      }

      // Cargar los Sets iniciales por separado utilizando los datos originales
      initialPersonalIds = areasLocales
          .expand((a) => a.personal)
          .where((p) => p.selected)
          .map((p) => p.id)
          .toSet();

      initialGerenteIds = areasLocales
          .expand((a) => a.gerentes)
          .where((p) => p.selected)
          .map((p) => p.id)
          .toSet();

      initialSupervisorIds = areasLocales
          .expand((a) => a.supervisores)
          .where((p) => p.selected)
          .map((p) => p.id)
          .toSet();

      _isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedTurnaroundId = ref.watch(selectedTurnaroundProvider)?.id;
    final estado = ref.watch(
      departamentoPersonalProvider(selectedTurnaroundId ?? 0),
    );

    if (estado.departamentoPersonalResponse != null && !_isInitialized) {
      _cargarDatos();
    }

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Asignar Personal'),
        elevation: 0,
      ),
      body: estado.isLoading || !_isInitialized
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: areasLocales
                            .map((area) => _buildAreaCard(theme, area))
                            .toList(),
                      ),
                    ),
                  ),
                  _buildBottomBar(context, selectedTurnaroundId ?? 0),
                ],
              ),
            ),
    );
  }

  Widget _buildAreaCard(ThemeData theme, DepartamentoPersonal area) {
    // Tomar directamente las listas seleccionadas provenientes del modelo
    final gerentes = area.gerentes.where((g) => g.selected).toList();
    final supervisores = area.supervisores.where((s) => s.selected).toList();
    final personal = area.personal.where((p) => p.selected).toList();

    final int totalAsignados = gerentes.length + supervisores.length + personal.length;
    final isExpanded = _expandedAreas[area.nombreDepartamento] ?? true;

    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300, width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Theme(
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          key: PageStorageKey(area.nombreDepartamento),
          initiallyExpanded: isExpanded,
          onExpansionChanged: (expanded) {
            setState(() {
              _expandedAreas[area.nombreDepartamento] = expanded;
            });
          },
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          title: Row(
            children: [
              Container(
                width: 6,
                height: 20,
                decoration: BoxDecoration(
                  color: const Color(0xFF00A859),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  area.nombreDepartamento,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: const Color(0xFF00A859),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF00A859).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$totalAsignados',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00A859),
                  ),
                ),
              ),
            ],
          ),
          trailing: Icon(
            isExpanded
                ? Icons.keyboard_arrow_up_rounded
                : Icons.keyboard_arrow_down_rounded,
            color: Colors.grey.shade700,
            size: 26,
          ),
          children: [
            const Divider(height: 16, thickness: 1),
            _buildGrupoCategoria(
              theme,
              area: area,
              titulo: 'Gerentes',
              listaPersonal: gerentes,
              icon: Icons.shield_outlined,
              colorAccent: Colors.amber.shade800,
              tipoCategoria: 'gerentes',
            ),
            const SizedBox(height: 14),
            _buildGrupoCategoria(
              theme,
              area: area,
              titulo: 'Supervisores',
              listaPersonal: supervisores,
              icon: Icons.badge_outlined,
              colorAccent: Colors.blue.shade700,
              tipoCategoria: 'supervisores',
            ),
            const SizedBox(height: 14),
            _buildGrupoCategoria(
              theme,
              area: area,
              titulo: 'Personal',
              listaPersonal: personal,
              icon: Icons.groups_outlined,
              colorAccent: Colors.teal.shade700,
              tipoCategoria: 'personal',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGrupoCategoria(
    ThemeData theme, {
    required DepartamentoPersonal area,
    required String titulo,
    required List<PersonalDepartamento> listaPersonal,
    required IconData icon,
    required Color colorAccent,
    required String tipoCategoria,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => _showEditarPersonalDialog(area, titulo, tipoCategoria),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(icon, size: 18, color: colorAccent),
                      const SizedBox(width: 6),
                      Text(
                        titulo,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00A859).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.edit_outlined,
                      color: Color(0xFF00A859),
                      size: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        if (listaPersonal.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Text(
              'Sin personal asignado',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade600,
                fontStyle: FontStyle.italic,
                fontSize: 13,
              ),
            ),
          )
        else
          ...listaPersonal.map((p) => _buildItemPersonal(theme, p)),
      ],
    );
  }

  void _showEditarPersonalDialog(
    DepartamentoPersonal area,
    String tituloCategoria,
    String tipoCategoria,
  ) {
    // Determinar la lista según la categoría correspondiente del área
    List<PersonalDepartamento> personalCategoria = [];

    if (tipoCategoria == 'gerentes') {
      personalCategoria = area.gerentes;
    } else if (tipoCategoria == 'supervisores') {
      personalCategoria = area.supervisores;
    } else {
      personalCategoria = area.personal;
    }

    final Map<int, bool> tempSelection = {
      for (var p in personalCategoria) p.id: p.selected
    };

    String searchQuery = '';
    final TextEditingController searchController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final personalFiltrado = personalCategoria.where((p) {
              final nombre = _obtenerNombreFormateado(p).toLowerCase();
              final cargo = p.cargo.toLowerCase();
              final q = searchQuery.toLowerCase().trim();
              return nombre.contains(q) || cargo.contains(q);
            }).toList();

            final int seleccionadosCount =
                tempSelection.values.where((v) => v).length;

            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              titlePadding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              actionsPadding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Asignar $tituloCategoria',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          fontSize: 18,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        area.nombreDepartamento,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF00A859),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00A859).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '$seleccionadosCount',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF00A859),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 38,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade300, width: 0.8),
                    ),
                    child: TextField(
                      controller: searchController,
                      onChanged: (val) {
                        setModalState(() {
                          searchQuery = val;
                        });
                      },
                      style: const TextStyle(fontSize: 13, color: Colors.black87),
                      decoration: InputDecoration(
                        hintText: 'buscar...',
                        hintStyle: TextStyle(
                          fontSize: 12.5,
                          color: Colors.grey.shade500,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          size: 18,
                          color: Colors.grey.shade600,
                        ),
                        suffixIcon: searchQuery.isNotEmpty
                            ? IconButton(
                                icon: Icon(
                                  Icons.clear,
                                  size: 16,
                                  color: Colors.grey.shade600,
                                ),
                                onPressed: () {
                                  searchController.clear();
                                  setModalState(() {
                                    searchQuery = '';
                                  });
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 8),
                        isDense: true,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                ],
              ),
              content: SizedBox(
                width: double.maxFinite,
                height: MediaQuery.of(context).size.height * 0.45,
                child: personalFiltrado.isEmpty
                    ? Center(
                        child: Text(
                          searchQuery.isEmpty
                              ? 'No hay personal disponible.'
                              : 'Sin resultados para "$searchQuery"',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 13,
                          ),
                        ),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        itemCount: personalFiltrado.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final p = personalFiltrado[index];
                          final String nombreMostrar = _obtenerNombreFormateado(p);
                          final isSelected = tempSelection[p.id] ?? false;

                          return CheckboxListTile(
                            key: ValueKey('dialog_p_${p.id}_$index'),
                            dense: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                            activeColor: const Color(0xFF00A859),
                            title: Text(
                              nombreMostrar,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            subtitle: Text(
                              p.cargo,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            value: isSelected,
                            onChanged: (bool? val) {
                              setModalState(() {
                                tempSelection[p.id] = val ?? false;
                              });
                            },
                          );
                        },
                      ),
              ),
              actions: [
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          searchController.dispose();
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Cancelar',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00A859),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () {
  // 1. Identificar únicamente la lista correspondiente a esta categoría
  List<PersonalDepartamento> listaObjetivo = [];
  if (tipoCategoria == 'gerentes') {
    listaObjetivo = area.gerentes;
  } else if (tipoCategoria == 'supervisores') {
    listaObjetivo = area.supervisores;
  } else {
    listaObjetivo = area.personal;
  }

  // 2. Modificar el estado 'selected' solo en los elementos de esa lista
  for (var p in listaObjetivo) {
    if (tempSelection.containsKey(p.id)) {
      p.selected = tempSelection[p.id]!;
    }
  }

  searchController.dispose();
  Navigator.pop(context);
  setState(() {});
},
                        child: const Text(
                          'Listo',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildItemPersonal(ThemeData theme, PersonalDepartamento p) {
    final String nombreMostrar = _obtenerNombreFormateado(p);

    return Container(
      key: ValueKey('item_personal_${p.id}'),
      margin: const EdgeInsets.only(bottom: 4.0),
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300, width: 1.0),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: const Color(0xFF00A859),
            child: Text(
              _getIniciales(nombreMostrar),
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  nombreMostrar,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                    fontSize: 14.5,
                    height: 1.1,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  p.cargo,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w400,
                    height: 1.1,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getIniciales(String nombre) {
    if (nombre.trim().isEmpty) return '?';
    final partes = nombre.trim().split(' ');
    if (partes.length >= 2) {
      return '${partes[0][0]}${partes[1][0]}'.toUpperCase();
    }
    return partes[0][0].toUpperCase();
  }

  Widget _buildBottomBar(BuildContext context, int selectedTurnaroundId) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () => _guardarCambios(selectedTurnaroundId),
              child: const Text('Guardar'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _guardarCambios(int selectedTurnaroundId) async {
  // 1. Obtener Sets con los IDs únicos actualmente seleccionados
  final currentPersonalIds = areasLocales
      .expand((a) => a.personal)
      .where((p) => p.selected)
      .map((p) => p.id)
      .toSet();

  final currentGerenteIds = areasLocales
      .expand((a) => a.gerentes)
      .where((p) => p.selected)
      .map((p) => p.id)
      .toSet();

  final currentSupervisorIds = areasLocales
      .expand((a) => a.supervisores)
      .where((p) => p.selected)
      .map((p) => p.id)
      .toSet();

  // 2. Calcular las diferencias contra las listas iniciales
  final personalNuevo =
      currentPersonalIds.difference(initialPersonalIds).toList();
  final personalEliminado =
      initialPersonalIds.difference(currentPersonalIds).toList();

  final personalgerenteNuevo =
      currentGerenteIds.difference(initialGerenteIds).toList();
  final personalgerenteEliminado =
      initialGerenteIds.difference(currentGerenteIds).toList();

  final personalsupervisorNuevo =
      currentSupervisorIds.difference(initialSupervisorIds).toList();
  final personalsupervisorEliminado =
      initialSupervisorIds.difference(currentSupervisorIds).toList();

  final estado = ref.read(
    departamentoPersonalProvider(selectedTurnaroundId),
  );

  // 3. Payload formateado para la API
  final body = {
    'id_trc': selectedTurnaroundId,
    'modificar': estado.departamentoPersonalResponse?.modificar ?? false,
    'personalEliminado': personalEliminado,
    'personalNuevo': personalNuevo,
    'personalapruebanEliminado': [],
    'personalapruebanNuevo': [],
    'personalfirmanEliminado': [],
    'personalfirmanNuevo': [],
    'personalgerenteEliminado': personalgerenteEliminado,
    'personalgerenteNuevo': personalgerenteNuevo,
    'personalsupervisorEliminado': personalsupervisorEliminado,
    'personalsupervisorNuevo': personalsupervisorNuevo,
  };

  final response = await ref
      .read(departamentoPersonalProvider(selectedTurnaroundId).notifier)
      .asignarPersonal(body);

  if (mounted) {
    CustomSnackbar.showResponseSnackbar(
      response.message,
      response.success,
      context,
      isFixed: true,
    );

    if (response.success) {
      Navigator.pop(context);
    }
  }
}

}

String _obtenerNombreFormateado(PersonalDepartamento p) {
  dynamic dynamicP = p;

  String apellido = '';
  String nombre = '';

  try {
    apellido = dynamicP.primerApellido ?? dynamicP.erApellido ?? dynamicP.apellido ?? '';
  } catch (_) {
    apellido = '';
  }

  try {
    nombre = dynamicP.primerNombre ?? dynamicP.erNombre ?? dynamicP.nombre ?? '';
  } catch (_) {
    nombre = '';
  }

  if (apellido.isNotEmpty && nombre.isNotEmpty) {
    return '$apellido, $nombre';
  } else if (nombre.isNotEmpty) {
    return nombre;
  }

  return p.nombre;
}