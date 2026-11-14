import 'package:serenia_app/features/carecircle/domain/care_circle_repository.dart';

class HasFamilyLinkUseCase {
  final CareCircleRepository _repository;
  const new({required this._repository});

  Future<bool> execute() async {
    return await _repository.getMyFamilyLink() != null;
  }
}
