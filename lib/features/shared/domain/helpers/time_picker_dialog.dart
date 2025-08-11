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
      initialTime: initialTime != null
          ? TimeOfDay.fromDateTime(hora)
          : TimeOfDay.now(),
    );
    return selectedTime;
  }
}
