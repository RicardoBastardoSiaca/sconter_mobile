import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

class FirmaSupervisorScreen extends StatefulWidget {
  const FirmaSupervisorScreen({super.key});

  @override
  State<FirmaSupervisorScreen> createState() => _FirmaSupervisorScreenState();
}

class _FirmaSupervisorScreenState extends State<FirmaSupervisorScreen> {
  // Dropdown variables
  String? selectedValue;
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
            DropdownButtonFormField<String>(
              value: selectedValue,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                // hintText: 'Selccione el supervisor',
              ),
              items: dropdownItems.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
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
                labelText: 'Ingrese su código',
                border: OutlineInputBorder(),
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
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                children: [
                  Signature(
                    controller: _signatureController,
                    height: 200,
                    backgroundColor: Colors.white,
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
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
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

                      // Form is valid - process data
                      _submitForm();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Submit'),
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
      'signatureImage': await _signatureController.toImage(),
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

    // In a real app, you would send this data to your backend
    // Navigator.pop(context); // Uncomment to close after submit
  }
}
