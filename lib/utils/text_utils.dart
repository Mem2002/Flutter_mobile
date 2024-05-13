class EmailValidator {
  static bool isEmailValid(String email) {
    final RegExp emailRegex = RegExp(
      r'^[\w\.-]+@[a-zA-Z\d\.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }
}

class UserValidator {
  static bool isUserValid(String? user) => user?.isNotEmpty == true;
}

class PasswordValidator {
  static bool isPasswordValid(String password) => password.length >= 6;
}
