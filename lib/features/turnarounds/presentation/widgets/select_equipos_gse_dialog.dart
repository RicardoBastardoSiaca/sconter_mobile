import 'package:flutter/material.dart';

import '../../domain/domain.dart';

class SelectEquiposGseDialog extends StatelessWidget {
  CategoriaEquiposGse categoria;
  SelectEquiposGseDialog({super.key, required this.categoria});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(children: [ListTile(title: Text('Equipos GSE'))]),
    );
  }
}
