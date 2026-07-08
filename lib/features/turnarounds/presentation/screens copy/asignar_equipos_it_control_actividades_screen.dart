import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'package:go_router/go_router.dart';

import '../../../shared/shared.dart';
// import '../../domain/entities/entities.dart';
import '../providers/providers.dart';

class AsignarEquiposItControlActividadesScreen extends StatelessWidget {
  const AsignarEquiposItControlActividadesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Asignar Equipos IT Limpieza')),
      body: const Center(child: _AsignarEquiposView()),
    );
  }
}

List<int> idsSelectedEquipos() {
  return [];
}

class _AsignarEquiposView extends ConsumerStatefulWidget {
  const _AsignarEquiposView();

  @override
  ConsumerState<_AsignarEquiposView> createState() =>
      _AsignarEquiposViewState();
}

class _AsignarEquiposViewState extends ConsumerState<_AsignarEquiposView> {
  CategoriasEquiposItLimpiezaState equiposResponse =
      CategoriasEquiposItLimpiezaState();
  late List<int> idsequiposOld = [];

  @override
  void initState() {
    super.initState();

    equiposResponse = ref.read(categoriasEquiposItLimpiezaProvider);
    // List<CategoriaEquiposItLimpieza> categorias = equiposResponse.equiposIt;
    // selectedEquiposIdsProvider
    // Set selected equipos from provider
    for (var categoria in equiposResponse.equiposIt) {
      for (var equipo in categoria.equipos) {
        final isSelected = ref
            .read(selectedEquiposIdsProvider)
            .contains(equipo.id);
        if (isSelected) {
          equipo.isSelected = true;
          idsequiposOld = [...idsequiposOld, equipo.id];
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    // CategoriasEquiposItLimpiezaState equiposResponse = ref.watch(
    //   categoriasEquiposItLimpiezaProvider,
    // );
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: equiposResponse.equiposIt.length,
              itemBuilder: (context, index) {
                final categoria = equiposResponse.equiposIt[index];
                return Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        tileColor: Colors.white,
                        dense: true,
                        title: Text(
                          categoria.nombreCategoria,
                          style: theme.textTheme.bodyLarge,
                        ),
                      ),

                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: categoria.equipos.length,
                        itemBuilder: (context, index) {
                          final eq = categoria.equipos[index];
                          // final isSelected = ref
                          //     .watch(selectedEquiposTaskProvider)
                          //     .contains(eq.id);
                          return CheckboxListTile(
                            tileColor: Colors.white,
                            title: Text(
                              '${eq.identificador} - ${eq.modelo}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            value: eq.isSelected,
                            onChanged: (value) {
                              setState(() {
                                eq.isSelected = value ?? false;
                                if (eq.isSelected) {
                                  // add to selected
                                  ref
                                      .read(selectedEquiposIdsProvider.notifier)
                                      .update((state) => [...state, eq.id]);
                                } else {
                                  // remove from selected
                                  ref
                                      .read(selectedEquiposIdsProvider.notifier)
                                      .update((state) =>
                                          state.where((id) => id != eq.id).toList());
                                }
                              });
                            },
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),

            // ...equiposResponse.equiposIt.map(
            //   (e) => Column(
            //     children: [
            //       ListTile(
            //         title: Text(e.nombreCategoria),
            //         // listado de equipos
            //       ),
            //       ...e.equipos.map(
            //         (eq) =>
            //         ListTile(
            //           title: Text('${eq.identificador} - ${eq.modelo}'),
            //           subtitle: Text('Selected: ${eq.isSelected}'),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ),
        
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Cancel button
      
                // Save button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      // primary
                      backgroundColor: Colors.grey,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Salir',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
      
                CustomFilledButton(
                  text: 'Asignar',
                  // buttonColor: Colors.green,
                  onPressed: () async {
                    print('Asignar equipos IT limpieza');
                    print('ids equipos old: $idsequiposOld');
                    // // get maquinarias ids with selected task in true
                    
                    // ids nuevos
                    final idsEquiposNew = ref.read(selectedEquiposIdsProvider);
                    print('ids equipos new: $idsEquiposNew');
                    
                    // ids equipos eliminados
                    final equiposEliminados = [];
                    for (final equipo in idsequiposOld) {
                      if (!idsEquiposNew.contains(equipo)) {
                        equiposEliminados.add(equipo);
                      }
                    }
                    print('ids equipos eliminados: $equiposEliminados');
                    // ids equipos nuevos
                    final equiposNuevos = [];
                    for (final equipo in idsEquiposNew) {
                      if (!idsequiposOld.contains(equipo)) {
                        equiposNuevos.add(equipo);
                      }
                    }
                    print('ids equipos nuevos: $equiposNuevos');
                    
                    final body = {
                      "id": ref.read(selectedTaskProvider)['tareaId']!,
                      "equiposNuevos": equiposNuevos,
                      "equiposEliminados": equiposEliminados,
                    };
                    print('body: $body');
                    final response = await ref
                        .read(categoriasEquiposItLimpiezaProvider.notifier)
                        .asignarEquiposItLimpiezaTareas(body);

                    if (response.success) {
                      // Show success snackbar

                      CustomSnackbar.showSuccessSnackbar(
                        response.message,
                        // ignore: use_build_context_synchronously
                        context,
                        isFixed: true,
                      );
      
                      // get control de actividades from api
                      ref.read(controlActividadesProvider(ref.read(selectedTurnaroundProvider)!.id,).notifier).getControlDeActividadesByTrcId();
                      // ref.watch(
                      //   controlActividadesProvider(
                      //     ref.read(selectedTurnaroundProvider)!.id,
                      //   ),
                      // );
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pop();
                    } else {
                      // Show error snackbarresponse
                      CustomSnackbar.showErrorSnackbar(
                        response.message,
                        // ignore: use_build_context_synchronously
                        context,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        
        ],
      ),
    );
  }
}
