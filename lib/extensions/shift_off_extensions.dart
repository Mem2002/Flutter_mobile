import 'package:flutter_app/models/form_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension ShiftOffExtensions on ShiftOff {
  String getTitle(BuildContext context) {
    switch (this) {
      case ShiftOff.morning:
        return AppLocalizations.of(context)!.morning;
      case ShiftOff.afternoon:
        return AppLocalizations.of(context)!.afternoon;
      case ShiftOff.night:
        return AppLocalizations.of(context)!.night;
    }
  }
}
