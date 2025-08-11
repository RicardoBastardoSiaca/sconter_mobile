import 'package:flutter/material.dart';

class CustomSnackbar {
  static void showSnackbar(String message, BuildContext context) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void showLoadingSnackbar(
    String message,
    BuildContext context, {
    bool isFixed = false,
  }) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          CircularProgressIndicator(),
          SizedBox(width: 10),
          Text(message),
        ],
      ),
      duration: Duration(days: 1), // Keep it visible until dismissed
      behavior: isFixed ? SnackBarBehavior.fixed : SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void showErrorSnackbar(
    String message,
    BuildContext context, {
    bool isFixed = false,
  }) {
    final snackBar = SnackBar(
      // duration: const Duration(seconds: 2),
      content: Text(message),
      backgroundColor: Colors.red,
      behavior: isFixed ? SnackBarBehavior.fixed : SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void showSuccessSnackbar(
    String message,
    BuildContext context, {
    bool isFixed = false,
  }) {
    final snackBar = SnackBar(
      // duration: const Duration(seconds: 2),
      content: Text(message),
      backgroundColor: Colors.green,
      behavior: isFixed ? SnackBarBehavior.fixed : SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void hideSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  // response message
  static void showResponseSnackbar(
    String message,
    bool success,
    BuildContext context, {
    bool isFixed = false,
  }) {
    final snackBar = SnackBar(
      duration: const Duration(seconds: 5),
      padding: const EdgeInsets.all(25),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      // margin: const EdgeInsets.all(15),
      behavior: isFixed ? SnackBarBehavior.fixed : SnackBarBehavior.floating,
      elevation: 2,
      // Message content with a conditional icon based on success
      // content: Row(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: [
      //     success
      //         ? const Icon(Icons.check_circle, color: Colors.green, size: 30)
      //         : const Icon(Icons.error, color: Colors.red, size: 30),
      //     const SizedBox(width: 10),
      //     Text(message),
      //     // Text(message, style: const TextStyle(color: Colors.black)),
      //   ],
      // ),
      // backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      content: Center(
        child: Text(
          message,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: success
          ? Theme.of(context).colorScheme.primary
          : Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // Success snackbar without context
}
