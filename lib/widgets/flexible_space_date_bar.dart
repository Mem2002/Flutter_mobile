import 'package:flutter_app/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class FlexibleSpaceDateBar extends StatelessWidget {
  final GestureTapCallback? onTap;
  DateTime? currentTime;

  FlexibleSpaceDateBar({super.key, required this.onTap, this.currentTime});
  @override
  Widget build(BuildContext context) {
    return FlexibleSpaceBar(
      centerTitle: false,
      title: GestureDetector(
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              DateFormat("MMMM").format(currentTime ?? DateTime.now()),
              style:
                  BoldTextStyle(color: Theme.of(context).colorScheme.primary),
            ),
            Icon(Icons.arrow_drop_down,
                color: Theme.of(context).colorScheme.primary)
          ],
        ),
      ),
    );
  }
}
