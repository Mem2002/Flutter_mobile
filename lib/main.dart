import 'package:flutter/material.dart';
import 'package:flutter_app/controllers/attendance_controller_2.dart';
import 'package:flutter_app/controllers/payment_controller.dart';
import 'package:flutter_app/controllers/user_controller.dart'; // Thêm UserController
import 'package:flutter_app/injection.dart';
import 'package:flutter_app/pages/home_page.dart';
import 'package:flutter_app/services/application_service.dart';
import '../styles/themes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_app/pages/authentication_screen.dart';
import 'package:flutter_app/pages/login_page.dart';
import 'package:get_it/get_it.dart';
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

final GetIt getIt = GetIt.instance;

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
final StreamController<NotificationResponse> onNotificationReceived =
    StreamController<NotificationResponse>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Thêm dòng này
  await configureDependencies();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<PaymentController>(
          create: (context) => PaymentController(getIt<IApplicationService>()),
        ),
        ChangeNotifierProvider<UserController>(
          create: (context) => UserController(), // Thêm UserController vào provider
        ),
      ],
      child: const MyApp(),
    ),
  );
}

final service = FlutterBackgroundService();

// Future<void> initializeService() async {
//   await service.configure(
//     androidConfiguration: AndroidConfiguration(
//       onStart: onStart,
//       autoStart: true,
//       isForegroundMode: true,
//       autoStartOnBoot: true,
//       initialNotificationContent: "Time talk đang hoạt động",
//       initialNotificationTitle: "Time talk",
//     ),
//     iosConfiguration: IosConfiguration(
//       onBackground: (service) {
//         onStart(service);
//         return true;
//       },
//       autoStart: true,
//       onForeground: (service) {
//         onStart(service);
//         return true;
//       },
//     ),
//   );
//   service.startService();
// }

// @pragma('vm:entry-point')
// Future<void> onStart(ServiceInstance service) async {
//   processService();
// }

// @pragma('vm:entry-point')
// StreamSubscription<List<ConnectivityResult>> processService() {
//   return Connectivity().onConnectivityChanged.listen(
//     (List<ConnectivityResult>? result) async {
//       result ??= [];
//       var hasWifi =
//           result.firstWhere((element) => element == ConnectivityResult.wifi);
//       if (hasWifi == ConnectivityResult.wifi) {
//         connectWifi();
//         return;
//       }

//       var hasMobile =
//           result.firstWhere((element) => element == ConnectivityResult.mobile);
//       if (hasMobile == ConnectivityResult.mobile) {
//         connectMobile();
//         return;
//       }

//       var disconnected = result.isEmpty ||
//           result.every((element) => element == ConnectivityResult.none);
//       if (disconnected) {
//         disconnect();
//       }
//     },
//     cancelOnError: false,
//   );
// }

// Các hàm connect, disconnect, checkIn, checkOut tương tự như trước...

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

  // @override
  // void initState() {
  //   stream = processService();
  //   loadTheme();
  //   super.initState();
  // }

  @override
  void dispose() {
    stream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: LoginPage(), // Hoặc HomePage nếu bạn đã đăng nhập
      localizationsDelegates: const [
        AppLocalizations.delegate,
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
