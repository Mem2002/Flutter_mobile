import 'package:flutter_app/apis/authentications/dtos/register_response.dart';
import 'package:injectable/injectable.dart';

import '../services/authentication_service.dart';

@injectable
class RegisterController {
  IAuthenticationService service;
  RegisterController(this.service);

  Future<RegisterResponse?> signUpAsync(String name,String email, String password) async {
    return service.signUpAsync(name, email, password);
  }
}
