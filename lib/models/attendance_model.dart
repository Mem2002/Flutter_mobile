import 'dart:convert';

AttendanceResponses attendanceResponsesFromJson(String str) =>
    AttendanceResponses.fromJson(json.decode(str));

String attendanceResponsesToJson(AttendanceResponses data) =>
    json.encode(data.toJson());

class AttendanceResponses {
  DateTime date;
  DateTime checkIn;
  DateTime? checkOut;

  AttendanceResponses({
    required this.date,
    required this.checkIn,
    required this.checkOut,
  });

  factory AttendanceResponses.fromJson(Map<String, dynamic> json) =>
      AttendanceResponses(
        date: DateTime.parse(json["date"]),
        checkIn: DateTime.parse(json["checkIn"]),
        checkOut:
            json["checkOut"] == null ? null : DateTime.parse(json["checkOut"]),
      );

  Map<String, dynamic> toJson() => {
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "checkIn": checkIn.toIso8601String(),
        "checkOut": checkOut?.toIso8601String(),
      };
}
