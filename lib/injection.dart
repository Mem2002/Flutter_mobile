import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'injection.config.dart';

//flutter packages pub run build_runner build --delete-conflicting-outputs
final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async =>
// đây là Dependencies
// để đảm bảo rằng tất cả các dịch vụ đã đăng ký (và bất kỳ dịch vụ không đồng bộ nào) đã sẵn sàng trước khi tiếp tục.
    await getIt.init(environment: "test").allReady();
