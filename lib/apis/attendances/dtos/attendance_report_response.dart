// To parse this JSON data, do
//
//     final attendanceReportDto = attendanceReportDtoFromJson(jsonString);

import 'dart:convert';

AttendanceReportDto attendanceReportDtoFromJson(String str) =>
    AttendanceReportDto.fromJson(json.decode(str));

String attendanceReportDtoToJson(AttendanceReportDto data) =>
    json.encode(data.toJson());

class AttendanceReportDto {
  AttendanceReportDto({
    required this.error,
    this.message,
    required this.data,
  });

  bool error;
  String? message;
  ReportDto data;

  factory AttendanceReportDto.fromJson(Map<String, dynamic> json) =>
      AttendanceReportDto(
        error: json["error"],
        data: ReportDto.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "data": data.toJson(),
      };
}

class ReportDto {
  ReportDto({
    required this.countLate,
    this.totalWorkRemaining = const [0.0, 0.0],
    required this.days,
    required this.totalHours,
    required this.numberOfWorkdayDefault,
  });

  double countLate;
  List<dynamic> totalWorkRemaining;
  double days;
  double totalHours;
  double numberOfWorkdayDefault;

  factory ReportDto.fromJson(Map<String, dynamic> json) {
    return ReportDto(
      countLate: json["count_late"] * 1.0,
      totalWorkRemaining: List<dynamic>.from(
          json["total_work_remaining"].map((x) => double.tryParse(x))),
      days: json["days"] * 1.0,
      totalHours: json["total_hours"] * 1.0,
      numberOfWorkdayDefault: json["number_of_workday_default"] * 1.0,
    );
  }

  Map<String, dynamic> toJson() => {
        "count_late": countLate,
        "total_work_remaining": [totalWorkRemaining],
        "days": days,
        "total_hours": totalHours,
        "number_of_workday_default": numberOfWorkdayDefault,
      };
}
