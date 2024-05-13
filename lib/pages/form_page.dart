// ignore_for_file: use_build_context_synchronously

import 'package:flutter_app/controllers/form_controller.dart';
import 'package:flutter_app/extensions/form_type_extensions.dart';
import 'package:flutter_app/extensions/shift_off_extensions.dart';
import 'package:flutter_app/extensions/working_hour_extensions.dart';
import 'package:flutter_app/models/form_model.dart';
import 'package:flutter_app/pages/add_form_page.dart';
import 'package:flutter_app/styles/text_styles.dart';
import 'package:flutter_app/utils/dialog_utils.dart';
import 'package:flutter_app/utils/page_router.dart';
import 'package:flutter_app/widgets/sliver_date_app_bar.dart';
import 'package:flutter_app/widgets/theme_base_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:mat_month_picker_dialog/mat_month_picker_dialog.dart';

import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<StatefulWidget> createState() => FormState();
}

class FormState extends State<FormPage> {
  final FormController controller = GetIt.instance.get<FormController>();
  List<FormModel> data = [];
  DateTime currentTime = DateTime.now();

  @override
  void initState() {
    EasyLoading.show();
    reloadData().then((value) => EasyLoading.dismiss());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ThemeBasePage(
      child: RefreshIndicator(
        onRefresh: reloadData,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            SliverDateAppBar(
              actions: [
                IconButton(
                  onPressed: addForm,
                  icon: const Icon(Icons.add),
                  iconSize: 24,
                  tooltip: "Thêm",
                )
              ],
              currentTime: currentTime,
              onTap: selectMonth,
            ),
            SliverToBoxAdapter(
              child: data.isEmpty
                  ? const SizedBox(
                      height: 240,
                      child: Center(
                        child: Text("Chưa có đề xuất nào!"),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: List.generate(data.length, (index) {
                        var form = data[index];
                        return FormItemView(
                          form: form,
                          delete: () async {
                            await showConfirm(context, () {
                              deleteAsync(form);
                            },
                                title: "Xóa đề xuất",
                                text:
                                    "Bạn có chắc chắn muốn xóa '${form.type.getTitle(context)}' ngày ${DateFormat("dd/MM/yyyy").format(form.startTime)}?",
                                cancel: "Xem lại",
                                confirm: "Xóa ngay");
                          },
                          info: () {
                            viewReason(form.rejectReason ?? "");
                          },
                        );
                      }),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Future reloadData() async {
    var firstMonth = DateTime(currentTime.year, currentTime.month, 1);
    var nextMonth = (currentTime.month + 1);
    var year = currentTime.year;
    if (nextMonth == 13) {
      nextMonth = 1;
      year++;
    }
    var lastMonth =
        DateTime(year, nextMonth, 1).add(const Duration(minutes: -1));
    var proposes =
        await controller.getProposesAsync(from: firstMonth, to: lastMonth);
    setState(() {
      data = proposes;
    });
  }

  Future addForm() async {
    var res = await Navigator.of(context)
        .push<bool>(FadePageRoute(const AddFormPage()));
    if (res == true) {
      reloadData();
    }
  }

  selectMonth() async {
    var selected = await showMonthPicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1970),
        lastDate: DateTime(2050));
    if (selected == null) {
      return;
    }
    setState(() {
      currentTime = selected;
    });
    reloadData();
  }

  viewReason(String form) {
    showInfo(context, title: "Lý do từ chối", text: form);
  }

  Future deleteAsync(FormModel form) async {
    EasyLoading.show();
    var res = await controller.deleteAsync(form.id ?? 0);
    EasyLoading.dismiss();
    if (res?.error == false) {
      EasyLoading.showSuccess('Xóa thành công');
      reloadData();
      return;
    }

    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: 'Oops...',
      text: res?.message ?? "Có lỗi xảy ra",
    );
  }
}

// ignore: must_be_immutable
class FormItemView extends StatelessWidget {
  FormModel form;
  Function() delete;
  Function() info;
  FormItemView(
      {super.key,
      required this.form,
      required this.delete,
      required this.info});
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        margin: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 12),
        padding: EdgeInsets.only(
            left: 16,
            right: form.status == FormStatus.requested ? 64 : 12,
            top: 12,
            bottom: 12),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                  offset: Offset(1, 1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  color: Colors.black12)
            ]),
        child: getContent(context),
      ),
      Visibility(
        visible: form.status == FormStatus.requested,
        child: Positioned(
          right: 32,
          top: 48,
          child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      color: Theme.of(context)
                          .colorScheme
                          .shadow
                          .withOpacity(0.15),
                      offset: const Offset(1, 1),
                      blurRadius: 4,
                      blurStyle: BlurStyle.normal)
                ]),
            child: IconButton(
                onPressed: () {
                  delete();
                },
                icon: Icon(Icons.delete_outlined,
                    color: Theme.of(context).colorScheme.onPrimary)),
          ),
        ),
      ),
      Visibility(
        visible: form.status == FormStatus.rejected,
        child: Positioned(
          right: 32,
          top: 48,
          child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
                border: Border.all(
                    color: Theme.of(context).colorScheme.primary, width: 1),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      color: Theme.of(context)
                          .colorScheme
                          .shadow
                          .withOpacity(0.15),
                      offset: const Offset(1, 1),
                      blurRadius: 4,
                      blurStyle: BlurStyle.normal)
                ]),
            child: IconButton(
                onPressed: () {
                  info();
                },
                icon: Icon(Icons.info,
                    color: Theme.of(context).colorScheme.primary)),
          ),
        ),
      )
    ]);
  }

  Widget getContent(BuildContext context) {
    switch (form.type) {
      case FormType.onLeave:
        return FormOnLeaveItemView(
          form: form,
        );
      case FormType.ot:
        return FormChangeOtItemView(form: form);
      case FormType.addAttendance:
        return FormChangeAddAttendance(form: form);
      case FormType.changeShift:
      default:
        return FormChangeShiftItemView(form: form);
    }
  }
}

