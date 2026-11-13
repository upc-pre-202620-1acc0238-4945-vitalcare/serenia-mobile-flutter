class ResolveAlertRequestDto {
  final String? resolutionNote;

  const new({this.resolutionNote});

  Map<String, dynamic> toJson() {
    return {'resolutionNote': resolutionNote};
  }
}
