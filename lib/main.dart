import 'package:flutter/material.dart';
import '../styles/themes.dart';

void main() {
  runApp(const HomePage());
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    const String appTitle = 'Flutter layout demoaaaa';
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(appTitle),
        ),
        body: Stack(children: [
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            height: MediaQuery.of(context).size.height / 2 + 100,
            child: Image.asset(
              Themes.currentBackground,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: MediaQuery.of(context).size.height / 2,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
