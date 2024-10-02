import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_app/models/attendance_model.dart';
import 'package:flutter_app/services/api.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@injectable
class AttendanceControllers {
  ValueNotifier<List<AttendanceResponses>> data = ValueNotifier([]);
  ValueNotifier<AttendanceResponses?> today = ValueNotifier(null);

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
