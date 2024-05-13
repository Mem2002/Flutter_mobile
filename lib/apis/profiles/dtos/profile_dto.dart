import 'dart:convert';

ProfileResponse profileResponseFromJson(String str) =>
    ProfileResponse.fromJson(json.decode(str));

String profileResponseToJson(ProfileResponse data) =>
    json.encode(data.toJson());

class ProfileResponse {
  ProfileResponse({
    required this.error,
    required this.data,
  });

  bool error;
  String? message;
  ProfileDto data;

  factory ProfileResponse.fromJson(Map<String, dynamic> json) =>
      ProfileResponse(
        error: json["error"],
        data: ProfileDto.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "data": data.toJson(),
      };
}

class ProfileDto {
  ProfileDto({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.gender,
    required this.birthday,
    required this.activeDeviceId,
    required this.bankAccounts,
  });
  String activeDeviceId;
  int id;
  String name;
  String email;
  String phone;
  String gender;
  DateTime birthday;
  List<BankAccount> bankAccounts;

  factory ProfileDto.fromJson(Map<String, dynamic> json) => ProfileDto(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        gender: json["gender"],
        birthday: DateTime.parse(json["birthday"]),
        activeDeviceId: json["device_active_id"],
        bankAccounts: List<BankAccount>.from(
            json["bank_accounts"].map((x) => BankAccount.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "phone": phone,
        "gender": gender,
        "device_active_id": activeDeviceId,
        "birthday":
            "${birthday.year.toString().padLeft(4, '0')}-${birthday.month.toString().padLeft(2, '0')}-${birthday.day.toString().padLeft(2, '0')}",
        "bank_accounts":
            List<dynamic>.from(bankAccounts.map((x) => x.toJson())),
      };
}

class BankAccount {
  BankAccount({
    required this.ownerName,
    required this.bankName,
    required this.number,
  });

  String ownerName;
  String bankName;
  String number;

  factory BankAccount.fromJson(Map<String, dynamic> json) => BankAccount(
        ownerName: json["owner_name"],
        bankName: json["bank_name"],
        number: json["number"],
      );

  Map<String, dynamic> toJson() => {
        "owner_name": ownerName,
        "bank_name": bankName,
        "number": number,
      };
}
