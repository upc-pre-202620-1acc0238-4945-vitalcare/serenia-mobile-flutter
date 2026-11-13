import 'package:serenia_app/features/carecircle/domain/care_circle_repository.dart';
import 'package:serenia_app/features/carecircle/domain/family_link.dart';
import 'package:serenia_app/features/carecircle/domain/relationship.dart';

class RedeemInvitationCodeUseCase {
  final CareCircleRepository _repository;
  const new({required this._repository});

  Future<FamilyLink> execute(String code, Relationship relationship) {
    final String normalizedCode = code
        .replaceAll(RegExp(r'[^A-Za-z0-9]'), '')
        .toUpperCase();
    return _repository.redeemInvitationCode(
      normalizedCode,
      relationship.storedLabel,
    );
  }
}
