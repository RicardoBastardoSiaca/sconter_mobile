import 'package:flutter/material.dart';

class PasajerosBoxContainer extends StatelessWidget {
  final String clase;
  final int cantidad;
  const PasajerosBoxContainer({
    super.key,
    required this.clase,
    required this.cantidad,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(clase),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(color: Colors.grey.shade200),
              child: Center(
                child: Text(
                  cantidad.toString(),
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
