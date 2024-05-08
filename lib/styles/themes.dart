import 'package:flutter/material.dart';

import '../utils/date_time_utils.dart';

class Themes {
  static ITheme spring = getCurrrentTheme();
  static ThemeData get currentTheme {
    return spring.currentTheme;
  }

  static const stepDate = 1;

  static setTheme() {
    spring = getCurrrentTheme();
  }

  static ITheme getCurrrentTheme() {
    var year = DateTime.now().year;
    var valentineDay = DateTime(year, 2, 14);
    var womenDay = DateTime(year, 3, 8);
    var womenVNDay = DateTime(year, 10, 20);
    if (DateTimeUtils.inRangeByDates(
        [valentineDay, womenDay, womenVNDay], stepDate)) {
      return ValentineTheme();
    }

    var hungKingDay = DateTime(year, 4, 29);
    var laborDay = DateTime(year, 5, 1);
    var liberationDay = DateTime(year, 4, 30);
    var independenceDay = DateTime(year, 9, 2);
    if (DateTimeUtils.inRangeByDates(
        [hungKingDay, laborDay, liberationDay, independenceDay], stepDate)) {
      return VietNameTheme();
    }

    var midAutumnDay = DateTime(year, 9, 11);
    if (DateTimeUtils.inRangeByDate(midAutumnDay, stepDate)) {
      return MidAutumnTheme();
    }

    var noelStartDay = DateTime(year, 12, 22);
    if (DateTimeUtils.inRangeByDate(noelStartDay, 5)) {
      return NoelTheme();
    }

    var newYearDay = DateTime(year, 12, 30);
    if (DateTimeUtils.inRangeByDate(newYearDay, 3)) {
      return NewYearTheme();
    }

    var themeIndex = DateTime.now().minute % 4;
    switch (themeIndex) {
      case 0:
        return SpringTheme();
      case 1:
        return SummerTheme();
      case 2:
        return AutumnTheme();
      case 3:
      default:
        return WinterTheme();
    }
  }

  static ThemeData get currentDarkTheme => spring.currentDarkTheme;
  static String get currentBackground => spring.currentBackground;
}

abstract class ITheme {
  ThemeData get currentTheme;
  ThemeData get currentDarkTheme;
  String get currentBackground;
}

class SpringTheme extends ITheme {
  @override
  String get currentBackground => "assets/images/bg_spring.png";

  @override
  ThemeData get currentDarkTheme => currentTheme;

  @override
  ThemeData get currentTheme => ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.light(
            background: Color(0xffFFFFFF),
            onBackground: Color.fromARGB(255, 18, 19, 19),
            secondary: Color(0x80F887A0),
            onPrimary: Color(0xffFFFFFF),
            surface: Color(0xffEBEBEB),
            primary: Color(0xffF887A0)),
      );
}

class SummerTheme extends ITheme {
  @override
  String get currentBackground => "assets/images/bg_summer.png";

  @override
  ThemeData get currentDarkTheme => currentTheme;

  @override
  ThemeData get currentTheme => ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.light(
            background: Color(0xffFFFFFF),
            secondary: Color(0x80E36600),
            onBackground: Color.fromARGB(255, 18, 19, 19),
            onPrimary: Color(0xffFFFFFF),
            surface: Color(0xffEBEBEB),
            primary: Color(0xffE36600)),
      );
}

class WinterTheme extends ITheme {
  @override
  String get currentBackground => "assets/images/bg_winter.png";

  @override
  ThemeData get currentDarkTheme => currentTheme;

  @override
  ThemeData get currentTheme => ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.light(
            background: Color(0xffFFFFFF),
            secondary: Color(0x803C70A4),
            onBackground: Color.fromARGB(255, 18, 19, 19),
            onPrimary: Color(0xffFFFFFF),
            surface: Color(0xffEBEBEB),
            primary: Color(0xff3C70A4)),
      );
}

class AutumnTheme extends ITheme {
  @override
  String get currentBackground => "assets/images/bg_autumn.png";

  @override
  ThemeData get currentDarkTheme => currentTheme;

  @override
  ThemeData get currentTheme => ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.light(
            background: Color(0xffFFFFFF),
            onBackground: Color.fromARGB(255, 18, 19, 19),
            secondary: Color(0x80316BCF),
            onPrimary: Color(0xffFFFFFF),
            surface: Color(0xffEBEBEB),
            primary: Color(0xff316BCF)),
      );
}

class ValentineTheme extends ITheme {
  @override
  String get currentBackground => "assets/images/bg_valentine.png";

  @override
  ThemeData get currentDarkTheme => currentTheme;

  @override
  ThemeData get currentTheme => ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.light(
          background: Color(0xffFFFFFF),
          onBackground: Color.fromARGB(255, 18, 19, 19),
          secondary: Color(0x80F64770),
          onPrimary: Color(0xffFFFFFF),
          surface: Color(0xffEBEBEB),
          primary: Color(0xffF64770),
        ),
      );
}

class VietNameTheme extends ITheme {
  @override
  String get currentBackground => "assets/images/bg_vietnam.png";

  @override
  ThemeData get currentDarkTheme => currentTheme;

  @override
  ThemeData get currentTheme => ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.light(
          background: Color(0xffFFFFFF),
          onBackground: Color.fromARGB(255, 18, 19, 19),
          secondary: Color(0x80D10F0F),
          onPrimary: Color(0xffE6E500),
          surface: Color(0xffEBEBEB),
          primary: Color(0xffD10F0F),
        ),
      );
}

class MidAutumnTheme extends ITheme {
  @override
  String get currentBackground => "assets/images/bg_mid_autumn.png";

  @override
  ThemeData get currentDarkTheme => currentTheme;

  @override
  ThemeData get currentTheme => ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.light(
          background: Color(0xffFFFFFF),
          onBackground: Color.fromARGB(255, 18, 19, 19),
          secondary: Color(0x800B1F37),
          onPrimary: Color(0xffFFFFFF),
          surface: Color(0xffEBEBEB),
          primary: Color(0xff0B1F37),
        ),
      );
}

class NoelTheme extends ITheme {
  @override
  String get currentBackground => "assets/images/bg_noel.png";

  @override
  ThemeData get currentDarkTheme => currentTheme;

  @override
  ThemeData get currentTheme => ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.light(
          background: Color(0xffFFFFFF),
          onBackground: Color.fromARGB(255, 18, 19, 19),
          secondary: Color(0x800B1F37),
          onPrimary: Color(0xffFFFFFF),
          surface: Color(0xffEBEBEB),
          primary: Color(0xff0B1F37),
        ),
      );
}

class NewYearTheme extends ITheme {
  @override
  String get currentBackground => "assets/images/bg_new_year.png";

  @override
  ThemeData get currentDarkTheme => currentTheme;

  @override
  ThemeData get currentTheme => ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.light(
          background: Color(0xffFFFFFF),
          onBackground: Color.fromARGB(255, 18, 19, 19),
          secondary: Color(0x80D10F0F),
          onPrimary: Color(0xffF5FAE7),
          surface: Color(0xffEBEBEB),
          primary: Color(0xff9F0104),
        ),
      );
}
