import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Asegúrate de tener flutter_svg en tu pubspec.yaml

class CustomDateTimePickerDialog extends StatefulWidget {
  final DateTime? initialDate;
  final String title;

  const CustomDateTimePickerDialog({super.key, this.initialDate, required this.title});

  @override
  State<CustomDateTimePickerDialog> createState() => _CustomDateTimePickerDialogState();
}

class _CustomDateTimePickerDialogState extends State<CustomDateTimePickerDialog> {
  late DateTime selectedDate;

  // Define aquí tus strings de SVG o rutas de archivos
  final String svgArrowUp = '''<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M18 15L12 9L6 15" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/></svg>''';
  final String svgArrowDown = '''<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M6 9L12 15L18 9" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/></svg>''';

  Timer? _repeatTimer;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate ?? 
        DateTime.now().copyWith(second: 0, millisecond: 0, microsecond: 0);
  }

  void _cancelRepeatTimer() {
    _repeatTimer?.cancel();
    _repeatTimer = null;
  }

  void _startRepeat(VoidCallback action) {
    action();
    _repeatTimer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      action();
    });
  }

  void _updateHour(int delta) {
    setState(() => selectedDate = selectedDate.add(Duration(hours: delta)));
  }

  void _updateMinute(int delta) {
    setState(() => selectedDate = selectedDate.add(Duration(minutes: delta)));
  }

  void _showCombinedTimePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white, // Fondo blanco en el modal
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (BuildContext context) {
        return Container(
          height: 300,
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Ajustar Hora", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    TextButton(onPressed: () => Navigator.pop(context), child: const Text("Listo")),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _cupertinoColumn(24, selectedDate.hour, (v) => setState(() => selectedDate = selectedDate.copyWith(hour: v))),
                    const SizedBox(width: 10),
                    const Text(":", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 10),
                    _cupertinoColumn(60, selectedDate.minute, (v) => setState(() => selectedDate = selectedDate.copyWith(minute: v))),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _cupertinoColumn(int count, int initial, Function(int) onChanged) {
    return SizedBox(
      width: 70,
      child: CupertinoPicker(
        scrollController: FixedExtentScrollController(initialItem: initial),
        itemExtent: 40,
        selectionOverlay: const CupertinoPickerDefaultSelectionOverlay(background: Colors.transparent), // Quita bordes del selector
        onSelectedItemChanged: onChanged,
        children: List.generate(count, (i) => Center(child: Text(i.toString().padLeft(2, '0'), style: const TextStyle(fontSize: 24)))),
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(data: Theme.of(context).copyWith(dialogTheme: DialogThemeData(backgroundColor: Colors.white)), child: child!);
      },
    );
    if (picked != null) {
      setState(() => selectedDate = DateTime(picked.year, picked.month, picked.day, selectedDate.hour, selectedDate.minute));
    }
  }

  // add 1 day to the selected date
  void _addDay() {
    setState(() => selectedDate = selectedDate.add(const Duration(days: 1)));
  }

  // subtract 1 day from the selected date
  void _subtractDay() {
    setState(() => selectedDate = selectedDate.subtract(const Duration(days: 1)));
  }

  @override
  void dispose() {
    _cancelRepeatTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white, // Fondo del diálogo blanco
      surfaceTintColor: Colors.white, // Evita el tinte de Material 3
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      // title: Center(
      //   child: Text(
      //     widget.title, 
      //     style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20), 
      //     textAlign: TextAlign.center, // Centers the text lines internally
      //     softWrap: true, // Allows wrapping to a new line
      //   ),
      // ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Input de Fecha sin bordes (ListTile limpio)
          Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 241, 241, 241),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: _subtractDay,
                    child: Container(
                      width: 44,
                      height: 44,
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        'assets/icons/Arrow Drop Left.svg',
                        width: 18,
                        height: 18,
                        colorFilter: const ColorFilter.mode(
                          Colors.black26,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: _selectDate,
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8 , horizontal: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Fecha: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: _addDay,
                    child: Container(
                      width: 44,
                      height: 44,
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        'assets/icons/Arrow Drop Right.svg',
                        width: 18,
                        height: 18,
                        colorFilter: const ColorFilter.mode(
                          Colors.black26,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _timeColumn("Horas", selectedDate.hour, () => _updateHour(1), () => _updateHour(-1), _showCombinedTimePicker),
              const Padding(
                padding: EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 20),
                child: Text(":", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              ),
              _timeColumn("Minutos", selectedDate.minute, () => _updateMinute(1), () => _updateMinute(-1), _showCombinedTimePicker),
            ],
          ),
        ],
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 40, // Aumentado ~10px del estándar
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    foregroundColor: Colors.black87,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text("Cancelar"),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: SizedBox(
                height: 40, // Aumentado ~10px del estándar
                child: TextButton(
                  onPressed: () => Navigator.pop(context, selectedDate),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text("Guardar"),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _timeColumn(String label, int value, VoidCallback onUp, VoidCallback onDown, VoidCallback onTap) {
    return Column(
      children: [
        // Flecha Arriba SVG
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onUp,
          onLongPressStart: (_) => _startRepeat(onUp),
          onLongPressEnd: (_) => _cancelRepeatTimer(),
          onLongPressCancel: _cancelRepeatTimer,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 18, top: 10, left: 8, right: 8),
            // From assets
            child: SvgPicture.asset('assets/icons/Arrow Drop Up.svg', width: 24, height: 24, colorFilter: const ColorFilter.mode(Colors.black38, BlendMode.srcIn)),
            // child: SvgPicture.string(svgArrowUp, width: 20, height: 20, colorFilter: const ColorFilter.mode(Colors.black54, BlendMode.srcIn)),
            // child: const Icon(Icons.keyboard_arrow_up, size: 20), // Icono original comentado
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 80, height: 80,
            decoration: BoxDecoration(
              color: Colors.grey[200], // Fondo muy suave, casi blanco
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.transparent), // Sin bordes visibles
            ),
            child: Center(
              child: Text(value.toString().padLeft(2, '0'), 
                  style: const TextStyle(fontFamily: 'OpenSans', fontSize:55, fontWeight: FontWeight.w900)),
            ),
          ),
        ),
        // Flecha Abajo SVG
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onDown,
          onLongPressStart: (_) => _startRepeat(onDown),
          onLongPressEnd: (_) => _cancelRepeatTimer(),
          onLongPressCancel: _cancelRepeatTimer,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10, top: 18, left: 8, right: 8),
            child: SvgPicture.asset('assets/icons/Arrow Drop Down.svg', width: 24, height: 24, colorFilter: const ColorFilter.mode(Colors.black38, BlendMode.srcIn)),
            // child: const Icon(Icons.keyboard_arrow_down, size: 20), // Icono original comentado
          ),
        ),
        Text(label, style: const TextStyle(color: Color.fromARGB(255, 80, 80, 80), fontSize: 16)),
      ],
    );
  }
}