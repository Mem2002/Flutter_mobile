// ignore: unused_import
import 'dart:io';
import 'package:flutter/material.dart';
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
// ignore: unused_import
import 'package:flutter_app/main.dart';
import 'package:flutter_app/widgets/primary_botton.dart';
import '../utils/page_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// ignore: duplicate_import
import 'package:intl/intl.dart';
import 'package:get_it/get_it.dart';
import '../styles/text_styles.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => HomePageState();
}

//  Using the Function in Your Flutter App
class HomePageState extends State<HomePage> {
  final HomeController controller = GetIt.instance.get<HomeController>();
  String deviceId = "";
  String error = "";

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
              child: ValueListenableBuilder(
                valueListenable: controller.data,
                builder: (context, value, child) {
                  String name = value?.username ?? "";
                  // String activeDevice = value?.activeDeviceId ?? "";
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
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary),
                              ),
                              Text(
                                DateFormat(
                                        AppLocalizations.of(context)!
                                            .home_currentTime,
                                        AppLocalizations.of(context)!.locale)
                                    .format(DateTime.now()),
                                style: SmallNormalTextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary),
                              )
                            ],
                          )),
                        ],
                      ),
                      Visibility(
                        // visible: activeDevice != deviceId,
                        child: Container(
                          margin: const EdgeInsets.only(top: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.7),
                              borderRadius: BorderRadius.circular(12)),
                          child: Text(
                            AppLocalizations.of(context)!.deviceId_warning,
                            style: NormalTextStyle(
                                color: Theme.of(context).colorScheme.onPrimary),
                          ),
                        ),
                      ),
                      ValueListenableBuilder(
                        valueListenable: controller.today,
                        builder: (context, value, child) {
                          var timeFormater = DateFormat("HH:mm");
                          if (value == null) {
                            return Container();
                          }
                          return Container(
                            margin: const EdgeInsets.only(top: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .background
                                    .withOpacity(0.7),
                                borderRadius: BorderRadius.circular(12)),
                            child: Row(children: [
                              Container(
                                margin: const EdgeInsets.only(right: 12),
                                height: 40,
                                width: 40,
                                child:
                                    Image.asset("assets/images/ic_success.png"),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      "Hôm nay đã check-in: ${timeFormater.format(value.checkIn)}"),
                                  Visibility(
                                    visible: value.checkOut != null,
                                    child: Text(
                                        "check-out: ${timeFormater.format((value.checkOut ?? DateTime.now()))}"),
                                  ),
                                ],
                              )
                            ]),
                          );
                        },
                      )
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
                        onPressed: navigateToForm,
                        title: AppLocalizations.of(context)!.home_form,
                        icon: "assets/images/ic_propose.png",
                      ),
                    ),
                    // Container(
                    //   height: 56,
                    //   margin: const EdgeInsets.only(top: 16),
                    //   // child: PrimaryButton(
                    //   //   onPressed: navigateToSetting,
                    //   //   title: AppLocalizations.of(context)!.home_setting,
                    //   //   icon: "assets/images/ic_setting.png",
                    //   // ),
                    // ),
                    Container(
                      height: 56,
                      margin: const EdgeInsets.only(top: 16),
                      child: PrimaryButton(
                        onPressed: navigateToLogout,
                        title: AppLocalizations.of(context)!.home_logout,
                        icon: "assets/images/ic_logout.png", // Đảm bảo có icon này
                      ),
                    ),
                    //   Container(
                    //   height: 56,
                    //   margin: const EdgeInsets.only(top: 16),
                    //   child: PrimaryButton(
                    //     onPressed: navigateToSetting,
                    //     title: AppLocalizations.of(context)!.home_setting,
                    //     icon: "assets/images/ic_setting.png",
                    //   ),
                    // )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }



  navigateToScanner() {
    Navigator.of(context).push(SidePageRoute(const ScannerPage()));
  }

  navigateToAttendance() {
    Navigator.of(context).push(SidePageRoute(const AttendancePage()));
  }

  navigateToPayment() {
    Navigator.of(context).push(SidePageRoute(const PaymentPage()));
  }

  navigateToForm() {
    Navigator.of(context).push(SidePageRoute(const FormPage()));
  }

  navigateToLogout() {
    Navigator.of(context).push(SidePageRoute(const LoginPage()));
  }
  //   navigateToSetting() {
  //   Navigator.of(context).push(SidePageRoute(const SettingPage()));
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.getProfile();
  }

}
