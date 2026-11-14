import 'package:serenia_app/features/iam/domain/auth_repository.dart';

class ChangePasswordUseCase {
  final AuthRepository _repository;
  const new({required this._repository});

  Future<void> execute(String currentPassword, String newPassword) {
    return _repository.changePassword(currentPassword, newPassword);
  }
}
