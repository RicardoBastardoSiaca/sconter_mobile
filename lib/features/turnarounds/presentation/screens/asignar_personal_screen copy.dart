import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scounter_mobile/features/turnarounds/presentation/providers/providers.dart';

import '../../../shared/shared.dart';
import '../../domain/domain.dart';

class AsignarPersonalScreen extends StatelessWidget {
  const AsignarPersonalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Asignar Personal')),
      body: _AsignarPersonalView(),
    );
  }
}

List<int> _getPersonalIds(List<DepartamentoPersonal> departamento) {
  return departamento
      .expand((dept) => dept.personal)
      .where((personal) => personal.selected)
      .map((personal) => personal.id)
      .toList();
}

class _AsignarPersonalView extends ConsumerStatefulWidget {
  const _AsignarPersonalView();

  @override
  ConsumerState<_AsignarPersonalView> createState() =>
      _AsignarPersonalViewState();
}

class _AsignarPersonalViewState extends ConsumerState<_AsignarPersonalView> {
  DepartamentoPersonalState? departamentosPersona;
  late DepartamentoPersonalState departamentosPersonaAux;

  // Gerentes
  List<DepartamentoPersonal> gerentes = [];
  List<DepartamentoPersonal> gerentesAux = [];
  List<int> idsGerentes = [];
  List<int> idsGerentesOld = [];

  // Supervisores
  List<DepartamentoPersonal> supervisores = [];
  List<DepartamentoPersonal> supervisoresAux = [];
  List<int> idsSupervisores = [];
  List<int> idsSupervisoresOld = [];

  // Personal Firma
  // List<DepartamentoPersonal> personalFirma = [];
  // List<DepartamentoPersonal> personalFirmaAux = [];
  // List<int> idsPersonalFirma = [];
  // List<int> idsPersonalFirmaOld = [];

  // Personal Aprueban
  // List<DepartamentoPersonal> personalAprueban = [];
  // List<DepartamentoPersonal> personalApruebanAux = [];
  // List<int> idsPersonalAprueban = [];
  // List<int> idsPersonalApruebanOld = [];

  // Personal
  List<DepartamentoPersonal> personal = [];
  List<DepartamentoPersonal> personalAux = [];
  List<int> idsPersonal = [];
  List<int> idsPersonalOld = [];

  // set state callback
  void _setStateCallback() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    var selectedTurnaroundId = ref.read(selectedTurnaroundProvider)!.id;
    // get departamentos con personal
    departamentosPersona = ref.read(
      departamentoPersonalProvider(selectedTurnaroundId),
    );

    // Gerentes
    gerentesAux =
        departamentosPersona?.departamentoPersonalResponse?.gerenteTurno ?? [];

    // idsGerentes = _getPersonalIds(gerentesAux);
    idsGerentesOld = _getPersonalIds(gerentesAux);

    gerentes = [];
    for (final departamento in gerentesAux) {
      List<PersonalDepartamento> personalAux = [];
      for (final personal in departamento.personal) {
        personal.selected = idsGerentesOld.contains(personal.id);
        personalAux.add(personal.copyWith());
      }
      gerentes.add(
        departamento.copyWith(
          personal: personalAux,
          nombreDepartamento: departamento.nombreDepartamento,
        ),
      );
    }

    // Supervisores
    supervisoresAux =
        departamentosPersona?.departamentoPersonalResponse?.supervisor ?? [];

    // idsSupervisores = _getPersonalIds(supervisoresAux);
    idsSupervisoresOld = _getPersonalIds(supervisoresAux);

    supervisores = [];
    for (final departamento in supervisoresAux) {
      List<PersonalDepartamento> personalAux = [];
      for (final personal in departamento.personal) {
        personal.selected = idsSupervisoresOld.contains(personal.id);
        personalAux.add(personal);
      }
      supervisores.add(
        departamento.copyWith(
          personal: personalAux,
          nombreDepartamento: departamento.nombreDepartamento,
        ),
      );
    }

    // // Personal Firma
    // personalFirmaAux =
    //     departamentosPersona
    //         ?.departamentoPersonalResponse
    //         ?.departamentosFirma ??
    //     [];

