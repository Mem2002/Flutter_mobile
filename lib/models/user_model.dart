class UserResponses {
  String message;
  User user;

  UserResponses({
    required this.message,
    required this.user,
  });

  factory UserResponses.fromJson(Map<String, dynamic> json) => UserResponses(
        message: json["message"],
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "user": user.toJson(),
      };
}

class User {
  String userId;
  String username;

  User({
    required this.userId,
    required this.username,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        userId: json["user_id"],
        username: json["username"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "username": username,
      };
}
