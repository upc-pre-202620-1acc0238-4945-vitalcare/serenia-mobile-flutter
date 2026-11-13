import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:serenia_app/core/token_storage.dart';

class SecureTokenStorage implements TokenStorage {
  final FlutterSecureStorage _storage;
  const new({required this._storage});

  static final String tokenKey = 'token';

  @override
  Future<void> deleteToken() async {
    await _storage.delete(key: tokenKey);
  }

  @override
  Future<String?> getToken() async {
    return await _storage.read(key: tokenKey);
  }

  @override
  Future<void> saveToken(String token) async {
    await _storage.write(key: tokenKey, value: token);
  }
}