    // // idsPersonalFirma = _getPersonalIds(personalFirmaAux);
    // idsPersonalFirmaOld = _getPersonalIds(personalFirmaAux);

    // personalFirma = [];
    // for (final departamento in personalFirmaAux) {
    //   List<PersonalDepartamento> personalAux = [];
    //   for (final personal in departamento.personal) {
    //     personal.selected = idsPersonalFirmaOld.contains(personal.id);
    //     personalAux.add(personal);
    //   }
    //   personalFirma.add(
    //     departamento.copyWith(
    //       personal: personalAux,
    //       nombreDepartamento: departamento.nombreDepartamento,
    //     ),
    //   );
    // }

    // // Personal Aprueban
    // personalApruebanAux =
    //     departamentosPersona
    //         ?.departamentoPersonalResponse
    //         ?.departamentosCerrar ??
    //     [];

    // // idsPersonalAprueban = _getPersonalIds(personalApruebanAux);
    // idsPersonalApruebanOld = _getPersonalIds(personalApruebanAux);

    // personalAprueban = [];
    // for (final departamento in personalApruebanAux) {
    //   List<PersonalDepartamento> personalAux = [];
    //   for (final personal in departamento.personal) {
    //     personal.selected = idsPersonalApruebanOld.contains(personal.id);
    //     personalAux.add(personal);
    //   }
    //   personalAprueban.add(
    //     departamento.copyWith(
    //       personal: personalAux,
    //       nombreDepartamento: departamento.nombreDepartamento,
    //     ),
    //   );
    // }

    // Personal
    personalAux =
        departamentosPersona
            ?.departamentoPersonalResponse
            ?.departamentosPersonal ??
        [];

    // idsPersonal = _getPersonalIds(personalAux);
    idsPersonalOld = _getPersonalIds(personalAux);

