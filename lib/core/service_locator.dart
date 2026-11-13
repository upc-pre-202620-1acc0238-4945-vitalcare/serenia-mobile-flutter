import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:serenia_app/core/secure_session_storage.dart';
import 'package:serenia_app/core/session_storage.dart';
import 'package:serenia_app/features/carecircle/application/get_my_circle_use_case.dart';
import 'package:serenia_app/features/carecircle/application/has_family_link_use_case.dart';
import 'package:serenia_app/features/carecircle/application/redeem_invitation_code_use_case.dart';
import 'package:serenia_app/features/carecircle/domain/care_circle_repository.dart';
import 'package:serenia_app/features/carecircle/infrastructure/care_circle_repository_impl.dart';
import 'package:serenia_app/features/carecircle/infrastructure/remote/care_circle_api.dart';
import 'package:serenia_app/features/carecircle/presentation/connected_view_model.dart';
import 'package:serenia_app/features/carecircle/presentation/invitation_code_view_model.dart';
import 'package:serenia_app/features/iam/application/get_current_user_use_case.dart';
import 'package:serenia_app/features/iam/application/get_user_use_case.dart';
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

  getIt.registerLazySingleton<GetUserUseCase>(
    () => GetUserUseCase(repository: getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<GetCurrentUserUseCase>(
    () => GetCurrentUserUseCase(repository: getIt<AuthRepository>()),
  );

  getIt.registerFactory<SignInViewModel>(
    () => SignInViewModel(
      signIn: getIt<SignInUseCase>(),
      hasFamilyLink: getIt<HasFamilyLinkUseCase>(),
    ),
  );

  getIt.registerFactory<SignUpViewModel>(
    () => SignUpViewModel(signUp: getIt<SignUpUseCase>()),
  );

  getIt.registerLazySingleton<CareCircleApi>(
    () => CareCircleApi(storage: getIt<SessionStorage>()),
  );

  getIt.registerLazySingleton<CareCircleRepository>(
    () => CareCircleRepositoryImpl(
      api: getIt<CareCircleApi>(),
      storage: getIt<SessionStorage>(),
    ),
  );

  getIt.registerLazySingleton<GetMyCircleUseCase>(
    () => GetMyCircleUseCase(
      repository: getIt<CareCircleRepository>(),
      authRepository: getIt<AuthRepository>(),
    ),
  );

  getIt.registerLazySingleton<HasFamilyLinkUseCase>(
    () => HasFamilyLinkUseCase(repository: getIt<CareCircleRepository>()),
  );

  getIt.registerLazySingleton<RedeemInvitationCodeUseCase>(
    () =>
        RedeemInvitationCodeUseCase(repository: getIt<CareCircleRepository>()),
  );

  getIt.registerFactory<InvitationCodeViewModel>(
    () => InvitationCodeViewModel(redeem: getIt<RedeemInvitationCodeUseCase>()),
  );

  getIt.registerFactory<ConnectedViewModel>(
    () => ConnectedViewModel(
      getMyCircle: getIt<GetMyCircleUseCase>(),
      getCurrentUser: getIt<GetCurrentUserUseCase>(),
    ),
  );
}
