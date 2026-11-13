import 'package:serenia_app/features/iam/domain/auth_repository.dart';
import 'package:serenia_app/features/iam/domain/user.dart';

class GetUserUseCase {
  final AuthRepository _repository;
  const new({required this._repository});

  Future<User> execute(String userId) {
    return _repository.getUser(userId);
  }
}
