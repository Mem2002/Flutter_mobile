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
          'Authorization': 'Bearer $storedToken', 
        },
      );

      if (response.statusCode == 200) {
        return ProposeDataResponse.fromJson(jsonDecode(response.body));
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error sending request: $e');
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
          'Authorization': 'Bearer $storedToken',
        },
      );

      if (response.statusCode == 200) {
        return ProposeDataResponse.fromJson(jsonDecode(response.body));
      } else {

        print('Error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error sending request: $e');
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
          'Authorization': 'Bearer $storedToken',
        },
      );
      return ResponseEmpty.fromJson(jsonDecode(response.body));
    } catch (e) {
      print('Error sending request: $e');
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
      print('Error sending request: $e');
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
      print('Error sending request: $e');
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
          'Authorization': 'Bearer $storedToken',
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
          'Authorization': 'Bearer $storedToken',
        },
        body: jsonEncode(<String, dynamic>{
        }),
      );

      if (response.statusCode == 200) {
        return ResponseEmpty.fromJson(jsonDecode(response.body));
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Lỗi khi gửi yêu cầu: $e');
      return null;
    }
  }

static Future<int> getIncome(String accessToken, String startDate, String endDate) async {
  final Uri uri = Uri.parse('${Constants.baseUrl}income').replace(queryParameters: {
    'startDate': startDate,
    'endDate': endDate,
  });

  try {
    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data.containsKey('income')) {
        print('Income key found in response: ${data['income']}'); 
        var incomeValue = data['income'];
          print('Raw income from API: $incomeValue'); 
        if (incomeValue is double) {
          return incomeValue.toInt(); 
        } else if (incomeValue is int) {
          return incomeValue; 
        } else {
          throw Exception('Unexpected income type: ${incomeValue.runtimeType}');
        }
      } else {
        throw Exception('Income key not found in response');
      }
    } else {
      print('Error: ${response.statusCode} - ${response.body}');
      throw Exception('Unable to load income data');
    }
  } catch (e) {
    print('Caught error: $e');
    rethrow; 
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
              'Bearer $storedToken',
        },
        body: jsonEncode(<String, dynamic>{
          'code': code,
        }),
      );

      if (response.statusCode == 200) {
        return 'Successful attendance';
      } else {
        return 'Error in timekeeping: ${response.body}';
      }
    } catch (e) {
      return 'Error sending request: $e';
    }
  }

  static Future<LoginResponse?> logInAsync(
      String email, String password) async {
    try {
      final url = Uri.parse('${Constants.baseUrl}login');

      if (email.trim().isEmpty || password.trim().isEmpty) {
        print('Email hoặc mật khẩu không được để trống');
        return null;
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

      if (res.statusCode == 200) {
        var body = loginResponseFromJson(res.body);

        if (body.dt?.data?.groupWithRole?.group != null) {
          String groupName = body.dt!.data!.groupWithRole!.group!.groupName;

          if (groupName == "Employee") {
            return body; 
          } else {
            print('Người dùng không thuộc nhóm Employee');
            return null;
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
      return null; 
    }
  }

  static Future<void> saveAccessToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', token);
  }

  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }
}
