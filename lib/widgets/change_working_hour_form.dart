import 'package:flutter_app/extensions/working_hour_extensions.dart';
import 'package:flutter_app/models/form_model.dart';
import 'package:flutter_app/styles/text_styles.dart';
import 'package:flutter_app/widgets/container_border.dart';
import 'package:flutter_app/widgets/primary_botton.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class ChangeWorkingHourFormView extends StatefulWidget {
  Function(FormModel model) onSubmit;
  ChangeWorkingHourFormView({super.key, required this.onSubmit});

  @override
  State<StatefulWidget> createState() => ChangeWorkingHourState();
}

class ChangeWorkingHourState extends State<ChangeWorkingHourFormView> {
  final TextEditingController controller = TextEditingController();
  DateTime date = DateTime.now();
  TimeOfDay startTime = const TimeOfDay(hour: 8, minute: 30);
  TimeOfDay endTime = const TimeOfDay(hour: 18, minute: 0);
  WorkingHour current = WorkingHour.morningAfternoon;
  WorkingHour changed = WorkingHour.afternoonNight;
  List<WorkingHour> workingHours = [
    WorkingHour.morningAfternoon,
    WorkingHour.afternoonNight
  ];
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
          child: Text(AppLocalizations.of(context)!.form_date),
        ),
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
          child: Text(AppLocalizations.of(context)!.form_start_time),
        ),
        ContainerBorder(
          margin: const EdgeInsets.only(left: 24, right: 24, top: 12),
          child: DropdownButton<WorkingHour>(
            menuMaxHeight: MediaQuery.of(context).size.height / 2,
            padding: const EdgeInsets.only(left: 16, right: 16),
            value: current,
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
            onChanged: (WorkingHour? value) {
              if (value == null) {
                return;
              }
              setState(() {
                current = value;
                changed =
                    workingHours.firstWhere((element) => element != value);
              });
            },
            items: workingHours
                .map<DropdownMenuItem<WorkingHour>>((WorkingHour value) {
              return DropdownMenuItem<WorkingHour>(
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
          child: Text(AppLocalizations.of(context)!.form_end_time),
        ),
        ContainerBorder(
          margin: const EdgeInsets.only(left: 24, right: 24, top: 12),
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 12),
          child: Text(
            changed.getTitle(context),
            style: const SmallNormalTextStyle(),
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
                      type: FormType.changeShift,
                      startTime: date,
                      workingHour: current,
                      workingHourChanged: changed,
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
