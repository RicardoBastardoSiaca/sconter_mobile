import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/presentation/providers/providers.dart';
import '../../../shared/widgets/widgets.dart';
import '../../../users/users.dart';

class UserConfigMenuIcon extends ConsumerWidget {
  const UserConfigMenuIcon({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ThemeData theme = Theme.of(context);
    return IconButton(
      onPressed: () {
        // Acción al presionar el ícono
        // Por ejemplo, abrir un menú de configuración
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return 
            // Lista de opciones de configuración
            ListView(
              children:  [
                ListTile(
                  leading: Icon(Icons.password),
                  title: Text('Cambiar Contraseña', style: theme.textTheme.bodyMedium),
                  onTap: () {
                    final userId = ref.read(authProvider).loginResponse?.id;
                    // Get User by id
                    ref.read(userProvider.notifier).getUserById(userId!);
                    // change-password-screen
                    // Navigator.of(context).pushNamed('/change-password-screen');
                    context.push('/change-password-screen');
                    Navigator.of(context).pop(); // Cerrar el menú después de la selección
                    // Acción al seleccionar esta opción
                  },
                ),
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Cerrar Sesión', style: theme.textTheme.bodyMedium),
                  onTap: () {
                    // Acción al seleccionar esta opción
                    CustomDialog.showConfirmationDialog(
            context,
            "Cerrar sesión",
            "¿Estás seguro de que deseas cerrar sesión?",
            "Cerrar",
          ).then((value) async {
            if (value == true) {
              // Add your sign out logic here
              await ref.read(authProvider.notifier).logout();

              CustomSnackbar.showSuccessSnackbar(
                "Has cerrado sesión",
                context,
                isFixed: true,
              );
            }
          });
                  },
                ),
                
              ],
            );
            // Container(
            //   height: 200,
            //   color: Colors.white,
            //   child: Center(
            //     child: Text('Menú de Configuración de Usuario'),
            //   ),
            // );
          },
        );
      },
      icon: const Icon(Icons.manage_accounts),
      // icon: const Icon(Icons.settings),
    );
  }
}