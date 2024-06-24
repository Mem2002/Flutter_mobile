import 'package:flutter_app/apis/profiles/dtos/profile_dto.dart';
import 'package:injectable/injectable.dart';
import '../http_base.dart';
// Implement the Profile API
@Injectable()
class ProfileApi {
  IHttpBase http;
  ProfileApi(this.http);
  Future<ProfileResponse?> getProfile() async {
    // Một Future sẽ hoàn thành với một giá trị tại một thời điểm không xác định trong tương lai.
    try {
      var res = await http.get('/v1/api/users');
      var body = profileResponseFromJson(res
          .body); // lấy body này liệu có đúng với định dạng x-www-form-urlencoded
      return body;
    } catch (e) {
      return null;
    }
  }
}
