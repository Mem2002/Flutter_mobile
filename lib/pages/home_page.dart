import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_app/controllers/user_controller.dart';
import 'package:flutter_app/models/user_model.dart';
import 'package:flutter_app/pages/form_page.dart';
import 'package:flutter_app/pages/login_page.dart';
import 'package:flutter_app/pages/qr_scanner.dart';
import 'package:flutter_app/pages/setting_page.dart';
import 'package:flutter_app/pages/attendance_page.dart';
import 'package:flutter_app/pages/payment_page.dart';
import 'package:intl/intl.dart';
import '../controllers/home_controller.dart';
import '../styles/themes.dart';
import '../utils/statusbar_utils.dart';
import 'package:flutter_app/widgets/primary_botton.dart';
import '../utils/page_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import '../styles/text_styles.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final UserController controller = GetIt.instance.get<UserController>();

  @override
  void initState() {
    super.initState();
    // Gọi phương thức getProfile để tải thông tin người dùng
    controller.getProfile();
  }

  @override
  Widget build(BuildContext context) {
    StatusBarUtils.config();
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            height: MediaQuery.of(context).size.height / 2 + 48,
            child: Image.asset(
              Themes.currentBackground,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: MediaQuery.of(context).size.height / 2,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
            ),
          ),
          Positioned(
            top: 12,
            right: 16,
            left: 16,
            child: SafeArea(
              child: ValueListenableBuilder<UserResponses?>(
                valueListenable: controller.data,
                builder: (context, userResponses, child) {
                  String name = userResponses?.user.username ?? "Guest";
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Welcome $name",
                                  style: TitleNormalTextStyle(
                                    color: Theme.of(context).colorScheme.onPrimary,
                                  ),
                                ),
                                Text(
                                  DateFormat(
                                    AppLocalizations.of(context)!.home_currentTime,
                                    AppLocalizations.of(context)!.locale,
                                  ).format(DateTime.now()),
                                  style: SmallNormalTextStyle(
                                    color: Theme.of(context).colorScheme.onPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: MediaQuery.of(context).size.height / 2,
            bottom: 0,
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: 56,
                      margin: const EdgeInsets.only(top: 16),
                      child: PrimaryButton(
                        onPressed: navigateToScanner,
                        title: AppLocalizations.of(context)!.home_qr_code,
                        icon: "assets/images/qr_code.png",
                      ),
                    ),
                    Container(
                      height: 56,
                      margin: const EdgeInsets.only(top: 16),
                      child: PrimaryButton(
                        onPressed: navigateToAttendance,
                        title: AppLocalizations.of(context)!.home_attendance,
                        icon: "assets/images/ic_calendar.png",
                      ),
                    ),
                    Container(
                      height: 56,
                      margin: const EdgeInsets.only(top: 16),
                      child: PrimaryButton(
                        onPressed: navigateToPayment,
                        title: AppLocalizations.of(context)!.home_payment,
                        icon: "assets/images/ic_payment1.png",
                      ),
                    ),
                    Container(
                      height: 56,
                      margin: const EdgeInsets.only(top: 16),
                      child: PrimaryButton(
                        onPressed: navigateToLogout,
                        title: AppLocalizations.of(context)!.home_logout,
                        icon: "assets/images/ic_logout.png",
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void navigateToScanner() {
    Navigator.of(context).push(SidePageRoute(const ScannerPage()));
  }

  void navigateToAttendance() {
    Navigator.of(context).push(SidePageRoute(const AttendancePage()));
  }

  void navigateToPayment() {
    Navigator.of(context).push(SidePageRoute(const PaymentPage()));
  }

  void navigateToLogout() {
    Navigator.of(context).push(SidePageRoute(const LoginPage()));
  }
}
