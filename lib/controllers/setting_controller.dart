// import 'package:flutter_app/apis/profiles/dtos/profile_dto.dart';
// import 'package:flutter/material.dart';
// import 'package:injectable/injectable.dart';

// import '../services/application_service.dart';
// import '../services/authentication_service.dart';

// @injectable
// class SettingController {
//   IApplicationService service;
//   IAuthenticationService auth;
//   SettingController(this.service, this.auth);

//   ValueNotifier<ProfileDto?> data = ValueNotifier<ProfileDto?>(null);

//   Future getProfile() async {
//     var res = await service.getProfile();
//     if (res == null) {
//       return;
//     }
//     data.value = res;
//   }

//   Future<String> deviceId() {
//     return service.getCurrentDeviceIdAsync();
//   }

//   Future signOut() async {
//     await service.removeCurrentDeviceIdAsync();
//     await auth.signOutAync();
//   }
// }
