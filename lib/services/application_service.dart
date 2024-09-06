import 'package:flutter_app/apis/attendances/dtos/attendance_report_response.dart';
import 'package:flutter_app/apis/profiles/dtos/profile_dto.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';
import '../apis/attendances/attendance_api.dart';
import '../apis/attendances/dtos/attendance_response.dart';
import '../apis/attendances/dtos/checkin_response.dart';
import '../apis/attendances/dtos/checkout_response.dart';
import '../apis/payslips/dtos/payslip_response.dart';
import '../apis/payslips/payslip_api.dart';
import '../apis/profiles/profile_api.dart';
import 'cache_service.dart';

abstract class IApplicationService {
  Future<CheckInResponse?> checkIn();
  Future<CheckOutResponse?> checkOut(DateTime date);
  Future<CheckOutResponse?> forceCheckOut();
  Future<ReportDto?> getReport(String from, String to);
  Future<AttendanceResponse?> getAttendance(String from, String to);
  Future<PayslipResponse?> getPayslip(int month, int year);
  Future<ProfileDto?> getProfile();
  Future<String> getCurrentDeviceIdAsync();

  Future removeCurrentDeviceIdAsync();
  Future<DateTime?> getCheckoutTime();
  Future setCheckoutTime(DateTime? date);
  Future<bool> checkoutable();
  Future setCheckoutable();
}

@Injectable(as: IApplicationService)
class ApplicationService extends IApplicationService {
  ICacheService cacheService;
  AttendanceApi attendanceApi;
  PayslipApi payslipApi;
  ProfileApi profileApi;
  ApplicationService(
      this.attendanceApi, this.payslipApi, this.profileApi, this.cacheService);
  @override
  Future<AttendanceResponse?> getAttendance(String from, String to) {
    return attendanceApi.getAttendance(from, to);
  }

  @override
  Future<PayslipResponse?> getPayslip(int month, int year) {
    return payslipApi.getPayslip(month, year);
  }

  @override
  Future<ProfileDto?> getProfile() async {
    var res = await profileApi.getProfile();
    return res?.data;
  }

  @override
  Future<ReportDto?> getReport(String from, String to) async {
    var res = await attendanceApi.reportAttendance(from, to);
    return res?.data;
  }

  @override
  Future<CheckInResponse?> checkIn() async {
    var deviceId = await getCurrentDeviceIdAsync();
    var profile = await getProfile();
    if (deviceId != (profile?.activeDeviceId ?? "")) {
      return null;
    }
    return await attendanceApi.checkIn(deviceId);
  }

  @override
  Future<CheckOutResponse?> checkOut(DateTime date) async {
    var deviceId = await getCurrentDeviceIdAsync();
    var profile = await getProfile();
    if (deviceId != (profile?.activeDeviceId ?? "")) {
      return null;
    }
    return await attendanceApi.checkOut(deviceId, date);
  }

  @override
  Future<String> getCurrentDeviceIdAsync() async {
    var device = await cacheService.getOrAddAsync<DeviceId>(
        "deviceId", () async => DeviceId(const Uuid().v4()));
    return device!["_id"].toString();
  }

  @override
  Future<DateTime?> getCheckoutTime() async {
    try {
      var device = await cacheService.getAsync(
        "checkoutTime",
      );
      if (device == null ||
          !device.containsKey("checkout") ||
          device["checkout"] == null) {
        return null;
      }
      var checkout = device["checkout"];
      return DateTime.parse(checkout);
    } catch (e) {
      return null;
    }
  }

  @override
  Future setCheckoutTime(DateTime? date) async {
    await cacheService.setAsync(
        "checkoutTime",
        date == null
            ? null
            : {"checkout": date.toIso8601String()} as Map<String, dynamic>);
  }

  @override
  Future removeCurrentDeviceIdAsync() {
    return cacheService.setAsync("deviceId", null);
  }

  @override
  Future<bool> checkoutable() async {
    try {
      var checkoutable = await cacheService.getAsync(
        "Checkoutable",
      );
      if (checkoutable == null ||
          !checkoutable.containsKey("checkout") ||
          checkoutable["checkout"] == null) {
        return false;
      }
      var checkout = checkoutable["checkout"];
      return checkout;
    } catch (e) {
      return false;
    }
  }

  @override
  Future setCheckoutable() async {
    var checkoutable = await attendanceApi.checkoutable();
    await cacheService
        .setAsync("Checkoutable", {"checkout": checkoutable?.error == false});
  }

  @override
  Future<CheckOutResponse?> forceCheckOut() async {
    var deviceId = await getCurrentDeviceIdAsync();
    var profile = await getProfile();
    if (deviceId != (profile?.activeDeviceId ?? "")) {
      return null;
    }
    return await attendanceApi.forceCheckOut(deviceId);
  }
}

class DeviceId {
  String id;
  DeviceId(this.id);

  Map<String, dynamic> toJson() => {"_id": id};
}
