class FamilyLinkDto {
  final String id;
  final String careCircleId;
  final String relativeId;
  final String? relationshipLabel;

  const new({
    required this.id,
    required this.careCircleId,
    required this.relativeId,
    required this.relationshipLabel,
  });

  factory FamilyLinkDto.fromJson(Map<String, dynamic> json) {
    return FamilyLinkDto(
      id: json['id'],
      careCircleId: json['careCircleId'],
      relativeId: json['relativeId'],
      relationshipLabel: json['relationshipLabel'],
    );
  }
}
