import 'dart:convert';
import 'package:flutter_app/apis/attendances/dtos/attendance_response.dart';
import 'package:flutter_app/apis/authentications/dtos/login_response.dart';
import 'package:flutter_app/apis/proposes/dtos/get_proposes_dto.dart';
import 'package:flutter_app/apis/response_base.dart';
import 'package:flutter_app/models/attendance_model.dart';
import 'package:flutter_app/models/form_model.dart';
import 'package:flutter_app/models/payslip_model.dart'; // Đổi tên file model cho phù hợp
import 'package:flutter_app/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Getit phải có injectable
@injectable
class Api {
  static Future<ProposeDataResponse?> getProposes(
      {DateTime? from, DateTime? to, int page = 1}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedToken = prefs.getString('accessToken');

    if (storedToken == null) {
      throw Exception('No access token found.');
    }

    final url = Uri.parse('${Constants.baseUrl}employee/proposes');

    try {
      final DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
      final response = await http.get(
        url.replace(queryParameters: {
          "page": page.toString(),
          "date_range[]": (from != null && to != null)
              ? [dateFormat.format(from), dateFormat.format(to)]
              : null,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $storedToken', // Thêm token vào header
        },
      );

      if (response.statusCode == 200) {
        return ProposeDataResponse.fromJson(jsonDecode(response.body));
      } else {
        // Xử lý lỗi nếu cần
        print('Error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Lỗi khi gửi yêu cầu: $e');
      return null;
    }
  }

  static Future<ProposeDataResponse?> getPropose(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedToken = prefs.getString('accessToken');

    if (storedToken == null) {
      throw Exception('No access token found.');
    }

    final url = Uri.parse('${Constants.baseUrl}employee/propose/$id');

    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $storedToken', // Thêm token vào header
        },
      );

      if (response.statusCode == 200) {
        return ProposeDataResponse.fromJson(jsonDecode(response.body));
      } else {
        // Xử lý lỗi nếu cần
        print('Error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Lỗi khi gửi yêu cầu: $e');
      return null;
    }
  }

  static Future<ResponseEmpty?> deletePropose(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedToken = prefs.getString('accessToken');

    if (storedToken == null) {
      throw Exception('No access token found.');
    }

    final url = Uri.parse('${Constants.baseUrl}employee/propose/$id');

    try {
      final response = await http.delete(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $storedToken', // Thêm token vào header
        },
      );
      return ResponseEmpty.fromJson(jsonDecode(response.body));
    } catch (e) {
      print('Lỗi khi gửi yêu cầu: $e');
      return null;
    }
  }

  static Future<ResponseEmpty?> createAddTimePropose(
    DateTime startTime,
    DateTime endTime,
    String reason,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedToken = prefs.getString('accessToken');

    if (storedToken == null) {
      throw Exception('No access token found.');
    }

    final url = Uri.parse('${Constants.baseUrl}employee/propose');

    try {
      var request = {
        "category": 3,
        "startTime": DateFormat("yyyy-MM-dd").format(startTime),
        "status": 0,
        "reason": reason,
        "timeCheckin": startTime.toIso8601String(),
        "timeCheckout": endTime.toIso8601String(),
      };

      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $storedToken', // Thêm token vào header
        },
        body: jsonEncode(request),
      );
      return ResponseEmpty.fromJson(jsonDecode(response.body));
    } catch (e) {
      print('Lỗi khi gửi yêu cầu: $e');
      return null;
    }
  }

  static Future<ResponseEmpty?> createOverTimePropose(
    DateTime date,
    DateTime startTime,
    DateTime endTime,
    String reason,
    String result,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedToken = prefs.getString('accessToken');

    if (storedToken == null) {
      throw Exception('No access token found.');
    }

    final url = Uri.parse('${Constants.baseUrl}employee/propose');

    try {
      var request = {
        "category": 1,
        "start_date": DateFormat("yyyy-MM-dd").format(date),
        "timeCheckin": startTime.toIso8601String(),
        "timeCheckout": endTime.toIso8601String(),
        "status": 0,
        "reason": reason,
        "overtime_results": result,
      };

      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $storedToken', // Thêm token vào header
        },
        body: jsonEncode(request),
      );
      return ResponseEmpty.fromJson(jsonDecode(response.body));
    } catch (e) {
      print('Lỗi khi gửi yêu cầu: $e');
      return null;
    }
  }

  static Future<ResponseEmpty?> createChangeShiftPropose(
    DateTime startDate,
    String reason,
    WorkingHour current,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedToken = prefs.getString('accessToken');

    if (storedToken == null) {
      throw Exception('No access token found.');
    }

    final url = Uri.parse('${Constants.baseUrl}employee/propose');

    try {
      var request = {
        "category": 2,
        "status": 0,
        "reason": reason,
        "start_date": DateFormat("yyyy-MM-dd").format(startDate),
        "current_working_change": current.index + 1,
        "current_working_hours": WorkingHour.values
                .firstWhere((element) => element != current)
                .index +
            1,
      };

      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $storedToken', // Thêm token vào header
        },
        body: jsonEncode(request),
      );
      return ResponseEmpty.fromJson(jsonDecode(response.body));
    } catch (e) {
      print('Lỗi khi gửi yêu cầu: $e');
      return null;
    }
  }

  static Future<ResponseEmpty?> createOnLeavePropose(
    DateTime startDate,
    DateTime endDate,
    String reason,
    double generalLeave,
    int startShiftOff,
    String? phone,
    int? typeLeave,
    DateTime timeCheckin,
    DateTime timeCheckout,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedToken = prefs.getString('accessToken');

    if (storedToken == null) {
      throw Exception('No access token found.');
    }

    final url = Uri.parse('${Constants.baseUrl}employee/propose');

    try {
      var request = {
        "category": 0,
        "phone": phone,
        "reason": reason,
        "startTime": DateFormat("yyyy-MM-dd").format(startDate),
        "endTime": DateFormat("yyyy-MM-dd").format(endDate),
        "start_shift_off": startShiftOff,
        "general_leave": generalLeave,
        "type_leave": typeLeave,
        "status": 0,
        "timeCheckin": timeCheckin.toIso8601String(),
        "timeCheckout": timeCheckout.toIso8601String(),
      };

      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $storedToken', // Thêm token vào header
        },
        body: jsonEncode(request),
      );
      return ResponseEmpty.fromJson(jsonDecode(response.body));
    } catch (e) {
      print('Lỗi khi gửi yêu cầu: $e');
      return null;
    }
  }

  static Future<ResponseEmpty?> createPropose() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedToken = prefs.getString('accessToken');

    if (storedToken == null) {
      throw Exception('No access token found.');
    }

    final url = Uri.parse('${Constants.baseUrl}employee/propose');

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $storedToken', // Thêm token vào header
        },
        body: jsonEncode(<String, dynamic>{
          // Thêm dữ liệu cần thiết vào body ở đây
        }),
      );

      if (response.statusCode == 200) {
        return ResponseEmpty.fromJson(jsonDecode(response.body));
      } else {
        // Xử lý lỗi nếu cần
        print('Error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Lỗi khi gửi yêu cầu: $e');
      return null;
    }
  }

