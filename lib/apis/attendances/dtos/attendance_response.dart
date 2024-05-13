// To parse this JSON data, do
//
//     final attendanceResponse = attendanceResponseFromJson(jsonString);

import 'dart:convert';

AttendanceResponse attendanceResponseFromJson(String str) =>
    AttendanceResponse.fromJson(json.decode(str));

String attendanceResponseToJson(AttendanceResponse data) =>
    json.encode(data.toJson());

class AttendanceResponse {
  AttendanceResponse({
    required this.error,
    this.message,
    required this.data,
  });

  bool error;
  dynamic message;
  List<AttendanceData> data;

  factory AttendanceResponse.fromJson(Map<String, dynamic> json) =>
      AttendanceResponse(
        error: json["error"],
        message: json["message"],
        data: List<AttendanceData>.from(
            json["data"].map((x) => AttendanceData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class AttendanceData {
  AttendanceData({
    required this.date,
    required this.inTime,
    required this.outTime,
  });

  DateTime date;
  DateTime inTime;
  DateTime? outTime;

  factory AttendanceData.fromJson(Map<String, dynamic> json) => AttendanceData(
        date: DateTime.parse(json["date_format"]).toLocal(),
        inTime: DateTime.parse(json["in"]).toLocal(),
        outTime: json.containsKey("out") && json["out"] != null
            ? DateTime.parse(json["out"]).toLocal()
            : null,
      );

  Map<String, dynamic> toJson() => {
        "date_format":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "in": inTime.toIso8601String(),
        "out": outTime?.toIso8601String(),
      };
}
