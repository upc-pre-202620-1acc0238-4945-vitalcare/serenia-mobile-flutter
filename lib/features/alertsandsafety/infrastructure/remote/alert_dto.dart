class AlertDto {
  final String id;
  final String olderAdultId;
  final String type;
  final String status;
  final String triggeredAt;
  final String? acknowledgedBy;
  final String? acknowledgedAt;
  final String? resolvedBy;
  final String? resolvedAt;

  const new({
    required this.id,
    required this.olderAdultId,
    required this.type,
    required this.status,
    required this.triggeredAt,
    required this.acknowledgedBy,
    required this.acknowledgedAt,
    required this.resolvedBy,
    required this.resolvedAt,
  });

  factory AlertDto.fromJson(Map<String, dynamic> json) {
    return AlertDto(
      id: json['id'],
      olderAdultId: json['olderAdultId'],
      type: json['type'],
      status: json['status'],
      triggeredAt: json['triggeredAt'],
      acknowledgedBy: json['acknowledgedBy'],
      acknowledgedAt: json['acknowledgedAt'],
      resolvedBy: json['resolvedBy'],
      resolvedAt: json['resolvedAt'],
    );
  }
}
