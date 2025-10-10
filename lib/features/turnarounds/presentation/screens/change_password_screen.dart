import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/domain/domain.dart';
import '../../../auth/presentation/providers/providers.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';


class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  String? _validationError;
  AuthResponse? user;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Validation method
  String? _validatePasswords(String? value) {
    if (value == null || value.isEmpty) {
      return 'Debe ingresar contraseña';
    }
    if (value.length < 3) {
      return 'Debe tener al menos 3 caracteres';
    }
    
    // Check if passwords match (only when both fields have values)
    if (_newPasswordController.text.isNotEmpty && 
        _confirmPasswordController.text.isNotEmpty &&
        _newPasswordController.text != _confirmPasswordController.text) {
      return 'Las contraseñas no coinciden';
    }
    
    return null;
  }

  // API call to change password
  Future<void> _changePassword( ) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Clear previous validation error
    setState(() {
      _validationError = null;
    });

    // Check if passwords match
    if (_newPasswordController.text != _confirmPasswordController.text) {
      setState(() {
        _validationError = 'Las contraseñas no coinciden';
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      user = ref.read(authProvider).loginResponse;
      // Prepare the request body
      final Map<String, dynamic> requestBody = {
        'id': user?.id,
        'nombr_usuario': user?.name ?? '' ,
        'correo': user?.username  ,
        'cedula': user?.cedula   ,
        // 'telefono': user?.,
        // 'usu_personal': user?.  ,
        // 'rol': user?.  ,
        // 'contrasena': user?.  ,
        // 'is_contrasena': user?.  ,
        // 'cliente': user?.  ,
        'newPassword': _newPasswordController.text,
        'confirmPassword': _confirmPasswordController.text,
        // Add any other required fields like userId, token, etc.
      };

      // Make API call
      // // final response = await http.post(
      // //   Uri.parse('https://your-api-endpoint.com/change-password'), // Replace with your API endpoint
      // //   headers: {
      // //     'Content-Type': 'application/json',
      // //     'Authorization': 'Bearer your-auth-token', // Add your auth token if needed
      // //   },
      // //   body: jsonEncode(requestBody),
      // // );

      // // setState(() {
      // //   _isLoading = false;
      // // });

      // if (response.statusCode == 200) {
      //   // Password changed successfully
      //   if (mounted) {
      //     ScaffoldMessenger.of(context).showSnackBar(
      //       const SnackBar(
      //         content: Text('Password changed successfully!'),
      //         backgroundColor: Colors.green,
      //       ),
      //     );
      //     Navigator.of(context).pop(); // Go back to previous screen
      //   }
      // } else {
      //   // Handle API error
      //   final errorData = jsonDecode(response.body);
      //   setState(() {
      //     _validationError = errorData['message'] ?? 'Failed to change password';
      //   });
      // }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _validationError = 'Error de conexion: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final user = ref.watch(authProvider).loginResponse;
    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text('Cambiar Contraseña')),
        // backgroundColor: Theme.of(context).primaryColor,
        // foregroundColor: Colors.white,
        actions: [const SizedBox(width: 48)], // Espacio para centrar el título
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                
                // New Password Field
                TextFormField(
                  controller: _newPasswordController,
                  obscureText: !_isNewPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Nueva Contraseña',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isNewPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _isNewPasswordVisible = !_isNewPasswordVisible;
                        });
                      },
                    ),
                  ),
                  validator: _validatePasswords,
                  onChanged: (value) {
                    // Trigger validation when typing
                    if (_formKey.currentState != null) {
                      _formKey.currentState!.validate();
                    }
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Confirm Password Field
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: !_isConfirmPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Confirmar Contraseña',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                        });
                      },
                    ),
                  ),
                  validator: _validatePasswords,
                  onChanged: (value) {
                    // Trigger validation when typing
                    if (_formKey.currentState != null) {
                      _formKey.currentState!.validate();
                    }
                  },
                ),
                
                const SizedBox(height: 8),
                
                // Validation Error Display
                if (_validationError != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error, color: Colors.red),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _validationError!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ),
                
                const SizedBox(height: 24),
                
                // Submit Button
                ElevatedButton(
                  onPressed: _isLoading ? null : _changePassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Enviar',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
                
                const SizedBox(height: 12),
                
                // Cancel Button
                OutlinedButton(
                  onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    side: const BorderSide(color: Colors.grey),
                  ),
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      
    );
  }
}