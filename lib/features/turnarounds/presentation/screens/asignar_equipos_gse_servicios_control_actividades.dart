import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/shared.dart';
import '../../domain/entities/entities.dart';
import '../providers/providers.dart';

class AsignarEquiposGseServiciosControlActividades extends ConsumerWidget {
  final AsignarEquiposDialogData data;

  const AsignarEquiposGseServiciosControlActividades(this.data, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('Asignar Equipos GSE')),
      body: _AsignarEquiposGseView(data: data), // Pasar la data
    );
  }
}

List<int> _setMaquinariasIds(List<CategoriaEquiposGse> categorias) {
  List<int> idsMaquinarias = [];
  for (final categoria in categorias) {
    for (final maquinaria in categoria.maquinarias) {
      if (maquinaria.selected) {
        idsMaquinarias.add(maquinaria.id);
      }
    }
  }
  return idsMaquinarias;
  // idsMaquinarias = this.data.maquinarias.map( (m: any) => m.maquinaria_id )
}

List<int> _setMaquinariasSelectedIds(List<CategoriaEquiposGse> categorias) {
  List<int> idsMaquinarias = [];
  for (final categoria in categorias) {
    for (final maquinaria in categoria.maquinarias) {
      if (maquinaria.selectedTask!) {
        idsMaquinarias.add(maquinaria.id);
      }
    }
  }
  return idsMaquinarias;
  // idsMaquinarias = this.data.maquinarias.map( (m: any) => m.maquinaria_id )
}

List<int> _setSelectedTaskMaquinariasIds(
  List<CategoriaEquiposGse> categorias,
  int indexTar,
  int indexAct,
  int indexDep,
) {
  List<int> idsMaquinarias = [];
  for (final categoria in categorias) {
    for (final maquinaria in categoria.maquinarias) {
      if (maquinaria.selected) {
        idsMaquinarias.add(maquinaria.id);
      }
    }
  }
  return idsMaquinarias;
  // idsMaquinarias = this.data.maquinarias.map( (m: any) => m.maquinaria_id )
}

class _AsignarEquiposGseView extends ConsumerStatefulWidget {
  AsignarEquiposDialogData data;
  _AsignarEquiposGseView({required this.data});

  @override
  ConsumerState<_AsignarEquiposGseView> createState() =>
      _AsignarEquiposGseViewState();
}

