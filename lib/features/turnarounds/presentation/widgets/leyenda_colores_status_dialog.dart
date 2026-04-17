import 'package:flutter/material.dart';
import 'package:scounter_mobile/features/turnarounds/presentation/widgets/leyeda_status_colores.dart';


class LeyendaColoresStatusDialog extends StatelessWidget {
  const LeyendaColoresStatusDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Center(child: const Text('Estatus', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
              content: const LeyendaColoresTurnarounds(),
              // actions: [
              //   TextButton(
              //     onPressed: () {
              //       Navigator.of(context).pop();
              //     },
              //     child: const Text('Cerrar'),
              //   ),
              // ],
            );
          },
        );
      },
      icon: const Icon(Icons.emoji_objects,),
      // icon: const Icon(Icons.list,),
      // icon: const Icon(Icons.format_list_bulleted),
    );
  }
}