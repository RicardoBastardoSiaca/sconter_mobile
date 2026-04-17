import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scounter_mobile/features/turnarounds/domain/entities/control_actividades.dart';

import '../../../shared/shared.dart';
import '../providers/providers.dart';

class PasajerosDialog extends ConsumerWidget {
  final Tarea tarea;
  const PasajerosDialog({super.key, required this.tarea});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final turnaround = ref.watch(selectedTurnaroundProvider);
    var pasajerosForm = ref.watch(pasajerosFormProvider);
    // PasajerosFormState pasajerosForm = ref
    //     .read(pasajerosFormProvider.notifier)
    //     .state;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AlertDialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 2),
        backgroundColor: Colors.white,
        title: Text('Pasajeros'),
        content: Builder(
          builder: (BuildContext context) {
            // var height = MediaQuery.of(context).size.height;
            var width = MediaQuery.of(context).size.width;

            return SizedBox(
              // height: height * 0.5,
              width: width * 0.8,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                      _PasajerosRowView(tarea: tarea),

                    const Divider(thickness: 1),

                    // if (turnaround?.fkVuelo.tipoServicio.id != 4)
                    //   _SalidaPasajerosView(tarea: tarea),

                    // if (turnaround?.fkVuelo.tipoServicio.id != 4)
                    //   SizedBox(height: 5),

                    // if (turnaround?.fkVuelo.tipoServicio.id != 4)
                    //   _TransitoPasajerosView(tarea: tarea),

                    // if (turnaround?.fkVuelo.tipoServicio.id != 4)
                    //   SizedBox(height: 5),

                    // if (turnaround?.fkVuelo.tipoServicio.id != 4)
                    //   _InadmitidosPasajerosView(tarea: tarea),

                    // // SizedBox(height: 5),
                    // if (turnaround?.fkVuelo.tipoServicio.id != 4)
                    //   const Divider(thickness: 1),

                    // if (turnaround?.fkVuelo.tipoServicio.id != 4)
                    //   _TotalPasajerosView(tarea: tarea),
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
            text: 'Guardar',

            // buttonColor: Colors.green,
            onPressed: () async {
              // validaciones
              // if (!pasajerosForm.isValid) {
              //   return;
              // }

              if (ref
                      .watch(pasajerosFormProvider.notifier)
                      .isTotalPassagersValid() ==
                  false) {
                // showErrorSnackbar on top of dialog

                // ScaffoldMessenger.of(context).showSnackBar(
                //   SnackBar(
                //     // on top of dialog
                //     // elevation: 1000,
                //     behavior: SnackBarBehavior.floating,
                //     content: const Text('snack'),
                //     duration: const Duration(seconds: 2),
                //     action: SnackBarAction(label: 'ACTION', onPressed: () {}),
                //   ),
                // );
                CustomSnackbar.showErrorSnackbar(
                  'Total de pasajeros no validos',
                  context,
                );
                // final snackBar = SnackBar(
                //   content: const Text('Total de pasajeros no validos'),
                //   backgroundColor: Colors.red,
                // );
                // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                return;
              }
              // body
              final SavePasajerosRequest body = SavePasajerosRequest(
                id: tarea.pasajeros!.id,
                ejecutivo: pasajerosForm.ejecutivo.value ?? 0,
                economica: pasajerosForm.economica.value ?? 0,
                infante: pasajerosForm.infante.value ?? 0,
                
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
            },
          ),
        ],
      ),
    );
  }
}

class _PasajerosRowView extends ConsumerWidget {
  final Tarea tarea;
  const _PasajerosRowView({required this.tarea});

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
                          .onEjecutivoChanged(intValue);
                    },
                    initialValue: tarea.pasajeros!.ejecutivo
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
                          .onEconomicaChanged(intValue);
                    },
                    initialValue: tarea.pasajeros!.economica
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
                          .onInfanteChanged(intValue);
                    },
                    initialValue: tarea.pasajeros!.infante
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


// class _TotalPasajerosView extends ConsumerWidget {
//   final Tarea tarea;
//   const _TotalPasajerosView({required this.tarea});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final pasajerosForm = ref.watch(pasajerosFormProvider);
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         // half width
//         Flexible(flex: 3, child: Text('Total:')),
//         Flexible(
//           flex: 6,
//           child: Row(
//             children: [
//               Expanded(
//                 child: PasajerosBoxContainer(
//                   clase: 'C',
//                   // total pasajeros = salida + transito - inadmitidos
//                   cantidad:
//                       pasajerosForm.salidaEjecutivo.value! +
//                       pasajerosForm.transitoEjecutivo.value! -
//                       pasajerosForm.inadmitidosEjecutivo.value!,
//                 ),
//               ),
//               Expanded(
//                 child: PasajerosBoxContainer(
//                   clase: 'Y',
//                   cantidad:
//                       pasajerosForm.salidaEconomica.value! +
//                       pasajerosForm.transitoEconomica.value! -
//                       pasajerosForm.inadmitidosEconomica.value!,
//                 ),
//               ),
//               Expanded(
//                 child: PasajerosBoxContainer(
//                   clase: 'I',
//                   cantidad:
//                       pasajerosForm.salidaInfante.value! +
//                       pasajerosForm.transitoInfante.value! -
//                       pasajerosForm.inadmitidosInfante.value!,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

