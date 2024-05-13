import 'dart:convert';

import 'package:flutter_app/apis/response_base.dart';
import 'package:injectable/injectable.dart';
import '../http_base.dart';
import 'dtos/attendance_report_response.dart';
import 'dtos/attendance_response.dart';
import 'dtos/checkout_response.dart';
import 'dtos/checkin_response.dart';

@injectable
class AttendanceApi {
  IHttpBase http;
  AttendanceApi(this.http);
  Future<AttendanceResponse?> getAttendance(String from, String to) async {
    try {
      var res = await http.get('/employee/attendances/by-month',
          queryParameters: {"start_date": from, "end_date": to}, auth: true);
      var body = attendanceResponseFromJson(res.body);
      return body;
    } catch (e) {
      return null;
    }
  }

  Future<AttendanceReportDto?> reportAttendance(String from, String to) async {
    try {
      var res = await http.get('/employee/attendance/report',
          queryParameters: {"start_date": from, "end_date": to}, auth: true);
      var body = attendanceReportDtoFromJson(res.body.replaceAll("\n", ""));
      return body;
    } catch (e) {
      return null;
    }
  }

  Future<CheckInResponse?> checkIn(String deviceId) async {
    try {
      var res = await http.post(
          '/employee/attendances/checkin', {"device_id": deviceId},
          auth: true);
      var body = checkInResponseFromJson(res.body);

      return body;
    } catch (e) {
      return null;
    }
  }

  Future<ResponseEmpty?> checkoutable() async {
    try {
      var res =
          await http.get('/employee/attendances/checkoutable', auth: true);
      var body = ResponseEmpty.fromJson(jsonDecode(res.body));
      return body;
    } catch (e) {
      return null;
    }
  }

  Future<CheckOutResponse?> checkOut(String deviceId, DateTime date) async {
    try {
      var res = await http.post('/employee/attendances/checkout',
          {"device_id": deviceId, "date": date.toIso8601String()},
          auth: true);
      var body = checkOutResponseFromJson(res.body);
      return body;
    } catch (e) {
      return null;
    }
  }

  Future<CheckOutResponse?> forceCheckOut(String deviceId) async {
    try {
      var res = await http.post(
          '/employee/attendances/force-checkout', {"device_id": deviceId},
          auth: true);
      var body = checkOutResponseFromJson(res.body);
      return body;
    } catch (e) {
      return null;
    }
  }
}
