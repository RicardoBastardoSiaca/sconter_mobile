import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/shared.dart';
import '../../domain/domain.dart';
import '../providers/providers.dart';

class AsignarEquiposGseServiciosAdicionalesEspeciales extends ConsumerWidget {
  const AsignarEquiposGseServiciosAdicionalesEspeciales({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('Agregar Servicios Adicionales')),
      body: _AsignarEquiposGseView(),
    );
  }
}

List<int> _setSelectedServiciosAdicionalesIds(
  List<CategoriaServicioAdicional> servicios,
) {
  List<int> idsServiciosAdicionales = [];

  // return the ids with selected in true
  for (var servicio in servicios) {
    if (servicio.selected) {
      idsServiciosAdicionales.add(servicio.id);
    }
  }
  return idsServiciosAdicionales;
}

class _AsignarEquiposGseView extends ConsumerStatefulWidget {
  const _AsignarEquiposGseView();

  @override
  ConsumerState<_AsignarEquiposGseView> createState() =>
      _AsignarEquiposGseViewState();
}

class _AsignarEquiposGseViewState
    extends ConsumerState<_AsignarEquiposGseView> {
  List<CategoriaServicioAdicional> serviciosAdicionalesAux = [];
  List<int> idsServiciosAdicionales = [];
  List<int> selectedServiciosAdicionalesIds = [];
  List<CategoriaServicioAdicional> serviciosAdicionales = [];

  List<int> idsserviciosOld = [];

  // initstate
  @override
  void initState() {
    super.initState();

    serviciosAdicionalesAux = ref
        .read(serviciosAdicionalesProvider)
        .categoriasEquiposGseResponse;

    idsServiciosAdicionales = serviciosAdicionalesAux
        .map((servicioAdicional) => servicioAdicional.id)
        .toList();

    selectedServiciosAdicionalesIds = ref
        .read(
          controlActividadesProvider(ref.read(selectedTurnaroundProvider)!.id),
        )
        .controlActividades!
        .serviciosAdicionales!
        .map((servicioAdicional) => servicioAdicional.servicioId)
        .toList();

    serviciosAdicionales = [];

    for (final servicio
        in ref
            .read(serviciosAdicionalesProvider)
            .categoriasEquiposGseResponse) {
      servicio.selected = selectedServiciosAdicionalesIds.contains(servicio.id);

      serviciosAdicionales.add(servicio);
    }

    idsserviciosOld = _setSelectedServiciosAdicionalesIds(serviciosAdicionales);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: serviciosAdicionales.length,
              itemBuilder: (context, index) {
                final servicioAdicional = serviciosAdicionales[index];
                return CheckboxListTile(
                  title: Text(servicioAdicional.titulo),
                  value: servicioAdicional.selected,
                  onChanged: (value) {
                    setState(() {
                      servicioAdicional.selected = value!;
                    });
                  },
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
                  text: 'Agregar',
                  // buttonColor: Colors.green,
                  onPressed: () async {
                    // get maquinarias ids with selected task in true
                    // final idsMaquinariasNew = _setMaquinariasSelectedIds(
                    //   categorias,
                    // );
      
                    // get servicios ids with selected task in true
                    final selectedServiciosAdicionalesIds =
                        _setSelectedServiciosAdicionalesIds(serviciosAdicionales);
      
                    final List<int> serviciosNuevos = [];
                    final List<int> serviciosEliminados = [];
      
                    // set servicios nuevos
                    for (final servicio in selectedServiciosAdicionalesIds) {
                      if (!idsserviciosOld.contains(servicio)) {
                        serviciosNuevos.add(servicio);
                      }
                    }
      
                    // set servicios eliminados
                    for (final servicio in idsserviciosOld) {
                      if (!selectedServiciosAdicionalesIds.contains(servicio)) {
                        serviciosEliminados.add(servicio);
                      }
                    }
      
                    // body
                    final body = ServiciosAdicionalRequest(
                      turnaround: ref.read(selectedTurnaroundProvider)!.id,
                      ids_nuevos: serviciosNuevos,
                      ids_eliminados: serviciosEliminados,
                    );
      
                    final response = await ref
                        .read(serviciosAdicionalesProvider.notifier)
                        .saveServiciosAdicionales(body);
      
                    if (response.success) {
                      // Show success snackbar
                      // Show snackbar response
                      CustomSnackbar.showSuccessSnackbar(
                        response.message,
                        context,
                        isFixed: true,
                      );
                      // get control de actividades
                      ref
                          .read(
                            controlActividadesProvider(
                              ref.read(selectedTurnaroundProvider)!.id,
                            ).notifier,
                          )
                          .getControlDeActividadesByTrcId();
                      ref
                          .read(
                            controlActividadesProvider(
                              ref.read(selectedTurnaroundProvider)!.id,
                            ).notifier,
                          )
                          .getControlDeActividadesServicioMiscelaneoById();

                        
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pop();
                    } else {
                      // Show error snackbar
                      // Show snackbar response
                      CustomSnackbar.showErrorSnackbar(
                        response.message,
                        context,
                        isFixed: true,
                      );
                    }
      
                    // final body = {
                    //   "id": ref.read(selectedTaskProvider)['tareaId'],
                    //   "maquinariasNuevas": maquinariasNuevas,
                    //   "maquinariasEliminadas": maquinariasEliminadas,
                    // };
      
                    // final response = await ref
                    //     .read(categoriasEquiposGseProvider.notifier)
                    //     .asignarMaquinariasTareas(body);
      
                    // Navigator.pop(context);
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
