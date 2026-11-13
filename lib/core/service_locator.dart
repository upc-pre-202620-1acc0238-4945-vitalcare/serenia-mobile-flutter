import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:serenia_app/core/secure_session_storage.dart';
import 'package:serenia_app/core/session_storage.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  getIt.registerLazySingleton<FlutterSecureStorage>(
    () => FlutterSecureStorage(),
  );

  getIt.registerLazySingleton<SessionStorage>(
    () => SecureSessionStorage(storage: getIt<FlutterSecureStorage>()),
  );
}
