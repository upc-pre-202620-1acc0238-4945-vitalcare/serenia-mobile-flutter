import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:serenia_app/core/secure_session_storage.dart';
import 'package:serenia_app/core/session_storage.dart';
import 'package:serenia_app/features/iam/application/is_signed_in_use_case.dart';
import 'package:serenia_app/features/iam/application/sign_in_use_case.dart';
import 'package:serenia_app/features/iam/application/sign_out_use_case.dart';
import 'package:serenia_app/features/iam/application/sign_up_use_case.dart';
import 'package:serenia_app/features/iam/domain/auth_repository.dart';
import 'package:serenia_app/features/iam/infrastructure/auth_repository_impl.dart';
import 'package:serenia_app/features/iam/infrastructure/remote/iam_api.dart';
import 'package:serenia_app/features/iam/presentation/sign_in_view_model.dart';
import 'package:serenia_app/features/iam/presentation/sign_up_view_model.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  getIt.registerLazySingleton<FlutterSecureStorage>(
    () => FlutterSecureStorage(),
  );

  getIt.registerLazySingleton<SessionStorage>(
    () => SecureSessionStorage(storage: getIt<FlutterSecureStorage>()),
  );

  getIt.registerLazySingleton<IamApi>(() => IamApi());

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      api: getIt<IamApi>(),
      storage: getIt<SessionStorage>(),
    ),
  );

  getIt.registerLazySingleton<SignInUseCase>(
    () => SignInUseCase(repository: getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<SignUpUseCase>(
    () => SignUpUseCase(repository: getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<SignOutUseCase>(
    () => SignOutUseCase(repository: getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<IsSignedInUseCase>(
    () => IsSignedInUseCase(repository: getIt<AuthRepository>()),
  );

  getIt.registerFactory<SignInViewModel>(
    () => SignInViewModel(signIn: getIt<SignInUseCase>()),
  );

  getIt.registerFactory<SignUpViewModel>(
    () => SignUpViewModel(signUp: getIt<SignUpUseCase>()),
  );
}
