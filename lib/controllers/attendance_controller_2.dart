import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_app/models/attendance_model.dart';
import 'package:flutter_app/services/api.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

@injectable
class AttendanceControllers {
  ValueNotifier<List<AttendanceResponses>> data = ValueNotifier([]);
  ValueNotifier<AttendanceResponses?> today = ValueNotifier(null);
   ValueNotifier<List<DateTime>> absentDays = ValueNotifier([]); // Thêm dòng này

  late String accessToken;

  AttendanceControllers();

  Future<void> setup() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString('accessToken') ?? "";
  }

  AttendanceResponses convertToAttendanceData(AttendanceResponses response) {
    return AttendanceResponses(
      date: response.date,
      checkIn: response.checkIn,
      checkOut: response.checkOut,
    );
  }

  Future<void> getAttendance(String startDate, String endDate) async {
    try {
      await setup();
      List<AttendanceResponses> attendanceResponses =
          await Api.getAttendance(accessToken, startDate, endDate);
      List<AttendanceResponses> attendanceData =
          attendanceResponses.map(convertToAttendanceData).toList();
      data.value = attendanceData; // Cập nhật lại với dữ liệu mới

      // Tạo danh sách các ngày trong khoảng thời gian
      List<DateTime> allDays = [];
      DateTime start = DateFormat('yyyy-MM-dd').parse(startDate);
      DateTime end = DateFormat('yyyy-MM-dd').parse(endDate);

      for (DateTime date = start; date.isBefore(end); date = date.add(Duration(days: 1))) {
        allDays.add(date);
      }

      List<DateTime> absentDays = allDays.where((day) {
  return !attendanceData.any((att) => att.date.isAtSameMomentAs(day));
}).toList();

// Cập nhật lại ValueNotifier
this.absentDays.value = absentDays;

      DateTime todayDate = DateTime.now();
      var error = attendanceData
          .where((att) => att.date.isAtSameMomentAs(todayDate))
          .firstOrNull;
      if (error != null) {
        today.value = error;
      }
    } catch (e) {
      print(e);
    }
  }
}
