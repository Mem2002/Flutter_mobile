import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import '../services/application_service.dart';
import '../services/api.dart'; // Thêm import cho API

@injectable
class PaymentController extends ChangeNotifier { // Kế thừa từ ChangeNotifier
  final IApplicationService service;

  PaymentController(this.service);

  ValueNotifier<int?> income = ValueNotifier<int?>(null); // Thay đổi để lưu thu nhập

  Future<void> getIncome(String accessToken, int month, int year) async {
    try {
      final String startDate = '$year-${month.toString().padLeft(2, '0')}-01'; // Định dạng ngày bắt đầu
      final String endDate = '$year-${month.toString().padLeft(2, '0')}-31'; // Định dạng ngày kết thúc

      final int incomeValue = await Api.getIncome(accessToken, startDate, endDate);
      income.value = incomeValue; // Lưu thu nhập vào ValueNotifier

      notifyListeners(); // Thông báo cho UI cập nhật
    } catch (e) {
      print('Error fetching income: $e');
      income.value = null; // Đặt lại giá trị nếu có lỗi
      notifyListeners(); // Thông báo cho UI cập nhật
    }
  }

  List<PayslipKey> keys = [
    PayslipKey(key: "Thông tin chung", type: PayslipType.title),
    PayslipKey(key: "thu_nhap", type: PayslipType.money), // Chỉ định khóa cho thu nhập
    // Thêm các khóa khác tùy theo yêu cầu
    // ...
  ];
}

class PayslipKey {
  bool important;
  String key;
  dynamic value;
  PayslipType type;
  String? note;

  PayslipKey(
      {required this.key,
      required this.type,
      this.value,
      this.note,
      this.important = false});
}

enum PayslipType { money, number, string, bool, title, percent, date }
