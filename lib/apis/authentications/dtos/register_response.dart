// // To parse this JSON data, do
// //
// //     final registerResponse = registerResponseFromMap(jsonString);

// import 'dart:convert';

// RegisterResponse registerResponseFromMap(String str) => RegisterResponse.fromMap(json.decode(str));

// String registerResponseToMap(RegisterResponse data) => json.encode(data.toMap());

// class RegisterResponse {
//   User? user;
//   bool? error;
//   String? message;

//   RegisterResponse({
//     this.user,
//     this.error,
//     this.message,
//   });

//   factory RegisterResponse.fromMap(Map<String, dynamic> json) => RegisterResponse(
//     user: json["user"] == null ? null : User.fromMap(json["user"]),
//     error: json["error"],
//     message: json["message"],
//   );

//   Map<String, dynamic> toMap() => {
//     "user": user?.toMap(),
//     "error": error,
//     "message": message,
//   };
// }

// class User {
//   int? id;
//   String? name;
//   dynamic phone;
//   dynamic status;

//   User({
//     this.id,
//     this.name,
//     this.phone,
//     this.status,
//   });

//   factory User.fromMap(Map<String, dynamic> json) => User(
//     id: json["id"],
//     name: json["name"],
//     phone: json["phone"],
//     status: json["status"],
//   );

//   Map<String, dynamic> toMap() => {
//     "id": id,
//     "name": name,
//     "phone": phone,
//     "status": status,
//   };
// }
