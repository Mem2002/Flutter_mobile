// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  String em;
  int ec;
  Dt dt;

  LoginResponse({
    required this.em,
    required this.ec,
    required this.dt,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        em: json["EM"],
        ec: json["EC"],
        dt: Dt.fromJson(json["DT"]),
      );

  Map<String, dynamic> toJson() => {
        "EM": em,
        "EC": ec,
        "DT": dt.toJson(),
      };
}

class Dt {
  String accessToken;
  String expiresIn;
  DataLogin data;

  Dt({
    required this.accessToken,
    required this.expiresIn,
    required this.data,
  });

  factory Dt.fromJson(Map<String, dynamic> json) => Dt(
        accessToken: json["access_token"],
        expiresIn: json["expiresIn"],
        data: DataLogin.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "access_token": accessToken,
        "expiresIn": expiresIn,
        "data": data.toJson(),
      };
}

class DataLogin {
  String id;
  String username;

  DataLogin({
    required this.id,
    required this.username,
  });

  factory DataLogin.fromJson(Map<String, dynamic> json) => DataLogin(
        id: json["id"],
        username: json["username"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
      };
}