    personal = [];
    for (final departamento in personalAux) {
      List<PersonalDepartamento> personalAux = [];
      for (final personal in departamento.personal) {
        personal.selected = idsPersonalOld.contains(personal.id);
        personalAux.add(personal);
      }
      personal.add(
        departamento.copyWith(
          personal: personalAux,
          nombreDepartamento: departamento.nombreDepartamento,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedTurnaroundId = ref.watch(selectedTurnaroundProvider)!.id;

    // departamentosPersona = ref.watch(
    //   departamentoPersonalProvider(selectedTurnaroundId),
    // );

    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: departamentosPersona!.isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child:
                        departamentosPersona?.departamentoPersonalResponse ==
                            null
                        ?
                          // Circular loading
                          Center(child: CircularProgressIndicator())
                        : Column(
                            children: [
                              // Gerentes de turno
                              _DepartamentoView(
                                // gerentes,
                                departamentos:
                                    departamentosPersona
                                        ?.departamentoPersonalResponse
                                        ?.gerenteTurno ??
                                    [],
                                setStateCallback: _setStateCallback,
                                titulo: 'Gerentes de Turno',
                              ),

                              // Supervisor
                              _DepartamentoView(
                                departamentos:
                                    departamentosPersona
                                        ?.departamentoPersonalResponse
                                        ?.supervisor ??
                                    [],
                                setStateCallback: _setStateCallback,
                                titulo: "Supervisores,",
                              ),

                              // Personal (Firman el TRC)
                              // _DepartamentoView(
                              //   departamentos:
                              //       departamentosPersona
                              //           ?.departamentoPersonalResponse
                              //           ?.departamentosFirma ??
                              //       [],
                              //   setStateCallback: _setStateCallback,
                              //   titulo: 'Personal (Firman el TRC)',
                              // ),

                              // // Personal (Aprueban el TRC)
                              // _DepartamentoView(
                              //   departamentos:
                              //       departamentosPersona
                              //           ?.departamentoPersonalResponse
                              //           ?.departamentosCerrar ??
                              //       [],
                              //   setStateCallback: _setStateCallback,
                              //   titulo: 'Personal (Aprueban el TRC)',
                              // ),

                              // Personal
                              _DepartamentoView(
                                departamentos:
                                    departamentosPersona
                                        ?.departamentoPersonalResponse
                                        ?.departamentosPersonal ??
                                    [],
                                setStateCallback: _setStateCallback,
                                titulo: 'Personal',
                              ),
                            ],
                          ),
                  ),
          ),

          // Expanded(
          //   child: _PersonalApruebanTRC(gerentes),
          // ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Cancelar',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      // Gerente de turno
                      idsGerentes = _getPersonalIds(
                        departamentosPersona
                                ?.departamentoPersonalResponse!
                                .gerenteTurno ??
                            [],
                      );
                      print('idsGerentes: $idsGerentes');
                      print('idsGerentesOld: $idsGerentesOld');

                      final personalgerenteNuevo = idsGerentes
                          .where((id) => !idsGerentesOld.contains(id))
                          .toList();
                      final personalgerenteEliminado = idsGerentesOld
                          .where((id) => !idsGerentes.contains(id))
                          .toList();
                      print('personalgerenteNuevo: $personalgerenteNuevo');
                      print(
                        'personalgerenteEliminado: $personalgerenteEliminado',
                      );

                      // Supervisor
                      idsSupervisores = _getPersonalIds(
                        departamentosPersona
                                ?.departamentoPersonalResponse!
                                .supervisor ??
                            [],
                      );
                      print('idsSupervisores: $idsSupervisores');
                      print('idsSupervisoresOld: $idsSupervisoresOld');

                      final personalsupervisorNuevo = idsSupervisores
                          .where((id) => !idsSupervisoresOld.contains(id))
                          .toList();
                      final personalsupervisorEliminado = idsSupervisoresOld
                          .where((id) => !idsSupervisores.contains(id))
                          .toList();
                      print(
                        'personalsupervisorNuevo: $personalsupervisorNuevo',
                      );
                      print(
                        'personalsupervisorEliminado: $personalsupervisorEliminado',
                      );

                      // // Personal (Firman el TRC)
                      // idsPersonalFirma = _getPersonalIds(
                      //   departamentosPersona
                      //           ?.departamentoPersonalResponse!
                      //           .departamentosFirma ??
                      //       [],
                      // );
                      // print('idsPersonalFirma: $idsPersonalFirma');
                      // print('idsPersonalFirmaOld: $idsPersonalFirmaOld');

                      // final personalfirmaNuevo = idsPersonalFirma
                      //     .where((id) => !idsPersonalFirmaOld.contains(id))
                      //     .toList();
                      // final personalfirmaEliminado = idsPersonalFirmaOld
                      //     .where((id) => !idsPersonalFirma.contains(id))
                      //     .toList();
                      // print('personalfirmaNuevo: $personalfirmaNuevo');
                      // print('personalfirmaEliminado: $personalfirmaEliminado');

                      // // Personal (Aprueban el TRC)
                      // idsPersonalFirma = _getPersonalIds(
                      //   departamentosPersona
                      //           ?.departamentoPersonalResponse!
                      //           .departamentosCerrar ??
                      //       [],
                      // );
                      // print('idsPersonalFirma: $idsPersonalFirma');
                      // print('idsPersonalFirmaOld: $idsPersonalFirmaOld');

                      // final personalcerrarNuevo = idsPersonalFirma
                      //     .where((id) => !idsPersonalFirmaOld.contains(id))
                      //     .toList();
                      // final personalcerrarEliminado = idsPersonalFirmaOld
                      //     .where((id) => !idsPersonalFirma.contains(id))
                      //     .toList();
                      // print('personalcerrarNuevo: $personalcerrarNuevo');
                      // print(
                      //   'personalcerrarEliminado: $personalcerrarEliminado',
                      // );

                      // Personal
                      idsPersonal = _getPersonalIds(
                        departamentosPersona
                                ?.departamentoPersonalResponse!
                                .departamentosPersonal ??
                            [],
                      );
                      print('idsPersonal: $idsPersonal');
                      print('idsPersonalOld: $idsPersonalOld');

                      final personalNuevo = idsPersonal
                          .where((id) => !idsPersonalOld.contains(id))
                          .toList();
                      final personalEliminado = idsPersonalOld
                          .where((id) => !idsPersonal.contains(id))
                          .toList();
                      print('personalNuevo: $personalNuevo');
                      print('personalEliminado: $personalEliminado');

                      // print('personalgerenteNuevo: $personalgerenteNuevo');
                      // print('personalgerenteEliminado: $personalgerenteEliminado');
                      // print('personalsupervisorNuevo: $personalsupervisorNuevo');
                      // print('personalsupervisorEliminado: $personalsupervisorEliminado');
                      // print('personalfirmaNuevo: $personalfirmaNuevo');
                      // print('personalfirmaEliminado: $personalfirmaEliminado');
                      // print('personalcerrarNuevo: $personalcerrarNuevo');
                      // print('personalcerrarEliminado: $personalcerrarEliminado');
                      final body = {
                        'id_trc': selectedTurnaroundId,
                        'modificar': ref
                            .read(
                              departamentoPersonalProvider(
                                selectedTurnaroundId,
                              ),
                            )
                            .departamentoPersonalResponse!
                            .modificar,
                        'personalNuevo': personalNuevo,
                        'personalEliminado': personalEliminado,
                        // 'personalapruebanNuevo': personalcerrarNuevo,
                        // 'personalapruebanEliminado': personalcerrarEliminado,
                        // 'personalfirmanNuevo': personalfirmaNuevo,
                        // 'personalfirmanEliminado': personalfirmaEliminado,
                        'personalgerenteNuevo': personalgerenteNuevo,
                        'personalgerenteEliminado': personalgerenteEliminado,
                        'personalsupervisorNuevo': personalsupervisorNuevo,
                        'personalsupervisorEliminado':
                            personalsupervisorEliminado,
                      };

                      print('body: $body');

                      // asignar personal
                      final response = await ref
                          .read(
                            departamentoPersonalProvider(
                              selectedTurnaroundId,
                            ).notifier,
                          )
                          .asignarPersonal(body);

                        CustomSnackbar.showResponseSnackbar(
                          response.message,
                          response.success,
                          context,
                          isFixed: true
                        );

                      if (response.success) {
                        // close
                        Navigator.pop(context);
                      }
                        
                      // if (response.success) {
                      //   // snackbar response
                      // } else {
                        // Optionally, you can show a snackbar or a dialog
                        // return SnackbarResponse(
                        //   message: 'Error al asignar personal.',
                        //   success: false,
                        // );
                      // }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Guardar',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Gerente de turno
class _DepartamentoView extends ConsumerWidget {
  final Function() setStateCallback;
  final List<DepartamentoPersonal> departamentos;
  final String titulo;

  const _DepartamentoView({
    required this.departamentos,
    required this.setStateCallback,
    required this.titulo,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(titulo, style: theme.textTheme.titleMedium),
        // List of Gerente de Turno
        ...departamentos.map((departamento) {
          return Column(
            children: [
              ListTile(
                tileColor: Colors.white,
                title: Text(
                  departamento.nombreDepartamento,
                  style: theme.textTheme.bodyLarge,
                ),
                trailing: SizedBox(
                  height: 33,
                  width: 33,
                  child: ElevatedButton(
                    // disable if isLoading
                    onPressed: () async {
                      // Mismo codigo que en el list tile
                      final values = await _showSelectPersonalDialog(
                        context,
                        departamento.personal,
                        departamento.nombreDepartamento,
                        titulo,
                        ref,
                      );
                      if (values.isEmpty) return;
                      departamento.personal.asMap().forEach((index, personal) {
                        personal.selected = values[index];
                      });
                      // set state of parent widget
                      setStateCallback();
                      // setState(() {});
                    },
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(2),
                      // iconSize: 40,
                      // fixedSize: const Size(10, 10),
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.primary, // <-- Button color
                    ),
                    child: Icon(Icons.add, color: Colors.white, size: 30),
                  ),
                ),
                onTap: () async {
                  final values = await _showSelectPersonalDialog(
                    context,
                    departamento.personal,
                    departamento.nombreDepartamento,
                    titulo,
                    ref,
                  );
                  if (values.isEmpty) return;
                  departamento.personal.asMap().forEach((index, personal) {
                    personal.selected = values[index];
                  });
                  // set state of parent widget
                  setStateCallback();
                  // setState(() {});
                },
              ),

              // List of personal assigned
              _buildSelectedPersonalView(departamento.personal, context, theme),
            ],
          );
        }),
      ],
    );
  }
}

