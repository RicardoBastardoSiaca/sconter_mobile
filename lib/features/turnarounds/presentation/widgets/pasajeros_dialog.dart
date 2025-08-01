import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turnaround_mobile/features/turnarounds/domain/entities/control_actividades.dart';

import '../../../shared/shared.dart';
import '../providers/providers.dart';

class PasajerosDialog extends ConsumerWidget {
  final Tarea tarea;
  const PasajerosDialog({super.key, required this.tarea});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var pasajerosForm = ref.watch(pasajerosFormProvider);
    // PasajerosFormState pasajerosForm = ref
    //     .read(pasajerosFormProvider.notifier)
    //     .state;
    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 2),
      backgroundColor: Colors.white,
      title: Text('Pasajeros'),
      content: Builder(
        builder: (context) {
          // var height = MediaQuery.of(context).size.height;
          var width = MediaQuery.of(context).size.width;

          return SizedBox(
            // height: height * 0.5,
            width: width * 0.8,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _LlegadaPasajerosView(tarea: tarea),

                  const Divider(thickness: 1),

                  _SalidaPasajerosView(tarea: tarea),

                  SizedBox(height: 5),

                  _TransitoPasajerosView(tarea: tarea),
                  SizedBox(height: 5),

                  _InadmitidosPasajerosView(tarea: tarea),

                  // SizedBox(height: 5),
                  const Divider(thickness: 1),
                  // Pasajeros Input Form Field
                ],
              ),
            ),
          );
        },
      ),

      actions: <Widget>[
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
            // textController.clear();
          },
          child: Text(
            'Salir',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),

        CustomFilledButton(
          text: 'Guardar 2',

          // buttonColor: Colors.green,
          onPressed: () async {
            // body
            final SavePasajerosRequest body = SavePasajerosRequest(
              id: tarea.pasajeros!['id']!,
              llegadaEjecutivo: pasajerosForm.llegadaEjecutivo.value ?? 0,
              llegadaEconomica: pasajerosForm.llegadaEconomica.value ?? 0,
              llegadaInfante: pasajerosForm.llegadaInfante.value ?? 0,
              transitoEjecutivo: pasajerosForm.transitoEjecutivo.value ?? 0,
              transitoEconomica: pasajerosForm.transitoEconomica.value ?? 0,
              transitoInfante: pasajerosForm.transitoInfante.value ?? 0,
              salidaEjecutivo: pasajerosForm.salidaEjecutivo.value ?? 0,
              salidaEconomica: pasajerosForm.salidaEconomica.value ?? 0,
              salidaInfante: pasajerosForm.salidaInfante.value ?? 0,
              inadmitidosEjecutivo:
                  pasajerosForm.inadmitidosEjecutivo.value ?? 0,
              inadmitidosEconomica:
                  pasajerosForm.inadmitidosEconomica.value ?? 0,
              inadmitidosInfante: pasajerosForm.inadmitidosInfante.value ?? 0,
            );

            final trcId = ref
                .read(selectedTurnaroundProvider.notifier)
                .state!
                .id;
            final response = await ref
                .read(controlActividadesProvider(trcId).notifier)
                .savePasajeros(body);

            // Show snackbar response
            CustomSnackbar.showResponseSnackbar(
              response.message,
              response.success,
              // ignore: use_build_context_synchronously
              context,
            );

            Navigator.pop(context);

            // final ComentarioRequest body = ComentarioRequest(
            //   id: tarea.id,
            //   comentario: textController.text,
            // );

            // print("Comentario: ${body.comentario}");
            // final trcId = ref
            //     .read(selectedTurnaroundProvider.notifier)
            //     .state!
            //     .id;
            // final response = await ref
            //     .read(controlActividadesProvider(trcId).notifier)
            //     .setComentario(body);

            // // Show snackbar response
            // CustomSnackbar.showResponseSnackbar(
            //   response.message,
            //   response.success,
            //   // ignore: use_build_context_synchronously
            //   context,
            // );

            // Navigator.pop(context);
            // textController.clear();
          },
        ),

        // TextButton(
        //   child: Text('Cancel'),
        //   onPressed: () {
        //     Navigator.of(context).pop(); // Close the dialog
        //   },
        // ),
        // ElevatedButton(
        //   child: Text('Submit'),
        //   onPressed: () {
        //     String submittedText = textController.text;
        //     // Process the submitted text (e.g., save it, display it)
        //     print('Submitted text: $submittedText');
        //     Navigator.of(context).pop(); // Close the dialog
        //     textController
        //         .clear(); // Clear the text field after submission
        //   },
        // ),
      ],
    );
  }
}

