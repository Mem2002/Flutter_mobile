import 'dart:convert';

// Hàm chuyển đổi JSON thành AttendanceResponses
AttendanceResponses attendanceResponsesFromJson(String str) =>
    AttendanceResponses.fromJson(json.decode(str));

// Hàm chuyển đổi AttendanceResponses thành JSON
String attendanceResponsesToJson(AttendanceResponses data) =>
    json.encode(data.toJson());

// Lớp AttendanceResponses
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

        // Thêm phương thức khởi tạo từ month và year (nếu cần)
  // factory AttendanceResponses.fromMonthYear(int month, int year) {
  //   // Logic tạo đối tượng từ month và year
  //   return AttendanceResponses(
  //     date: DateTime(year, month),
  //     checkIn: DateTime(year, month), // Hoặc giá trị khác phù hợp
  //     checkOut: null, // Hoặc giá trị khác phù hợp
  //   );
  // }
}