// // bool isValidForm(PasajerosFormState pasajerosForm) {
// //   return pasajerosForm.isValid;
// // }

// class _LlegadaPasajerosView extends ConsumerWidget {
//   final Tarea tarea;
//   const _LlegadaPasajerosView({required this.tarea});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Flexible(flex: 3, child: Text('Llegada:')),

//         // const Spacer(),
//         Flexible(
//           flex: 6,
//           child: Row(
//             children: [
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 2),
//                   child: PasajerosInputFormField(
//                     keyboardType: TextInputType.number,

//                     // controller: textController,
//                     onChanged: (value) {
//                       // remove leading zeros
//                       // value = value.replaceAll(RegExp(r'^0+'), '');
//                       int intValue = value.isEmpty ? 0 : int.parse(value);
//                       print(intValue);
//                       return ref
//                           .read(pasajerosFormProvider.notifier)
//                           .onLlegadaEjecutivoChanged(intValue);
//                     },
//                     initialValue: tarea.pasajeros!['llegada_ejecutivo']
//                         .toString(),
//                     // errorMessage: null
//                     //                     onFieldSubmitted: (_) =>
//                     // ref.read(loginFormProvider.notifier).onFormSubmit(),
//                   ),
//                 ),
//               ),

//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 2),
//                   child: PasajerosInputFormField(
//                     keyboardType: TextInputType.number,
//                     // controller: textController,
//                     onChanged: (value) {
//                       int intValue = value.isEmpty ? 0 : int.parse(value);
//                       return ref
//                           .read(pasajerosFormProvider.notifier)
//                           .onLlegadaEconomicaChanged(intValue);
//                     },
//                     initialValue: tarea.pasajeros!['llegada_economica']
//                         .toString(),
//                     // errorMessage: null
//                     //                     onFieldSubmitted: (_) =>
//                     // ref.read(loginFormProvider.notifier).onFormSubmit(),
//                   ),
//                 ),
//               ),

//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 2),
//                   child: PasajerosInputFormField(
//                     keyboardType: TextInputType.number,
//                     // controller: textController,
//                     onChanged: (value) {
//                       int intValue = value.isEmpty ? 0 : int.parse(value);
//                       return ref
//                           .read(pasajerosFormProvider.notifier)
//                           .onLlegadaInfanteChanged(intValue);
//                     },
//                     initialValue: tarea.pasajeros!['llegada_infante']
//                         .toString(),
//                     // errorMessage: null
//                     //                     onFieldSubmitted: (_) =>
//                     // ref.read(loginFormProvider.notifier).onFormSubmit(),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _SalidaPasajerosView extends ConsumerWidget {
//   final Tarea tarea;
//   const _SalidaPasajerosView({required this.tarea});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Flexible(flex: 3, child: Text('Salida:')),

//         // const Spacer(),
//         Flexible(
//           flex: 6,
//           child: Row(
//             children: [
//               // ejecutivo
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 2),
//                   child: PasajerosInputFormField(
//                     keyboardType: TextInputType.number,
//                     // controller: textController,
//                     onChanged: (value) {
//                       int intValue = value.isEmpty ? 0 : int.parse(value);
//                       return ref
//                           .read(pasajerosFormProvider.notifier)
//                           .onSalidaEjecutivoChanged(intValue);
//                     },
//                     initialValue: tarea.pasajeros!['salida_ejecutivo']
//                         .toString(),
//                     // initialValue: ref
//                     //     .watch(pasajerosFormProvider)
//                     //     .salidaEjecutivo
//                     //     .toString(),
//                     // errorMessage: null
//                     //                     onFieldSubmitted: (_) =>
//                     // ref.read(loginFormProvider.notifier).onFormSubmit(),
//                   ),
//                 ),
//               ),

//               // economico
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 2),
//                   child: PasajerosInputFormField(
//                     keyboardType: TextInputType.number,
//                     // controller: textController,
//                     onChanged: (value) {
//                       int intValue = value.isEmpty ? 0 : int.parse(value);
//                       return ref
//                           .read(pasajerosFormProvider.notifier)
//                           .onSalidaEconomicaChanged(intValue);
//                     },
//                     initialValue: tarea.pasajeros!['salida_economica']
//                         .toString(),
//                     // errorMessage: null
//                     //                     onFieldSubmitted: (_) =>
//                     // ref.read(loginFormProvider.notifier).onFormSubmit(),
//                   ),
//                 ),
//               ),

//               // infante
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 2),
//                   child: PasajerosInputFormField(
//                     keyboardType: TextInputType.number,
//                     // controller: textController,
//                     onChanged: (value) {
//                       int intValue = value.isEmpty ? 0 : int.parse(value);
//                       return ref
//                           .read(pasajerosFormProvider.notifier)
//                           .onSalidaInfanteChanged(intValue);
//                     },
//                     initialValue: tarea.pasajeros!['salida_infante'].toString(),
//                     // errorMessage: null
//                     //                     onFieldSubmitted: (_) =>
//                     // ref.read(loginFormProvider.notifier).onFormSubmit(),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

