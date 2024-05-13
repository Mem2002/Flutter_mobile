import 'package:flutter_app/widgets/theme_background.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ThemeBasePage extends StatelessWidget {
  Widget child;
  ThemeBasePage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            height: MediaQuery.of(context).size.height / 2 + 24,
            child: const ThemeBackground(),
          ),
          SafeArea(child: child)
        ],
      ),
    );
  }
}
