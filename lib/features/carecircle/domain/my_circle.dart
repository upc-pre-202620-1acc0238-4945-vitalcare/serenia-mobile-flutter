import 'package:serenia_app/features/carecircle/domain/family_link.dart';
import 'package:serenia_app/features/iam/domain/user.dart';

class MyCircle {
  final FamilyLink link;
  final User olderAdult;

  const new({required this.link, required this.olderAdult});

  String get careCircleId => link.careCircleId;

  String get myUserId => link.relativeId;

  String get olderAdultFirstName {
    return olderAdult.fullName.trim().split(RegExp(r'\s+')).first;
  }
}
