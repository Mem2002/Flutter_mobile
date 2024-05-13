import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ContainerBorder extends StatelessWidget {
  Widget child;
  EdgeInsets? margin;
  EdgeInsets? padding;
  ContainerBorder({super.key, required this.child, this.margin, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
                offset: Offset(1, 1),
                spreadRadius: 1,
                blurRadius: 4,
                color: Colors.black12)
          ]),
      margin: margin ?? const EdgeInsets.only(left: 24, right: 24, top: 24),
      padding: padding,
      child: child,
    );
  }
}
