import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:serenia_app/core/secure_token_storage.dart';
import 'package:serenia_app/core/token_storage.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  getIt.registerLazySingleton<FlutterSecureStorage>(
    () => FlutterSecureStorage(),
  );

  getIt.registerLazySingleton<TokenStorage>(
    () => SecureTokenStorage(storage: getIt<FlutterSecureStorage>()),
  );
}
