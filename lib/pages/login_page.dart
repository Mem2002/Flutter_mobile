import 'package:flutter_app/pages/home_page.dart';
import 'package:flutter_app/services/api.dart';
import 'package:flutter_app/styles/text_styles.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/text_utils.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import '../controllers/login_controller.dart';
import '../styles/colors.dart';
import '../utils/page_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() => LoginState();
}

class LoginState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController(text: "mem@gmail.com");
  final TextEditingController passwordController = TextEditingController(text: "Mem@@382002");
  bool hidePassword = true;
  String? emailError;
  String? passwordError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LocalColors.edutalk,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            bottom: 350,
            child: Image.asset("assets/images/logo.png"),
          ),
          Positioned(
            height: 370,
            left: 24,
            right: 24,
            bottom: 80,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white54,
                borderRadius: BorderRadius.circular(32),
              ),
              child: Container(
                margin: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 24, left: 24),
                      child: Text(
                        AppLocalizations.of(context)!.login_title,
                        style: const TitleSmallBoldTextStyle(color: LocalColors.edutalk),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 24),
                      child: Text(
                        AppLocalizations.of(context)!.login_description,
                        style: const SmallNormalTextStyle(color: Colors.black54),
                      ),
                    ),
                    _buildEmailField(),
                    _buildPasswordField(),
                    _buildLoginButton(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Tạo trường nhập email
  Widget _buildEmailField() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xffEFEFEF),
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.only(left: 24, right: 24, top: 24),
      child: TextField(
        controller: emailController,
        onSubmitted: (text) {
          setState(() {
            emailError = EmailValidator.isEmailValid(text) ? null : "Email is not in correct format.";
          });
        },
        keyboardType: TextInputType.emailAddress,
        style: const SmallNormalTextStyle(),
        decoration: MainInputDecoration(
          const AssetImage("assets/images/mail.png"),
          hint: AppLocalizations.of(context)!.login_email,
          error: emailError,
        ),
      ),
    );
  }

  // Tạo trường nhập mật khẩu
  Widget _buildPasswordField() {
    return Container(
      decoration: BoxDecoration(
        color: LocalColors.input,
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.only(left: 24, right: 24, top: 32),
      child: TextField(
        controller: passwordController,
        onSubmitted: (text) {
          setState(() {
            passwordError = PasswordValidator.isPasswordValid(text) ? null : "Password must be 6 characters";
          });
        },
        obscureText: hidePassword,
        keyboardType: TextInputType.visiblePassword,
        style: const SmallNormalTextStyle(),
        decoration: MainInputDecoration(
          const AssetImage("assets/images/lock.png"),
          hint: AppLocalizations.of(context)!.login_password,
          error: passwordError,
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                hidePassword = !hidePassword;
              });
            },
            child: Icon(
              hidePassword ? Icons.visibility_off : Icons.visibility,
              size: 20,
              color: LocalColors.onBackground,
            ),
          ),
        ),
      ),
    );
  }

  // Tạo nút đăng nhập
  Widget _buildLoginButton() {
    return Container(
      height: 48,
      margin: const EdgeInsets.only(left: 24, right: 24, top: 32),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: LocalColors.edutalk,
        ),
        onPressed: login,
        child: Text(
          AppLocalizations.of(context)!.login,
          style: const SmallNormalTextStyle(color: Colors.white),
        ),
      ),
    );
  }

  // Hàm xử lý đăng nhập
  login() async {
    var email = emailController.text;
    var password = passwordController.text;

    QuickAlert.show(
      context: context,
      type: QuickAlertType.loading,
      title: 'Connecting...',
    );

    try {
      var res = await Api.logInAsync(email, password);
      Navigator.of(context).pop();

      if (res == null || res.dt.accessToken.isEmpty) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Error',
          text: res?.em ?? "Wrong password or email ",
        );
      } else {
        var accessToken = res.dt.accessToken;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('accessToken', accessToken);
        print('Access Token: $accessToken');
        var groupName = res.dt.data.groupWithRole.group.groupName;

        if (groupName == "Employee") {
          var userId = res.dt.data.id;
          print('User ID: $userId');
          var nav = Navigator.of(context);
          nav.pushAndRemoveUntil(
              SidePageRoute(const HomePage()), (Route<dynamic> route) => false);
        } else {
          Navigator.of(context).pop();
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: 'Error',
            text: 'The user does not belong to the Employee group',
          );
        }
      }
    } catch (error) {
      Navigator.of(context).pop();
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Connection error',
        text: "Unable to connect to server. Please try again later.",
      );
    }
  }
}

// Chỉnh sửa `InputDecoration` để thống nhất màu sắc và thiết kế
class MainInputDecoration extends InputDecoration {
  @override
  MainInputDecoration(ImageProvider prefixImg, {super.suffixIcon, String hint = "", String? error})
      : super(
          contentPadding: EdgeInsets.zero,
          prefixIcon: Align(
            widthFactor: 1.0,
            heightFactor: 1.0,
            child: Image(image: prefixImg, width: 16, fit: BoxFit.fitHeight),
          ),
          hintText: hint,
          errorText: error,
          hintStyle: const SmallNormalTextStyle(color: LocalColors.border),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Colors.red, width: 1.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: LocalColors.input, width: 1.0),
            borderRadius: BorderRadius.circular(8.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: LocalColors.edutalk, width: 1.0),
            borderRadius: BorderRadius.circular(8.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: LocalColors.edutalk, width: 1.0),
          ),
        );
}
