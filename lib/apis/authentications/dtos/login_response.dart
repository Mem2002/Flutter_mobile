import 'dart:convert';

LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  LoginResponse(
      {required this.user, required this.error, this.token, this.message});

  User user;
  bool error;
  String? token;
  String? message;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        user: User.fromJson(json["user"]),
        error: json["error"],
        token: json["token"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "user": user.toJson(),
        "error": error,
        "token": token,
        "message": message
      };
}

class User {
  User({
    required this.id,
    this.name,
    this.phone,
  });

  int id;
  String? name;
  String? phone;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "phone": phone,
      };
}
