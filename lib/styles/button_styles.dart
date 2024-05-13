import 'package:flutter_app/styles/text_styles.dart';
import 'package:flutter/material.dart';

class PrimaryButtonStyle extends ButtonStyle {
  PrimaryButtonStyle(BuildContext context)
      : super(
            backgroundColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
                return Theme.of(context).colorScheme.surface;
              },
            ),
            overlayColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  return Theme.of(context).colorScheme.primary;
                }
                return null;
              },
            ),
            foregroundColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  return Theme.of(context).colorScheme.onPrimary;
                }
                return Theme.of(context)
                    .colorScheme
                    .onBackground; // Defer to the widget's default.
              },
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
            ),
            textStyle: MaterialStateProperty.resolveWith<TextStyle?>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  return NormalTextStyle(
                      color: Theme.of(context).colorScheme.onPrimary);
                }

                return NormalTextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onBackground); // Defer to the widget's default.
              },
            ),
            surfaceTintColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  return Theme.of(context).colorScheme.onPrimary;
                }
                return Theme.of(context)
                    .colorScheme
                    .onBackground; // Defer to the widget's default.
              },
            ),
            iconColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  return Theme.of(context).colorScheme.onPrimary;
                }
                return Theme.of(context)
                    .colorScheme
                    .onBackground; // Defer to the widget's default.
              },
            ),
            padding: const MaterialStatePropertyAll(
                EdgeInsets.only(left: 8, right: 8)));
}

class SecondaryButtonStyle extends ButtonStyle {
  SecondaryButtonStyle(BuildContext context)
      : super(
            backgroundColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
                return Theme.of(context).colorScheme.primary;
              },
            ),
            overlayColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  return Theme.of(context).colorScheme.surface;
                }
                return null;
              },
            ),
            foregroundColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  return Theme.of(context)
                      .colorScheme
                      .onBackground; // Defer to the widget's default.
                }

                return Theme.of(context).colorScheme.onPrimary;
              },
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
            ),
            textStyle: MaterialStateProperty.resolveWith<TextStyle?>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  return NormalTextStyle(
                      color: Theme.of(context).colorScheme.onPrimary);
                }

                return NormalTextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onBackground); // Defer to the widget's default.
              },
            ),
            surfaceTintColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  return Theme.of(context).colorScheme.onPrimary;
                }
                return Theme.of(context)
                    .colorScheme
                    .onBackground; // Defer to the widget's default.
              },
            ),
            iconColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  return Theme.of(context).colorScheme.onPrimary;
                }
                return Theme.of(context)
                    .colorScheme
                    .onBackground; // Defer to the widget's default.
              },
            ),
            padding: const MaterialStatePropertyAll(
                EdgeInsets.only(left: 8, right: 8)));
}
