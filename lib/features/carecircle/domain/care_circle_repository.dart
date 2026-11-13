import 'package:serenia_app/features/carecircle/domain/care_circle.dart';
import 'package:serenia_app/features/carecircle/domain/family_link.dart';

abstract class CareCircleRepository {
  Future<FamilyLink?> getMyFamilyLink();
  Future<FamilyLink> redeemInvitationCode(
    String code,
    String relationshipLabel,
  );
  Future<CareCircle> getCareCircle(String careCircleId);
  Future<List<FamilyLink>> getCircleFamilyLinks(String careCircleId);
}
