// import 'package:flutter_app/pages/home_page.dart';
// import 'package:flutter/material.dart';


// class AuthenticationScreen extends StatefulWidget {
//   const AuthenticationScreen({super.key});

//   @override
//   State<StatefulWidget> createState() => AuthenticationScreenState();
// }

// class AuthenticationScreenState extends State<AuthenticationScreen> {
//   final AuthenticationController bloc =
//       GetIt.instance.get<AuthenticationController>();
//   @override
//   void initState() {
//     checkData();
//     super.initState();
//   }

//   checkData() async {
//     var navigator = Navigator.of(context);
//     try {
//       EasyLoading.show();
//       var res = await bloc.checkSignInAsync();
//       EasyLoading.dismiss();
//       if (res == true) {
//         navigator.pushReplacement(FadePageRoute(const HomePage()));
//         return;
//       }
//       // ignore: empty_catches
//     } catch (e) {
//       EasyLoading.dismiss();
//     }
//     navigator.pushReplacement(FadePageRoute(const LoginPage()));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: LocalColors.edutalk,
//       child: Center(
//         child: Image.asset(
//           "assets/images/logo.png",
//           fit: BoxFit.fill,
//         ),
//       ),
//     );
//   }
// }
