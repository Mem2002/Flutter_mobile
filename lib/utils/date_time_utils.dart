import 'package:intl/intl.dart';

class DateTimeUtils {
  static bool inRange(DateTime start, DateTime end) {
    var now = DateTime.now();
    return now.isAfter(start) && now.isBefore(end);
  }

  static bool inRangeByDate(DateTime date, int step) {
    return inRange(
        date.add(Duration(days: -step)), date.add(Duration(days: step)));
  }

  static bool inRangeByDates(List<DateTime> dates, int step) {
    return dates.any((c) => inRangeByDate(c, step));
  }

  static String formatDate(DateTime date) {
    DateFormat format = DateFormat("yyyy-MM-dd");
    return format.format(date);
  }
}