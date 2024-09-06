import 'package:flutter/material.dart';
import 'package:flutter_app/injection.dart';
import 'package:flutter_app/pages/home_page.dart';
import '../styles/themes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_app/pages/authentication_screen.dart';
import 'package:get_it/get_it.dart';

import 'pages/login_page.dart';

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_app/pages/authentication_screen.dart';
import 'package:flutter_app/services/application_service.dart';
import 'package:flutter_app/styles/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'injection.dart';
NotificationDetails notificationDetails({String title = "Checkin"}) =>
    NotificationDetails(
      android: AndroidNotificationDetails(
        title,
        title,
        priority: Priority.max,
        importance: Importance.max,
        enableVibration: true,
      ),
    );
final info = NetworkInfo();
bool hasCheckIn = false;
final StreamController<NotificationResponse> onNotificationRecevied =
    StreamController<NotificationResponse>();

Future<void> main() async {
  await configureDependencies();
  runApp(const MyApp());
}

checkPermission() async {
  if (await Permission.location.isGranted) {
    // Either the permission was already granted before or the user just granted it.
  }
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();
  await [
    Permission.location,
    Permission.notification,
    Permission.backgroundRefresh
  ].request();
}

final service = FlutterBackgroundService();
Future<void> initializeService() async {
  await service.configure(
      androidConfiguration: AndroidConfiguration(
          onStart: onStart,
          autoStart: true,
          isForegroundMode: true,
          autoStartOnBoot: true,
          initialNotificationContent: "Time talk đang hoạt động",
          initialNotificationTitle: "Time talk"),
      iosConfiguration: IosConfiguration(
        onBackground: (service) {
          onStart(service);
          return true;
        },
        autoStart: true,
        onForeground: (service) {
          onStart(service);
          return true;
        },
      ));
  service.startService();
}

@pragma('vm:entry-point')
Future<void> onStart(ServiceInstance service) async {
  processService();
}

@pragma('vm:entry-point')
StreamSubscription<List<ConnectivityResult>> processService() {
  return Connectivity().onConnectivityChanged.listen(
      (List<ConnectivityResult>? result) async {
    result ??= [];

    var hasWifi =
        result.firstWhere((element) => element == ConnectivityResult.wifi);
    if (hasWifi == ConnectivityResult.wifi) {
      connectWifi();
      return;
    }

    var hasMobile =
        result.firstWhere((element) => element == ConnectivityResult.mobile);
    if (hasMobile == ConnectivityResult.mobile) {
      connectMobile();
      return;
    }

    var disconnected = result.isEmpty ||
        result.every((element) => element == ConnectivityResult.none);
    if (disconnected) {
      disconnect();
    }
  }, cancelOnError: false);
}

disconnect() async {
  if (!getIt.isRegistered<IApplicationService>()) {
    await configureDependencies();
  }
  if (!getIt.isRegistered<IApplicationService>()) {
    return;
  }

  var service = getIt.get<IApplicationService>();
  var checkoutable = await service.checkoutable();
  if (checkoutable == false) {
    return;
  }
  service.setCheckoutTime(DateTime.now());
}

connectWifi() async {
  checkOut();
  var service = getIt.get<IApplicationService>();
  service.setCheckoutable();
  checkIn();
}

connectMobile() {
  checkOut();
}

Future<bool> hasCheckedIn() async {
  final key = "checkin${DateFormat("ddMMyyyy").format(DateTime.now())}";
  final preferences = await SharedPreferences.getInstance();
  var checkedInTime = preferences.getDouble(key);
  return checkedInTime != null && checkedInTime > 0;
}

checkIn() async {
  if (!getIt.isRegistered<IApplicationService>()) {
    await configureDependencies();
  }
  if (!getIt.isRegistered<IApplicationService>()) {
    return;
  }
  bool lastCheckedIn = await hasCheckedIn();
  if (lastCheckedIn == true) {
    return;
  }

  final preferences = await SharedPreferences.getInstance();
  final key = "checkin${DateFormat("ddMMyyyy").format(DateTime.now())}";

  var service = getIt.get<IApplicationService>();
  var checkedIn = await service.checkIn();

  if ((checkedIn?.data.id ?? 0) > 0) {
    preferences.setDouble(key, DateTime.now().millisecondsSinceEpoch * 1.0);
    flutterLocalNotificationsPlugin.show(
        DateTime.now().second,
        "Checkin thành công",
        "Bạn đã Checkin thành công lúc ${DateFormat("HH:mm dd/MM/yyyy").format(DateTime.now())}",
        notificationDetails(title: "Checkin"));
  }
  // flutterLocalNotificationsPlugin.show(1, "title", "body", notificationDetails);
}

checkOut() async {
  if (!getIt.isRegistered<IApplicationService>()) {
    await configureDependencies();
  }
  if (!getIt.isRegistered<IApplicationService>()) {
    return;
  }

  var service = getIt.get<IApplicationService>();
  var checkoutTime = await service.getCheckoutTime();
  if (checkoutTime == null) {
    return;
  }

  var res = await service.checkOut(checkoutTime);
  const NotificationDetails notificationDetails = NotificationDetails(
    android: AndroidNotificationDetails(
      "CheckOut",
      "CheckOut",
      priority: Priority.max,
      importance: Importance.max,
      enableVibration: true,
    ),
  );
  if (res == null || res.data == null) {
    return;
  }

  flutterLocalNotificationsPlugin.show(
      DateTime.now().second,
      "Checkout thành công",
      "Bạn đã checkout thành công lúc ${DateFormat("HH:mm dd/MM/yyyy").format(checkoutTime)}",
      notificationDetails);
  await service.setCheckoutTime(null);
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
initNotification() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('ic_notification');
  const DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings();
  const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin);
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (details) {
      onNotificationRecevied.add(details);
    },
  );
}

void onDidReceiveLocalNotification(
    int id, String title, String body, String payload) async {
  // display a dialog with the notification details, tap ok to go to another page
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<MyApp> {
    late StreamSubscription<List<ConnectivityResult>> stream;
  ValueNotifier<ThemeData?> theme = ValueNotifier<ThemeData?>(null);

   loadTheme() {
    Themes.setTheme();
    theme.value = Themes.currentTheme;
  }


   @override
  void initState() {
    stream = processService();
    loadTheme();
    super.initState();
  }

@override
  void dispose() {
    stream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // localizationsDelegates: AppLocalizations.localizationsDelegates,
      // supportedLocales: AppLocalizations.supportedLocales,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      localizationsDelegates: const [
        AppLocalizations.delegate, // Add this line
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('vi', 'VN'),
      ],
      locale: const Locale('en', 'US'),
      builder: EasyLoading.init(),
    );
  }
}
