import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final Color? confirmColor;
  final Color? cancelColor;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    this.confirmColor,
    this.cancelColor,
    required this.onConfirm,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false); // Return false on cancel
            onCancel?.call();
          },
          style: TextButton.styleFrom(
            foregroundColor: cancelColor ?? Colors.grey[700],
          ),
          child: Text(cancelText, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(true); // Return true on confirm
            onConfirm();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: confirmColor ?? Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(confirmText, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          ),
        ),
      ],
    );
  }
}