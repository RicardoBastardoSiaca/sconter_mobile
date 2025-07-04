import 'package:flutter_riverpod/flutter_riverpod.dart';

final datetimeProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});
