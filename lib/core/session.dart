class Session {
  final String token;
  final String sessionId;
  final String userId;

  const new({
    required this.token,
    required this.sessionId,
    required this.userId,
  });
}
