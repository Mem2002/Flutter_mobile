

class FormModel {
  int? id;
  FormType type;
  DateTime startTime;
  DateTime? endTime;
  String reason;
  String? rejectReason;
  String? phone;
  double? days;
  ShiftOff? shiftOff;
  DateTime? createdTime;
  FormStatus status;
  WorkingHour? workingHour;
  WorkingHour? workingHourChanged;
  String? overtimeResults;
  int? typeLeave;
  DateTime timeCheckin;
  DateTime timeCheckout;
  FormModel(
      {required this.type,
      required this.startTime,
      required this.reason,
      this.endTime,
      this.status = FormStatus.requested,
      this.days,
      this.createdTime,
      this.shiftOff,
      this.phone,
      this.workingHour,
      this.workingHourChanged,
      this.id,
      this.rejectReason,
      this.overtimeResults,
      this.typeLeave,
      required this.timeCheckin,
      required this.timeCheckout});


}

enum AttendanceType { checkInt, checkOut }

enum FormType { onLeave, ot, changeShift, addAttendance }

enum FormStatus { requested, approved, rejected }

enum ShiftOff { morning, afternoon, night }

enum WorkingHour { morningAfternoon, afternoonNight }

//Trong Flutter (và Dart), enum là một kiểu dữ liệu đặc biệt cho phép bạn định 
//nghĩa một tập hợp các giá trị hằng số có tên. enum giúp mã nguồn trở nên dễ đọc 
//và bảo trì hơn bằng cách thay thế các giá trị số hoặc chuỗi không có ý nghĩa bằng các tên có ý nghĩa.

class AttendanceTimeModel {
  AttendanceType type;
  DateTime time;
  AttendanceTimeModel({required this.time, required this.type});
}

