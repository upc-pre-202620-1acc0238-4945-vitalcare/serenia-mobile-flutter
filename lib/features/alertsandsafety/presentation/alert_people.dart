class AlertPeople {
  final String myUserId;
  final String olderAdultFirstName;
  final String? olderAdultPhoneNumber;
  final Map<String, String> _firstNames;

  const new({
    required this.myUserId,
    required this.olderAdultFirstName,
    this.olderAdultPhoneNumber,
    required this._firstNames,
  });

  bool get canCallOlderAdult {
    return olderAdultPhoneNumber != null &&
        olderAdultPhoneNumber!.trim().isNotEmpty;
  }

  bool isMe(String? userId) => userId != null && userId == myUserId;

  String? firstNameOf(String? userId) {
    return userId == null ? null : _firstNames[userId];
  }
}
