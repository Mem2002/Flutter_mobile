import 'package:flutter_app/controllers/payment_controller.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mat_month_picker_dialog/mat_month_picker_dialog.dart';

import '../styles/text_styles.dart';
import '../styles/themes.dart';
import '../utils/statusbar_utils.dart';
import '../widgets/item_setting.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<StatefulWidget> createState() => PaymentPageState();
}

class PaymentPageState extends State<PaymentPage> {
  DateTime currentTime = DateTime.now();
  ScrollController scrollController = ScrollController();
  final PaymentController controller = GetIt.instance.get<PaymentController>();
  double opacity = 0;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(scrollChange);
    var now = DateTime.now();
    var month = now.month - 1;
    var year = now.year;
    if (now.day < 10) {
      month -= 1;
    }
    if (month <= 0) {
      month += 12;
      year -= 1;
    }
    controller.getPayslip(month, year);
    currentTime = DateTime(year, month, 1);
  }

  scrollChange() {
    setState(() {
      opacity = scrollController.offset <= 0
          ? 0
          : scrollController.offset >= 56
              ? 1
              : scrollController.offset / 56;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            height: MediaQuery.of(context).size.height / 2 + 24,
            child: Image.asset(
              Themes.currentBackground,
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                await controller.getPayslip(
                    currentTime.month, currentTime.year);
              },
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                controller: scrollController,
                slivers: [
                  SliverAppBar(
                    systemOverlayStyle: StatusBarUtils.statusConfigWithColor(
                        Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(opacity)),
                    backgroundColor: Theme.of(context)
                        .colorScheme
                        .primary
                        .withOpacity(opacity),
                    shadowColor: Colors.transparent,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    collapsedHeight: 56,
                    toolbarHeight: 56,
                    expandedHeight: 56,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      centerTitle: false,
                      title: GestureDetector(
                        onTap: selectMonth,
                        child: Container(
                          margin: EdgeInsets.zero,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                DateFormat("MMMM yyyy").format(currentTime),
                                style: BoldTextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary),
                              ),
                              Icon(Icons.arrow_drop_down,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SafeArea(
                      child: Container(
                        margin: const EdgeInsets.only(top: 0, bottom: 24),
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.background,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(32),
                                topRight: Radius.circular(32))),
                        child: ValueListenableBuilder(
                          valueListenable: controller.data,
                          builder: (context, value, child) {
                            if (value == null) {
                              return SizedBox(
                                height:
                                    MediaQuery.of(context).size.height / 3 * 2,
                                child: const Center(child: Text("Đang tải")),
                              );
                            }
                            if (value.isEmpty) {
                              return SizedBox(
                                height:
                                    MediaQuery.of(context).size.height / 3 * 2,
                                child: const Center(
                                    child: Text("Chưa có phiếu lương")),
                              );
                            }
                            return Column(
                                children: List.generate(controller.keys.length,
                                    (index) {
                              return paymentItem(
                                  context,
                                  controller.keys[index],
                                  value[controller.keys[index].key]);
                            }));
                          },
                          
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget paymentItem(BuildContext context, PayslipKey key, dynamic data) {
    if (key.type == PayslipType.title) {
      return header(key.key);
    }

    String value = "";
    switch (key.type) {
      case PayslipType.percent:
        if (data is String) {
               print("nam anh");
          if (data.contains('%') == true) {
            value = data.toString();
            print("nam anh");
            break;
          }
          print("nam anh");
        }
        data ??= 0;
        final percentFormat = NumberFormat("#.##", "en_US");
        value = "${percentFormat.format(data * 100)}%";
        break;
      case PayslipType.money:
        if (data is String || data == null) {
          value = data?.toString() ?? "N/A";
          break;
        }
        final percentFormat = NumberFormat.currency(
            customPattern: "#,##0.### đ", decimalDigits: 0);
        value = percentFormat.format(data);
        break;
      case PayslipType.number:
        if (data is String || data == null) {
          value = data?.toString() ?? "N/A";
          break;
        }
        final percentFormat = NumberFormat("#.##", "en_US");
        value = data != null ? percentFormat.format(data) : "N/A";
        break;
      default:
        value = data?.toString() ?? "N/A";
    }
    return ItemSettingWidget(
      title: text(context)[key.key] ?? key.key,
      value: value,
      hasEdit: false,
      important: key.important,
    );
  }

  Map<String, String> text(BuildContext context) => {
        "phat": AppLocalizations.of(context)!.phat,
        "thuong": AppLocalizations.of(context)!.thuong,
        "phu_cap": AppLocalizations.of(context)!.phu_cap,
        "tam_ung": AppLocalizations.of(context)!.tam_ung,
        "tang_ca": AppLocalizations.of(context)!.tang_ca,
        "phep_nam": AppLocalizations.of(context)!.phep_nam,
        "thu_viec": AppLocalizations.of(context)!.thu_viec,
        "tru_khac": AppLocalizations.of(context)!.tru_khac,
        "muc_luong": AppLocalizations.of(context)!.muc_luong,
        "bhxh_thang": AppLocalizations.of(context)!.bhxh_thang,
        "cong_thang": AppLocalizations.of(context)!.cong_thang,
        "thu_nhap_kra": AppLocalizations.of(context)!.thu_nhap_kra,
        "cong_dinh_muc": AppLocalizations.of(context)!.cong_dinh_muc,
        "khong_du_cong": AppLocalizations.of(context)!.khong_du_cong,
        "luong_thuc_nhan": AppLocalizations.of(context)!.luong_thuc_nhan,
        "so_exp_tich_luy": AppLocalizations.of(context)!.so_exp_tich_luy,
        "tong_cong_thang": AppLocalizations.of(context)!.tong_cong_thang,
        "so_ngay_phep_con_lai":
            AppLocalizations.of(context)!.so_ngay_phep_con_lai,
        "ngay_le_tet_viec_rieng":
            AppLocalizations.of(context)!.ngay_le_tet_viec_rieng,
        "phan_tram_kpi_thoi_gian":
            AppLocalizations.of(context)!.phan_tram_kpi_thoi_gian,
        "tong_cac_khoan_thu_nhap":
            AppLocalizations.of(context)!.tong_cac_khoan_thu_nhap,
        "thu_nhap_thieu_thang_truoc":
            AppLocalizations.of(context)!.thu_nhap_thieu_thang_truoc,
        "thuong_trai_phieu_tich_luy":
            AppLocalizations.of(context)!.thuong_trai_phieu_tich_luy,
        "tong_cac_khoan_tru_thu_nhap":
            AppLocalizations.of(context)!.tong_cac_khoan_tru_thu_nhap,
        "thoi_diem_trai_phieu_co_hieu_luc":
            AppLocalizations.of(context)!.thoi_diem_trai_phieu_co_hieu_luc,
        "phan_tram_kpi_hoan_thanh_cong_viec":
            AppLocalizations.of(context)!.phan_tram_kpi_hoan_thanh_cong_viec
      };

  Widget header(String title) {
    return Container(
      margin: const EdgeInsets.only(left: 24, right: 24, top: 24),
      child: Text(
        title,
        style: SmallBoldTextStyle(color: Theme.of(context).colorScheme.primary),
      ),
    );
  }

  selectMonth() async {
    var selected = await showMonthPicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1970),
        lastDate: DateTime(2050));

    setState(() {
      currentTime = selected ?? currentTime;
      controller.getPayslip(currentTime.month, currentTime.year);
    });
  }

  nextMonth() {
    if (DateTime.now()
        .isBefore(DateTime(currentTime.year, currentTime.month + 1, 1))) {
      return;
    }

    setState(() {
      currentTime = DateTime(currentTime.year, currentTime.month + 1, 1);
      controller.getPayslip(currentTime.month, currentTime.year);
    });
  }

  previousMonth() {
    setState(() {
      var month = currentTime.month - 1;
      currentTime = DateTime(
          month < 1 ? currentTime.year - 1 : currentTime.year,
          month < 1 ? 12 : month,
          1);
      controller.getPayslip(currentTime.month, currentTime.year);
    });
  }
}
