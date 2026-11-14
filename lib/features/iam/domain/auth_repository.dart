import 'package:serenia_app/features/iam/domain/user.dart';

abstract class AuthRepository {
  Future<User> signIn(String email, String password);
  Future<User> register({
    required String fullName,
    required String email,
    required String password,
    String? phoneNumber,
  });
  Future<User> getUser(String userId);
  Future<String?> currentUserId();
  Future<User> updateProfile({
    required String fullName,
    String? phoneNumber,
    String? birthDate,
  });
  Future<User> uploadPhoto(List<int> bytes);
  Future<void> changePassword(String currentPassword, String newPassword);
  Future<void> signOut();
  Future<bool> isSignedIn();
}
