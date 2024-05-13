import 'package:flutter/widgets.dart';

extension DayOfWeekExtensions on int {
  String toDayOfWeek(BuildContext context) {
    switch (this) {
      case 0:
        return "T2";
      case 1:
        return "T3";
      case 2:
        return "T4";
      case 3:
        return "T5";
      case 4:
        return "T6";
      case 5:
      default:
        return "T7";
    }
  }
}