// ignore: must_be_immutable
class FormChangeAddAttendance extends StatelessWidget {
  FormModel form;
  FormChangeAddAttendance({super.key, required this.form});
  final DateFormat dateTimeFormat = DateFormat("HH:mm dd/MM/yyyy");
  final DateFormat dateFormat = DateFormat("dd/MM/yyyy");
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Row(
        children: [
          Expanded(
            child: Text(
              AppLocalizations.of(context)!.form_add_attendance,
              style: NormalBoldTextStyle(
                  color: Theme.of(context).colorScheme.primary),
            ),
          ),
          FormStatusView(
            status: form.status,
          )
        ],
      ),
      RichText(
        text: TextSpan(
          children: [
            const TextSpan(
                text: "Thời gian bắt đầu: ", style: SmallNormalTextStyle()),
            TextSpan(
              text: dateTimeFormat.format(form.timeCheckin),
              style: const MediumTextStyle(),
            ),
          ],
          style: const MediumTextStyle(),
        ),
      ),
      RichText(
        text: TextSpan(
          children: [
            const TextSpan(
                text: "Thời gian kết thúc: ", style: SmallNormalTextStyle()),
            TextSpan(
              text: dateTimeFormat.format(form.timeCheckout),
              style: const MediumTextStyle(),
            ),
          ],
          style: const MediumTextStyle(),
        ),
      ),
      Text("${AppLocalizations.of(context)!.form_reason} : ${form.reason}",
          style: const SmallNormalTextStyle()),
      Text("Ngày gửi ${dateFormat.format(form.createdTime ?? DateTime.now())}",
          style: const SmallNormalTextStyle()),
    ]);
  }
}

// ignore: must_be_immutable
class FormChangeOtItemView extends StatelessWidget {
  FormModel form;
  FormChangeOtItemView({super.key, required this.form});
  final DateFormat dateTimeFormat = DateFormat("HH:mm dd/MM/yyyy");
  final DateFormat dateFormat = DateFormat("dd/MM/yyyy");
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Row(
        children: [
          Text(
            AppLocalizations.of(context)!.form_ot,
            style: NormalBoldTextStyle(
                color: Theme.of(context).colorScheme.primary),
          ),
          FormStatusView(
            status: form.status,
          )
        ],
      ),
      RichText(
        text: TextSpan(
          children: [
            const TextSpan(text: "Giờ bắt đầu ", style: SmallNormalTextStyle()),
            TextSpan(
              text: dateTimeFormat.format(form.timeCheckin),
              style: const MediumTextStyle(),
            ),
          ],
          style: const MediumTextStyle(),
        ),
      ),
      RichText(
        text: TextSpan(
          children: [
            const TextSpan(
                text: "Giờ kết thúc ", style: SmallNormalTextStyle()),
            TextSpan(
              text: dateTimeFormat.format(form.timeCheckout),
              style: const MediumTextStyle(),
            ),
          ],
          style: const MediumTextStyle(),
        ),
      ),
      Text("${AppLocalizations.of(context)!.form_reason} : ${form.reason}",
          style: const SmallNormalTextStyle()),
      Text(
          "${AppLocalizations.of(context)!.form_result_overtime} : ${form.overtimeResults}",
          style: const SmallNormalTextStyle()),
      Text("Ngày gửi ${dateFormat.format(form.createdTime ?? DateTime.now())}",
          style: const SmallNormalTextStyle()),
    ]);
  }
}

