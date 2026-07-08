extension DateTimeExtension on DateTime {
  /// Devuelve el lunes de la semana a la que pertenece esta fecha
  DateTime get startOfWeek {
    // weekday va de 1 (lunes) a 7 (domingo)
    return DateTime(year, month, day).subtract(Duration(days: weekday - 1));
  }

  /// Devuelve el domingo de la semana a la que pertenece esta fecha
  DateTime get endOfWeek {
    return startOfWeek.add(const Duration(days: 6));
  }
}