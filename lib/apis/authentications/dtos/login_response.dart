// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

LoginResponse loginResponseFromJson(String str) => LoginResponse.fromJson(json.decode(str));

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
    Data data;

    Dt({
        required this.accessToken,
        required this.expiresIn,
        required this.data,
    });

    factory Dt.fromJson(Map<String, dynamic> json) => Dt(
        accessToken: json["access_token"],
        expiresIn: json["expiresIn"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "access_token": accessToken,
        "expiresIn": expiresIn,
        "data": data.toJson(),
    };
}

class Data {
    String id;
    String username;
    GroupWithRole groupWithRole;

    Data({
        required this.id,
        required this.username,
        required this.groupWithRole,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        username: json["username"],
        groupWithRole: GroupWithRole.fromJson(json["groupWithRole"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "groupWithRole": groupWithRole.toJson(),
    };
}

class GroupWithRole {
    Group group;

    GroupWithRole({
        required this.group,
    });

    factory GroupWithRole.fromJson(Map<String, dynamic> json) => GroupWithRole(
        group: Group.fromJson(json["group"]),
    );

    Map<String, dynamic> toJson() => {
        "group": group.toJson(),
    };
}

class Group {
    String id;
    String groupName;
    String description;
    DateTime createdAt;
    DateTime updatedAt;
    int v;

    Group({
        required this.id,
        required this.groupName,
        required this.description,
        required this.createdAt,
        required this.updatedAt,
        required this.v,
    });

    factory Group.fromJson(Map<String, dynamic> json) => Group(
        id: json["_id"],
        groupName: json["group_name"],
        description: json["description"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "group_name": groupName,
        "description": description,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
    };
}
