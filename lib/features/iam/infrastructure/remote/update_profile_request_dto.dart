class UpdateProfileRequestDto {
  final String fullName;
  final String? phoneNumber;
  final String? birthDate;
  final String locale;
  final String timeZone;

  const new({
    required this.fullName,
    required this.phoneNumber,
    required this.birthDate,
    required this.locale,
    required this.timeZone,
  });

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'birthDate': birthDate,
      'locale': locale,
      'timeZone': timeZone,
    };
  }
}
