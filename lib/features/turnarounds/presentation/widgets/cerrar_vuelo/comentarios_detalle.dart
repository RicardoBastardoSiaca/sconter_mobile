import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scounter_mobile/features/turnarounds/presentation/providers/providers.dart';
import 'package:scounter_mobile/features/turnarounds/presentation/widgets/widgets.dart';

class ComentariosDetalle extends ConsumerWidget {
  const ComentariosDetalle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Comentario
    final comentario = ref.watch(comentarioProvider);
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Comentarios:',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w400),
                ),
                ElevatedButton(
                  // disable if isLoading
                  onPressed: () async {
                    final result = await showDialog<String>(
                      context: context,
                      builder: (context) => const ComentarioInuputDialog(),
                    );

                    // Si el resultado no es nulo, lo procesamos
                    if (result != null) {
                      print("Comentario recibido: $result");
                      // Aquí puedes actualizar tu estado o enviar a una API
                      ref.read(comentarioProvider.notifier).state = result;
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(5),
                    fixedSize: const Size(45, 45),
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.primary, // <-- Button color
                    foregroundColor: Colors.red, // <-- Splash color
                  ),
                  child: Icon(Icons.edit_note, color: Colors.white, size: 32),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                comentario.isEmpty ? 'No hay comentarios.' : comentario,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
