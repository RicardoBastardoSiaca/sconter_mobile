import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:signature/signature.dart';
import 'package:turnaround_mobile/features/auth/presentation/providers/auth_provider.dart';

import '../../../shared/shared.dart';
import '../../domain/domain.dart';
import '../providers/providers.dart';

class FirmaSupervisorScreen extends ConsumerStatefulWidget {
  const FirmaSupervisorScreen({super.key});

  @override
  ConsumerState<FirmaSupervisorScreen> createState() =>
      _FirmaSupervisorScreenState();
}

class _FirmaSupervisorScreenState extends ConsumerState<FirmaSupervisorScreen> {
  // Dropdown variables
  SupervisorUser? selectedValue;
  final List<String> dropdownItems = ['Option 1', 'Option 2', 'Option 3'];

  // Password controller
  final TextEditingController _passwordController = TextEditingController();

  // Signature controller
  final SignatureController _signatureController = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
  );

  @override
  void dispose() {
    _passwordController.dispose();
    _signatureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final List<SupervisorUser> supervisores = ref
        .watch(supervisorAerolineaProvider)
        .supervisores;
    return Scaffold(
      appBar: AppBar(title: const Text('Firma del Supervisor')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Dropdown Button
            Text(
              'Supervisor de la aerolinea:',
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<SupervisorUser>(
              value: selectedValue,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                // hintText: 'Selccione el supervisor',
              ),
              items: supervisores.map((SupervisorUser supervisor) {
                return DropdownMenuItem<SupervisorUser>(
                  value: supervisor,
                  child: Text(supervisor.nombre),
                );
              }).toList(),
              // items: dropdownItems.map((String value) {
              //   return DropdownMenuItem<String>(
              //     value: value,
              //     child: Text(value),
              //   );
              // }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedValue = newValue;
                });
              },
              validator: (value) =>
                  value == null ? 'Seleccione una opción' : null,
            ),

            const SizedBox(height: 24),

            // 2. Numeric Password Input
            Text('Codigo de autorizacion:', style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                // labelText: 'Ingrese su código',
                border: OutlineInputBorder(),
                hintText: 'Ingrese su código',
                // hintText: 'Enter numbers only',
              ),
              keyboardType: TextInputType.text,
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Debe ingresar un código';
                }
                // if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                //   return 'Only numbers are allowed';
                // }
                return null;
              },
            ),

            const SizedBox(height: 24),

            // 3. Signature Canvas
            const Text('Firma:', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Signature(
                    controller: _signatureController,
                    height: 230,
                    backgroundColor: Colors.transparent,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            _signatureController.clear();
                          },
                          child: const Text('limpiar'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Bottom buttons
            Row(
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
                      if (selectedValue == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Debe selecionar supervisor'),
                          ),
                        );
                        return;
                      }

                      if (_passwordController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Ingrese codigo de autorizacion'),
                          ),
                        );
                        return;
                      }

                      if (_signatureController.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Debe proporcionar una firma'),
                          ),
                        );
                        return;
                      }

                      // final datetime = DateFormat('yyyy-MM-dd').parse(DateTime.now().toString());
                      // final datetime = DateFormat('yyyy-MM-dd HH:mm:ss')
                      //     .parse(DateTime.now().toString());

                      final user = ref.read(authProvider).loginResponse!;
                      final signatureImage = await _signatureController
                          .toPngBytes();
                      final body = {
                        'username': user.username,
                        'fk_usuario': user.id,
                        'fecha': DateFormat(
                          'yyyy-MM-dd',
                        ).format(DateTime.now()).toString(),
                        'hora': DateFormat(
                          'HH:mm',
                        ).format(DateTime.now()).toString(),
                        'fk_turnaround': ref
                            .read(selectedTurnaroundProvider)!
                            .id,
                        'supervisor': selectedValue!.id,
                        'codigo': _passwordController.text,
                        'signatureImage': signatureImage,
                        // .toPngBytes(),
                      };

                      final response = await ref
                          .read(
                            controlActividadesProvider(
                              ref.read(selectedTurnaroundProvider)!.id,
                            ).notifier,
                          )
                          .firmaSupervisor(body);
                      // Show snackbar response
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
                          selectedValue = null;
                          _passwordController.clear();
                          _signatureController.clear();
                        });

                        // get turnarounds
                        ref.read(turnaroundProvider.notifier).getTurnarounds();
                        // Close
                        Navigator.pop(context);
                      }

                      // Form is valid - process data
                      // _submitForm();
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
          ],
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    // Process the form data
    final formData = {
      'selectedOption': selectedValue,
      'password': _passwordController.text,
      'signatureImage': await _signatureController.toPngBytes(),
      // 'signatureImage': await _signatureController.toImage(),
      // 'signature': _signatureController.isNotEmpty
      //     ? 'Signature provided'
      //     : 'No signature',
    };

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Form submitted: $formData'),
        duration: const Duration(seconds: 2),
      ),
    );

    Uint8List dataUriToBytes(String dataUri) {
      // Split the data URI
      final uriParts = dataUri.split(',');
      if (uriParts.length != 2) {
        throw FormatException('Invalid data URI');
      }

      // Get the base64 part
      final base64Str = uriParts[1];

      // Decode base64 to bytes
      return base64Decode(base64Str);
    }

    // In a real app, you would send this data to your backend
    // Navigator.pop(context); // Uncomment to close after submit
  }
}
