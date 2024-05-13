import 'package:flutter_app/models/form_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension EnumExtensions on int {
  FormType toFormType() {
    switch (this) {
      case 0:
        return FormType.onLeave;
      case 1:
        return FormType.ot;
      case 2:
        return FormType.changeShift;
      case 3:
      default:
        return FormType.addAttendance;
    }
  }

  WorkingHour toWorkingHour() {
    switch (this) {
      case 1:
        return WorkingHour.morningAfternoon;
      case 2:
      default:
        return WorkingHour.afternoonNight;
    }
  }

  ShiftOff toShiftOff() {
    switch (this) {
      case 1:
        return ShiftOff.morning;
      case 2:
        return ShiftOff.afternoon;
      case 3:
      default:
        return ShiftOff.night;
    }
  }

  FormStatus toStatus() {
    switch (this) {
      case 0:
        return FormStatus.requested;
      case 1:
        return FormStatus.approved;
      case 2:
      default:
        return FormStatus.rejected;
    }
  }

  String getShiftOffText(BuildContext context) {
    switch (this) {
      case 1:
        return AppLocalizations.of(context)!.morning;
      case 2:
        return AppLocalizations.of(context)!.afternoon;
      case 3:
      default:
        return AppLocalizations.of(context)!.night;
    }
  }
}