class _LlegadaPasajerosView extends ConsumerWidget {
  final Tarea tarea;
  const _LlegadaPasajerosView({required this.tarea});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(flex: 3, child: Text('Llegada:')),

        // const Spacer(),
        Flexible(
          flex: 6,
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: PasajerosInputFormField(
                    keyboardType: TextInputType.number,

                    // controller: textController,
                    onChanged: (value) {
                      // remove leading zeros
                      // value = value.replaceAll(RegExp(r'^0+'), '');
                      int intValue = value.isEmpty ? 0 : int.parse(value);
                      print(intValue);
                      return ref
                          .read(pasajerosFormProvider.notifier)
                          .onLlegadaEjecutivoChanged(intValue);
                    },
                    initialValue: tarea.pasajeros!['llegada_ejecutivo']
                        .toString(),
                    // errorMessage: null
                    //                     onFieldSubmitted: (_) =>
                    // ref.read(loginFormProvider.notifier).onFormSubmit(),
                  ),
                ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: PasajerosInputFormField(
                    keyboardType: TextInputType.number,
                    // controller: textController,
                    onChanged: (value) {
                      int intValue = value.isEmpty ? 0 : int.parse(value);
                      return ref
                          .read(pasajerosFormProvider.notifier)
                          .onLlegadaEconomicaChanged(intValue);
                    },
                    initialValue: tarea.pasajeros!['llegada_economica']
                        .toString(),
                    // errorMessage: null
                    //                     onFieldSubmitted: (_) =>
                    // ref.read(loginFormProvider.notifier).onFormSubmit(),
                  ),
                ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: PasajerosInputFormField(
                    keyboardType: TextInputType.number,
                    // controller: textController,
                    onChanged: (value) {
                      int intValue = value.isEmpty ? 0 : int.parse(value);
                      return ref
                          .read(pasajerosFormProvider.notifier)
                          .onLlegadaInfanteChanged(intValue);
                    },
                    initialValue: tarea.pasajeros!['llegada_infante']
                        .toString(),
                    // errorMessage: null
                    //                     onFieldSubmitted: (_) =>
                    // ref.read(loginFormProvider.notifier).onFormSubmit(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SalidaPasajerosView extends ConsumerWidget {
  final Tarea tarea;
  const _SalidaPasajerosView({required this.tarea});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(flex: 3, child: Text('Salida:')),

        // const Spacer(),
        Flexible(
          flex: 6,
          child: Row(
            children: [
              // ejecutivo
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: PasajerosInputFormField(
                    keyboardType: TextInputType.number,
                    // controller: textController,
                    onChanged: (value) {
                      int intValue = value.isEmpty ? 0 : int.parse(value);
                      return ref
                          .read(pasajerosFormProvider.notifier)
                          .onSalidaEjecutivoChanged(intValue);
                    },
                    initialValue: tarea.pasajeros!['salida_ejecutivo']
                        .toString(),
                    // errorMessage: null
                    //                     onFieldSubmitted: (_) =>
                    // ref.read(loginFormProvider.notifier).onFormSubmit(),
                  ),
                ),
              ),

              // economico
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: PasajerosInputFormField(
                    keyboardType: TextInputType.number,
                    // controller: textController,
                    onChanged: (value) {
                      int intValue = value.isEmpty ? 0 : int.parse(value);
                      return ref
                          .read(pasajerosFormProvider.notifier)
                          .onSalidaEconomicaChanged(intValue);
                    },
                    initialValue: tarea.pasajeros!['salida_economica']
                        .toString(),
                    // errorMessage: null
                    //                     onFieldSubmitted: (_) =>
                    // ref.read(loginFormProvider.notifier).onFormSubmit(),
                  ),
                ),
              ),

              // infante
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: PasajerosInputFormField(
                    keyboardType: TextInputType.number,
                    // controller: textController,
                    onChanged: (value) {
                      int intValue = value.isEmpty ? 0 : int.parse(value);
                      return ref
                          .read(pasajerosFormProvider.notifier)
                          .onSalidaInfanteChanged(intValue);
                    },
                    initialValue: tarea.pasajeros!['salida_infante'].toString(),
                    // errorMessage: null
                    //                     onFieldSubmitted: (_) =>
                    // ref.read(loginFormProvider.notifier).onFormSubmit(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Transito
class _TransitoPasajerosView extends ConsumerWidget {
  final Tarea tarea;
  const _TransitoPasajerosView({required this.tarea});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(flex: 3, child: Text('Transito:')),

        // const Spacer(),
        Flexible(
          flex: 6,
          child: Row(
            children: [
              // ejecutivo
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: PasajerosInputFormField(
                    keyboardType: TextInputType.number,
                    // controller: textController,
                    onChanged: (value) {
                      int intValue = value.isEmpty ? 0 : int.parse(value);
                      return ref
                          .read(pasajerosFormProvider.notifier)
                          .onTransitoEjecutivoChanged(intValue);
                    },
                    initialValue: tarea.pasajeros!['transito_ejecutivo']
                        .toString(),
                    // errorMessage: null
                    //                     onFieldSubmitted: (_) =>
                    // ref.read(loginFormProvider.notifier).onFormSubmit(),
                  ),
                ),
              ),

              // economico
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: PasajerosInputFormField(
                    keyboardType: TextInputType.number,
                    // controller: textController,
                    onChanged: (value) {
                      int intValue = value.isEmpty ? 0 : int.parse(value);
                      return ref
                          .read(pasajerosFormProvider.notifier)
                          .onTransitoEconomicaChanged(intValue);
                    },
                    initialValue: tarea.pasajeros!['transito_economica']
                        .toString(),
                    // errorMessage: null
                    //                     onFieldSubmitted: (_) =>
                    // ref.read(loginFormProvider.notifier).onFormSubmit(),
                  ),
                ),
              ),

              // infante
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: PasajerosInputFormField(
                    keyboardType: TextInputType.number,
                    // controller: textController,
                    onChanged: (value) {
                      int intValue = value.isEmpty ? 0 : int.parse(value);
                      return ref
                          .read(pasajerosFormProvider.notifier)
                          .onTransitoInfanteChanged(intValue);
                    },
                    initialValue: tarea.pasajeros!['transito_infante']
                        .toString(),
                    // errorMessage: null
                    //                     onFieldSubmitted: (_) =>
                    // ref.read(loginFormProvider.notifier).onFormSubmit(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// inadmitidos
class _InadmitidosPasajerosView extends ConsumerWidget {
  final Tarea tarea;
  const _InadmitidosPasajerosView({required this.tarea});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(flex: 3, child: Text('Inadmitidos:')),

        // const Spacer(),
        Flexible(
          flex: 6,
          child: Row(
            children: [
              // ejecutivo
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: PasajerosInputFormField(
                    keyboardType: TextInputType.number,
                    // controller: textController,
                    onChanged: (value) {
                      int intValue = value.isEmpty ? 0 : int.parse(value);
                      return ref
                          .read(pasajerosFormProvider.notifier)
                          .onInadmitidosEjecutivoChanged(intValue);
                    },
                    initialValue: tarea.pasajeros!['inadmitidos_ejecutivo']
                        .toString(),
                    // errorMessage: null
                    //                     onFieldSubmitted: (_) =>
                    // ref.read(loginFormProvider.notifier).onFormSubmit(),
                  ),
                ),
              ),

              // economico
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: PasajerosInputFormField(
                    keyboardType: TextInputType.number,
                    // controller: textController,
                    onChanged: (value) {
                      int intValue = value.isEmpty ? 0 : int.parse(value);
                      return ref
                          .read(pasajerosFormProvider.notifier)
                          .onInadmitidosEconomicaChanged(intValue);
                    },
                    initialValue: tarea.pasajeros!['inadmitidos_economica']
                        .toString(),
                    // errorMessage: null
                    //                     onFieldSubmitted: (_) =>
                    // ref.read(loginFormProvider.notifier).onFormSubmit(),
                  ),
                ),
              ),

              // infante
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: PasajerosInputFormField(
                    keyboardType: TextInputType.number,
                    // controller: textController,
                    onChanged: (value) {
                      int intValue = value.isEmpty ? 0 : int.parse(value);
                      return ref
                          .read(pasajerosFormProvider.notifier)
                          .onInadmitidosInfanteChanged(intValue);
                    },
                    initialValue: tarea.pasajeros!['inadmitidos_infante']
                        .toString(),
                    // errorMessage: null
                    //                     onFieldSubmitted: (_) =>
                    // ref.read(loginFormProvider.notifier).onFormSubmit(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
