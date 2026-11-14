class FamilyLink {
  final String id;
  final String careCircleId;
  final String relativeId;
  final String? relationshipLabel;

  const new({
    required this.id,
    required this.careCircleId,
    required this.relativeId,
    this.relationshipLabel,
  });
}
