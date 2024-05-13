import 'dart:convert';

CheckInResponse checkInResponseFromJson(String str) =>
    CheckInResponse.fromJson(json.decode(str));

String checkInResponseToJson(CheckInResponse data) =>
    json.encode(data.toJson());

class CheckInResponse {
  CheckInResponse({
    required this.error,
    this.message,
    required this.data,
  });

  bool error;
  dynamic message;
  CheckInDto data;

  factory CheckInResponse.fromJson(Map<String, dynamic> json) =>
      CheckInResponse(
        error: json["error"],
        message: json["message"],
        data: CheckInDto.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "data": data.toJson(),
      };
}

class CheckInDto {
  CheckInDto({
    // required this.userId,
    // required this.dateTime,
    // this.deviceId,
    // required this.type,
    // required this.fingerprintUserId,
    // required this.createdAt,
    required this.id,
  });

  // int userId;
  // DateTime dateTime;
  // dynamic deviceId;
  // int type;
  // int fingerprintUserId;
  int id;

  factory CheckInDto.fromJson(Map<String, dynamic> json) => CheckInDto(
        // userId: json["user_id"],
        // dateTime: DateTime.parse(json["date_time"]),
        // deviceId: json["device_id"],
        // type: json["type"],
        // fingerprintUserId: json["fingerprint_user_id"],
        // createdAt: DateTime.parse(json["created_at"]),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        // "user_id": userId,
        // "date_time": dateTime.toIso8601String(),
        // "device_id": deviceId,
        // "type": type,
        // "fingerprint_user_id": fingerprintUserId,
        "id": id,
      };
}
