enum UserRole {
  olderAdult('OLDER_ADULT'),
  distantRelative('DISTANT_RELATIVE');

  final String value;

  const UserRole(this.value);

  static UserRole fromValue(String value) {
    return UserRole.values.firstWhere((role) => role.value == value);
  }
}
