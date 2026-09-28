import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scounter_mobile/features/turnarounds/domain/domain.dart';
import 'package:scounter_mobile/features/turnarounds/presentation/providers/providers.dart';

class AsignarCountersDialog extends ConsumerStatefulWidget {
  final int turnaroundId;
  final List<PosicionCounter>? posicion;

  const AsignarCountersDialog({
    super.key,
    required this.turnaroundId,
    this.posicion,
  });

  @override
  ConsumerState<AsignarCountersDialog> createState() => _AsignarCountersDialogState();
}

class _AsignarCountersDialogState extends ConsumerState<AsignarCountersDialog> {
  final List<int> _selectedCounterIds = [];

  @override
  void initState() {
    super.initState();

    // Precargar las posiciones asignadas previamente
    if (widget.posicion != null && widget.posicion!.isNotEmpty) {
      _selectedCounterIds.addAll(
        widget.posicion!.map((p) => p.posicion),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final counterState = ref.watch(counterProvider);

    // Filtrar la lista de counters asignados para renderizar los Chips
    final selectedCountersList = counterState.counters
        .where((counter) => _selectedCounterIds.contains(counter.id))
        .toList();

    return AlertDialog(
      title: const Text('Asignar Counters'),
      content: counterState.isLoading
          ? const SizedBox(
              height: 150,
              child: Center(child: CircularProgressIndicator()),
            )
          : SizedBox(
              width: double.maxFinite,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // --- SECCIÓN 1: CHIPS DE COUNTERS SELECCIONADOS ---
                    const Text(
                      'Seleccionados:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    _selectedCounterIds.isEmpty
                        ? const Text(
                            'Ningún counter seleccionado',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          )
                        : Wrap(
                            spacing: 2.0,
                            runSpacing: 2.0,
                            children: selectedCountersList.map((counter) {
                              return Chip(
                                label: Text(counter.numero ?? 'Counter ${counter.id}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold ),),
                                deleteIcon: const Icon(Icons.cancel, size: 18),
                                onDeleted: () {
                                  setState(() {
                                    _selectedCounterIds.remove(counter.id);
                                  });
                                },
                                // backgroundColor: const Color(0xFF0FA45F).withOpacity(0.15),
                                deleteIconColor: const Color(0xFF0FA45F),
                              );
                            }).toList(),
                          ),

                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 8),

                    // --- SECCIÓN 2: BOXES / CUADRÍCULA DE COUNTERS DISPONIBLES ---
                    const Text(
                      'Counters Disponibles:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 12),
                    
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, // Número de cajas por fila
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 2.2, // Proporción de la caja
                      ),
                      itemCount: counterState.counters.length,
                      itemBuilder: (context, index) {
                        final counter = counterState.counters[index];
                        final isSelected = _selectedCounterIds.contains(counter.id);

                        return InkWell(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                _selectedCounterIds.remove(counter.id);
                              } else {
                                _selectedCounterIds.add(counter.id);
                              }
                            });
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.surfaceVariant,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isSelected
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.grey.shade400,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              counter.numero ?? 'C-${counter.id}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: isSelected
                                    ? Theme.of(context).colorScheme.onPrimary
                                    : Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () async {
            final response = await ref.read(counterProvider.notifier).asignarCounters(
                  turnaroundId: widget.turnaroundId,
                  posicionIds: _selectedCounterIds,
                );

            if (mounted) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(response.message)),
              );
            }
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}