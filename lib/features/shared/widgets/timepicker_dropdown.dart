import 'package:flutter/material.dart';

class TimePicker24Hour extends StatefulWidget {
  final TimeOfDay? initialTime;
  final ValueChanged<TimeOfDay>? onTimeChanged;
  final double containerHeight;
  final double containerWidth;

  const TimePicker24Hour({
    super.key,
    this.initialTime,
    this.onTimeChanged,
    this.containerHeight = 200,
    this.containerWidth = 300,
  });

  @override
  State<TimePicker24Hour> createState() => _TimePicker24HourState();
}

class _TimePicker24HourState extends State<TimePicker24Hour> {
  int _selectedHour = 0;
  int _selectedMinute = 0;

  @override
  void initState() {
    super.initState();
    _initializeTime();
  }

  void _initializeTime() {
    final now = TimeOfDay.now();
    if (widget.initialTime != null) {
      _selectedHour = widget.initialTime!.hour;
      _selectedMinute = widget.initialTime!.minute;
    } else {
      _selectedHour = now.hour;
      _selectedMinute = now.minute;
    }
  }

  List<DropdownMenuItem<int>> _getHourItems() {
    return List.generate(24, (hour) {
      return DropdownMenuItem<int>(
        value: hour,
        child: Text(
          hour.toString().padLeft(2, '0'),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      );
    });
  }

  List<DropdownMenuItem<int>> _getMinuteItems() {
    return List.generate(60, (minute) {
      return DropdownMenuItem<int>(
        value: minute,
        child: Text(
          minute.toString().padLeft(2, '0'),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      );
    });
  }

  void _onHourChanged(int? hour) {
    if (hour != null) {
      setState(() {
        _selectedHour = hour;
      });
      _notifyTimeChanged();
    }
  }

  void _onMinuteChanged(int? minute) {
    if (minute != null) {
      setState(() {
        _selectedMinute = minute;
      });
      _notifyTimeChanged();
    }
  }

  void _notifyTimeChanged() {
    widget.onTimeChanged?.call(
      TimeOfDay(hour: _selectedHour, minute: _selectedMinute),
    );
  }

  String get _formattedTime {
    return '${_selectedHour.toString().padLeft(2, '0')}:${_selectedMinute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Hours dropdown
        _buildDropdown(
          value: _selectedHour,
          items: _getHourItems(),
          onChanged: _onHourChanged,
          label: 'Horas',
        ),

        const Padding(
          padding: EdgeInsets.only(
            left: 8,
            right: 8,
            top: 20,
            // bottom: 12,
          ),
          child: Text(
            ':',
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
        ),

        // Minutes dropdown
        _buildDropdown(
          value: _selectedMinute,
          items: _getMinuteItems(),
          onChanged: _onMinuteChanged,
          label: 'Minutos',
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required int value,
    required List<DropdownMenuItem<int>> items,
    required ValueChanged<int?> onChanged,
    required String label,
  }) {
    return Column(
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 4),
        Container(
          width: 110,
          // height: 60,
          padding: const EdgeInsets.only(
            left: 24,
            right: 12,
            top: 12,
            bottom: 12,
          ),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
            // border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownButton<int>(
            value: value,
            items: items,
            alignment: Alignment.center,
            itemHeight: null,
            onChanged: onChanged,
            isExpanded: true,
            underline: const SizedBox(), // Remove default underline
            icon: const Icon(Icons.arrow_drop_down, size: 24),
            iconSize: 18,
            elevation: 16,
            menuMaxHeight: 300,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            dropdownColor: Colors.white,
            borderRadius: BorderRadius.circular(8),
            selectedItemBuilder: (BuildContext context) {
              return items.map((DropdownMenuItem<int> item) {
                return Text(
                  item.value.toString().padLeft(2, '0'),
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.normal,
                    color: Colors.black87,
                  ),
                );
              }).toList();
            },
          ),
        ),
      ],
    );
  }
}

// import 'package:flutter/material.dart';

// class TimePickerDropdown extends StatefulWidget {
//   const TimePickerDropdown({super.key});

//   @override
//   TimePickerDropdownState createState() => TimePickerDropdownState();
// }

// class TimePickerDropdownState extends State<TimePickerDropdown> {
//   int selectedHour = TimeOfDay.now().hour;
//   int selectedMinute = TimeOfDay.now().minute;
//   String selectedAmPm = 'AM';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           Text(
//             'Selected Time: $selectedHour:$selectedMinute $selectedAmPm',
//             style: const TextStyle(fontSize: 20),
//           ),
//           DropdownButton<int>(
//             value: selectedHour,
//             onChanged: (int? newValue) {
//               setState(() {
//                 selectedHour = newValue!;
//               });
//             },
//             items: List<DropdownMenuItem<int>>.generate(24, (int index) {
//               return DropdownMenuItem<int>(value: index, child: Text('$index'));
//             }),
//           ),
//           DropdownButton<int>(
//             value: selectedMinute,
//             onChanged: (int? newValue) {
//               setState(() {
//                 selectedMinute = newValue!;
//               });
//             },
//             items: List<DropdownMenuItem<int>>.generate(60, (int index) {
//               return DropdownMenuItem<int>(value: index, child: Text('$index'));
//             }),
//           ),
//           DropdownButton<String>(
//             value: selectedAmPm,
//             onChanged: (String? newValue) {
//               setState(() {
//                 selectedAmPm = newValue!;
//               });
//             },
//             items: const <DropdownMenuItem<String>>[
//               DropdownMenuItem<String>(value: 'AM', child: Text('AM')),
//               DropdownMenuItem<String>(value: 'PM', child: Text('PM')),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
