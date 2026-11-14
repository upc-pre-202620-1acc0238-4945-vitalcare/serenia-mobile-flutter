import 'package:serenia_app/core/session.dart';

abstract class SessionStorage {
  Future<void> saveSession(Session session);
  Future<Session?> getSession();
  Future<String?> getToken();
  Future<void> deleteSession();
}
