import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/attendance_page.dart';
import 'package:intl/intl.dart';
import '../controllers/home_controller.dart';
import '../styles/themes.dart';
import '../utils/statusbar_utils.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/widgets/primary_botton.dart';
import '../utils/page_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
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
                        onPressed: navigateToAttendance,
                        title: AppLocalizations.of(context)!.home_attendance,
                        icon: "assets/images/ic_calendar.png",
                      ),
                    ),
                    // Container(
                    //   height: 56,
                    //   margin: const EdgeInsets.only(top: 16),
                    //   child: PrimaryButton(
                    //     onPressed: navigateToPayment,
                    //     title: AppLocalizations.of(context)!.home_payment,
                    //     icon: "assets/images/ic_payment1.png",
                    //   ),
                    // ),
                    // Container(
                    //   height: 56,
                    //   margin: const EdgeInsets.only(top: 16),
                    //   child: PrimaryButton(
                    //     onPressed: navigateToForm,
                    //     title: AppLocalizations.of(context)!.home_form,
                    //     icon: "assets/images/ic_propose.png",
                    //   ),
                    // ),
                    // Container(
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

  navigateToAttendance() {
    Navigator.of(context).push(SidePageRoute(const AttendancePage()));
  }
}
