// import 'package:flutter_app/services/application_service.dart';
// import 'package:flutter/material.dart';
// import 'package:injectable/injectable.dart';
// import 'package:intl/intl.dart';

// import '../apis/attendances/dtos/attendance_report_response.dart';
// import '../apis/attendances/dtos/attendance_response.dart';

// @injectable
// class AttendanceController {
//   IApplicationService service;
//   AttendanceController(this.service);
//   ValueNotifier<AttendanceData?> today = ValueNotifier(null);
//   ValueNotifier<List<AttendanceData>?> data =
//       ValueNotifier<List<AttendanceData>?>(null);
//   ValueNotifier<ReportDto?> report = ValueNotifier<ReportDto?>(null);

//   Future loadToday() async {
//     var formater = DateFormat("yyyy-MM-dd");
//     var now = DateTime.now();
//     var res = await service.getAttendance(formater.format(now),
//         formater.format(now.add(const Duration(days: 1))));
//     if (res == null) {
//       return;
//     }
//     if (res.data.isNotEmpty) {
//       var todayData =
//           res.data.firstWhere((element) => element.date.day == now.day);
//       today.value = todayData;
//     }
//   }

//   Future loadAttendance(String from, String to) async {
//     var res = await service.getAttendance(from, to);
//     if (res == null) {
//       return;
//     }

//     if (res.data.isEmpty) {
//       data.value = [];
//     } else {
//       data.value = res.data;
//     }
//   }

//   Future loadReport(String from, String to) async {
//     var res = await service.getReport(from, to);
//     if (res == null) {
//       return;
//     }

//     report.value = res;
//   }

//   Future getAttendance(String from, String to) async {
//     await loadAttendance(from, to);
//     await loadReport(from, to);
//   }
// }
