import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/shared.dart';
import '../../domain/domain.dart';
import '../providers/providers.dart';
// import '../widgets/widgets.dart';

class AsignarEquiposGseScreen extends ConsumerWidget {
  const AsignarEquiposGseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final turnaround = ref.watch(selectedTurnaroundProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Asignar Equipos GSE')),
      body: _AsignarEquiposGseView(),
    );
  }
}

class _AsignarEquiposGseView extends ConsumerStatefulWidget {
  const _AsignarEquiposGseView();

  @override
  ConsumerState<_AsignarEquiposGseView> createState() =>
      _AsignarEquiposGseViewState();
}

class _AsignarEquiposGseViewState
    extends ConsumerState<_AsignarEquiposGseView> {
  // Local categorias valiable list
  var categorias = [];
  // initstate
  @override
  void initState() {
    super.initState();
    // getCategoriasEquiposGse
     ref.read(categoriasEquiposGseProvider.notifier).getCategoriasEquiposGse();
  }

  @override
  Widget build(BuildContext context) {
    final categoriasAux =
        ref
            .watch(categoriasEquiposGseProvider)
            .categoriasEquiposGseResponse
            ?.categoriasEquiposGse ??
        [];
    // List<CategoriaEquiposGse> categorias = [...categoriasAux];
    // Local copy of categoriasAux
    List<CategoriaEquiposGse> categorias = ref.watch(
      newCategoriasEquiposGseProvider,
    );
    List<int> idsMaquinariasOldState = _getMaquinariasIds(categorias);

    categorias = [...categoriasAux];
    // var categorias =
    //     ref
    //         .watch(categoriasEquiposGseProvider)
    //         .categoriasEquiposGseResponse
    //         ?.categoriasEquiposGse ??
    //     [];
    // List builder
    // if (categorias.isEmpty) return Container();
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              // Background color
              itemCount: categorias.length,
              itemBuilder: (context, indexCategoria) {
                final categoria = categorias[indexCategoria];
                // return ListTile(title: Text(categoria?.categoriaNombre ?? ''));

                // if (categorias.isEmpty) return Container();
                return Card(
                  child: Column(
                    children: [
                      GestureDetector(
                        // OnTap dialog with fullscreen list view to select equipos
                        onTap: () async {
                          final values = await _showSelectedEquiposDialog(
                            context,
                            categoria,
                            ref,
                          );
                          if (values.isEmpty) return;
                          categoria.maquinarias.asMap().forEach((
                            index,
                            maquinaria,
                          ) {
                            maquinaria.selected = values[index];
                          });
                          // 
                          // set state of parent widget
                          // setStateCallback();
                          setState(() {});
                        },

                        //
                        // SelectEquiposGseDialog(categoria: categoria),
                        child: ListTile(
                          // background color
                          tileColor: Colors.white,
                          title: Text(categoria.categoriaNombre),
                          // subtitle: Text('${categoria.maquinarias.length} maquinarias'),
                          trailing: SizedBox(
                            // margin: const EdgeInsets.all(5),
                            // padding: const EdgeInsets.all(5),
                            height: 33,
                            width: 33,
                            child: ElevatedButton(
                              // disable if isLoading
                              onPressed: () async {},
                              style: ElevatedButton.styleFrom(
                                shape: CircleBorder(),
                                padding: EdgeInsets.all(2),
                                // iconSize: 40,
                                // fixedSize: const Size(10, 10),
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.primary, // <-- Button color
                                foregroundColor: Colors.red, // <-- Splash color
                              ),
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // List builder maquinarias
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: categoria.maquinarias.length,
                        itemBuilder: (context, index) {
                          final maquinaria = categoria.maquinarias[index];
                          if (!maquinaria.selected) return Container();
                          return Container(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 27,
                              ),
                              child: Text(
                                '${maquinaria.identificador} - ${maquinaria.modelo}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Action buttons at bottom
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
                    final idsMaquinariasNewState = _getMaquinariasIds(
                      categorias,
                    );
                    // final idsMaquinariasOldState = _getMaquinariasIds(
                    //   categoriasAux,
                    //   // ref
                    //   //         .watch(categoriasEquiposGseProvider)
                    //   //         .categoriasEquiposGseResponse
                    //   //         ?.categoriasEquiposGse ??
                    //   //     [],
                    // );

                    print(idsMaquinariasOldState);

                    print('idsMaquinariasNewState: $idsMaquinariasNewState');

                    //       print(
                    //         ref
                    // .watch(categoriasEquiposGseProvider)
                    // .categoriasEquiposGseResponse
                    // ?.categoriasEquiposGse ??
                    //       )
                    // Set Maquinarias nuevas y elimindas
                    final maquinariasNuevas = [];
                    final maquinariasEliminadas = [];

                    for (final maquinaria in idsMaquinariasNewState) {
                      if (!idsMaquinariasOldState.contains(maquinaria)) {
                        maquinariasNuevas.add(maquinaria);
                      }
                    }

                    for (final maquinaria in idsMaquinariasOldState) {
                      if (!idsMaquinariasNewState.contains(maquinaria)) {
                        maquinariasEliminadas.add(maquinaria);
                      }
                    }

                    print('Maquinarias nuevas: $maquinariasNuevas');
                    print('Maquinarias eliminadas: $maquinariasEliminadas');

                    final body = {
                      "id_trc": ref.read(selectedTurnaroundProvider)?.id,
                      "hora_inicio": ref
                          .read(selectedTurnaroundProvider)
                          ?.fkVuelo
                          .etaIn,
                      "hora_fin": ref
                          .read(selectedTurnaroundProvider)
                          ?.fkVuelo
                          .etdOut,
                      "fecha":
                          ref
                              .read(selectedTurnaroundProvider)
                              ?.fkVuelo
                              .etaFechaIn ??
                          ref
                              .read(selectedTurnaroundProvider)
                              ?.fkVuelo
                              .etdFechaOut,
                      "modificar": true,
                      "maquinariasNuevas": maquinariasNuevas,
                      "maquinariasEliminadas": maquinariasEliminadas,
                    };

                    print('body: $body');
                    // Call the repository method to Asignar Equipos GSE
                    final response = await ref
                        .read(categoriasEquiposGseProvider.notifier)
                        .asignarEquiposGse(body);

                    if (response.success) {
                      // Show success snackbar
                      // Show snackbar response
                      CustomSnackbar.showSuccessSnackbar(
                        response.message,
                        // ignore: use_build_context_synchronously
                        context,
                        isFixed: true,
                      );
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

  Future<List<bool>> _showSelectedEquiposDialog(
    BuildContext context,
    CategoriaEquiposGse categoria,
    WidgetRef ref,
  ) async {
    ref.read(selectedEquiposGseDialogProvider.notifier).state = [];
    final result = await showDialog(
      context: context,
      builder: (BuildContext context) {
         return StatefulBuilder(
        builder: (context, setState) {
          // StatefulBuilder to update the dialog
        return AlertDialog(
          title: Text(categoria.categoriaNombre),
          content: SizedBox(
            // Or specify a fixed height
            width: MediaQuery.of(
              context,
            ).size.width, // Allow the ListView to take max width

            child: ListView.builder(
              shrinkWrap: true, // Important for ListView in AlertDialog
              physics:
                  const ClampingScrollPhysics(), // Prevents unwanted bouncing
              itemCount: categoria
                  .maquinarias
                  .length, // Replace with your actual item count
              itemBuilder: (BuildContext context, int indexMaquinaria) {
                final maquinaria = categoria.maquinarias[indexMaquinaria];
                // Return ListTile with checkbox
                return CheckboxListTile(
                  title: Text(
                    '${maquinaria.identificador} - ${maquinaria.modelo}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  value: maquinaria.selected,
                  onChanged: (value) {
                    // Change selected value
                    maquinaria.selected = value!;
                    setState(() {});
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Asignar'),
              onPressed: () {
                // getting previous selected personal values, true and false
                final List<bool> selectedEquipos = categoria.maquinarias
                    // .where((personal) => personal.selected)
                    .map((maquinaria) => maquinaria.selected)
                    .toList();
                // final List<bool> selectedPersonal = personalList
                //     .where((personal) => personal.selected)
                //     .map((personal) => personal.selected)
                //     .toList();

                print("selected personal: $selectedEquipos");
                ref.read(selectedEquiposGseDialogProvider.notifier).state =
                    selectedEquipos;

                // return selected personal
                Navigator.of(context).pop(selectedEquipos);
                // return selectedPersonal;
              },
            ),
          ],
        );
        },
      );
      },
    );

    print("result: $result");
    return result ?? [];
  }
  // Future<dynamic> _showSelectedEquiposDialog(
  //   BuildContext context,
  //   CategoriaEquiposGse categoria,
  // ) {
  //   return showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text(categoria.categoriaNombre),
  //         content: SizedBox(
  //           // Or specify a fixed height
  //           width: MediaQuery.of(
  //             context,
  //           ).size.width, // Allow the ListView to take max width

  //           child: ListView.builder(
  //             shrinkWrap: true, // Important for ListView in AlertDialog
  //             physics:
  //                 const ClampingScrollPhysics(), // Prevents unwanted bouncing
  //             itemCount: categoria
  //                 .maquinarias
  //                 .length, // Replace with your actual item count
  //             itemBuilder: (BuildContext context, int indexMaquinaria) {
  //               final maquinaria = categoria.maquinarias[indexMaquinaria];
  //               // Return ListTile with checkbox
  //               return CheckboxListTile(
  //                 title: Text(
  //                   '${maquinaria.identificador} - ${maquinaria.modelo}',
  //                   style: const TextStyle(
  //                     fontSize: 16,
  //                     fontWeight: FontWeight.normal,
  //                   ),
  //                 ),
  //                 value: maquinaria.selected,
  //                 onChanged: (value) {
  //                   // Change selected value
  //                   maquinaria.selected = value!;
  //                   setState(() {});
  //                 },
  //               );

  //             },
  //           ),
  //         ),
  //         actions: [
  //           TextButton(
  //             child: const Text('Close'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}

// _getMaquinariasIds(List<Maquinaria> maquinarias) => maquinarias.map((m) => m.id).toList();
List<int> _getMaquinariasIds(List<CategoriaEquiposGse> categorias) {
  final List<int> ids = [];
  for (final categoria in categorias) {
    for (final maquinaria in categoria.maquinarias) {
      if (maquinaria.selected) {
        ids.add(maquinaria.id);
      }
    }
  }
  return ids;
}

Widget setupAlertDialoadContainer() {
  return SizedBox(
    // height: 300.0, // Change as per your requirement
    // width: 300.0, // Change as per your requirement
    child: ListView.builder(
      shrinkWrap: true,
      itemCount: 5,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(title: Text('Gujarat, India'));
      },
    ),
  );
}
