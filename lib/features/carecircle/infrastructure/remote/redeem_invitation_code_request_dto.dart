class RedeemInvitationCodeRequestDto {
  final String code;
  final String relationshipLabel;

  const new({required this.code, required this.relationshipLabel});

  Map<String, dynamic> toJson() {
    return {'code': code, 'relationshipLabel': relationshipLabel};
  }
}
