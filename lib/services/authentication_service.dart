import 'dart:async';
import 'package:injectable/injectable.dart';
import '../apis/authentications/authentication_api.dart';
import '../apis/authentications/dtos/login_response.dart';
import '../apis/authentications/dtos/register_response.dart';
import '../apis/header_provider.dart';

abstract class IAuthenticationService {
  Future<LoginResponse?> signInAsync(String email, String password);

  Future<RegisterResponse?> signUpAsync(
      String name, String email, String password);

  Future signOutAync();
}

@Injectable(as: IAuthenticationService)
class AuthenticationService implements IAuthenticationService {
  AuthenticationApi authenticationApi;
  HeaderProvider headerProvider;

  AuthenticationService(this.authenticationApi, this.headerProvider);

  @override
  Future<LoginResponse?> signInAsync(String email, String password) async {
    var res = await authenticationApi.logInAsync(email, password);
    if (res == null || res.token?.isEmpty == true) {
      return null;
    }
    await headerProvider.saveAuthorization(
      Token(
        res.token ?? "",
        DateTime.now().add(
          const Duration(milliseconds: 24 * 60 * 60 * 1000),
        ),
      ),
    );
    return res;
  }

  @override
  Future signOutAync() async {
    await headerProvider.saveAuthorization(null);
  }

  @override
  Future<RegisterResponse?> signUpAsync(
      String name, String email, String password) async {
    var res = await authenticationApi.signUpAsync(name, email, password);
    return res;
  }
}
