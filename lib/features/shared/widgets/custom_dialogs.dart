// a class with custom dialog widgets

import 'package:flutter/material.dart';

class CustomDialog {
  static Future<bool> showConfirmationDialog(
    BuildContext context,
    String title,
    String content,
    String confirmText,
  ) async {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        return AlertDialog(
          title: Text(title),
          content: Text(content, style: theme.textTheme.bodySmall),
          // backgroundColor: Colors.transparent,
          // shape: RoundedRectangleBorder(
          //   borderRadius: BorderRadius.circular(16.0),
          // ),
          // elevation
          elevation: 4,
          backgroundColor: Colors.white,
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              style: ElevatedButton.styleFrom(
                // backgroundColor: Colors.transparent,
                backgroundColor: Colors.grey.shade100,
                // foregroundColor: theme.colorScheme.primary,
                // foregroundColor: Colors.black54,
                padding: const EdgeInsets.all(16.0),

                // remove border
                side: BorderSide(color: Colors.transparent),
                // border: Border.all(color: Colors.black38),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  // side: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              child: Text(
                'Cancelar',
                style: theme.textTheme.bodyMedium?.copyWith(
                  // color: theme.colorScheme.primary,
                  color: Colors.black54,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Perform confirm action
                Navigator.of(context).pop(true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
              child: Text(
                confirmText,
                style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white),
              ),
            ),
          ],
        );
      },
    ).then((value) => value ?? false);
  }
}

            //     backgroundColor: Colors.transparent,
            //     padding: const EdgeInsets.all(16.0),

            //     // border
            //   ),
            //   child: Text(
            //     'Cancelar',
            //     style: Theme.of(
            //       context,
            //     ).textTheme.bodyMedium?.copyWith(color: Colors.black87),
            //   ),
            // ),
            
            // TextButton(
            //   onPressed: () {
            //     // Perform confirm action
            //     Navigator.of(context).pop(true);
            //   },
            //   style: TextButton.styleFrom(
            //     backgroundColor: Theme.of(context).colorScheme.primary,
            //     foregroundColor: Colors.white,
            //     padding: const EdgeInsets.all(16.0),
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(16.0),
            //     ),
            //   ),
            //   child: Text(
            //     confirmText,
            //     style: Theme.of(
            //       context,
            //     ).textTheme.bodyLarge?.copyWith(color: Colors.white),
            //   ),
            // ),
          // ],
        // );
      // },
    // ).then((value) => value ?? false);
  // }
// }
