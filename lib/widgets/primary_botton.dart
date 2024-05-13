import 'package:flutter_app/styles/button_styles.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PrimaryButton extends StatefulWidget {
  VoidCallback? onPressed;
  String? icon;
  String title;
  PrimaryButton(
      {super.key, required this.title, this.icon, required this.onPressed});

  @override
  State<StatefulWidget> createState() => PrimaryButtonState();
}

class PrimaryButtonState extends State<PrimaryButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onPressed,
      style: PrimaryButtonStyle(context),
      child: Row(
        children: [
          Visibility(
            visible: widget.icon?.isNotEmpty == true,
            child: SizedBox(
              width: 40,
              child: ImageIcon(AssetImage(widget.icon ?? "")),
            ),
          ),
          Text(
            widget.title,
          )
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class SecondaryButton extends StatefulWidget {
  VoidCallback? onPressed;
  String? icon;
  String title;
  SecondaryButton(
      {super.key, required this.title, this.icon, required this.onPressed});

  @override
  State<StatefulWidget> createState() => SecondaryButtonState();
}

class SecondaryButtonState extends State<SecondaryButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onPressed,
      style: SecondaryButtonStyle(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Visibility(
            visible: widget.icon?.isNotEmpty == true,
            child: SizedBox(
              width: 40,
              child: ImageIcon(AssetImage(widget.icon ?? "")),
            ),
          ),
          Text(
            widget.title,
          )
        ],
      ),
    );
  }
}