// ignore: must_be_immutable
class FormChangeShiftItemView extends StatelessWidget {
  FormModel form;
  FormChangeShiftItemView({super.key, required this.form});
  final DateFormat dateTimeFormat = DateFormat("HH:mm dd/MM/yyyy");

  final DateFormat dateFormat = DateFormat("dd/MM/yyyy");
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Row(
        children: [
          Text(
            AppLocalizations.of(context)!.form_changeShift,
            style: NormalBoldTextStyle(
                color: Theme.of(context).colorScheme.primary),
          ),
          FormStatusView(
            status: form.status,
          )
        ],
      ),
      RichText(
        text: TextSpan(
          children: [
            const TextSpan(text: "Từ ", style: SmallNormalTextStyle()),
            TextSpan(text: form.workingHour?.getTitle(context) ?? ""),
            const TextSpan(text: " thành ", style: SmallNormalTextStyle()),
            TextSpan(text: form.workingHourChanged?.getTitle(context) ?? ""),
            const TextSpan(text: ", ngày ", style: SmallNormalTextStyle()),
            TextSpan(
              text: dateFormat.format(form.startTime),
              style: const MediumTextStyle(),
            )
          ],
          style: const MediumTextStyle(),
        ),
      ),
      Text("${AppLocalizations.of(context)!.form_reason} : ${form.reason}",
          style: const SmallNormalTextStyle()),
      Text(
          "Ngày gửi ${dateTimeFormat.format(form.createdTime ?? DateTime.now())}",
          style: const SmallNormalTextStyle()),
    ]);
  }
}

// ignore: must_be_immutable
class FormOnLeaveItemView extends StatelessWidget {
  FormModel form;
  FormOnLeaveItemView({super.key, required this.form});
  final DateFormat dateTimeFormat = DateFormat("HH:mm dd/MM/yyyy");
  final DateFormat dateFormat = DateFormat("dd/MM/yyyy");
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Row(
        children: [
          Text(
            AppLocalizations.of(context)!.form_onLeave,
            style: NormalBoldTextStyle(
                color: Theme.of(context).colorScheme.primary),
          ),
          FormStatusView(status: form.status)
        ],
      ),
      RichText(
        text: TextSpan(
          children: [
            const TextSpan(text: "Xin phép ", style: SmallNormalTextStyle()),
            TextSpan(text: "${form.days ?? 0.5}"),
            const TextSpan(text: " công, từ ", style: SmallNormalTextStyle()),
            TextSpan(
              text: form.shiftOff?.getTitle(context),
              style: const MediumTextStyle(),
            ),
            const TextSpan(text: " ngày ", style: SmallNormalTextStyle()),
            TextSpan(
              text: dateFormat.format(form.startTime),
              style: const MediumTextStyle(),
            ),
          ],
          style: const MediumTextStyle(),
        ),
      ),
      Text("${AppLocalizations.of(context)!.form_reason} : ${form.reason}",
          style: const SmallNormalTextStyle()),
      Text(
          "${AppLocalizations.of(context)!.form_type_of_leave}: ${form.typeLeave == 0 ? AppLocalizations.of(context)!.take_leave : AppLocalizations.of(context)!.unpaid_leave}",
          style: const SmallNormalTextStyle()),
      Text(
          "Ngày gửi : ${dateTimeFormat.format(form.createdTime ?? DateTime.now())}",
          style: const SmallerNormalTextStyle()),
    ]);
  }
}

// ignore: must_be_immutable
class FormStatusView extends StatelessWidget {
  FormStatus status;
  FormStatusView({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      decoration: BoxDecoration(
        color: getBackgroundColorFromStatus(),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
      child: Text(
        getTextFromStatus(context),
        style: SmallerMediumTextStyle(
          color: getForcegroundColorFromStatus(),
        ),
      ),
    );
  }

  Color getBackgroundColorFromStatus() {
    switch (status) {
      case FormStatus.requested:
        return Colors.orange;
      case FormStatus.approved:
        return Colors.green;
      case FormStatus.rejected:
        return Colors.red;
    }
  }

  Color getForcegroundColorFromStatus() {
    switch (status) {
      case FormStatus.requested:
        return Colors.black;
      case FormStatus.approved:
        return Colors.white;
      case FormStatus.rejected:
        return Colors.white;
    }
  }

  String getTextFromStatus(BuildContext context) {
    switch (status) {
      case FormStatus.requested:
        return AppLocalizations.of(context)!.form_status_request;
      case FormStatus.approved:
        return AppLocalizations.of(context)!.form_status_approved;
      case FormStatus.rejected:
        return AppLocalizations.of(context)!.form_status_rejected;
    }
  }
}
