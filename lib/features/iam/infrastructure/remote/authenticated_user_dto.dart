import 'package:serenia_app/features/iam/infrastructure/remote/user_dto.dart';

class AuthenticatedUserDto {
  final String sessionId;
  final String token;
  final UserDto user;

  const new({required this.sessionId, required this.token, required this.user});

  factory AuthenticatedUserDto.fromJson(Map<String, dynamic> json) {
    return AuthenticatedUserDto(
      sessionId: json['sessionId'],
      token: json['token'],
      user: UserDto.fromJson(json['user']),
    );
  }
}
