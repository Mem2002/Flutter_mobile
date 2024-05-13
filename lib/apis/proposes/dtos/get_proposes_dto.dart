import 'dart:convert';

GetProposesDto getProposesFromJson(String str) =>
    GetProposesDto.fromJson(json.decode(str));

String getProposesToJson(GetProposesDto data) => json.encode(data.toJson());

class GetProposesDto {
  bool? error;
  String? message;
  ProposeDataResponse? data;

  GetProposesDto({
    this.error,
    this.message,
    this.data,
  });

  factory GetProposesDto.fromJson(Map<String, dynamic> json) => GetProposesDto(
        error: json["error"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : ProposeDataResponse.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "data": data?.toJson(),
      };
}

class ProposeDataResponse {
  int currentPage;
  List<ProposeDto> data;
  int perPage;
  int total;

  ProposeDataResponse({
    required this.currentPage,
    required this.data,
    required this.perPage,
    required this.total,
  });

  factory ProposeDataResponse.fromJson(Map<String, dynamic> json) =>
      ProposeDataResponse(
        currentPage: json["current_page"],
        data: List<ProposeDto>.from(
            json["data"].map((x) => ProposeDto.fromJson(x))),
        perPage: json["per_page"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": List<ProposeDto>.from(data.map((x) => x.toJson())),
        "per_page": perPage,
        "total": total,
      };
}

class ProposeDto {
  int id;
  DateTime? startDate;
  DateTime? endDate;
  DateTime? timeCheckin;
  DateTime? timeCheckout;
  double? generalLeave;
  int? startShiftOff;
  int? currentWorkingHours;
  int? currentWorkingChange;
  String? reason;
  int category;
  int status;
  String? phone;
  int? userHandler;
  dynamic reasonForRefusal;
  DateTime? createdAt;
  String? overtimeResults;
  int? typeLeave;
  ProposeDto(
      {required this.id,
      required this.reason,
      required this.category,
      required this.status,
      this.startDate,
      this.endDate,
      this.timeCheckin,
      this.timeCheckout,
      this.generalLeave,
      this.startShiftOff,
      this.currentWorkingHours,
      this.currentWorkingChange,
      this.phone,
      this.userHandler,
      this.reasonForRefusal,
      required this.createdAt,
      this.overtimeResults,
      this.typeLeave});

  factory ProposeDto.fromJson(Map<String, dynamic> json) {
    return ProposeDto(
        id: json["id"],
        startDate: json["start_date"] == null
            ? null
            : DateTime.parse(json["start_date"]).toLocal(),
        endDate: json["end_date"] == null
            ? null
            : DateTime.parse(json["end_date"]).toLocal(),
        timeCheckin: json["time_checkin"] == null
            ? null
            : DateTime.parse(json["start_date"] + "T" + json["time_checkin"])
                .toLocal(),
        timeCheckout: json["time_checkout"] == null
            ? null
            : DateTime.parse(json["start_date"] + "T" + json["time_checkout"])
                .toLocal(),
        generalLeave: (json["general_leave"] ?? 0) * 1.0,
        startShiftOff: json["start_shift_off"],
        currentWorkingHours: json["current_working_hours"],
        currentWorkingChange: json["current_working_change"],
        reason: json["reason"],
        category: json["category"],
        status: json["status"],
        phone: json["phone"],
        userHandler: json["user_handler"],
        reasonForRefusal: json["reason_for_refusal"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]).toLocal(),
        overtimeResults: json["overtime_results"],
        typeLeave: json["type_leave"]);
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "start_date": startDate == null
            ? null
            : "${startDate!.year.toString().padLeft(4, '0')}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}",
        "end_date": endDate == null
            ? null
            : "${endDate!.year.toString().padLeft(4, '0')}-${endDate!.month.toString().padLeft(2, '0')}-${endDate!.day.toString().padLeft(2, '0')}",
        "time_checkin": timeCheckin,
        "time_checkout": timeCheckout,
        "general_leave": generalLeave,
        "start_shift_off": startShiftOff,
        "current_working_hours": currentWorkingHours,
        "current_working_change": currentWorkingChange,
        "reason": reason,
        "overtimeResults": overtimeResults,
        "category": category,
        "status": status,
        "phone": phone,
        "user_handler": userHandler,
        "reason_for_refusal": reasonForRefusal,
        "created_at": createdAt?.toIso8601String(),
      };
}
