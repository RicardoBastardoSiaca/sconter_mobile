import 'package:flutter/material.dart';
import 'confirmation_dialog.dart';

Future<bool?> showConfirmationDialog({
  required BuildContext context,
  required String title,
  required String message,
  String confirmText = 'Confirmar',
  String cancelText = 'Cancelar',
  Color? confirmColor,
  Color? cancelColor,
}) async {
  return await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return ConfirmationDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        confirmColor: confirmColor,
        cancelColor: cancelColor,
        onConfirm: () => Navigator.of(context).pop(true), // Pass value directly
        onCancel: () => Navigator.of(context).pop(false), // Pass value directly
      );
    },
  );
}

// Enhanced version with custom content
Future<bool?> showCustomConfirmationDialog({
  required BuildContext context,
  required String title,
  required Widget content,
  String confirmText = 'Confirm',
  String cancelText = 'Cancel',
  Color? confirmColor,
  Color? cancelColor,
  bool barrierDismissible = true,
}) async {
  return await showDialog<bool>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: content,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            style: TextButton.styleFrom(
              foregroundColor: cancelColor ?? Colors.grey[700],
            ),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: confirmColor ?? Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text(confirmText),
          ),
        ],
      );
    },
  );
}
