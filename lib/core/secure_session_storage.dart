import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:serenia_app/core/session.dart';
import 'package:serenia_app/core/session_storage.dart';

class SecureSessionStorage implements SessionStorage {
  final FlutterSecureStorage _storage;
  const new({required this._storage});

  static final String tokenKey = 'token';
  static final String sessionIdKey = 'session_id';
  static final String userIdKey = 'user_id';

  @override
  Future<void> saveSession(Session session) async {
    await _storage.write(key: tokenKey, value: session.token);
    await _storage.write(key: sessionIdKey, value: session.sessionId);
    await _storage.write(key: userIdKey, value: session.userId);
  }

  @override
  Future<Session?> getSession() async {
    final String? token = await _storage.read(key: tokenKey);
    final String? sessionId = await _storage.read(key: sessionIdKey);
    final String? userId = await _storage.read(key: userIdKey);
    if (token == null || sessionId == null || userId == null) {
      return null;
    }
    return Session(token: token, sessionId: sessionId, userId: userId);
  }

  @override
  Future<String?> getToken() async {
    return await _storage.read(key: tokenKey);
  }

  @override
  Future<void> deleteSession() async {
    await _storage.delete(key: tokenKey);
    await _storage.delete(key: sessionIdKey);
    await _storage.delete(key: userIdKey);
  }
}
