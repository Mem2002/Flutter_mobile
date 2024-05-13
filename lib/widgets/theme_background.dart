import 'dart:ui';
import 'package:flutter_app/styles/themes.dart';
import 'package:flutter/material.dart';

class ThemeBackground extends StatelessWidget {
  const ThemeBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage(Themes.currentBackground), fit: BoxFit.cover),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
        child: Container(
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.6)),
        ),
      ),
    );
  }
}
