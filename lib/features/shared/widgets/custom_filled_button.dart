import 'package:flutter/material.dart';

class CustomFilledButton extends StatelessWidget {
  final void Function()? onPressed;
  final String text;
  final Color? buttonColor;
  // text Color

  const CustomFilledButton({
    super.key,
    this.onPressed,
    required this.text,
    this.buttonColor,
  });

  @override
  Widget build(BuildContext context) {
    const radius = Radius.circular(30);

    return FilledButton(
      style: FilledButton.styleFrom(
        // primary
        backgroundColor: buttonColor ?? Theme.of(context).primaryColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(radius),
        ),
      ),

      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
