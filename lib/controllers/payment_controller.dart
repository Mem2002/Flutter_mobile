import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import '../services/application_service.dart';
import '../services/api.dart'; 

@injectable
class PaymentController extends ChangeNotifier { 
  final IApplicationService service;

  PaymentController(this.service);

  ValueNotifier<int?> income = ValueNotifier<int?>(null);

  Future<void> getIncome(String accessToken, int month, int year) async {
    try {
      final String startDate = '$year-${month.toString().padLeft(2, '0')}-01'; 
      final String endDate = '$year-${month.toString().padLeft(2, '0')}-31'; 

      final int incomeValue = await Api.getIncome(accessToken, startDate, endDate);
      income.value = incomeValue; 

      notifyListeners(); 
    } catch (e) {
      print('Error fetching income: $e');
      income.value = null; 
      notifyListeners(); 
    }
  }

}
