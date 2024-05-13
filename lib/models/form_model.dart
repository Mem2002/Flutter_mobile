

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

class AttendanceTimeModel {
  AttendanceType type;
  DateTime time;
  AttendanceTimeModel({required this.time, required this.type});
}
