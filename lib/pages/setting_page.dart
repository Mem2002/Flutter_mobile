import 'dart:convert';

import 'package:clipboard/clipboard.dart';
import 'package:flutter_app/controllers/setting_controller.dart';
import 'package:flutter_app/pages/login_page.dart';
import 'package:flutter_app/styles/text_styles.dart';
import 'package:flutter_app/widgets/theme_base_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../styles/button_styles.dart';
import '../utils/page_router.dart';
import '../utils/statusbar_utils.dart';
import '../widgets/item_setting.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<StatefulWidget> createState() => SettingPageState();
}

class SettingPageState extends State<SettingPage> {
  final SettingController controller = GetIt.instance.get<SettingController>();

  @override
  void initState() {
    super.initState();
    controller.getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return ThemeBasePage(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            systemOverlayStyle: StatusBarUtils.statusConfig(),
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: Theme.of(context).colorScheme.primary,
            collapsedHeight: 56,
            pinned: true,
          ),
          SliverToBoxAdapter(
            child: ValueListenableBuilder(
              valueListenable: controller.data,
              builder: (context, value, child) {
                if (value == null) {
                  return Container();
                }
                return Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: 160,
                      width: 160,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.background,
                            borderRadius: BorderRadius.circular(16)),
                        padding: const EdgeInsets.all(16),
                        child: QrImageView(data: jsonEncode(value.toJson())),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      alignment: Alignment.center,
                      child: Text(
                        value.name,
                        style: NormalTextStyle(
                            color: Theme.of(context).colorScheme.onBackground),
                      ),
                    ),
                    Container(
                        alignment: Alignment.center,
                        child: Text(
                          "(${value.id + 100000})",
                          style: SmallNormalTextStyle(
                              color:
                                  Theme.of(context).colorScheme.onBackground),
                        )),
                    Container(
                      margin: const EdgeInsets.only(bottom: 48),
                      alignment: Alignment.center,
                      child: Text(
                        value.email,
                        style: SmallNormalTextStyle(
                            color: Theme.of(context).colorScheme.onBackground),
                      ),
                    ),
                    itemDisplay("Số điện thoại", value.phone, hasEdit: false),
                    FutureBuilder(
                      future: controller.deviceId(),
                      builder: (context, snapshot) {
                        return GestureDetector(
                          onDoubleTap: () {
                            FlutterClipboard.copy(snapshot.data ?? "").then(
                                (value) => EasyLoading.showInfo("Copied"));
                          },
                          child: itemDisplay("Device Id", snapshot.data ?? "",
                              hasEdit: false),
                        );
                      },
                    ),
                    itemDisplay(
                        "Ngày sinh",
                        DateFormat("dd/MM/yyyy").format(
                          (value.birthday),
                        ),
                        hasEdit: false),
                    itemDisplay("Mật khẩu", "******", hasEdit: false),
                    FutureBuilder(
                      future: PackageInfo.fromPlatform(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData == false ||
                            snapshot.data == null) {
                          return Container();
                        }
                        return itemDisplay("Phiên bản",
                            "${snapshot.data!.version}(${snapshot.data!.buildNumber})",
                            hasEdit: false);
                      },
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          left: 24, right: 24, bottom: 4, top: 12),
                      alignment: Alignment.centerLeft,
                      child: Row(children: [
                        Text(
                          "Thông tin ngân hàng",
                          style: SmallBoldTextStyle(
                              color: Theme.of(context).colorScheme.primary),
                        ),
                        // Container(
                        //   margin: const EdgeInsets.only(left: 8),
                        //   child: Icon(Icons.edit,
                        //       size: 16,
                        //       color: Theme.of(context)
                        //           .colorScheme
                        //           .onBackground),
                        // )
                      ]),
                    ),
                    itemDisplay(
                        "Chủ tài khoản", ((value.bankAccounts).first).ownerName,
                        hasEdit: false),
                    itemDisplay(
                        "Số tài khoản", ((value.bankAccounts).first).number,
                        hasEdit: false),
                    itemDisplay(
                        "Ngân hàng", ((value.bankAccounts).first).bankName,
                        hasEdit: false),
                    Container(
                      margin: const EdgeInsets.only(
                          left: 24, right: 24, bottom: 4, top: 12),
                      alignment: Alignment.centerLeft,
                      child: Row(children: [
                        Text(
                          "Quản lý tài khoản",
                          style: SmallBoldTextStyle(
                              color: Theme.of(context).colorScheme.primary),
                        ),
                        // Container(
                        //   margin: const EdgeInsets.only(left: 8),
                        //   child: Icon(Icons.edit,
                        //       size: 16,
                        //       color: Theme.of(context)
                        //           .colorScheme
                        //           .onBackground),
                        // )
                      ]),
                    ),
                    GestureDetector(
                      onTap: () {
                        deleteAccount();
                      },
                      child: itemDisplay("Xóa tài khoản", "", hasEdit: false),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 12, bottom: 24),
                      alignment: Alignment.center,
                      child: SizedBox(
                        height: 44,
                        width: 160,
                        child: ElevatedButton(
                          onPressed: signOut,
                          style: PrimaryButtonStyle(context),
                          child: const Text("Logout"),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }

  deleteAccount() {
    launchUrlString("https://forms.gle/ZHVxPqWgpVViSPLC8",
            webOnlyWindowName: "_blank")
        .then((value) {
      if (value != true) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Oops...',
          text: "Có lỗi xảy ra",
        );
      }
    });
  }

  signOut() async {
    await controller.signOut().then((value) => Navigator.of(context)
        .pushAndRemoveUntil(
            FadePageRoute(const LoginPage()), (Route<dynamic> route) => false));
  }

  Widget itemDisplay(String title, String value, {bool hasEdit = true}) {
    return ItemSettingWidget(title: title, value: value, hasEdit: hasEdit);
  }

  loadVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo;
  }
}
