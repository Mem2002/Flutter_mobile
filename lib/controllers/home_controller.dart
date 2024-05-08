// // import 'package:edutalk_time_talk/apis/attendances/dtos/attendance_report_response.dart';
// // import 'package:edutalk_time_talk/apis/profiles/dtos/profile_dto.dart';
// import 'package:flutter/material.dart';
// // import 'package:injectable/injectable.dart';
// import 'package:intl/intl.dart';

// // import '../apis/attendances/dtos/attendance_response.dart';
// // import '../services/application_service.dart';
// import '../utils/date_time_utils.dart';

// @injectable
// class HomeController {
//   IApplicationService service;
//   HomeController(this.service);

//   ValueNotifier<ProfileDto?> data = ValueNotifier<ProfileDto?>(null);
//   ValueNotifier<ReportDto?> report = ValueNotifier<ReportDto?>(null);
//   ValueNotifier<AttendanceData?> today = ValueNotifier(null);
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

//   Future<ProfileDto?> getProfile() async {
//     var res = await service.getProfile();
//     if (res == null) {
//       return null;
//     }
//     data.value = res;
//     return res;
//   }

//   Future<String> deviceId() {
//     return service.getCurrentDeviceIdAsync();
//   }

//   Future loadReport() async {
//     var now = DateTime.now();
//     var start = DateTimeUtils.formatDate(DateTime(now.year, now.month));
//     var end = DateTimeUtils.formatDate(DateTime(now.year, now.month + 1));
//     var res = await service.getReport(start, end);
//     if (res == null) {
//       return;
//     }
//     report.value = res;
//   }
// }