// Dialog to select personal with actions
Future<List<bool>> _showSelectPersonalDialog(
  BuildContext context,
  List<PersonalDepartamento> personalList,
  String gerencia,
  String categoria,
  WidgetRef ref,
) async {
  ref.read(selectedPersonalDialogProvider.notifier).state = [];
  final result = await showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          // StatefulBuilder to update the dialog

          return AlertDialog(
            insetPadding: EdgeInsets.zero, // This makes the dialog full width
            title: Column(
              children: [
                Text('Asignar $categoria '),
                Text(gerencia, style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true, // Important for ListView in AlertDialog
                physics:
                    const ClampingScrollPhysics(), // Prevents unwanted bouncing
                itemCount: personalList.length,
                itemBuilder: (context, index) {
                  final personal = personalList[index];
                  return CheckboxListTile(
                    title: Text(
                      personal.nombre,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    value: personal.selected,
                    onChanged: (value) {
                      // Handle personal selection
                      personal.selected = value!;
                      setState(() {}); // Refresh the dialog
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
                  final List<bool> selectedPersonal = personalList
                      // .where((personal) => personal.selected)
                      .map((personal) => personal.selected)
                      .toList();
                  // final List<bool> selectedPersonal = personalList
                  //     .where((personal) => personal.selected)
                  //     .map((personal) => personal.selected)
                  //     .toList();

                  print("selected personal: $selectedPersonal");
                  ref.read(selectedPersonalDialogProvider.notifier).state =
                      selectedPersonal;

                  // return selected personal
                  Navigator.of(context).pop(selectedPersonal);
                  // return selectedPersonal;
                },
              ),
            ],
          );
        },
      );

      // AlertDialog(
      //   insetPadding: EdgeInsets.zero, // This makes the dialog full width
      //   title: Column(
      //     children: [
      //       Text('Asignar $categoria '),
      //       Text(gerencia, style: Theme.of(context).textTheme.bodyLarge),
      //     ],
      //   ),
      //   content: SizedBox(
      //     width: double.maxFinite,
      //     child: ListView.builder(
      //       shrinkWrap: true, // Important for ListView in AlertDialog
      //       physics:
      //           const ClampingScrollPhysics(), // Prevents unwanted bouncing
      //       itemCount: personalList.length,
      //       itemBuilder: (context, index) {
      //         final personal = personalList[index];
      //         return CheckboxListTile(
      //           title: Text(
      //             personal.nombre,
      //             style: Theme.of(context).textTheme.bodyMedium,
      //           ),
      //           value: personal.selected,
      //           onChanged: (value) {
      //             // Handle personal selection
      //             personal.selected = value!;
      //             // setState(() {}); // Refresh the dialog
      //           },
      //         );
      //       },
      //     ),
      //   ),
      // );
    },
  );
  print("result: $result");
  return result ?? [];
}

// List selected personal view function
Widget _buildSelectedPersonalView(
  List<PersonalDepartamento> personalList,
  BuildContext context,
  ThemeData theme,
) {
  return !_isPersonalSelected(personalList)
      ? Text('No hay personal seleccionado', style: theme.textTheme.bodySmall)
      : Column(
          children: personalList.map((personal) {
            if (personal.selected == false) {
              // if (false) {
              return SizedBox.shrink();
            } else {
              return ListTile(
                title: Text(personal.nombre, style: theme.textTheme.bodyMedium),
                subtitle: Text(
                  personal.cargo,
                  style: theme.textTheme.bodySmall,
                ),
                onTap: () {},
              );
            }
          }).toList(),
        );
}

bool _isPersonalSelected(List<PersonalDepartamento> personalList) {
  return personalList.any((personal) => personal.selected);
}

// Supervisor

            // Personal (Firman el TRC)

            // Personal (Aprueban el TRC)

            // Personal