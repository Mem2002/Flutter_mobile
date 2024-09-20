class LoginResponse {
  final String? message;
  final int? errorCode;
  final LoginData? data;

  LoginResponse({this.message, this.errorCode, this.data});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      message: json['EM'],
      errorCode: json['EC'],
      data: json['DT'] != null ? LoginData.fromJson(json['DT']) : null,
    );
  }
}

class LoginData {
  final String? accessToken;
  final String? expiresIn;
  final User? user;

  LoginData({this.accessToken, this.expiresIn, this.user});

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      accessToken: json['access_token'],
      expiresIn: json['expiresIn'],
      user: json['data'] != null ? User.fromJson(json['data']) : null,
    );
  }
}

class User {
  final String? id;
  final String? username;
  final GroupWithRole? groupWithRole;
  final String? facultyId;

  User({this.id, this.username, this.groupWithRole, this.facultyId});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      groupWithRole: json['groupWithRole'] != null
          ? GroupWithRole.fromJson(json['groupWithRole'])
          : null,
      facultyId: json['faculty_id'],
    );
  }
}

class GroupWithRole {
  final Group? group;

  GroupWithRole({this.group});

  factory GroupWithRole.fromJson(Map<String, dynamic> json) {
    return GroupWithRole(
      group: json['group'] != null ? Group.fromJson(json['group']) : null,
    );
  }
}

class Group {
  final String? id;
  final String? groupName;
  final String? description;
  final String? createdAt;
  final String? updatedAt;

  Group({this.id, this.groupName, this.description, this.createdAt, this.updatedAt});

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['_id'],
      groupName: json['group_name'],
      description: json['description'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
