import 'package:serenia_app/features/iam/domain/auth_repository.dart';
import 'package:serenia_app/features/iam/domain/user.dart';

class UploadProfilePhotoUseCase {
  final AuthRepository _repository;
  const new({required this._repository});

  Future<User> execute(List<int> bytes) {
    return _repository.uploadPhoto(bytes);
  }
}
