class Validators {
  static bool isValidEmail(String email) {
    final RegExp regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return regex.hasMatch(email);
  }

  static bool isValidPassword(String password) {
    return password.length >= 8;
  }
}