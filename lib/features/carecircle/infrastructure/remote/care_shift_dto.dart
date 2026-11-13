class CareShiftDto {
  final String id;
  final String careCircleId;
  final String relativeId;
  final String shiftDate;

  const new({
    required this.id,
    required this.careCircleId,
    required this.relativeId,
    required this.shiftDate,
  });

  factory CareShiftDto.fromJson(Map<String, dynamic> json) {
    return CareShiftDto(
      id: json['id'],
      careCircleId: json['careCircleId'],
      relativeId: json['relativeId'],
      shiftDate: json['shiftDate'],
    );
  }
}
