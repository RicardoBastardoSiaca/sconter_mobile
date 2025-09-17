import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:turnaround_mobile/features/turnarounds/domain/domain.dart';

import '../../../shared/shared.dart';
import '../providers/providers.dart';
import '../widgets/widgets.dart';

class AsignarDemorasScreen extends StatelessWidget {
  const AsignarDemorasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Asignar Demora')),
      body: _AsignarDemorasView(),
    );
  }
}

class _AsignarDemorasView extends ConsumerStatefulWidget {
  const _AsignarDemorasView();

  @override
  ConsumerState<_AsignarDemorasView> createState() =>
      _AsignarDemorasViewState();
}

class _AsignarDemorasViewState extends ConsumerState<_AsignarDemorasView> {
  @override
  DemoraCodigo? selectedDemora;
  // time of day 00:00
  TimeOfDay _selectedTime = const TimeOfDay(hour: 0, minute: 0);
  // TimeOfDay _selectedTime = TimeOfDay.now();
  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('HH:mm');
    // theme
    final theme = Theme.of(context);
    final demoras = ref.watch(demorasProvider);
    final categorias = demoras.categorias;

    // Listview categorias
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Seleccionar codigo de demora:',
                    style: Theme.of(
                      context,
                    ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(height: 8.0),
                  // Box displaying the selected demora
                  GestureDetector(
                    onTap: () {
                      showSearch(
                        context: context,
                        delegate: DemoraSearchDelegate(
                          categorias: categorias ?? [],
                        ),
                      ).then((value) {
                        // Handle the selected value
                        if (value != null) {
                          print('Selected: $value');
                          // Update the selectedDemora
                          selectedDemora = value;
                          setState(() {});
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 12.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        // border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // const SizedBox(height: 4.0),
                          selectedDemora == null
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium,
                                    ),
                                    // select arrow down icon
                                    Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.grey,
                                    ),
                                  ],
                                )
                              : ListTile(
                                  title: Text(
                                    '${selectedDemora?.codIdentificadorNumero.toString()} ${selectedDemora?.codIdentificadorLetra} ${selectedDemora?.codIdentificadorLetraAdicional}',
                                    style: theme.textTheme.displaySmall?.copyWith(
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  subtitle: Text(
                                    selectedDemora?.codDescripcionEs ?? '',
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                  trailing: Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.grey,
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
      
                  const SizedBox(height: 20.0),
      
                  // Tiempo de demora
                  Text(
                    'Tiempo de demora:',
                    style: Theme.of(
                      context,
                    ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w400),
                  ),
      
                  const SizedBox(height: 8.0),
      
                  // TimePickerDropdownState
                  TimePicker24Hour(
                    initialTime: _selectedTime,
                    onTimeChanged: (time) {
                      setState(() {
                        _selectedTime = time;
                      });
                    },
                    containerHeight: 250,
                    containerWidth: 320,
                  ),
                ],
              ),
            ),
      
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      // borderRadius: BorderRadius.circular(30),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Cancelar', style: TextStyle(fontSize: 18)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      // check codigo seleccionado
                      if (selectedDemora == null) {
                        CustomSnackbar.showErrorSnackbar(
                          'Seleccione un código de demora',
                          context,
                          isFixed: true,
                        );
                        return;
                      }
      
                      // check if _selectedTime is 00:00
                      if (_selectedTime == TimeOfDay(hour: 0, minute: 0)) {
                        CustomSnackbar.showErrorSnackbar(
                          'Seleccionar tiempo de demora',
                          context,
                          isFixed: true,
                        );
                        return;
                      }
      
                      // body = {
                      //       codigo_demora: this.myForm.value.codigoSeleccionado,
                      //       turnaround: this.data.trc.id,
                      //       hora: this.myForm.value.hora,
                      //     }
      
                      // final timeFormat = DateFormat('HH:mm');
                      final body = {
                        'codigo_demora': selectedDemora?.codId,
                        'turnaround': ref.read(selectedTurnaroundProvider)!.id,
                        // format hora "HH:mm"
                        'hora': timeFormat.format(
                          DateTime(
                            0,
                            0,
                            0,
                            _selectedTime.hour,
                            _selectedTime.minute,
                          ),
                        ),
                      };
      
                      print('Body: $body');
      
                      final SnackbarResponse response = await ref
                          .read(demorasProvider.notifier)
                          .asignarDemora(body);
      
                      CustomSnackbar.showResponseSnackbar(
                        response.message,
                        response.success,
                        // ignore: use_build_context_synchronously
                        context,
                        isFixed: true,
                      );
      
                      if (response.success) {
                        // Clear the form
                        setState(() {
                          selectedDemora = null;
                          _selectedTime = const TimeOfDay(hour: 0, minute: 0);
                        });
                        // Close
                        Navigator.pop(context);
                      }
      
                      // if (response.success) {
                      //   // Clear the form
                      //   setState(() {
                      //     selectedValue = null;
                      //     _passwordController.clear();
                      //     _signatureController.clear();
                      //   });
                      //   // Close
                      //   Navigator.pop(context);
                      // }
      
                      // Form is valid - process data
                      // _submitForm();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: Text(
                      'Asignar',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    // ListView.builder(
    //   itemCount: categorias?.length ?? 0,
    //   itemBuilder: (context, index) {
    //     final categoria = categorias![index];
    //     return ListTile(
    //       title: Text(categoria.nombre),
    //       subtitle: Text('Demoras: ${categoria.codigo.length}'),
    //     );
    //   },
    // );
  }
}
