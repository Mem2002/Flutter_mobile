// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter_app/apis/api_base.dart' as _i474;
import 'package:flutter_app/apis/attendances/attendance_api.dart' as _i932;
import 'package:flutter_app/apis/header_provider.dart' as _i692;
import 'package:flutter_app/apis/http_base.dart' as _i277;
import 'package:flutter_app/apis/payslips/payslip_api.dart' as _i643;
import 'package:flutter_app/apis/profiles/profile_api.dart' as _i350;
import 'package:flutter_app/apis/proposes/propose_api.dart' as _i545;
import 'package:flutter_app/controllers/attendance_controller.dart' as _i498;
import 'package:flutter_app/controllers/attendance_controller_2.dart' as _i296;
import 'package:flutter_app/controllers/authentication_controller.dart'
    as _i404;
import 'package:flutter_app/controllers/form_controller.dart' as _i444;
import 'package:flutter_app/controllers/home_controller.dart' as _i831;
import 'package:flutter_app/controllers/payment_controller.dart' as _i635;
import 'package:flutter_app/services/application_service.dart' as _i838;
import 'package:flutter_app/services/cache_service.dart' as _i611;
import 'package:flutter_app/services/form_service.dart' as _i522;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

const String _test = 'test';

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.factory<_i296.AttendanceControllers>(
        () => _i296.AttendanceControllers());
    gh.factory<_i474.IConfigBase>(
      () => _i474.BetaConfig(),
      registerFor: {_test},
    );
    gh.factory<_i611.ICacheService>(() => _i611.CacheService());
    gh.factory<_i692.HeaderProvider>(
        () => _i692.HeaderProvider(gh<_i611.ICacheService>()));
    gh.factory<_i277.IHttpBase>(() => _i277.HttpBase(
          gh<_i474.IConfigBase>(),
          gh<_i692.HeaderProvider>(),
        ));
    gh.factory<_i932.AttendanceApi>(
        () => _i932.AttendanceApi(gh<_i277.IHttpBase>()));
    gh.factory<_i643.PayslipApi>(() => _i643.PayslipApi(gh<_i277.IHttpBase>()));
    gh.factory<_i350.ProfileApi>(() => _i350.ProfileApi(gh<_i277.IHttpBase>()));
    gh.factory<_i545.ProposeApi>(() => _i545.ProposeApi(gh<_i277.IHttpBase>()));
    gh.factory<_i838.IApplicationService>(() => _i838.ApplicationService(
          gh<_i932.AttendanceApi>(),
          gh<_i643.PayslipApi>(),
          gh<_i350.ProfileApi>(),
          gh<_i611.ICacheService>(),
        ));
    gh.factory<_i522.IFormService>(
        () => _i522.FormService(gh<_i545.ProposeApi>()));
    gh.factory<_i444.FormController>(
        () => _i444.FormController(gh<_i522.IFormService>()));
    // gh.factory<_i498.AttendanceController>(
    //     () => _i498.AttendanceController(gh<_i838.IApplicationService>()));
    gh.factory<_i831.HomeController>(
        () => _i831.HomeController(gh<_i838.IApplicationService>()));
    gh.factory<_i635.PaymentController>(
        () => _i635.PaymentController(gh<_i838.IApplicationService>()));
    gh.factory<_i404.AuthenticationController>(
        () => _i404.AuthenticationController(
              gh<_i692.HeaderProvider>(),
              gh<_i838.IApplicationService>(),
            ));
    return this;
  }
}
