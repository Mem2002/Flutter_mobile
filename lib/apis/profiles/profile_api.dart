import 'package:flutter_app/apis/profiles/dtos/profile_dto.dart';
import 'package:injectable/injectable.dart';
import '../http_base.dart';

@injectable
class ProfileApi {
  IHttpBase http;
  ProfileApi(this.http);
  Future<ProfileResponse?> getProfile() async {
    try {
      var res = await http.get('/employee/user/info', auth: true);
      //
      var body = profileResponseFromJson(res.body);
      return body;
    } catch (e) {
      return null;
    }
  }
}