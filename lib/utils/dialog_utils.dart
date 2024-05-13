import 'package:flutter_app/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_animtype.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

showConfirm(BuildContext context, Function() onConfirm,
    {String? title, String? text, String? cancel, String? confirm}) {
  QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      animType: QuickAlertAnimType.scale,
      title: title,
      text: text,
      confirmBtnText: confirm ?? "Ok",
      cancelBtnText: cancel ?? "Cancel",
      confirmBtnColor: Theme.of(context).colorScheme.primary,
      backgroundColor: Theme.of(context).colorScheme.background,
      headerBackgroundColor: Theme.of(context).colorScheme.primary,
      confirmBtnTextStyle:
          SmallMediumTextStyle(color: Theme.of(context).colorScheme.onPrimary),
      cancelBtnTextStyle:
          SmallMediumTextStyle(color: Theme.of(context).colorScheme.secondary),
      onConfirmBtnTap: () {
        Navigator.pop(context);
        onConfirm();
      });
}

showInfo(BuildContext context,
    {String? title, String? text, String? cancel, String? confirm}) {
  QuickAlert.show(
      context: context,
      type: QuickAlertType.info,
      animType: QuickAlertAnimType.scale,
      title: title,
      text: text,
      confirmBtnText: confirm ?? "Ok",
      cancelBtnText: cancel ?? "Cancel",
      confirmBtnColor: Theme.of(context).colorScheme.primary,
      backgroundColor: Theme.of(context).colorScheme.background,
      headerBackgroundColor: Theme.of(context).colorScheme.primary,
      confirmBtnTextStyle:
          SmallMediumTextStyle(color: Theme.of(context).colorScheme.onPrimary),
      cancelBtnTextStyle:
          SmallMediumTextStyle(color: Theme.of(context).colorScheme.secondary),
      onConfirmBtnTap: () {
        Navigator.pop(context);
      });
}
