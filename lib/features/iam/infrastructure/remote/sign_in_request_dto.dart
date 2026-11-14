class SignInRequestDto {
  final String email;
  final String password;
  final String deviceInfo;

  const new({
    required this.email,
    required this.password,
    required this.deviceInfo,
  });

  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password, 'deviceInfo': deviceInfo};
  }
}
