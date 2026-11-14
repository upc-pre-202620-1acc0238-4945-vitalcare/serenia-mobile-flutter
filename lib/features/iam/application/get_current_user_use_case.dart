import 'package:serenia_app/features/iam/domain/auth_repository.dart';
import 'package:serenia_app/features/iam/domain/user.dart';

class GetCurrentUserUseCase {
  final AuthRepository _repository;
  const new({required this._repository});

  Future<User> execute() async {
    final String? userId = await _repository.currentUserId();
    if (userId == null) {
      throw StateError('There is no active session');
    }
    return _repository.getUser(userId);
  }
}
