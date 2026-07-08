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

Future<bool?> showConfirmationDialogNoClose2({
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
        onConfirm: () { return ;}, // Pass value directly
        // onConfirm: () => Navigator.of(context).pop(false), // Pass value directly
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
        titlePadding: const EdgeInsets.only(
          top: 20,
          left: 20,
          right: 20,
          bottom: 10,
        ),
        // white background
        backgroundColor: Colors.white,
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
            // onPressed: () => Navigator.of(context).pop(true),
            onPressed: () => true,
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

Future<void> showErrorListDialog({
  required BuildContext context,
  required String message,
  List<String>? errorList,
  String closeText = 'Cerrar',
  String? title,
}) async {
  await showDialog<void>(
    context: context,
    builder: (BuildContext dialogContext) {
      final theme = Theme.of(dialogContext);
      final hasErrors = errorList != null && errorList.isNotEmpty;

      return AlertDialog(
        title: title == null
            ? null
            : Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
        contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
                height: 1.4,
              ),
            ),
            if (hasErrors) ...[
              const SizedBox(height: 16),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(dialogContext).size.height * 0.3,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: errorList.map((error) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0, right: 10.0),
                              child: Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: Colors.red[400],
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                error,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.black87,
                                  height: 1.3,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              closeText,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      );
    },
  );
}
