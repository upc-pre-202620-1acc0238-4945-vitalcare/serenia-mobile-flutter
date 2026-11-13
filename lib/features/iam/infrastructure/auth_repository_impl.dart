import 'package:flutter/foundation.dart';
import 'package:serenia_app/core/api_constants.dart';
import 'package:serenia_app/core/session.dart';
import 'package:serenia_app/core/session_storage.dart';
import 'package:serenia_app/features/iam/domain/auth_repository.dart';
import 'package:serenia_app/features/iam/domain/user.dart';
import 'package:serenia_app/features/iam/domain/user_role.dart';
import 'package:serenia_app/features/iam/infrastructure/remote/authenticated_user_dto.dart';
import 'package:serenia_app/features/iam/infrastructure/remote/iam_api.dart';
import 'package:serenia_app/features/iam/infrastructure/remote/register_user_request_dto.dart';
import 'package:serenia_app/features/iam/infrastructure/remote/sign_in_request_dto.dart';
import 'package:serenia_app/features/iam/infrastructure/remote/user_dto.dart';

class AuthRepositoryImpl implements AuthRepository {
  final IamApi _api;
  final SessionStorage _storage;
  const new({required this._api, required this._storage});

  static const String locale = 'es-PE';
  static const String timeZone = 'America/Lima';

  @override
  Future<User> signIn(String email, String password) async {
    final AuthenticatedUserDto dto = await _api.signIn(
      SignInRequestDto(
        email: email,
        password: password,
        deviceInfo: _deviceInfo(),
      ),
    );
    await _storage.saveSession(
      Session(token: dto.token, sessionId: dto.sessionId, userId: dto.user.id),
    );
    return _toUser(dto.user);
  }

  @override
  Future<User> register({
    required String fullName,
    required String email,
    required String password,
    String? phoneNumber,
  }) async {
    final UserDto dto = await _api.register(
      RegisterUserRequestDto(
        email: email,
        password: password,
        role: UserRole.distantRelative.value,
        fullName: fullName,
        phoneNumber: phoneNumber,
        locale: locale,
        timeZone: timeZone,
      ),
    );
    return _toUser(dto);
  }

  @override
  Future<User> getUser(String userId) async {
    final String? token = await _storage.getToken();
    final UserDto dto = await _api.getUser(userId, token ?? '');
    return _toUser(dto);
  }

  @override
  Future<String?> currentUserId() async {
    final Session? session = await _storage.getSession();
    return session?.userId;
  }

  @override
  Future<void> signOut() async {
    final Session? session = await _storage.getSession();
    if (session != null) {
      await _api.signOut(session.sessionId, session.token);
    }
    await _storage.deleteSession();
  }

  @override
  Future<bool> isSignedIn() async {
    return await _storage.getSession() != null;
  }

  User _toUser(UserDto dto) {
    return User(
      id: dto.id,
      email: dto.email,
      role: UserRole.fromValue(dto.role),
      fullName: dto.fullName,
      phoneNumber: dto.phoneNumber,
      photoUrl: dto.photoUrl == null
          ? null
          : '${ApiConstants.host}${dto.photoUrl}',
    );
  }

  String _deviceInfo() {
    final String platform = kIsWeb ? 'Web' : defaultTargetPlatform.name;
    return 'Serenia familiar - $platform';
  }
}
