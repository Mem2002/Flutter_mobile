import 'package:flutter_app/controllers/attendance_controller_2.dart';
import 'package:flutter_app/models/attendance_model.dart';
import 'package:flutter_app/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:flutter_app/widgets/theme_background.dart';
import 'package:mat_month_picker_dialog/mat_month_picker_dialog.dart';

import '../utils/statusbar_utils.dart';
import '../widgets/calendar.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<StatefulWidget> createState() => AttendancePageState();
}

final getIt = GetIt.instance;

class AttendancePageState extends State<AttendancePage> {
  final AttendanceControllers controller = GetIt.I<AttendanceControllers>();
  // final AttendanceControllers controller =
  //     GetIt.instance.get<AttendanceControllers>();
  DateTime currentTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Positioned(
          //   left: 0,
          //   right: 0,
          //   top: 0,
          //   height: MediaQuery.of(context).size.height / 2 + 24,
          //   child: const ThemeBackground(),
          // ),
          CustomScrollView(
            slivers: [
              SliverAppBar(
                systemOverlayStyle: StatusBarUtils.statusConfig(),
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                collapsedHeight: 56,
                toolbarHeight: 56,
                expandedHeight: 56,
                foregroundColor: Theme.of(context).colorScheme.primary,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: false,
                  title: GestureDetector(
                    onTap: selectMonth,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          DateFormat("MMMM").format(currentTime),
                          style: BoldTextStyle(
                              color: Theme.of(context).colorScheme.primary),
                        ),
                        Icon(Icons.arrow_drop_down,
                            color: Theme.of(context).colorScheme.primary)
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: ValueListenableBuilder<List<AttendanceResponses>>(
                    valueListenable: controller.data,
                    builder: (context, value, child) {
                      return CalendarWidget(
                        startDay: currentTime,
                        data: value,
                        onpress: (p0) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              var dateFormat = DateFormat("HH:mm dd/MM/yyyy");
                              return Dialog(
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 80,
                                  width: 240,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Giờ vào: ${p0.checkIn != null ? dateFormat.format(p0.checkIn!.toLocal()) : 'Not yet'}",
                                      ),
                                      Visibility(
                                        visible: p0.checkOut != null,
                                        child: Text(
                                          "Giờ ra: ${p0.checkOut != null ? dateFormat.format(p0.checkOut!.toLocal()) : 'Not yet'}",
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    }),
              ),
              SliverToBoxAdapter(
                child: ValueListenableBuilder<AttendanceResponses?>(
                  valueListenable: controller.today,
                  builder: (context, value, child) {
                    if (value == null) {
                      return Container(); // Trả về Container khi không có dữ liệu
                    }
                    var timeFormatter = DateFormat("HH:mm");
                    return itemDisplay(
                      "Hôm nay",
                      timeFormatter.format(value.checkIn.toLocal()),
                      outTime: value.checkOut == null
                          ? null
                          : timeFormatter.format(value.checkOut!.toLocal()),
                    );
                  },
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 24,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget itemDisplay(String title, String inTime, {String? outTime}) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: 24, right: 24, top: 12, bottom: 12),
      margin: const EdgeInsets.only(left: 24, right: 24, top: 24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.15),
            offset: const Offset(6, 6),
            blurRadius: 12,
            blurStyle: BlurStyle.normal,
          ),
        ],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const NormalTextStyle(),
          ),
          Text(
            "Check-in: $inTime",
            style: NormalBoldTextStyle(
                color: Theme.of(context).colorScheme.primary),
          ),
          Visibility(
            visible: outTime != null,
            child: Text(
              "Check-out: ${outTime ?? ""}",
              style: NormalBoldTextStyle(
                  color: Theme.of(context).colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }

  selectMonth() async {
    var selected = await showMonthPicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1970),
      lastDate: DateTime(2050),
    );

    setState(() {
      currentTime = selected ?? currentTime;
    });
    loadData();
  }

  loadData() {
    var firstMonth = DateTime(currentTime.year, currentTime.month);
    var lastMonth = DateTime(currentTime.year, currentTime.month + 1);
    var formatter = DateFormat("yyyy-MM-dd");
    controller.getAttendance(formatter.format(firstMonth),
        formatter.format(lastMonth) // Truyền accessToken vào
        );
  }
}
