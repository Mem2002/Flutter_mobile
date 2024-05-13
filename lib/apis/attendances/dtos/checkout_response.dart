// To parse this JSON data, do
//
//     final checkOutResponse = checkOutResponseFromJson(jsonString);

import 'dart:convert';

CheckOutResponse checkOutResponseFromJson(String str) =>
    CheckOutResponse.fromJson(json.decode(str));

String checkOutResponseToJson(CheckOutResponse data) =>
    json.encode(data.toJson());

class CheckOutResponse {
  CheckOutResponse({
    required this.error,
    this.message,
    required this.data,
  });

  bool error;
  String? message;
  CheckOutDto? data;

  factory CheckOutResponse.fromJson(Map<String, dynamic> json) =>
      CheckOutResponse(
        error: json["error"],
        message: json["message"],
        data: CheckOutDto.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "data": data?.toJson(),
      };
}

class CheckOutDto {
  CheckOutDto({
    required this.id,
  });

  int id;

  factory CheckOutDto.fromJson(Map<String, dynamic> json) => CheckOutDto(
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
      };
}
