import 'package:flutter_app/models/form_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension FormTypeExtensions on FormType {
  String getTitle(BuildContext context) {
    switch (this) {
      case FormType.onLeave:
        return AppLocalizations.of(context)!.form_onLeave;
      case FormType.ot:
        return AppLocalizations.of(context)!.form_ot;
      case FormType.addAttendance:
        return AppLocalizations.of(context)!.form_add_attendance;
      case FormType.changeShift:
        return AppLocalizations.of(context)!.form_changeShift;
    }
  }
}
