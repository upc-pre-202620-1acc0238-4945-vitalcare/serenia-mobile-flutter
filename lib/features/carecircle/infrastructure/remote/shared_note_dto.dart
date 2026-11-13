class SharedNoteDto {
  final String id;
  final String careCircleId;
  final String authorId;
  final String content;
  final String createdAt;
  final String? updatedAt;

  const new({
    required this.id,
    required this.careCircleId,
    required this.authorId,
    required this.content,
    required this.createdAt,
    this.updatedAt,
  });

  factory SharedNoteDto.fromJson(Map<String, dynamic> json) {
    return SharedNoteDto(
      id: json['id'],
      careCircleId: json['careCircleId'],
      authorId: json['authorId'],
      content: json['content'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
