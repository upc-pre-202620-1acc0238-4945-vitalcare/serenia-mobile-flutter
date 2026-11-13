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
  Future<void> signOut();
  Future<bool> isSignedIn();
}
