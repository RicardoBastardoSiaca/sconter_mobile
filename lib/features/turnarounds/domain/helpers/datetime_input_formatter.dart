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

  static DateFormat displayFormat = DateFormat('dd/MM/yyyy');
  static DateFormat englishDisplayFormat = DateFormat('dd/MM/yyyy');
  static DateFormat displayFormatWithTime = DateFormat('dd/MM/yyyy HH:mm');
  static DateFormat displayFormatWithTimeAndSeconds = DateFormat(
    'dd/MM/yyyy HH:mm:ss',
  );
  static DateFormat displayFormatWithTimeAndSecondsAndMilliseconds = DateFormat(
    'dd/MM/yyyy HH:mm:ss.SSS',
  );
  static DateFormat displayFormatWithTimeAndMilliseconds = DateFormat(
    'dd/MM/yyyy HH:mm.SSS',
  );
  static DateFormat displayFormatWithTimeAndMillisecondsAndTimezone =
      DateFormat('dd/MM/yyyy HH:mm:ss.SSS Z');

  // Time
  static DateFormat timeFormat = DateFormat('HH:mm');
  static DateFormat timeFormatWithSeconds = DateFormat('HH:mm:ss');
  static DateFormat timeFormatWithMilliseconds = DateFormat('HH:mm:ss.SSS');

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
  // date time to string dd/MM/yyyy
  static formatDateToString(DateTime date) {
    return displayFormat.format(date);
  }
  // string yyyy/MM/dd to date time
  static DateTime parseStringToDate(String dateString) {
    return DateFormat('yyyy-MM-dd').parse(dateString);
  }

  // static DateTime parseStringToDate(String dateString) {
  //   return displayFormat.parse(dateString);
  // }
}
