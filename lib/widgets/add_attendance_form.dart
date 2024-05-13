import 'package:flutter_app/models/form_model.dart';
import 'package:flutter_app/styles/text_styles.dart';
import 'package:flutter_app/widgets/container_border.dart';
import 'package:flutter_app/widgets/primary_botton.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class AddAttendanceFormView extends StatefulWidget {
  Function(FormModel model) onSubmit;
  AddAttendanceFormView({super.key, required this.onSubmit});

  @override
  State<StatefulWidget> createState() => AddAttendaceState();
}

class AddAttendaceState extends State<AddAttendanceFormView> {
  final TextEditingController controller = TextEditingController();
  DateTime date = DateTime.now();
  TimeOfDay startTime = const TimeOfDay(hour: 8, minute: 30);
  TimeOfDay endTime = const TimeOfDay(hour: 18, minute: 0);

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
        ContainerBorder(
          padding: EdgeInsets.zero,
          margin: const EdgeInsets.only(left: 24, top: 12, right: 24),
          child: GestureDetector(
            onTap: () {
              selectDay(date);
            },
            child: Container(
              color: Colors.transparent,
              padding: const EdgeInsets.only(
                  left: 16, right: 16, top: 12, bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    DateFormat("dd/MM/yyyy").format(date),
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
          child: Text(AppLocalizations.of(context)!.form_start_time_attendance),
        ),
        ContainerBorder(
          padding: EdgeInsets.zero,
          margin: const EdgeInsets.only(left: 24, top: 12, right: 24),
          child: GestureDetector(
            onTap: () {
              selectStartTime();
            },
            child: Container(
              color: Colors.transparent,
              padding: const EdgeInsets.only(
                  left: 16, right: 16, top: 12, bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    startTime.format(context),
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
          child: Text(AppLocalizations.of(context)!.form_end_time_attendance),
        ),
        ContainerBorder(
          padding: EdgeInsets.zero,
          margin: const EdgeInsets.only(left: 24, top: 12, right: 24),
          child: GestureDetector(
            onTap: () {
              selectEndTime();
            },
            child: Container(
              color: Colors.transparent,
              padding: const EdgeInsets.only(
                  left: 16, right: 16, top: 12, bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    endTime.format(context),
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
                    type: FormType.addAttendance,
                    startTime: DateTime(date.year, date.month, date.day,
                        startTime.hour, startTime.minute),
                    endTime: DateTime(date.year, date.month, date.day,
                        endTime.hour, endTime.minute),
                    timeCheckin: DateTime(startTime.hour, startTime.minute),
                    timeCheckout: DateTime(startTime.hour, startTime.minute),
                    reason: controller.text,
                  ),
                );
              }),
        ),
      ],
    );
  }

  selectStartTime() async {
    var selected = await selectTime(startTime);
    if (selected == null) {
      return;
    }
    setState(() {
      startTime = selected;
    });
  }

  selectEndTime() async {
    var selected = await selectTime(endTime);
    if (selected == null) {
      return;
    }
    setState(() {
      endTime = selected;
    });
  }

  Future<TimeOfDay?> selectTime(TimeOfDay time) async {
    var selectedTime = await showTimePicker(
        context: context,
        initialTime: time,
        initialEntryMode: TimePickerEntryMode.dial);

    return selectedTime;
  }

  Future selectDay(DateTime time) async {
    var selectedDate = await showDatePicker(
      context: context,
      initialDate: time,
      firstDate: (DateTime.now()).subtract(const Duration(days: 3)),
      lastDate: DateTime.now().add(const Duration(days: 31)),
    );
    if (selectedDate == null) {
      return;
    }
    setState(() {
      date = selectedDate;
    });
  }
}
