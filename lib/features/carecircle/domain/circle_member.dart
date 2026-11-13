class CircleMember {
  final String userId;
  final String familyLinkId;
  final String name;
  final String? relationship;
  final String? photoUrl;
  final bool isMe;

  const new({
    required this.userId,
    required this.familyLinkId,
    required this.name,
    this.relationship,
    this.photoUrl,
    required this.isMe,
  });

  String get firstName => name.trim().split(RegExp(r'\s+')).first;
}
