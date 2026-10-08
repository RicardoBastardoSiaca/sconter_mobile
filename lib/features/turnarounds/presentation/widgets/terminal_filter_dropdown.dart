import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scounter_mobile/features/turnarounds/domain/domain.dart';
import 'package:scounter_mobile/features/turnarounds/presentation/providers/providers.dart';

class TerminalFilterDropdown extends ConsumerWidget {
  final double menuFontSize;
  final double selectedFontSize;
  final double? height; // <- nuevo parámetro opcional

  const TerminalFilterDropdown({
    super.key,
    this.menuFontSize = 16.0,
    this.selectedFontSize = 16.0,
    this.height,
  });

  static const int allTerminalsValue = -1;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final terminalState = ref.watch(terminalProvider);
    final selectedTerminal = ref.watch(selectedTerminalFilterProvider);

    if (terminalState.isLoading) {
      return SizedBox(
        height: height ?? 24, // <- respeta la altura si se define
        width: 24,
        child: const CircularProgressIndicator(strokeWidth: 2),
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
          PopupMenuItem<int>(
            value: allTerminalsValue,
            child: Text(
              "Todas",
              style: TextStyle(fontSize: menuFontSize),
            ),
          ),
          ...terminals.map((terminal) {
            return PopupMenuItem<int>(
              value: terminal.id,
              child: Text(
                terminal.nombre,
                style: TextStyle(fontSize: menuFontSize),
                overflow: TextOverflow.ellipsis,
              ),
            );
          }),
        ];
      },
      child: Container(
        width: 140,
        height: height, // <- altura fija opcional
        padding: const EdgeInsets.symmetric(horizontal: 8),
        alignment: Alignment.centerLeft, // <- centra el contenido verticalmente
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                selectedTerminal?.nombre ?? 'Terminales',
                style: TextStyle(
                  fontSize: selectedFontSize,
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