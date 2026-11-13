class RegisterUserRequestDto {
  final String email;
  final String password;
  final String role;
  final String fullName;
  final String? phoneNumber;
  final String locale;
  final String timeZone;

  const new({
    required this.email,
    required this.password,
    required this.role,
    required this.fullName,
    required this.phoneNumber,
    required this.locale,
    required this.timeZone,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'role': role,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'locale': locale,
      'timeZone': timeZone,
    };
  }
}
