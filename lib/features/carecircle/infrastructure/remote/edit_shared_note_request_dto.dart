class EditSharedNoteRequestDto {
  final String content;

  const new({required this.content});

  Map<String, dynamic> toJson() {
    return {'content': content};
  }
}
