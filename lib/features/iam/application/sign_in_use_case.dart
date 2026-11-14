import 'package:serenia_app/features/iam/domain/auth_repository.dart';
import 'package:serenia_app/features/iam/domain/older_adult_account_exception.dart';
import 'package:serenia_app/features/iam/domain/user.dart';
import 'package:serenia_app/features/iam/domain/user_role.dart';

class SignInUseCase {
  final AuthRepository _repository;
  const new({required this._repository});

  Future<User> execute(String email, String password) async {
    final User user = await _repository.signIn(email.trim(), password);
    if (user.role != UserRole.distantRelative) {
      await _repository.signOut();
      throw const OlderAdultAccountException();
    }
    return user;
  }
}
