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
        "exp": exp.toUtc().millisecondsSinceEpoch, //Đây là một biến hoặc thuộc tính (thường là kiểu DateTime)
        // đại diện cho thời điểm hết hạn (expiration) của token.
      };
      // toUtc() là một phương thức của kiểu DateTime trong Dart, dùng để chuyển đổi đối tượng
      //millisecondsSinceEpoch là một thuộc tính của DateTime trong Dart, trả về số mili giây đã trôi qua kể từ thời điểm "epoch" 
      //(tức là ngày 1 tháng 1 năm 1970, 00:00:00 UTC).
      //////////////////////////////////////////////////////////////////////////////////////////////
      /// => exp.toUtc().millisecondsSinceEpoch sẽ trả về một giá trị số nguyên, là số mili giây kể từ thời điểm "epoch", biểu diễn thời
      /// gian hết hạn của token dưới dạng UTC. Trường "exp" này sẽ được gửi dưới dạng JSON khi mã hóa đối tượng, giúp các bên liên 
      /// quan có thể kiểm tra xem token đã hết hạn hay chưa.
}

@Injectable()
class HeaderProvider {
  final String keyTokenUser = "jwt"; //nhưng mà tên tokenn của mk jwt
  ICacheService cacheService;   //Đây là tên của một interface hoặc abstract class trong Dart
  HeaderProvider(this.cacheService); //Đây là constructor của một lớp có tên là HeaderProvider. 
  //Constructor này được sử dụng để khởi tạo đối tượng của lớp HeaderProvider 
  //và truyền giá trị cho thuộc tính cacheService.
  Future<Token?> getAuthorization() async {
    var map = await cacheService.getAsync(keyTokenUser);
    if (map == null) {
      return null;
    }
    return Token.fromJson(map);
  }
  //Future là một lời hứa về một kết quả có thể có trong tương lai. Trong trường hợp này, 
  //phương thức getAuthorization() sẽ trả về một đối tượng Future mà giá trị bên trong của nó là một đối tượng Token hoặc null.

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
