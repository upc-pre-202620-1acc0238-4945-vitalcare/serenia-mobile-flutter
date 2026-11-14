import 'package:serenia_app/features/iam/domain/auth_repository.dart';
import 'package:serenia_app/features/iam/domain/user.dart';

class UpdateProfileUseCase {
  final AuthRepository _repository;
  const new({required this._repository});

  Future<User> execute({
    required String fullName,
    String? phoneNumber,
    String? birthDate,
  }) {
    return _repository.updateProfile(
      fullName: fullName.trim(),
      phoneNumber: phoneNumber,
      birthDate: birthDate,
    );
  }
}
