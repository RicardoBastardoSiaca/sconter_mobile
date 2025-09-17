import 'package:flutter/material.dart';

class CustomTimePickerDialog {
  static Future<TimeOfDay?> showTimePickerDialog(
    BuildContext context,
    // WidgetRef ref,
    DateTime hora,
    TimeOfDay? initialTime,
  ) async {
    final selectedTime = await showTimePicker(
      confirmText: 'Seleccionar',
      cancelText: 'Cancelar',
      minuteLabelText: 'Minutos',
      hourLabelText: 'Horas',
      useRootNavigator: true,
      initialEntryMode: TimePickerEntryMode.input,
      helpText: 'Seleccionar hora',
      context: context,
      builder: (context, childWidget) {
        return MediaQuery(
        data: MediaQuery.of(context).copyWith(
        // textScaler: TextScaler.linear(1)),
        textScaler: TextScaler.linear(0.77)),
        child: childWidget!,
        );
      },
      initialTime: initialTime != null
          ? TimeOfDay.fromDateTime(hora)
          : TimeOfDay.now(),
    );
    return selectedTime;
  }
}
