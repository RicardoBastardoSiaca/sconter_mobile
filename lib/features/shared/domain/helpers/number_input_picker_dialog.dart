import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CantidadDialog extends StatefulWidget {
  final int maxQuantity;
  final int initialValue;
  final String unit; // Nueva propiedad para la unidad
  final String? title;

  const CantidadDialog({
    super.key,
    this.maxQuantity = 999,
    required this.initialValue,
    this.unit = "", // Valor por defecto
    this.title,
  });

  @override
  _CantidadDialogState createState() => _CantidadDialogState();
}

class _CantidadDialogState extends State<CantidadDialog> {
  late TextEditingController _controller = TextEditingController(text: "1");
  Timer? _timer;
  String? _errorText; // Variable para manejar el error

  @override
  void initState() {
    super.initState();
    // 1. Determinamos el valor inicial basándonos en los límites.
    int valueToDisplay = widget.initialValue;

    if (valueToDisplay > widget.maxQuantity) {
      valueToDisplay = widget.maxQuantity;
    } else if (valueToDisplay < 0) {
      valueToDisplay = 0;
    }

    // 2. Inicializamos el controlador con el valor ya validado.
    _controller = TextEditingController(text: valueToDisplay.toString());
  }

  // SVG strings (puedes reemplazarlos por tus assets)
  final String svgUp =
      '''<svg width="40" height="40" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M18 15L12 9L6 15" stroke="black" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/></svg>''';
  final String svgDown =
      '''<svg width="40" height="40" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M6 9L12 15L18 9" stroke="black" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/></svg>''';

  void _updateValue(int delta) {
    setState(() => _errorText = null); // Limpiar error al interactuar
    int current = int.tryParse(_controller.text) ?? 0;
    int newValue = current + delta;

    // Lógica de límites
    if (newValue < 0) {
      newValue = 0;
    } else if (newValue > widget.maxQuantity) {
      newValue = widget.maxQuantity;
    }

    if (newValue != current) {
      setState(() {
        _controller.text = newValue.toString();
      });
    }
  }

  void _startTimer(int delta) {
    _updateValue(delta); // Primer click instantáneo
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      _updateValue(delta);
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool showUnit = widget.unit.length <= 8;
    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      title: widget.title != null ? Center(
        child: Text(
          widget.title!,
          style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20), 
          textAlign: TextAlign.center, // Centers the text lines internally
          softWrap: true, // Allows wrapping to a new line
        ),
      ): null,
      // SOLUCIÓN PARA LANDSCAPE: SingleChildScrollView + ConstrainedBox
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            // Flecha Arriba
            GestureDetector(
              onLongPressStart: (_) => _startTimer(1),
              onLongPressEnd: (_) => _stopTimer(),
              onTap: () => _updateValue(1),
              child: SvgPicture.asset(
                'assets/icons/Arrow Drop Up.svg',
                width: 24,
                height: 24,
                colorFilter: const ColorFilter.mode(
                  Colors.black38,
                  BlendMode.srcIn,
                ),
              ),
            ),
            const SizedBox(height: 25),

            // Input Central
            // TextField sin bordes de selección
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200], // Fondo muy suave, casi blanco
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.transparent,
                ), // Sin bordes visibles
              ),
              child:
                  // Área del Input Centrado
                  // Contenedor del número centrado y sufijo alineado al bottom
                  SizedBox(
                    width: double.maxFinite,
                    height:
                        90, // Un poco más alto para acomodar el error sin saltos
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: TextField(
                            controller: _controller,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(
                              fontSize: 55,
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                              height: 1.0,
                            ),
                            onChanged: (value) {
                              setState(
                                () => _errorText = null,
                              ); // Quitar error al escribir
                              int? val = int.tryParse(value);
                              if (val != null && val > widget.maxQuantity) {
                                _controller.text = widget.maxQuantity
                                    .toString();
                                _controller
                                    .selection = TextSelection.fromPosition(
                                  TextPosition(offset: _controller.text.length),
                                );
                              }
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                        if (showUnit)
                          Positioned(
                            right: 0,
                            bottom: 25,
                            child: IgnorePointer(
                              child: Text(
                                widget.unit,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        // MENSAJE DE ERROR DEBAJO DEL TEXTO
                        if (_errorText != null)
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              _errorText!,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 18,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                      ],
                    ),
                  ),
              //   TextField(
              //     controller: _controller,
              //     textAlign: TextAlign.center,
              //     keyboardType: TextInputType.number,
              //     style: TextStyle(
              //       fontSize: 55,
              //       fontWeight: FontWeight.w900,
              //       color: Colors.black,
              //       // backgroundColor: Colors.grey[200],
              //     ),
              //     onChanged: (value) {
              //     int? val = int.tryParse(value);
              //     if (val != null && val > widget.maxQuantity) {
              //       _controller.text = widget.maxQuantity.toString();
              //       _controller.selection = TextSelection.fromPosition(
              //         TextPosition(offset: _controller.text.length),
              //       );
              //     }
              //   },
              //     inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              //   decoration: InputDecoration(
              //     border: InputBorder.none,
              //     enabledBorder: InputBorder.none,
              //     focusedBorder: InputBorder.none,
              //     contentPadding: EdgeInsets.zero,
              //     // SuffixText coloca la unidad al lado del número
              //     suffixText: " ${widget.unit}",
              //     suffixStyle: const TextStyle(
              //       fontSize: 18,
              //       fontWeight: FontWeight.w400,
              //       color: Colors.grey,
              //     ),
              //   ),
              // ),
            ),

            const SizedBox(height: 25),

            // Flecha Abajo
            GestureDetector(
              onLongPressStart: (_) => _startTimer(-1),
              onLongPressEnd: (_) => _stopTimer(),
              onTap: () => _updateValue(-1),
              child: SvgPicture.asset(
                'assets/icons/Arrow Drop Down.svg',
                width: 24,
                height: 24,
                colorFilter: const ColorFilter.mode(
                  Colors.black38,
                  BlendMode.srcIn,
                ),
              ),
            ),

            const SizedBox(height: 10),
            // Text(
            //   "Máximo permitido: ${widget.maxQuantity}",
            //   style: TextStyle(color: Colors.grey[400], fontSize: 11),
            // ),
          ],
        ),
      ),
      actions: [
        // Botón Cancelar (Gris claro)
        Row(
          children: [
            // Botón Cancelar (50% de ancho)
            Expanded(
              child: SizedBox(
                height: 50,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    foregroundColor: Colors.black87,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("Cancelar"), // Titlecase
                ),
              ),
            ),
            const SizedBox(width: 12), // Espaciado entre botones
            // Botón Aceptar (50% de ancho)
            Expanded(
              child: SizedBox(
                height: 50,
                child: TextButton(
                  onPressed: () {
                    if (_controller.text.isEmpty) {
                      setState(() => _errorText = "Ingresa un valor");
                    } else {
                      Navigator.pop(context, int.tryParse(_controller.text));
                    }
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("Aceptar"), // Titlecase
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
