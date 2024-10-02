import 'package:flutter_app/extensions/date_extensions.dart';
import 'package:flutter_app/models/attendance_model.dart';
import 'package:flutter_app/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../apis/attendances/dtos/attendance_response.dart';

// ignore: must_be_immutable
class CalendarWidget extends StatefulWidget {
  List<AttendanceResponses> data;
  DateTime startDay;
  Function(AttendanceResponses) onpress;

  CalendarWidget(
      {super.key,
      required this.data,
      required this.onpress,
      required this.startDay});

  @override
  State<StatefulWidget> createState() => CalendarWidgetState();
}

class CalendarWidgetState extends State<CalendarWidget> {
  int? selectionIndex;
  int daysInWeeks = 6;
  static const double padding = 12;

  @override
  Widget build(BuildContext context) {
    var now = widget.startDay;
    var firstMonth = DateTime(now.year, now.month, 1);
    var days = DateTimeRange(
            start: firstMonth, end: DateTime(now.year, now.month + 1, 1))
        .duration
        .inDays;
    List<DateTime> allDays = List.generate(days, (index) {
      return DateTime(now.year, now.month, index + 1);
    });

    var displayDays =
        allDays.where((e) => e.weekday != DateTime.sunday).toList();

    var skipDays = DateTime(now.year, now.month, 2).weekday -
        1 -
        (firstMonth.weekday == DateTime.sunday ? 1 : 0);
    var size = MediaQuery.of(context).size;
    var rate = (size.width - padding * 2) * 2.0 / (size.height - 56 * 2);

    return Container(
      padding: const EdgeInsets.only(left: padding, right: padding),
      child: Column(
        children: [
          Row(
            children: [
              for (int i = 0; i < 6; i++)
                Expanded(
                    child: Container(
                  alignment: Alignment.center,
                  height: 32,
                  width: 32,
                  child: Text(
                    i.toDayOfWeek(context),
                  ),
                )),
            ],
          ),
          SizedBox(
            height: (size.width - padding * 2) / rate,
            child: GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: daysInWeeks,
              mainAxisSpacing: 6,
              childAspectRatio: rate,
              children: [
                for (int i = 1; i < skipDays; i++) Container(),
                for (int i = 0; i < displayDays.length; i++)
                  Tooltip(
                    message: DateFormat("dd/MM/yyyy").format(displayDays[i]),
                    child: Column(
                      children: [
                        Material(
                          color: displayDays[i].day == now.day
                              ? Theme.of(context).colorScheme.primary
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          child: InkWell(
                            splashColor: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.5),
                            onTap: () {
                              onpress(displayDays[i]);
                              setState(() {
                                selectionIndex = i;
                              });
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              alignment: Alignment.center,
                              height: 32,
                              width: 32,
                              child: Text(
                                  DateFormat("d").format(displayDays[i]),
                                  style: NormalTextStyle(
                                      color: displayDays[i].day == now.day
                                          ? Theme.of(context)
                                              .colorScheme
                                              .onPrimary
                                          : Theme.of(context)
                                              .colorScheme
                                              .onBackground)),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 3),
                          height: 6,
                          width: 6,
                          decoration: BoxDecoration(
                            color: timeToColor(widget.data
                                    .where((element) =>
                                        DateFormat("dd/MM/yyyy")
                                            .format(element.date) ==
                                        DateFormat("dd/MM/yyyy")
                                            .format(displayDays[i]))
                                    .isNotEmpty
                                ? widget.data
                                    .where((element) =>
                                        DateFormat("dd/MM/yyyy")
                                            .format(element.date) ==
                                        DateFormat("dd/MM/yyyy")
                                            .format(displayDays[i]))
                                    .first
                                : null),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        )
                      ],
                    ),
                  )
              ],
            ),
          )
        ],
      ),
    );
  }

  Color timeToColor(AttendanceResponses? data) {
    if (data == null) {
      return Colors.transparent;
    }
    if ((data.checkIn
                    .toLocal()
                    .add(-const Duration(hours: 8, minutes: 45))
                    .difference(data.date)
                    .isNegative ==
                true ||
            (data.checkIn
                        .toLocal()
                        .add(-const Duration(hours: 12, minutes: 00))
                        .difference(data.date)
                        .isNegative ==
                    false &&
                data.checkIn
                        .toLocal()
                        .add(-const Duration(hours: 13, minutes: 45))
                        .difference(data.date)
                        .isNegative ==
                    true)) &&
        data.checkOut != null) {
      return Colors.green;
    }

    if ((data.checkIn
                    .toLocal()
                    .add(-const Duration(hours: 8, minutes: 45))
                    .difference(data.date)
                    .isNegative ==
                false &&
            data.checkIn
                    .toLocal()
                    .add(-const Duration(hours: 12))
                    .difference(data.date)
                    .isNegative ==
                true) ||
        data.checkIn
                .toLocal()
                .add(-const Duration(hours: 13, minutes: 45))
                .difference(data.date)
                .isNegative ==
            false) {
      return Colors.orange;
    }
    return Colors.red;
  }

  void onpress(DateTime date) {
    var data = widget.data.where((element) => element.date == date);
    if (data.isEmpty) {
      return;
    }
    widget.onpress(data.first);
  }
}
