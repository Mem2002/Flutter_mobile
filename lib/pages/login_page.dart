// ignore_for_file: use_build_context_synchronously

import 'package:flutter_app/pages/home_page.dart';
import 'package:flutter_app/pages/register_page.dart';
import 'package:flutter_app/services/api.dart';
import 'package:flutter_app/styles/text_styles.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
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
  // final LoginController loginController = GetIt.instance.get<LoginController>();
  final TextEditingController emailController =
      TextEditingController(text: "mem@gmail.com");
  final TextEditingController passwordController =
      TextEditingController(text: "Mem@@382002");
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
                          style: const TitleSmallBoldTextStyle(
                              color: LocalColors.edutalk),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 24),
                        child: Text(
                          AppLocalizations.of(context)!.login_description,
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
                                      : "Mật khẩu phải có 6 kí tự";
                            });
                          },
                          obscureText: hidePassword,
                          keyboardType: TextInputType.emailAddress,
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
                        height: 48,
                        margin:
                            const EdgeInsets.only(left: 24, right: 24, top: 32),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: LocalColors.edutalk),
                          onPressed: login,
                          child: Text(
                            AppLocalizations.of(context)!.login,
                            style:
                                const SmallNormalTextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ]),
              ),
            ),
          ),
      
        ],
      ),
    );
  }

  login() async {
    var email = emailController.text;
    var password = passwordController.text;

    // Hiển thị loading dialog khi đang gửi yêu cầu
    QuickAlert.show(
      context: context,
      type: QuickAlertType.loading,
      title: 'Đang kết nối...',
    );

    try {
      // Gọi API đăng nhập
      var res = await Api.logInAsync(email, password);

      // Đóng loading dialog sau khi có kết quả
      Navigator.of(context).pop();

      // Kiểm tra kết quả trả về từ API
      if (res == null || res.dt.accessToken.isEmpty != false) {
        // Nếu không có token hoặc thông tin không chính xác
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Lỗi',
          text: res?.em ?? "Sai mật khẩu hoặc email",
        );
      } else {
        // Nếu đăng nhập thành công, điều hướng đến trang chủ
        var nav = Navigator.of(context);
        nav.pushAndRemoveUntil(
            SidePageRoute(const HomePage()), (Route<dynamic> route) => false);
      }
    } catch (error) {
      // Xử lý lỗi nếu gặp sự cố kết nối hoặc lỗi từ server
      Navigator.of(context).pop(); // Đóng loading dialog
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Lỗi kết nối',
        text: "Không thể kết nối đến server. Vui lòng thử lại sau.",
      );
    }
  }
  // pushAndRemoveUntil là một phương thức của Navigator giúp điều hướng đến một trang mới
  // const giúp tối ưu hóa hiệu suất khi đối tượng không thay đổi.

//   (Route<dynamic> route) => false:

// Đây là một hàm ẩn danh (lambda function) được sử dụng để kiểm tra từng Route trong ngăn xếp điều hướng.
// Khi hàm này trả về false cho tất cả các Route, pushAndRemoveUntil sẽ xóa tất cả các trang hiện có khỏi ngăn xếp điều hướng, chỉ để lại trang mới (HomePage) trong ngăn xếp.
}

class MainInputDecoration extends InputDecoration {
  @override
  MainInputDecoration(ImageProvider prefixImg,
      {super.suffixIcon, String hint = "", String? error})
      : super(
          fillColor: Colors.red,
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
            borderSide:
                const BorderSide(color: LocalColors.edutalk, width: 1.0),
            borderRadius: BorderRadius.circular(8.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide:
                const BorderSide(color: LocalColors.edutalk, width: 1.0),
          ),
        );
}
