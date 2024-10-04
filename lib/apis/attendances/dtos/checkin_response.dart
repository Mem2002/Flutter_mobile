// import 'dart:convert';

// CheckInResponse checkInResponseFromJson(String str) =>
//     CheckInResponse.fromJson(json.decode(str));

// String checkInResponseToJson(CheckInResponse data) =>
//     json.encode(data.toJson());

// class CheckInResponse {
//   CheckInResponse({
//     required this.error,
//     this.message,
//     required this.data,
//   });

//   bool error;
//   dynamic message;
//   CheckInDto data;

//   factory CheckInResponse.fromJson(Map<String, dynamic> json) =>
//       CheckInResponse(
//         error: json["error"],
//         message: json["message"],
//         data: CheckInDto.fromJson(json["data"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "error": error,
//         "message": message,
//         "data": data.toJson(),
//       };
// }

// class CheckInDto {
//   CheckInDto({
//     required this.id,
//   });

//   int id;

//   factory CheckInDto.fromJson(Map<String, dynamic> json) => CheckInDto(
//         id: json["id"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//       };
// }
