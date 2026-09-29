import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scounter_mobile/features/turnarounds/domain/domain.dart';
import 'package:scounter_mobile/features/turnarounds/presentation/providers/providers.dart';

class TerminalFilterDropdown extends ConsumerWidget {
  const TerminalFilterDropdown({super.key});

  static const int allTerminalsValue = -1;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final terminalState = ref.watch(terminalProvider);
    final selectedTerminal = ref.watch(selectedTerminalFilterProvider);

    if (terminalState.isLoading) {
      return const SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }

    final terminals = terminalState.terminales;

    return PopupMenuButton<int>(
      tooltip: 'Filtrar por terminal',
      initialValue: selectedTerminal?.id ?? allTerminalsValue,
      onSelected: (int terminalId) {
        if (terminalId == allTerminalsValue) {
          ref.read(selectedTerminalFilterProvider.notifier).state = null;
        } else {
          final selected = terminals.firstWhere(
            (t) => t.id == terminalId,
            orElse: () => terminals.first,
          );
          ref.read(selectedTerminalFilterProvider.notifier).state = selected;
        }
      },
      itemBuilder: (BuildContext context) {
        return [
          const PopupMenuItem<int>(
            value: allTerminalsValue,
            child: Text("Todas", style: TextStyle(fontSize: 14)),
          ),
          ...terminals.map((terminal) {
            return PopupMenuItem<int>(
              value: terminal.id,
              child: Text(
                terminal.nombre,
                style: const TextStyle(fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
            );
          }),
        ];
      },
      child: Container(
        width: 140, // <-- Define un ancho fijo adecuado para el botón
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          // color: const Color(0xFFEEEEEE),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                selectedTerminal?.nombre ?? 'Terminales',
                style: TextStyle(
                  fontSize: 16,
                  // color: selectedTerminal == null ? Colors.black54 : Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}