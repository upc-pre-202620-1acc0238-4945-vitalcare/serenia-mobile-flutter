import 'package:serenia_app/features/carecircle/domain/care_circle_repository.dart';
import 'package:serenia_app/features/carecircle/domain/my_circle.dart';

class RevokeFamilyLinkUseCase {
  final CareCircleRepository _repository;
  const new({required this._repository});

  Future<void> execute(MyCircle circle) {
    return _repository.revokeFamilyLink(circle.careCircleId, circle.link.id);
  }
}
