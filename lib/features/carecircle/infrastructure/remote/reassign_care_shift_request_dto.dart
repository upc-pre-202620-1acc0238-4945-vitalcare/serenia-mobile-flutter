class ReassignCareShiftRequestDto {
  final String relativeId;

  const new({required this.relativeId});

  Map<String, dynamic> toJson() {
    return {'relativeId': relativeId};
  }
}
