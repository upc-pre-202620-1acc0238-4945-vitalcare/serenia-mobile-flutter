import 'package:serenia_app/features/iam/domain/auth_repository.dart';
import 'package:serenia_app/features/iam/domain/user.dart';

class SignUpUseCase {
  final AuthRepository _repository;
  const new({required this._repository});

  Future<User> execute({
    required String fullName,
    required String email,
    required String password,
    String? phoneNumber,
  }) async {
    final String trimmedEmail = email.trim();
    await _repository.register(
      fullName: fullName.trim(),
      email: trimmedEmail,
      password: password,
      phoneNumber: phoneNumber,
    );
    return _repository.signIn(trimmedEmail, password);
  }
}
