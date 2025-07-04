import 'package:intl/intl.dart';

class DateTimeInputFormatter {
  // static String format(DateTime dateTime) {
  //   return '${dateTime.year.toString().padLeft(4, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
  // }

  // static DateTime parse(String dateString) {
  //   final parts = dateString.split('-');
  //   if (parts.length != 3) {
  //     throw FormatException('Invalid date format: $dateString');
  //   }
  //   return DateTime(
  //     int.parse(parts[0]),
  //     int.parse(parts[1]),
  //     int.parse(parts[2]),
  //   );
  // }

  static DateFormat inputFormat = DateFormat('dd/MM/yyyy HH:mm');
  // static Future<void> format(DateTime selectedDate) async {
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: selectedDate,
  //     firstDate: DateTime(2015, 8),
  //     lastDate: DateTime(2101),
  //   );
  //   if (picked != null && picked != selectedDate) {
  //     setState(() {
  //       selectedDate = picked;
  //     });
  //   }
  // }
}
