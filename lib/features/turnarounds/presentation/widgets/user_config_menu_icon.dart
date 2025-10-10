import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UserConfigMenuIcon extends StatelessWidget {
  const UserConfigMenuIcon({super.key});

  @override
  Widget build(BuildContext context) {
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
                  // onTap: () {
                  //   // Acción al seleccionar esta opción
                  // },
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
      icon: const Icon(Icons.settings),
    );
  }
}