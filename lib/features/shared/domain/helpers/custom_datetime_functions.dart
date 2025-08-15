import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDateTimeFunctions {
  static DateTime getDateTimeFromTimeOfDay(String date, TimeOfDay time) {
    DateTime parsedDate = DateFormat('yyyy-MM-dd').parse(date);
    return DateTime(
      parsedDate.year,
      parsedDate.month,
      parsedDate.day,
      time.hour,
      time.minute,
    );
  }
}
