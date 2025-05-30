import 'package:flutter/material.dart';


class Labels extends StatelessWidget {
  const Labels({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('¿No tienes una cuenta?'),
        RichText(
          text: TextSpan(
            text: 'Crea una',
            style: TextStyle(
              // Material blue
              color: Colors.blue,
              // decoration: TextDecoration.underline,
              fontSize: Theme.of(context).textTheme.bodyLarge?.fontSize,
              fontFamily: Theme.of(context).textTheme.bodyMedium?.fontFamily,
            ),
          ),
        )
      ],
    );
  }
}
