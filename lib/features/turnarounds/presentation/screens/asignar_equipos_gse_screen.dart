import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/providers.dart';

class AsignarEquiposGseScreen extends ConsumerWidget {
  const AsignarEquiposGseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final turnaround = ref.watch(selectedTurnaroundProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Asignar Equipos GSE')),
      body: _AsignarEquiposGseView(),
    );
  }
}

class _AsignarEquiposGseView extends ConsumerStatefulWidget {
  const _AsignarEquiposGseView({super.key});

  @override
  ConsumerState<_AsignarEquiposGseView> createState() =>
      _AsignarEquiposGseViewState();
}

class _AsignarEquiposGseViewState
    extends ConsumerState<_AsignarEquiposGseView> {
  // initstate
  @override
  void initState() {
    super.initState();
    // getCategoriasEquiposGse
    ref.read(categoriasEquiposGseProvider.notifier).getCategoriasEquiposGse();
  }

  @override
  Widget build(BuildContext context) {
    final categorias = ref.watch(categoriasEquiposGseProvider);
    // List builder
    return ListView.builder(
      itemCount:
          categorias.categoriasEquiposGseResponse?.categoriasEquiposGse.length,
      itemBuilder: (context, index) {
        final categoria = categorias
            .categoriasEquiposGseResponse
            ?.categoriasEquiposGse[index];
        return ListTile(title: Text(categoria?.categoriaNombre ?? ''));
      },
    );
  }
}
