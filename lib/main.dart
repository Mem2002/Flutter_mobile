import 'package:flutter/material.dart';
import 'package:flutter_app/injection.dart';
import 'package:flutter_app/pages/home_page.dart';
import '../styles/themes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

import 'pages/login_page.dart';

void main() async {
  await configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(     
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(),
    );
  }
}
