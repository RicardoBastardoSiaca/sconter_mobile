import 'package:flutter/material.dart';

class ConfirmarDialog {
  static Future<bool> mostrar(
    BuildContext context, {
    String mensaje = "¿Está seguro que desea realizar esta acción?",
  }) async {
    // El resultado de showDialog se guarda en la variable 'resultado'
    final resultado = await showDialog<bool>(
      context: context,
      barrierDismissible: false, // Obliga al usuario a presionar un botón
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          content: Text(mensaje),
          actions: <Widget>[
            // Botón "No" en rojo
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                                // primary
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
              ),
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text(
                "No",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // TextButton(
            //   onPressed: () => Navigator.of(context).pop(false),
            //   child: const Text(
            //     "No",
            //     style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            //   ),
            // ),
            // Botón "Si" en verde
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                                // primary
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
              ),
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text(
                "Si",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // TextButton(
            //   onPressed: () => Navigator.of(context).pop(true),
            //   child: const Text(
            //     "Si",
            //     style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
            //   ),
            // ),
          ],
        );
      },
    );

    // Si el resultado es null (por algún error raro), devolvemos false por seguridad
    return resultado ?? false;
  }
}