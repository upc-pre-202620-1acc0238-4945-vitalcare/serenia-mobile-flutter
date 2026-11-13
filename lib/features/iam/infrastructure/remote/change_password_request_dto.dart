class ChangePasswordRequestDto {
  final String currentPassword;
  final String newPassword;

  const new({required this.currentPassword, required this.newPassword});

  Map<String, dynamic> toJson() {
    return {'currentPassword': currentPassword, 'newPassword': newPassword};
  }
}
