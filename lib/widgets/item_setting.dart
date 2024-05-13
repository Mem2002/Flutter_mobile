// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import '../styles/text_styles.dart';

class ItemSettingWidget extends StatelessWidget {
  String title;
  String value;
  bool hasEdit;
  bool important;
  ItemSettingWidget(
      {super.key,
      required this.title,
      required this.value,
      this.hasEdit = true,
      this.important = false});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      margin: const EdgeInsets.only(left: 24, right: 24),
      decoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(
                color: Theme.of(context).colorScheme.onBackground, width: 1)),
      ),
      child: Row(children: [
        Text(
          title,
          style: SmallerNormalTextStyle(
              color:
                  Theme.of(context).colorScheme.onBackground.withOpacity(0.8)),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: important
                ? SmallBoldTextStyle(
                    color: Theme.of(context).colorScheme.onBackground)
                : SmallNormalTextStyle(
                    color: Theme.of(context).colorScheme.onBackground),
          ),
        ),
        Visibility(
          visible: hasEdit,
          child: Container(
            margin: const EdgeInsets.only(left: 8),
            child: Icon(Icons.edit,
                size: 16, color: Theme.of(context).colorScheme.onBackground),
          ),
        )
      ]),
    );
  }
}
