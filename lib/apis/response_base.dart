// ignore: missing_return
abstract class IBaseJson {
  IBaseJson();
  // ignore: empty_constructor_bodies
  factory IBaseJson.fromJson(Map<String, dynamic> json) {
    throw UnimplementedError();
  }
  Map<String, dynamic> toJson();
}

class ResponseBase<T extends IBaseJson> extends IBaseJson {
  ResponseBase({
    this.error = false,
    this.message = "",
    this.data,
  });

  bool? error;
  String? message;
  T? data;

  // @override
  // factory ResponseBase.fromJson(Map<String, dynamic> json) => ResponseBase(
  //     error: json["error"],
  //     message: json["message"],
  //     data: json.containsKey("data") ? (T)IBaseJson.fromJson(json) : null);

  @override
  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "data": data?.toJson(),
      };
}

class ResponseEmpty extends IBaseJson {
  ResponseEmpty({
    this.error = false,
    this.message = "",
  });

  bool? error;
  String? message;

  factory ResponseEmpty.fromJson(Map<String, dynamic> json) =>
      ResponseEmpty(error: json["error"], message: json["message"]);

  @override
  Map<String, dynamic> toJson() => {"error": error, "message": message};
}
