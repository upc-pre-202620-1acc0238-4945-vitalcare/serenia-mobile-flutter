import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:serenia_app/core/secure_session_storage.dart';
import 'package:serenia_app/core/session_storage.dart';
import 'package:serenia_app/features/account/presentation/account_view_model.dart';
import 'package:serenia_app/features/account/presentation/change_password_view_model.dart';
import 'package:serenia_app/features/account/presentation/profile_data_view_model.dart';
import 'package:serenia_app/features/alertsandsafety/application/acknowledge_alert_use_case.dart';
import 'package:serenia_app/features/alertsandsafety/application/call_older_adult_use_case.dart';
import 'package:serenia_app/features/alertsandsafety/application/get_alerts_use_case.dart';
import 'package:serenia_app/features/alertsandsafety/application/resolve_alert_use_case.dart';
import 'package:serenia_app/features/alertsandsafety/domain/alerts_repository.dart';
import 'package:serenia_app/features/alertsandsafety/domain/care_alert.dart';
import 'package:serenia_app/features/alertsandsafety/domain/phone_dialer.dart';
import 'package:serenia_app/features/alertsandsafety/infrastructure/alerts_repository_impl.dart';
import 'package:serenia_app/features/alertsandsafety/infrastructure/remote/alerts_api.dart';
import 'package:serenia_app/features/alertsandsafety/infrastructure/url_launcher_phone_dialer.dart';
import 'package:serenia_app/features/alertsandsafety/presentation/alert_detail_view_model.dart';
import 'package:serenia_app/features/alertsandsafety/presentation/alerts_view_model.dart';
import 'package:serenia_app/features/carecircle/application/get_my_circle_use_case.dart';
import 'package:serenia_app/features/carecircle/application/has_family_link_use_case.dart';
import 'package:serenia_app/features/carecircle/application/redeem_invitation_code_use_case.dart';
import 'package:serenia_app/features/carecircle/application/reassign_care_shift_use_case.dart';
import 'package:serenia_app/features/carecircle/domain/care_circle_repository.dart';
import 'package:serenia_app/features/carecircle/infrastructure/care_circle_repository_impl.dart';
import 'package:serenia_app/features/carecircle/infrastructure/remote/care_circle_api.dart';
import 'package:serenia_app/features/carecircle/presentation/connected_view_model.dart';
import 'package:serenia_app/features/carecircle/application/assign_care_shift_use_case.dart';
import 'package:serenia_app/features/carecircle/application/get_care_shifts_use_case.dart';
import 'package:serenia_app/features/carecircle/application/get_circle_members_use_case.dart';
import 'package:serenia_app/features/carecircle/application/get_shared_notes_use_case.dart';
import 'package:serenia_app/features/carecircle/domain/care_shift_repository.dart';
import 'package:serenia_app/features/carecircle/domain/shared_note_repository.dart';
import 'package:serenia_app/features/carecircle/infrastructure/care_shift_repository_impl.dart';
import 'package:serenia_app/features/carecircle/infrastructure/remote/care_shifts_api.dart';
import 'package:serenia_app/features/carecircle/infrastructure/remote/shared_notes_api.dart';
import 'package:serenia_app/features/carecircle/infrastructure/shared_note_repository_impl.dart';
import 'package:serenia_app/features/carecircle/presentation/care_shifts_view_model.dart';
import 'package:serenia_app/features/carecircle/presentation/circle_view_model.dart';
import 'package:serenia_app/features/carecircle/presentation/invitation_code_view_model.dart';
import 'package:serenia_app/features/carecircle/presentation/reassign_care_shift_view_model.dart';
import 'package:serenia_app/features/iam/application/get_current_user_use_case.dart';
import 'package:serenia_app/features/iam/application/get_user_use_case.dart';
import 'package:serenia_app/features/iam/application/change_password_use_case.dart';
import 'package:serenia_app/features/iam/application/update_profile_use_case.dart';
import 'package:serenia_app/features/iam/application/upload_profile_photo_use_case.dart';
import 'package:serenia_app/features/iam/domain/user.dart';
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

  getIt.registerLazySingleton<UpdateProfileUseCase>(
    () => UpdateProfileUseCase(repository: getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<UploadProfilePhotoUseCase>(
    () => UploadProfilePhotoUseCase(repository: getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<ChangePasswordUseCase>(
    () => ChangePasswordUseCase(repository: getIt<AuthRepository>()),
  );

  getIt.registerFactory<AccountViewModel>(
    () => AccountViewModel(
      getCurrentUser: getIt<GetCurrentUserUseCase>(),
      getMyCircle: getIt<GetMyCircleUseCase>(),
      signOut: getIt<SignOutUseCase>(),
      storage: getIt<SessionStorage>(),
    ),
  );

  getIt.registerFactoryParam<ProfileDataViewModel, User, void>(
    (user, _) => ProfileDataViewModel(
      updateProfile: getIt<UpdateProfileUseCase>(),
      uploadPhoto: getIt<UploadProfilePhotoUseCase>(),
      user: user,
    ),
  );

  getIt.registerFactory<ChangePasswordViewModel>(
    () =>
        ChangePasswordViewModel(changePassword: getIt<ChangePasswordUseCase>()),
  );

  getIt.registerLazySingleton<AlertsApi>(
    () => AlertsApi(storage: getIt<SessionStorage>()),
  );

  getIt.registerLazySingleton<AlertsRepository>(
    () => AlertsRepositoryImpl(api: getIt<AlertsApi>()),
  );

  getIt.registerLazySingleton<GetAlertsUseCase>(
    () => GetAlertsUseCase(repository: getIt<AlertsRepository>()),
  );

  getIt.registerLazySingleton<AcknowledgeAlertUseCase>(
    () => AcknowledgeAlertUseCase(repository: getIt<AlertsRepository>()),
  );

  getIt.registerLazySingleton<ResolveAlertUseCase>(
    () => ResolveAlertUseCase(repository: getIt<AlertsRepository>()),
  );

  getIt.registerLazySingleton<PhoneDialer>(() => UrlLauncherPhoneDialer());

  getIt.registerLazySingleton<CallOlderAdultUseCase>(
    () => CallOlderAdultUseCase(dialer: getIt<PhoneDialer>()),
  );

  getIt.registerFactory<AlertsViewModel>(
    () => AlertsViewModel(
      getMyCircle: getIt<GetMyCircleUseCase>(),
      getAlerts: getIt<GetAlertsUseCase>(),
      getUser: getIt<GetUserUseCase>(),
    ),
  );

  getIt.registerFactoryParam<AlertDetailViewModel, CareAlert, void>(
    (alert, _) => AlertDetailViewModel(
      acknowledge: getIt<AcknowledgeAlertUseCase>(),
      resolve: getIt<ResolveAlertUseCase>(),
      callOlderAdult: getIt<CallOlderAdultUseCase>(),
      alert: alert,
    ),
  );

  getIt.registerLazySingleton<GetCircleMembersUseCase>(
    () => GetCircleMembersUseCase(
      repository: getIt<CareCircleRepository>(),
      authRepository: getIt<AuthRepository>(),
    ),
  );

  getIt.registerLazySingleton<CareShiftsApi>(
    () => CareShiftsApi(storage: getIt<SessionStorage>()),
  );

  getIt.registerLazySingleton<CareShiftRepository>(
    () => CareShiftRepositoryImpl(
      api: getIt<CareShiftsApi>(),
      storage: getIt<SessionStorage>(),
    ),
  );

  getIt.registerLazySingleton<GetCareShiftsUseCase>(
    () => GetCareShiftsUseCase(repository: getIt<CareShiftRepository>()),
  );

  getIt.registerLazySingleton<SharedNotesApi>(
    () => SharedNotesApi(storage: getIt<SessionStorage>()),
  );

  getIt.registerLazySingleton<SharedNoteRepository>(
    () => SharedNoteRepositoryImpl(
      api: getIt<SharedNotesApi>(),
      storage: getIt<SessionStorage>(),
    ),
  );

  getIt.registerLazySingleton<GetSharedNotesUseCase>(
    () => GetSharedNotesUseCase(repository: getIt<SharedNoteRepository>()),
  );

  getIt.registerLazySingleton<CircleViewModel>(
    () => CircleViewModel(
      getMyCircle: getIt<GetMyCircleUseCase>(),
      getCircleMembers: getIt<GetCircleMembersUseCase>(),
      getCareShifts: getIt<GetCareShiftsUseCase>(),
      getSharedNotes: getIt<GetSharedNotesUseCase>(),
      storage: getIt<SessionStorage>(),
    ),
  );

  getIt.registerLazySingleton<AssignCareShiftUseCase>(
    () => AssignCareShiftUseCase(repository: getIt<CareShiftRepository>()),
  );

  getIt.registerLazySingleton<CareShiftsViewModel>(
    () => CareShiftsViewModel(
      getCareShifts: getIt<GetCareShiftsUseCase>(),
      assignCareShift: getIt<AssignCareShiftUseCase>(),
    ),
  );

  getIt.registerLazySingleton<ReassignCareShiftUseCase>(
    () => ReassignCareShiftUseCase(repository: getIt<CareShiftRepository>()),
  );

  getIt.registerLazySingleton<ReassignCareShiftViewModel>(
    () => ReassignCareShiftViewModel(
      reassignCareShift: getIt<ReassignCareShiftUseCase>(),
    ),
  );
}
