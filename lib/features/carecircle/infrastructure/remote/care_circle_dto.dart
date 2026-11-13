class CareCircleDto {
  final String id;
  final String olderAdultId;

  const new({required this.id, required this.olderAdultId});

  factory CareCircleDto.fromJson(Map<String, dynamic> json) {
    return CareCircleDto(id: json['id'], olderAdultId: json['olderAdultId']);
  }
}
