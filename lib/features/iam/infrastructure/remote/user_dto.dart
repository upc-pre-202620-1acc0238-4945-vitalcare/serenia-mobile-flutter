class UserDto {
  final String id;
  final String email;
  final String role;
  final String fullName;
  final String? phoneNumber;
  final String? birthDate;
  final String? photoUrl;

  const new({
    required this.id,
    required this.email,
    required this.role,
    required this.fullName,
    required this.phoneNumber,
    required this.birthDate,
    required this.photoUrl,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      id: json['id'],
      email: json['email'],
      role: json['role'],
      fullName: json['fullName'],
      phoneNumber: json['phoneNumber'],
      birthDate: json['birthDate'],
      photoUrl: json['photoUrl'],
    );
  }
}
