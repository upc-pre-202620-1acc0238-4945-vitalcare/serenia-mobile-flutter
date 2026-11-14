import 'package:serenia_app/features/carecircle/domain/care_circle_repository.dart';
import 'package:serenia_app/features/carecircle/domain/circle_member.dart';
import 'package:serenia_app/features/carecircle/domain/family_link.dart';
import 'package:serenia_app/features/iam/domain/auth_repository.dart';
import 'package:serenia_app/features/iam/domain/user.dart';

class GetCircleMembersUseCase {
  final CareCircleRepository _repository;
  final AuthRepository _authRepository;
  const new({required this._repository, required this._authRepository});

  Future<List<CircleMember>> execute(String careCircleId) async {
    final List<FamilyLink> links = await _repository.getCircleFamilyLinks(
      careCircleId,
    );
    final String? myUserId = await _authRepository.currentUserId();
    final List<CircleMember> members = await Future.wait(
      links.map((link) async {
        final User user = await _authRepository.getUser(link.relativeId);
        return CircleMember(
          userId: link.relativeId,
          familyLinkId: link.id,
          name: user.fullName,
          relationship: link.relationshipLabel,
          photoUrl: user.photoUrl,
          isMe: link.relativeId == myUserId,
        );
      }),
    );
    return [
      ...members.where((member) => member.isMe),
      ...members.where((member) => !member.isMe),
    ];
  }
}
