class CredentialsValidator {
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 72;
  static const int maxNameLength = 120;

  static final RegExp _emailPattern = RegExp(
    r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
  );

  static bool isValidName(String name) {
    return name.trim().isNotEmpty && name.trim().length <= maxNameLength;
  }

  static bool isValidEmail(String email) {
    return _emailPattern.hasMatch(email.trim());
  }

  static bool isValidPassword(String password) {
    return password.length >= minPasswordLength &&
        password.length <= maxPasswordLength;
  }
}
