// ignore_for_file: use_build_context_synchronously

import 'package:flutter_app/pages/home_page.dart';
import 'package:flutter_app/styles/text_styles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import '../controllers/register_controller.dart';
import '../styles/colors.dart';
import '../utils/page_router.dart';
import '../utils/text_utils.dart';
import '../widgets/term_and_condition.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<StatefulWidget> createState() => RegisterState();
}

class RegisterState extends State<RegisterPage> {
  
  final RegisterController registerController =
      GetIt.instance.get<RegisterController>();
  final TextEditingController userController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool hidePassword = true;
  bool _checked = false;
  String? emailError;
  String? userError;
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
            bottom: 600,
            child: Image.asset("assets/images/logo.png"),
          ),
          Positioned(
            height: 520,
            left: 24,
            right: 24,
            bottom: 70,
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
                          AppLocalizations.of(context).register_title,
                          style: const TitleSmallBoldTextStyle(
                              color: LocalColors.edutalk),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 24),
                        child: Text(
                          AppLocalizations.of(context)!.register_description,
                          style:
                              const SmallNormalTextStyle(color: Colors.black54),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: const Color(0xffEFEFEF),
                            borderRadius: BorderRadius.circular(8)),
                        margin:
                            const EdgeInsets.only(left: 24, right: 24, top: 24),
                        child: TextField(
                          controller: userController,
                          onSubmitted: (text) {
                            setState(() {
                              userError = UserValidator.isUserValid(text)
                                  ? null
                                  : "Tên không được để trống";
                            });
                          },
                          keyboardType: TextInputType.text,
                          style: const SmallNormalTextStyle(),
                          decoration: MainInputDecoration(
                              const AssetImage("assets/images/user.png"),
                              hint: AppLocalizations.of(context)!.register_name,
                              error: userError),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: const Color(0xffEFEFEF),
                            borderRadius: BorderRadius.circular(8)),
                        margin:
                            const EdgeInsets.only(left: 24, right: 24, top: 24),
                        child: TextField(
                          controller: emailController,
                          onSubmitted: (text) {
                            setState(() {
                              emailError = EmailValidator.isEmailValid(text)
                                  ? null
                                  : "Email không đúng định dạng";
                            });
                          },
                          keyboardType: TextInputType.emailAddress,
                          style: const SmallNormalTextStyle(),
                          decoration: MainInputDecoration(
                              const AssetImage("assets/images/mail.png"),
                              hint: AppLocalizations.of(context)!.login_email,
                              error: emailError),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: LocalColors.input,
                            borderRadius: BorderRadius.circular(8)),
                        margin:
                            const EdgeInsets.only(left: 24, right: 24, top: 32),
                        child: TextField(
                          controller: passwordController,
                          onSubmitted: (text) {
                            setState(() {
                              passwordError =
                                  PasswordValidator.isPasswordValid(text)
                                      ? null
                                      : "Mật khẩu phải trên 6 kí tự";
                            });
                          },
                          obscureText: hidePassword,
                          keyboardType: TextInputType.emailAddress,
                          style: const SmallNormalTextStyle(),
                          decoration: MainInputDecoration(
                            const AssetImage(
                              "assets/images/lock.png",
                            ),
                            hint: AppLocalizations.of(context)!.login_password,
                            error: passwordError,
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  hidePassword = !hidePassword;
                                });
                              },
                              child: Icon(
                                hidePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                size: 20,
                                color: LocalColors.onBackground,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 40,
                        margin:
                            const EdgeInsets.only(left: 1, right: 24, top: 5),
                        child: Transform.scale(
                          scale: 0.9,
                          child: CheckboxListTile(
                            controlAffinity: ListTileControlAffinity.leading,
                            title: GestureDetector(
                              onTap: () async {
                                var res = await showDialog(
                                  context: context,
                                  builder: (context) {
                                    return const Dialog(
                                      child: TermAndCondition(),
                                    );
                                  },
                                );

                                if (res == true) {
                                  setState(() {
                                    _checked = true;
                                  });
                                }
                              },
                              child: const Text("Tôi đồng ý điều khoản",
                                  style: TextStyle(fontSize: 15)),
                            ),
                            // contentPadding: EdgeInsets.all(1),
                            value: _checked,
                            onChanged: (bool? value) {
                              setState(() {
                                _checked = value!;
                              });
                            },
                            activeColor: Colors.deepPurple[600],
                            checkColor: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        height: 48,
                        margin:
                            const EdgeInsets.only(left: 24, right: 24, top: 28),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: LocalColors.edutalk),
                          onPressed: signup,
                          child: Text(
                            AppLocalizations.of(context)!.register,
                            style:
                                const SmallNormalTextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ]),
              ),
            ),
          ),
          Positioned(
            height: 30,
            left: 24,
            right: 24,
            bottom: 20,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                    FadePageRoute(const LoginPage()),
                    (Route<dynamic> route) => false);
              },
              child: Center(
                child: RichText(
                  text: TextSpan(
                    text: AppLocalizations.of(context)!.question_register,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    children: const [
                      TextSpan(
                        text: ' Login',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  signup() async {
    var name = userController.text;
    var email = emailController.text;
    var password = passwordController.text;
    var res = await registerController.signUpAsync(name, email, password);
    if (res == null) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Oops...',
        text: "Sai mật khẩu hoặc Email",
      );
      return;
    }
    var nav = Navigator.of(context);
    EasyLoading.showSuccess("Đăng ký thành công");
    nav.pushAndRemoveUntil(
        SidePageRoute(const LoginPage()), (Route<dynamic> route) => false);
  }
}
