import 'package:flutter/material.dart';

class ComentarioInuputDialog extends StatefulWidget {
  final String titulo;
  final String label;
  final String textoBotonAceptar;
  final String textoBotonCancelar;

  const ComentarioInuputDialog({
    super.key,
    this.titulo = 'Comentario',
    this.label = 'Escribe aquí...',
    this.textoBotonAceptar = 'Aceptar',
    this.textoBotonCancelar = 'Cancelar',
  });

  @override
  State<ComentarioInuputDialog> createState() => _ComentarioInuputDialogState();
}

class _ComentarioInuputDialogState extends State<ComentarioInuputDialog> {
  // Controlador para obtener el texto del input
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.titulo),
      content: TextField(
        controller: _controller,
        maxLines: 5, // Esto lo convierte en un "textarea"
        decoration: InputDecoration(
          hintText: widget.label,
          // border: const OutlineInputBorder(),
          border: null,
          fillColor: Colors.grey[200],
        ),
      ),
      actions: <Widget>[
        // Botón para salir sin enviar nada
        FilledButton(
          onPressed: () => Navigator.pop(context, null),
          style: FilledButton.styleFrom(backgroundColor: Colors.grey),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              widget.textoBotonCancelar,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        // Botón para aceptar y devolver el comentario
        FilledButton(
          onPressed: () {
            // _controller.clear();
            Navigator.pop(context, _controller.text);
          },

          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              widget.textoBotonAceptar,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
