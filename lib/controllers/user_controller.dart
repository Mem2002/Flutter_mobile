import 'package:flutter/material.dart';
import 'package:flutter_app/models/user_model.dart';
import 'package:flutter_app/services/api.dart';
import 'package:injectable/injectable.dart';

@injectable
class UserController extends ChangeNotifier { // Kế thừa từ ChangeNotifier
  final ValueNotifier<UserResponses?> data = ValueNotifier(null);

  UserController();

  Future<void> getProfile() async {
    try {
      UserResponses user = await Api.getUser();
      data.value = user; 
      notifyListeners(); // Thông báo cho tất cả các listener
    } catch (e) {
      print("Error fetching user data: $e"); 
      data.value = null; 
      notifyListeners(); // Cập nhật thông báo lỗi
    }
  }
}
