import 'package:serenia_app/features/iam/domain/user_role.dart';

class User {
  final String id;
  final String email;
  final UserRole role;
  final String fullName;
  final String? phoneNumber;
  final String? birthDate;
  final String? photoUrl;

  const new({
    required this.id,
    required this.email,
    required this.role,
    required this.fullName,
    this.phoneNumber,
    this.birthDate,
    this.photoUrl,
  });
}
