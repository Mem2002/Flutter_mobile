import 'package:flutter_app/models/form_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension WorkingHourExtensions on WorkingHour {
  String getTitle(BuildContext context) {
    switch (this) {
      case WorkingHour.morningAfternoon:
        return AppLocalizations.of(context)!.form_working_hour_morning;
      case WorkingHour.afternoonNight:
        return AppLocalizations.of(context)!.form_working_hour_afternoon;
    }
  }
}