static Future<Map<String, dynamic>> getIncome(
    String accessToken, int month, int year) async {
  final Uri uri = Uri.parse('${Constants.baseUrl}income').replace(queryParameters: {
    'month': month.toString(),
    'year': year.toString(),
  });

  final response = await http.get(
    uri,
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $accessToken',
    },
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body); // Trả về Map<String, dynamic>
  } else {
    print('Error: ${response.statusCode} - ${response.body}');
    throw Exception('Unable to load income data');
  }
}


  static Future<List<AttendanceResponses>> getAttendance(
      String accessToken, String startDate, String endDate) async {
    final Uri uri =
        Uri.parse('${Constants.baseUrl}attendance').replace(queryParameters: {
      'startDate': startDate,
      'endDate': endDate,
    });

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse
          .map((json) => AttendanceResponses.fromJson(json))
          .toList();
    } else {
      print('Error: ${response.statusCode} - ${response.body}');
      throw Exception('Unable to load attendance data');
    }
  }

  static Future<List<Payslip>> getPayslip(String accessToken) async {
    final response =
        await http.get(Uri.parse('${Constants.baseUrl}payslip'), headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $accessToken'
    });

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((item) => Payslip.fromJson(item)).toList();
    } else {
      print('Error: ${response.statusCode} - ${response.body}');
      throw Exception('Failed to load payslips');
    }
  }

  static Future<String> sendCodeToBackend(String code) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedToken = prefs.getString('accessToken');

    if (storedToken == null) {
      throw Exception('No access token found.');
    }

    final url = Uri.parse('${Constants.baseUrl}qr-scanner');
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':
              'Bearer $storedToken', // Include the token in the header
        },
        body: jsonEncode(<String, dynamic>{
          'code': code,
        }),
      );

      if (response.statusCode == 200) {
        return 'Chấm công thành công';
      } else {
        return 'Lỗi khi chấm công: ${response.body}';
      }
    } catch (e) {
      return 'Lỗi khi gửi yêu cầu: $e';
    }
  }

  static Future<LoginResponse?> logInAsync(
      String email, String password) async {
    try {
      final url = Uri.parse('${Constants.baseUrl}login');

      // Kiểm tra xem email và password có hợp lệ không
      if (email.trim().isEmpty || password.trim().isEmpty) {
        print('Email hoặc mật khẩu không được để trống');
        return null; // Trả về null nếu dữ liệu không hợp lệ
      }

      var res = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email.trim(),
          'password': password.trim(),
        }),
      );

      // Kiểm tra phản hồi từ API
      if (res.statusCode == 200) {
        var body = loginResponseFromJson(res.body);

        // Kiểm tra nếu có dữ liệu group
        if (body.dt?.data?.groupWithRole?.group != null) {
          String groupName = body.dt!.data!.groupWithRole!.group!.groupName;

          // Chỉ cho phép đăng nhập nếu group_name là "Employee"
          if (groupName == "Employee") {
            return body; // Trả về kết quả nếu group_name là Employee
          } else {
            print('Người dùng không thuộc nhóm Employee');
            return null; // Trả về null nếu không phải Employee
          }
        } else {
          print('Không lấy được thông tin nhóm từ API');
          return null;
        }
      } else {
        print('Lỗi từ server: ${res.statusCode} - ${res.body}');
        return null;
      }
    } catch (e) {
      print('Đã xảy ra lỗi: $e');
      return null; // Trả về null nếu xảy ra lỗi
    }
  }

  static Future<List<Payslip>> getPayslipWithStoredToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedToken = prefs.getString('accessToken');

    if (storedToken != null) {
      return await getPayslip(
          storedToken); // Call your existing getPayslip method
    } else {
      throw Exception('No access token found.');
    }
  }

  // Lưu access token vào SharedPreferences
  static Future<void> saveAccessToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', token);
  }

  // Lấy access token từ SharedPreferences
  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }
}
