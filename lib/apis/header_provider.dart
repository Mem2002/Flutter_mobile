import 'dart:async';

import 'package:injectable/injectable.dart';

import '../services/cache_service.dart';

class Token {
  Token(this.token, this.exp);
  String token;
  DateTime exp;

  factory Token.fromJson(Map<String, dynamic> json) => Token(
        json["token"],
        DateTime.fromMillisecondsSinceEpoch(json["exp"]),
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "exp": exp.toUtc().millisecondsSinceEpoch,
      };
}

@Injectable()
class HeaderProvider {
  final String keyTokenUser = "token_user";
  ICacheService cacheService;
  HeaderProvider(this.cacheService);
  Future<Token?> getAuthorization() async {
    var map = await cacheService.getAsync(keyTokenUser);
    if (map == null) {
      return null;
    }
    return Token.fromJson(map);
  }

  Future<bool> saveAuthorization(Token? token) async {
    if (token == null) {
      await cacheService.setAsync(keyTokenUser, null);
      return true;
    }

    await cacheService.setAsync(keyTokenUser, token.toJson());
    if ((await cacheService.getAsync(keyTokenUser)) == null) {
      return false;
    }
    return true;
  }
}
