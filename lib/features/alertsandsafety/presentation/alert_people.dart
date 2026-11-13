class AlertPeople {
  final String myUserId;
  final String olderAdultFirstName;
  final Map<String, String> _firstNames;

  const new({
    required this.myUserId,
    required this.olderAdultFirstName,
    required this._firstNames,
  });

  bool isMe(String? userId) => userId != null && userId == myUserId;

  String? firstNameOf(String? userId) {
    return userId == null ? null : _firstNames[userId];
  }
}
