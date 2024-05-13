import 'package:flutter_app/extensions/shift_off_extensions.dart';
import 'package:flutter_app/models/form_model.dart';
import 'package:flutter_app/services/application_service.dart';
import 'package:flutter_app/styles/text_styles.dart';
import 'package:flutter_app/widgets/container_border.dart';
import 'package:flutter_app/widgets/primary_botton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class OnLeaveFormView extends StatefulWidget {
  Function(FormModel model) onSubmit;
  OnLeaveFormView({super.key, required this.onSubmit});

  @override
  State<StatefulWidget> createState() => OnLeaveFormState();
}

class OnLeaveFormState extends State<OnLeaveFormView> {
   TimeOfDay startTime = const TimeOfDay(hour: 8, minute: 30);
  TimeOfDay endTime = const TimeOfDay(hour: 18, minute: 0);
  int select = 0;
  final TextEditingController controller = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final IApplicationService service = GetIt.instance.get<IApplicationService>();
  DateTime currentTime = DateTime.now();
  double? totalDay = 0.5;
  ShiftOff shiftOff = ShiftOff.morning;
  List<double> allDays = List.generate(60, (index) => (index + 1) / 2);
  List<ShiftOff> allShift = [
    ShiftOff.morning,
    ShiftOff.afternoon,
    ShiftOff.night
  ];

  void loadProfile() async {
    EasyLoading.show();
    var profile = await service.getProfile();
    phoneController.text = profile?.phone ?? "";
    EasyLoading.dismiss();
  }

  @override
  void initState() {
    loadProfile();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 24, right: 24),
          child: Text(AppLocalizations.of(context)!.form_start_time),
        ),
        ContainerBorder(
          padding: EdgeInsets.zero,
          margin: const EdgeInsets.only(left: 24, top: 12, right: 24),
          child: GestureDetector(
            onTap: selectDay,
            child: Container(
              color: Colors.transparent,
              padding: const EdgeInsets.only(
                  left: 16, right: 16, top: 12, bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    DateFormat("dd/MM/yyyy").format(currentTime),
                    style: const SmallNormalTextStyle(),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: const Icon(Icons.arrow_drop_down),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 24, right: 24, top: 16),
          child: Text(AppLocalizations.of(context)!.form_shift_off),
        ),
        ContainerBorder(
          margin: const EdgeInsets.only(left: 24, right: 24, top: 12),
          child: DropdownButton<ShiftOff>(
            menuMaxHeight: MediaQuery.of(context).size.height / 2,
            padding: const EdgeInsets.only(left: 16, right: 16),
            value: shiftOff,
            icon: Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                child: const Icon(Icons.arrow_drop_down),
              ),
            ),
            elevation: 4,
            style: const SmallNormalTextStyle(),
            underline: Container(
              height: 0,
              color: Theme.of(context).colorScheme.primary,
            ),
            onChanged: (ShiftOff? value) {
              if (value == null) {
                return;
              }
              setState(() {
                shiftOff = value;
              });
            },
            items: allShift.map<DropdownMenuItem<ShiftOff>>((ShiftOff value) {
              return DropdownMenuItem<ShiftOff>(
                value: value,
                child: Text(
                  value.getTitle(context),
                  style: const SmallNormalTextStyle(),
                ),
              );
            }).toList(),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 24, right: 24, top: 16),
          child: Text(AppLocalizations.of(context)!.form_total_days),
        ),
        ContainerBorder(
          margin: const EdgeInsets.only(left: 24, right: 24, top: 12),
          child: DropdownButton<double>(
            menuMaxHeight: MediaQuery.of(context).size.height / 2,
            padding: const EdgeInsets.only(left: 16, right: 16),
            value: totalDay,
            icon: Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                child: const Icon(Icons.arrow_drop_down),
              ),
            ),
            elevation: 4,
            style: const SmallNormalTextStyle(),
            underline: Container(
              height: 0,
              color: Theme.of(context).colorScheme.primary,
            ),
            onChanged: (double? value) {
              setState(() {
                totalDay = value;
              });
            },
            items: allDays.map<DropdownMenuItem<double>>((double value) {
              return DropdownMenuItem<double>(
                value: value,
                child: Text(
                  '$value ngày',
                  style: const SmallNormalTextStyle(),
                ),
              );
            }).toList(),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 24, right: 24, top: 16),
          child: const Text("Số điện thoại liên hệ"),
        ),
        ContainerBorder(
          margin:
              const EdgeInsets.only(left: 24, right: 24, top: 12, bottom: 12),
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
          ),
          child: TextField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            style: const SmallNormalTextStyle(),
            decoration: const InputDecoration(border: InputBorder.none),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 24, right: 24, top: 16),
          child: const Text("Loại nghỉ phép"),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            RadioListTile(
                title: const Text(
                  'Nghỉ dùng phép',
                  style: TextStyle(fontSize: 13),
                ),
                value: 0,
                groupValue: select,
                onChanged: setSelect),
            RadioListTile(
                title: const Text(
                  'Nghỉ không lương',
                  style: TextStyle(fontSize: 13),
                ),
                value: 1,
                groupValue: select,
                onChanged: setSelect)
          ],
        ),
        Container(
          margin: const EdgeInsets.only(left: 24, right: 24, top: 16),
          child: Text(AppLocalizations.of(context)!.form_reason),
        ),
        ContainerBorder(
          margin:
              const EdgeInsets.only(left: 24, right: 24, top: 12, bottom: 12),
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 12),
          child: TextField(
            minLines: 2,
            controller: controller,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            style: const SmallNormalTextStyle(),
            decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.form_reason),
          ),
        ),
        Container(
          height: 48,
          margin: const EdgeInsets.only(left: 24, right: 24, top: 16),
          child: SecondaryButton(
              title: AppLocalizations.of(context)!.send,
              onPressed: () {
                widget.onSubmit(
                  FormModel(
                      type: FormType.onLeave,
                      startTime: currentTime,
                      days: totalDay,
                      shiftOff: shiftOff,
                      reason: controller.text,
                      phone: phoneController.text,
                      typeLeave: select,
                      timeCheckin: DateTime(startTime.hour, startTime.minute),
                      timeCheckout: DateTime(startTime.hour, startTime.minute),),
                );
              }),
        ),
      ],
    );
  }

  void setSelect(Object? value) {
    print(value);
    setState(() {
      select = int.parse(value.toString());
    });
  }

  selectDay() async {
    var selectedDate = await showDatePicker(
      context: context,
      initialDate: currentTime,
      firstDate: (DateTime.now()).subtract(const Duration(days: 3)),
      lastDate: DateTime.now().add(const Duration(days: 31)),
    );
    if (selectedDate == null) {
      return;
    }
    setState(() {
      currentTime = selectedDate;
    });
  }
}
