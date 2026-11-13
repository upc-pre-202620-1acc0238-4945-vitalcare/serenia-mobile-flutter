import 'package:serenia_app/features/iam/domain/auth_repository.dart';

class SignOutUseCase {
  final AuthRepository _repository;
  const new({required this._repository});

  Future<void> execute() {
    return _repository.signOut();
  }
}
