class CareShift {
  final String? id;
  final DateTime date;
  final String? assigneeId;
  final bool isMine;

  const new({
    this.id,
    required this.date,
    this.assigneeId,
    this.isMine = false,
  });

  bool get isFree => assigneeId == null;
}
