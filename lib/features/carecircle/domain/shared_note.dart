class SharedNote {
  final String id;
  final String authorId;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String text;
  final bool isMine;

  const new({
    required this.id,
    required this.authorId,
    required this.createdAt,
    this.updatedAt,
    required this.text,
    required this.isMine,
  });
}
