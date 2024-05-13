// To parse this JSON data, do
//
//     final payslipResponse = payslipResponseFromJson(jsonString);

import 'dart:convert';

PayslipResponse payslipResponseFromJson(String str) =>
    PayslipResponse.fromJson(json.decode(str));

String payslipResponseToJson(PayslipResponse data) =>
    json.encode(data.toJson());

class PayslipResponse {
  PayslipResponse({
    required this.error,
    required this.message,
    required this.data,
  });

  bool error;
  String message;
  Map<String, dynamic>? data;

  factory PayslipResponse.fromJson(Map<String, dynamic> json) =>
      PayslipResponse(
        error: json["error"],
        message: json["message"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "data": data,
      };
}
