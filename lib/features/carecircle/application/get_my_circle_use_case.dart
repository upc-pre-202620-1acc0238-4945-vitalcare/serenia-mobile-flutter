import 'package:serenia_app/features/carecircle/domain/care_circle.dart';
import 'package:serenia_app/features/carecircle/domain/care_circle_repository.dart';
import 'package:serenia_app/features/carecircle/domain/family_link.dart';
import 'package:serenia_app/features/carecircle/domain/my_circle.dart';
import 'package:serenia_app/features/iam/domain/auth_repository.dart';
import 'package:serenia_app/features/iam/domain/user.dart';

class GetMyCircleUseCase {
  final CareCircleRepository _repository;
  final AuthRepository _authRepository;
  const new({required this._repository, required this._authRepository});

  Future<MyCircle?> execute() async {
    final FamilyLink? link = await _repository.getMyFamilyLink();
    if (link == null) return null;
    final CareCircle circle = await _repository.getCareCircle(
      link.careCircleId,
    );
    final User olderAdult = await _authRepository.getUser(circle.olderAdultId);
    return MyCircle(link: link, olderAdult: olderAdult);
  }
}
