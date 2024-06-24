import 'dart:async';
import 'package:injectable/injectable.dart';

import '../../apis/header_provider.dart';
import '../services/application_service.dart';

@Injectable()
class AuthenticationController {
  HeaderProvider headerProvider;
  IApplicationService accountService;
  AuthenticationController(this.headerProvider, this.accountService);

  Future<bool> checkSignInAsync() async {
    var token = await headerProvider.getAuthorization();
    if (token?.token == null) {
      return false;
    }
    var profile = await accountService.getProfile();
    return (profile?.id ?? 0) > 0;
  }
}
