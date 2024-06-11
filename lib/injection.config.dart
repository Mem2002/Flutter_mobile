// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter_app/apis/api_base.dart' as _i3;
import 'package:flutter_app/apis/attendances/attendance_api.dart' as _i7;
import 'package:flutter_app/apis/authentications/authentication_api.dart'
    as _i8;
import 'package:flutter_app/apis/header_provider.dart' as _i5;
import 'package:flutter_app/apis/http_base.dart' as _i6;
import 'package:flutter_app/apis/payslips/payslip_api.dart' as _i9;
import 'package:flutter_app/apis/profiles/profile_api.dart' as _i10;
import 'package:flutter_app/apis/proposes/propose_api.dart' as _i11;
import 'package:flutter_app/controllers/attendance_controller.dart' as _i18;
import 'package:flutter_app/controllers/form_controller.dart' as _i17;
import 'package:flutter_app/controllers/home_controller.dart' as _i19;
import 'package:flutter_app/controllers/login_controller.dart' as _i13;
import 'package:flutter_app/controllers/payment_controller.dart' as _i20;
import 'package:flutter_app/controllers/register_controller.dart' as _i14;
import 'package:flutter_app/controllers/setting_controller.dart' as _i21;
import 'package:flutter_app/services/application_service.dart' as _i15;
import 'package:flutter_app/services/authentication_service.dart' as _i12;
import 'package:flutter_app/services/cache_service.dart' as _i4;
import 'package:flutter_app/services/form_service.dart' as _i16;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

const String _test = 'test';

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.factory<_i3.IConfigBase>(
      () => _i3.BetaConfig(),
      registerFor: {_test},
    );
    gh.factory<_i4.ICacheService>(() => _i4.CacheService());
    gh.factory<_i5.HeaderProvider>(
        () => _i5.HeaderProvider(gh<_i4.ICacheService>()));
    gh.factory<_i6.IHttpBase>(() => _i6.HttpBase(
          gh<_i3.IConfigBase>(),
          gh<_i5.HeaderProvider>(),
        ));
    gh.factory<_i7.AttendanceApi>(() => _i7.AttendanceApi(gh<_i6.IHttpBase>()));
    gh.factory<_i8.AuthenticationApi>(
        () => _i8.AuthenticationApi(gh<_i6.IHttpBase>()));
    gh.factory<_i9.PayslipApi>(() => _i9.PayslipApi(gh<_i6.IHttpBase>()));
    gh.factory<_i10.ProfileApi>(() => _i10.ProfileApi(gh<_i6.IHttpBase>()));
    gh.factory<_i11.ProposeApi>(() => _i11.ProposeApi(gh<_i6.IHttpBase>()));
    gh.factory<_i12.IAuthenticationService>(() => _i12.AuthenticationService(
          gh<_i8.AuthenticationApi>(),
          gh<_i5.HeaderProvider>(),
        ));
    gh.factory<_i13.LoginController>(
        () => _i13.LoginController(gh<_i12.IAuthenticationService>()));
    gh.factory<_i14.RegisterController>(
        () => _i14.RegisterController(gh<_i12.IAuthenticationService>()));
    gh.factory<_i15.IApplicationService>(() => _i15.ApplicationService(
          gh<_i7.AttendanceApi>(),
          gh<_i9.PayslipApi>(),
          gh<_i10.ProfileApi>(),
          gh<_i4.ICacheService>(),
        ));
    gh.factory<_i16.IFormService>(
        () => _i16.FormService(gh<_i11.ProposeApi>()));
    gh.factory<_i17.FormController>(
        () => _i17.FormController(gh<_i16.IFormService>()));
    gh.factory<_i18.AttendanceController>(
        () => _i18.AttendanceController(gh<_i15.IApplicationService>()));
    gh.factory<_i19.HomeController>(
        () => _i19.HomeController(gh<_i15.IApplicationService>()));
    gh.factory<_i20.PaymentController>(
        () => _i20.PaymentController(gh<_i15.IApplicationService>()));
    gh.factory<_i21.SettingController>(() => _i21.SettingController(
          gh<_i15.IApplicationService>(),
          gh<_i12.IAuthenticationService>(),
        ));
    return this;
  }
}
