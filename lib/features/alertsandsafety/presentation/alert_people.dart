class AlertPeople {
  final String myUserId;
  final String olderAdultFirstName;
  final String? olderAdultPhoneNumber;
  final List<String> familyFirstNames;
  final List<String> otherFamilyFirstNames;
  final Map<String, String> _firstNames;

  const new({
    required this.myUserId,
    required this.olderAdultFirstName,
    this.olderAdultPhoneNumber,
    this.familyFirstNames = const [],
    this.otherFamilyFirstNames = const [],
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

  bool get _knowsFamily => familyFirstNames.isNotEmpty;

  bool get _hasOthers => otherFamilyFirstNames.isNotEmpty;

  String get notifiedLine {
    if (!_knowsFamily) return 'Avisamos a tu familia';
    return 'Avisamos ${_join(familyFirstNames, prefix: 'a ')}';
  }

  String? get acknowledgeHint {
    if (!_knowsFamily) {
      return 'Así tus demás familiares sabrán que ya estás en eso.';
    }
    if (!_hasOthers) return null;
    final String verb = otherFamilyFirstNames.length == 1 ? 'sabrá' : 'sabrán';
    return 'Así ${_join(otherFamilyFirstNames)} $verb que ya estás en eso.';
  }

  String? get alreadyKnowLine {
    if (!_hasOthers) return null;
    final String verb = otherFamilyFirstNames.length == 1 ? 'sabe' : 'saben';
    return '${_join(otherFamilyFirstNames)} ya lo $verb';
  }

  String get resolvedMessage {
    if (!_hasOthers) return 'Alerta resuelta.';
    return 'Alerta resuelta. Avisamos a ${_join(otherFamilyFirstNames)}.';
  }

  static String _join(List<String> names, {String prefix = ''}) {
    final List<String> items = [
      for (final String name in names) '$prefix$name',
    ];
    if (items.length == 1) return items.first;
    final String last = items.last;
    return '${items.sublist(0, items.length - 1).join(', ')} y $last';
  }
}
