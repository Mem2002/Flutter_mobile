// import 'package:injectable/injectable.dart';
// import '../http_base.dart';
// import 'dtos/login_response.dart';
// import 'dtos/register_response.dart';

// @injectable
// class AuthenticationApi {
//   IHttpBase http;

//   AuthenticationApi(this.http);

//   Future<LoginResponse?> logInAsync(String email, String password) async {
//     try {
//       var res = await http.post('/v1/api/login', {
//         'email': email.trim(),
//         'password': password.trim()
//       }); //trim được sử dụng để loại bỏ khoảng trắng (whitespace)
//       var body = loginResponseFromJson(res.body);
//       // return body;
//       print("body");
//     } catch (e) {
//       return null;
//     }
//   }

//   Future<RegisterResponse?> signUpAsync(
//       String name, String email, String password) async {
//     try {
//       var res = await http.post('/v1/api/login', {
//         'name': name.trim(),
//         'email': email.trim(),
//         'password': password.trim(),
//         'confirm_password': password.trim()
//       });
//       return registerResponseFromMap(res.body);
//     } catch (e) {
//       return null;
//     }
//   }
// }
