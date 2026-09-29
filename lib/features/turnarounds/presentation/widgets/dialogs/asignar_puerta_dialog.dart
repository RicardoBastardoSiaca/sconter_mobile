import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scounter_mobile/features/shared/shared.dart';
import 'package:scounter_mobile/features/turnarounds/domain/domain.dart';
import 'package:scounter_mobile/features/turnarounds/presentation/providers/providers.dart';

class AsignarPuertaDialog extends ConsumerStatefulWidget {
  final int turnaroundId;
  final PuertaResponse? puerta; // Puerta actualmente asignada (si existe)

  const AsignarPuertaDialog({
    super.key,
    required this.turnaroundId,
    this.puerta,
  });

  @override
  ConsumerState<AsignarPuertaDialog> createState() =>
      _AsignarPuertaDialogState();
}

class _AsignarPuertaDialogState extends ConsumerState<AsignarPuertaDialog> {
  int? puertaSeleccionadaId;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.puerta != null) {
        setState(() {
          puertaSeleccionadaId = widget.puerta!.puerta;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final puertaState = ref.watch(puertaProvider);
    final theme = Theme.of(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: const Row(
        children: [
          Icon(Icons.sensor_door_outlined, color: Colors.green),
          SizedBox(width: 10),
          Text(
            'Asignar Puerta',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: puertaState.isLoading
            ? const SizedBox(
                height: 120,
                child: Center(child: CircularProgressIndicator()),
              )
            : puertaState.puertas.isEmpty
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      'No se encontraron puertas disponibles para esta terminal.',
                      textAlign: TextAlign.center,
                    ),
                  )
                : ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.45,
                    ),
                    child: GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, // 3 cajas por fila
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 1.1,
                      ),
                      itemCount: puertaState.puertas.length,
                      itemBuilder: (context, index) {
                        final puerta = puertaState.puertas[index];
                        final isSelected = puertaSeleccionadaId == puerta.id;

                        // Extrae solo el número o identificador corto (ej. "Puerta 3" -> "3")
                        final numeroPuerta = puerta.nombre != null
                            ? puerta.nombre!.replaceAll(RegExp(r'[^\d]'), '')
                            : '${puerta.id}';
                        
                        final textoMostrar = numeroPuerta.isNotEmpty
                            ? numeroPuerta
                            : '${puerta.id}';

                        return InkWell(
                          onTap: isSaving
                              ? null
                              : () {
                                  setState(() {
                                    puertaSeleccionadaId = puerta.id;
                                  });
                                },
                          borderRadius: BorderRadius.circular(12),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.surfaceContainerHighest.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? theme.colorScheme.primary
                                    : Colors.grey.shade300,
                                width: isSelected ? 2 : 1,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: theme.colorScheme.primary.withOpacity(0.3),
                                        blurRadius: 6,
                                        offset: const Offset(0, 3),
                                      ),
                                    ]
                                  : [],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.meeting_room_outlined,
                                  size: 22,
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.grey.shade700,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  textoMostrar,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected
                                        ? Colors.white
                                        : theme.textTheme.bodyLarge?.color,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
      ),
      actions: [
        TextButton(
          onPressed: isSaving ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: (isSaving || puertaSeleccionadaId == null)
              ? null
              : () async {
                  setState(() {
                    isSaving = true;
                  });

                  final response = await ref
                      .read(puertaProvider.notifier)
                      .asignarPuerta(
                        turnaroundId: widget.turnaroundId,
                        puertaId: puertaSeleccionadaId!,
                      );

                  setState(() {
                    isSaving = false;
                  });

                  if (!mounted) return;

                  if (response.success) {
                    ref.read(turnaroundProvider.notifier).getTurnarounds();
                    Navigator.of(context).pop();
                    showCustomSuccessSnackbar(
                      context,
                      response.message.isNotEmpty
                          ? response.message
                          : 'Puerta asignada.',
                    );
                  } else {
                    showCustomErrorSnackbar(
                      context,
                      response.message,
                    );
                  }
                },
          child: isSaving
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text('Guardar'),
        )
      ],
    );
  }
}