class _AsignarEquiposGseViewState
    extends ConsumerState<_AsignarEquiposGseView> {
  // Local categorias valiable list
  List<CategoriaEquiposGse> categorias = [];
  List<CategoriaEquiposGse> categoriasAux = [];
  List<int> idsMaquinarias = [];
  List<int> selectedMaquinariasTaskIds = [];
  List<dynamic> selectedMaquinariasTask = [];

  List<int> idsMaquinariasOld = [];
  // List<int> idsMaquinarias = [];

  // initstate
  @override
  void initState() {
    super.initState();
    // getCategoriasEquiposGse
    // ref.read(categoriasEquiposGseProvider.notifier).getCategoriasEquiposGse();

    // Maquinarias asignadas a servicios adicionales
    // El servico adicional seleccionado
    // turnaround
    // tipo de asignacion

    AsignarEquiposDialogData data = ref
        .read(asignarEquiposDialogDataProvider.notifier)
        .state;

    categoriasAux =
        ref.read(categoriasEquiposGseProvider).categoriasEquiposGseResponse !=
            null
        ? ref
              .read(categoriasEquiposGseProvider)
              .categoriasEquiposGseResponse!
              .categoriasEquiposGse
        : [];

    List<int> idsMaquinarias = _setMaquinariasIds(categoriasAux);

    // TurnaroundMain turnaround = ref
    //     .read(selectedTurnaroundProvider.notifier)
    //     .state!;

    // selectedMaquinariasTaskProvider
    // selectedMaquinariasTask = ref
    //     .read(selectedMaquinariasTaskProvider.notifier)
    //     .state;
    // selectedMaquinariasTaskIds = selectedMaquinariasTask
    //     .map((maquinaria) => maquinaria['maquinaria_id'])
    //     .cast<int>()
    //     .toList();

    // TODO: condicional para tomar servicios especiales
    selectedMaquinariasTaskIds = data.servicioAdicional!.maquinaria
        .map((maquinaria) => maquinaria.maquinariaId)
        .cast<int>()
        .toList();

    categorias = [];
    for (final categoria
        in ref
                    .read(categoriasEquiposGseProvider)
                    .categoriasEquiposGseResponse !=
                null
            ? ref
                  .read(categoriasEquiposGseProvider)
                  .categoriasEquiposGseResponse!
                  .categoriasEquiposGse
            : []) {
      List<MaquinariaCategoriaEquipos> maquinarias = [];
      for (final maquinaria in categoria.maquinarias) {
        if (idsMaquinarias.contains(maquinaria.id)) {
          maquinaria.selectedTask = selectedMaquinariasTaskIds.contains(
            maquinaria.id,
          );
          maquinarias.add(maquinaria);
        }
      }
      if (maquinarias.isEmpty) continue;
      categorias.add(
        CategoriaEquiposGse(
          idCategoria: categoria.idCategoria,
          cantidadMaquinaria: categoria.cantidadMaquinaria,
          categoriaNombre: categoria.categoriaNombre,
          maquinarias: maquinarias,
        ),
      );
    }

    // Set idsMaquinariasOld
    idsMaquinariasOld = _setMaquinariasSelectedIds(categoriasAux);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // *************************************************************************************************************************************************
    // *************************************************************************************************************************************************
    // *************************************************************************************************************************************************
    // categoriasAux =
    //     ref.watch(categoriasEquiposGseProvider).categoriasEquiposGseResponse !=
    //         null
    //     ? ref
    //           .watch(categoriasEquiposGseProvider)
    //           .categoriasEquiposGseResponse!
    //           .categoriasEquiposGse
    //     : [];
    // List<int> idsMaquinarias = _setMaquinariasIds(categoriasAux);

    // // TurnaroundMain turnaround = ref
    // //     .watch(selectedTurnaroundProvider.notifier)
    // //     .state!;

    // // selectedMaquinariasTaskProvider
    // List<dynamic> selectedMaquinariasTask = ref
    //     .watch(selectedMaquinariasTaskProvider.notifier)
    //     .state;
    // List<int>? selectedMaquinariasTaskIds = selectedMaquinariasTask
    //     .map((maquinaria) => maquinaria['maquinaria_id'])
    //     .cast<int>()
    //     .toList();

    // categorias = [];
    // for (final categoria
    //     in ref
    //                 .watch(categoriasEquiposGseProvider)
    //                 .categoriasEquiposGseResponse !=
    //             null
    //         ? ref
    //               .watch(categoriasEquiposGseProvider)
    //               .categoriasEquiposGseResponse!
    //               .categoriasEquiposGse
    //         : []) {
    //   List<MaquinariaCategoriaEquipos> maquinarias = [];
    //   for (final maquinaria in categoria.maquinarias) {
    //     if (idsMaquinarias.contains(maquinaria.id)) {
    //       maquinaria.selectedTask = selectedMaquinariasTaskIds.contains(
    //         maquinaria.id,
    //       );
    //       maquinarias.add(maquinaria);
    //     }
    //   }
    //   if (maquinarias.isEmpty) continue;
    //   categorias.add(
    //     CategoriaEquiposGse(
    //       idCategoria: categoria.idCategoria,
    //       cantidadMaquinaria: categoria.cantidadMaquinaria,
    //       categoriaNombre: categoria.categoriaNombre,
    //       maquinarias: maquinarias,
    //     ),
    //   );
    // }

    // *************************************************************************************************************************************************
    // *************************************************************************************************************************************************
    // *************************************************************************************************************************************************
    // *************************************************************************************************************************************************

    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              // Background color
              shrinkWrap: true,
              itemCount: categorias.length,
              itemBuilder: (context, indexCategoria) {
                final categoria = categorias[indexCategoria];
                return Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        // leading: Icon(Icons.album),
                        title: Text(
                          categoria.categoriaNombre,
                          style: theme.textTheme.bodyLarge,
                        ),
                        // subtitle: Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
                        // trailing: Icon(Icons.more_vert),
                        tileColor: Colors.white,
                        dense: true,
                      ),
      
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: categoria.maquinarias.length,
                        itemBuilder: (context, indexMaquinaria) {
                          final maquinaria =
                              categoria.maquinarias[indexMaquinaria];
                          return CheckboxListTile(
                            tileColor: Colors.white,
                            title: Text(
                              '${maquinaria.identificador} - ${maquinaria.modelo}',
                              style: theme.textTheme.bodyMedium,
                            ),
                            value: maquinaria.selectedTask,
                            onChanged: (value) {
                              print(value);
      
                              // ref
                              //     .read(selectedMaquinariasTaskProvider
                              //         .notifier)
      
                              // maquinaria.selectedTask = value;
                              // ref
                              //     .read(
                              //       selectedMaquinariasTaskProvider.notifier,
                              //     )
                              //     .addMaquinaria(maquinaria);
                              setState(() {
                                // ref
                                //         .read(categoriasEquiposGseProvider)
                                //         .categoriasEquiposGseResponse
                                //         ?.categoriasEquiposGse[indexCategoria]
                                //         .maquinarias[indexMaquinaria]
                                //         .selectedTask =
                                //     value;
      
                                print('value: $value');
                                print(
                                  ref
                                      .read(
                                        selectedMaquinariasTaskProvider.notifier,
                                      )
                                      .state,
                                );
                                print(
                                  categorias[indexCategoria]
                                      .maquinarias[indexMaquinaria]
                                      .selectedTask,
                                );
                                print(maquinaria.id);
                                // actualizar provider
                                // ref
                                //     .read(selectedMaquinariasTaskProvider
                                //         .notifier).state = ref
                                //     .read(selectedMaquinariasTaskProvider
                                //         .notifier)
                                //     .state
                                //     // map and change value
                                //     .map((maquinaria) {
                                //       if (maquinaria['maquinaria_id'] ==
                                //           maquinaria.id) {
                                //         return {
                                //           'maquinaria_id': maquinaria.id,
                                //           'selectedTask': value,
                                //         };
                                //       }
                                //       return maquinaria;
                                //     });
                                categorias[indexCategoria]
                                        .maquinarias[indexMaquinaria]
                                        .selectedTask =
                                    value;
                                maquinaria.selectedTask = value;
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
          ),
      
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Cancel button
      
                // Save button
                FilledButton(
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
                const SizedBox(width: 12),
                CustomFilledButton(
                  text: 'Asignar',
                  // buttonColor: Colors.green,
                  onPressed: () async {
                    // get maquinarias ids with selected task in true
                    final idsMaquinariasNew = _setMaquinariasSelectedIds(
                      categorias,
                    );
      
                    final maquinariasNuevas = [];
                    final maquinariasEliminadas = [];
      
                    for (final maquinaria in idsMaquinariasNew) {
                      if (!idsMaquinariasOld.contains(maquinaria)) {
                        maquinariasNuevas.add(maquinaria);
                      }
                    }
      
                    // print('maquinariasNuevas: $maquinariasNuevas');
      
                    for (final maquinaria in idsMaquinariasOld) {
                      if (!idsMaquinariasNew.contains(maquinaria)) {
                        maquinariasEliminadas.add(maquinaria);
                      }
                    }
      
                    // print('maquinariasEliminadas: $maquinariasEliminadas');
      
                    // body
                    final body = {
                      "id": ref
                          .read(asignarEquiposDialogDataProvider.notifier)
                          .state
                          .servicioAdicional
                          ?.id,
                      "ids_nuevos": maquinariasNuevas,
                      "ids_eliminados": maquinariasEliminadas,
                    };
      
                    final response = await ref
                        .read(categoriasEquiposGseProvider.notifier)
                        .asignarMaquinariasSerivicioAdicional(body);
      
                    // AsignarEquiposDialogData data = ref
                    //         .read(asignarEquiposDialogDataProvider.notifier)
                    //         .state;
                    if (response.success) {
                      // Show success snackbar
                      // Show snackbar response
                      CustomSnackbar.showSuccessSnackbar(
                        response.message,
                        // ignore: use_build_context_synchronously
                        context,
                        isFixed: true,
                      );
      
                      // get control de actividades
                      await ref
                          .read(
                            controlActividadesProvider(
                              widget.data.turnaround!.id,
                            ).notifier,
                          )
                          .getControlDeActividadesByTrcId();
                      // ref.watch(
                      //   controlActividadesProvider(
                      //     ref.read(selectedTurnaroundProvider)!.id,
                      //   ),
                      // );
                      // ref
                      //     .read(
                      //       controlActividadesProvider(
                      //         ref.read(selectedTurnaroundProvider)!.id,
                      //       ),
                      //     )
                      //     .getControlDeActividadesByTrcId();
                      // ref
                      // .read(controlActividadesProvider.notifier).
                      // .read(controlActividadesProvider.notifier)
                      // .getControlDeActividadesByTrcId();
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pop();
                    } else {
                      // Show error snackbarresponse
                      CustomSnackbar.showErrorSnackbar(
                        response.message,
                        // ignore: use_build_context_synchronously
                        context,
                        isFixed: true,
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
