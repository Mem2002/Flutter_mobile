import 'dart:convert';
import 'package:flutter_app/apis/authentications/dtos/login_response.dart';
import 'package:flutter_app/models/payslipModel.dart'; // Đổi tên file model cho phù hợp
import 'package:flutter_app/utils/constants.dart';
import 'package:http/http.dart' as http;

class Api {

  static Future<List<Payslip>> getPayslip() async {
  final response = await http.get(Uri.parse('${Constants.baseUrl}createPayslip'));

  if (response.statusCode == 200) {
    List<dynamic> body = jsonDecode(response.body);
    List<Payslip> payslips = body.map((item) => Payslip.fromJson(item)).toList();
    return payslips;
  } else {
    throw Exception('Failed to load payslips');
  }
}


 static Future<String> sendCodeToBackend(String code, String scanTime) async {
    final url = Uri.parse('${Constants.baseUrl}/qr-scanner');  // Sử dụng URL từ Constants
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'code': code,
          'scanTime': scanTime, // Thêm thời gian vào body request
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

static Future<LoginResponse?> logInAsync(String email, String password) async {
  try {
    final url = Uri.parse('${Constants.baseUrl}login'); // Thay đổi URL bằng cách sử dụng Uri.parse

    // Kiểm tra xem email và password có hợp lệ không
    if (email.trim().isEmpty || password.trim().isEmpty) {
      print('Email hoặc mật khẩu không được để trống');
      return null; // Trả về null nếu dữ liệu không hợp lệ
    }

    var res = await http.post(
      url, // Sử dụng URL đã tạo
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
      return body;
    } else {
      print('Lỗi từ server: ${res.statusCode} - ${res.body}');
      return null;
    }
  } catch (e) {
    print('Đã xảy ra lỗi: $e');
    return null; // Trả về null nếu xảy ra lỗi
  }
}

}
