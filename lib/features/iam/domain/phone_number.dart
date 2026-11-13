class PhoneNumber {
  static const String countryCode = '+51';
  static const int localLength = 9;

  static bool isValidLocal(String digits) {
    return digits.length == localLength &&
        digits.startsWith('9') &&
        RegExp(r'^\d+$').hasMatch(digits);
  }

  static String fromLocal(String digits) => '$countryCode$digits';

  static String toLocal(String phoneNumber) {
    return phoneNumber.startsWith(countryCode)
        ? phoneNumber.substring(countryCode.length)
        : phoneNumber;
  }
}
