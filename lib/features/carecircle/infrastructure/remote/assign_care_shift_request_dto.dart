class AssignCareShiftRequestDto {
  final String shiftDate;

  const new({required this.shiftDate});

  Map<String, dynamic> toJson() {
    return {'shiftDate': shiftDate};
  }
}
