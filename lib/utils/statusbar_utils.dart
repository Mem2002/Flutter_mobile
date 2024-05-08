import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StatusBarUtils {
  static void config() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent));
  }

  static void configLight() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent));
  }

  static SystemUiOverlayStyle statusConfig() =>
      SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.transparent);

  static SystemUiOverlayStyle statusConfigWithColor(Color color) =>
      SystemUiOverlayStyle.dark
          .copyWith(statusBarColor: color, systemNavigationBarColor: color);
}
