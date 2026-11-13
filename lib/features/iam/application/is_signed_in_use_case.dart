import 'package:serenia_app/features/iam/domain/auth_repository.dart';

class IsSignedInUseCase {
  final AuthRepository _repository;
  const new({required this._repository});

  Future<bool> execute() {
    return _repository.isSignedIn();
  }
}