// // Transito
// class _TransitoPasajerosView extends ConsumerWidget {
//   final Tarea tarea;
//   const _TransitoPasajerosView({required this.tarea});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Flexible(flex: 3, child: Text('Transito:')),

//         // const Spacer(),
//         Flexible(
//           flex: 6,
//           child: Row(
//             children: [
//               // ejecutivo
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 2),
//                   child: PasajerosInputFormField(
//                     keyboardType: TextInputType.number,
//                     // controller: textController,
//                     onChanged: (value) {
//                       int intValue = value.isEmpty ? 0 : int.parse(value);
//                       return ref
//                           .read(pasajerosFormProvider.notifier)
//                           .onTransitoEjecutivoChanged(intValue);
//                     },
//                     initialValue: tarea.pasajeros!['transito_ejecutivo']
//                         .toString(),
//                     // errorMessage: null
//                     //                     onFieldSubmitted: (_) =>
//                     // ref.read(loginFormProvider.notifier).onFormSubmit(),
//                   ),
//                 ),
//               ),

//               // economico
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 2),
//                   child: PasajerosInputFormField(
//                     keyboardType: TextInputType.number,
//                     // controller: textController,
//                     onChanged: (value) {
//                       int intValue = value.isEmpty ? 0 : int.parse(value);
//                       return ref
//                           .read(pasajerosFormProvider.notifier)
//                           .onTransitoEconomicaChanged(intValue);
//                     },
//                     initialValue: tarea.pasajeros!['transito_economica']
//                         .toString(),
//                     // errorMessage: null
//                     //                     onFieldSubmitted: (_) =>
//                     // ref.read(loginFormProvider.notifier).onFormSubmit(),
//                   ),
//                 ),
//               ),

//               // infante
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 2),
//                   child: PasajerosInputFormField(
//                     keyboardType: TextInputType.number,
//                     // controller: textController,
//                     onChanged: (value) {
//                       int intValue = value.isEmpty ? 0 : int.parse(value);
//                       return ref
//                           .read(pasajerosFormProvider.notifier)
//                           .onTransitoInfanteChanged(intValue);
//                     },
//                     initialValue: tarea.pasajeros!['transito_infante']
//                         .toString(),
//                     // errorMessage: null
//                     //                     onFieldSubmitted: (_) =>
//                     // ref.read(loginFormProvider.notifier).onFormSubmit(),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

// // inadmitidos
// class _InadmitidosPasajerosView extends ConsumerWidget {
//   final Tarea tarea;
//   const _InadmitidosPasajerosView({required this.tarea});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Flexible(flex: 3, child: Text('Inadmitidos:')),

//         // const Spacer(),
//         Flexible(
//           flex: 6,
//           child: Row(
//             children: [
//               // ejecutivo
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 2),
//                   child: PasajerosInputFormField(
//                     keyboardType: TextInputType.number,
//                     // controller: textController,
//                     onChanged: (value) {
//                       int intValue = value.isEmpty ? 0 : int.parse(value);
//                       return ref
//                           .read(pasajerosFormProvider.notifier)
//                           .onInadmitidosEjecutivoChanged(intValue);
//                     },
//                     initialValue: tarea.pasajeros!['inadmitidos_ejecutivo']
//                         .toString(),
//                     // errorMessage: null
//                     //                     onFieldSubmitted: (_) =>
//                     // ref.read(loginFormProvider.notifier).onFormSubmit(),
//                   ),
//                 ),
//               ),

//               // economico
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 2),
//                   child: PasajerosInputFormField(
//                     keyboardType: TextInputType.number,
//                     // controller: textController,
//                     onChanged: (value) {
//                       int intValue = value.isEmpty ? 0 : int.parse(value);
//                       return ref
//                           .read(pasajerosFormProvider.notifier)
//                           .onInadmitidosEconomicaChanged(intValue);
//                     },
//                     initialValue: tarea.pasajeros!['inadmitidos_economica']
//                         .toString(),
//                     // errorMessage: null
//                     //                     onFieldSubmitted: (_) =>
//                     // ref.read(loginFormProvider.notifier).onFormSubmit(),
//                   ),
//                 ),
//               ),

//               // infante
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 2),
//                   child: PasajerosInputFormField(
//                     keyboardType: TextInputType.number,
//                     // controller: textController,
//                     onChanged: (value) {
//                       int intValue = value.isEmpty ? 0 : int.parse(value);
//                       return ref
//                           .read(pasajerosFormProvider.notifier)
//                           .onInadmitidosInfanteChanged(intValue);
//                     },
//                     initialValue: tarea.pasajeros!['inadmitidos_infante']
//                         .toString(),
//                     // errorMessage: null
//                     //                     onFieldSubmitted: (_) =>
//                     // ref.read(loginFormProvider.notifier).onFormSubmit(),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
