import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serenia_app/core/error_messages.dart';
import 'package:serenia_app/core/session_storage.dart';
import 'package:serenia_app/features/carecircle/application/get_my_circle_use_case.dart';
import 'package:serenia_app/features/carecircle/domain/my_circle.dart';
import 'package:serenia_app/features/iam/application/get_current_user_use_case.dart';
import 'package:serenia_app/features/iam/application/sign_out_use_case.dart';
import 'package:serenia_app/features/iam/domain/user.dart';

class AccountState {
  final bool loading;
  final String? loadError;
  final User? user;
  final MyCircle? circle;
  final String? token;
  final bool confirmingSignOut;
  final bool signingOut;
  final bool signedOut;
  final String? message;

  const new({
    this.loading = true,
    this.loadError,
    this.user,
    this.circle,
    this.token,
    this.confirmingSignOut = false,
    this.signingOut = false,
    this.signedOut = false,
    this.message,
  });

  AccountState copyWith({
    bool? loading,
    String? Function()? loadError,
    User? user,
    MyCircle? Function()? circle,
    String? token,
    bool? confirmingSignOut,
    bool? signingOut,
    bool? signedOut,
    String? Function()? message,
  }) {
    return AccountState(
      loading: loading ?? this.loading,
      loadError: loadError == null ? this.loadError : loadError(),
      user: user ?? this.user,
      circle: circle == null ? this.circle : circle(),
      token: token ?? this.token,
      confirmingSignOut: confirmingSignOut ?? this.confirmingSignOut,
      signingOut: signingOut ?? this.signingOut,
      signedOut: signedOut ?? this.signedOut,
      message: message == null ? this.message : message(),
    );
  }
}

class AccountViewModel extends Cubit<AccountState> {
  final GetCurrentUserUseCase _getCurrentUser;
  final GetMyCircleUseCase _getMyCircle;
  final SignOutUseCase _signOut;
  final SessionStorage _storage;

  new({
    required this._getCurrentUser,
    required this._getMyCircle,
    required this._signOut,
    required this._storage,
  }) : super(const AccountState());

  Future<void> load() async {
    if (state.user == null) {
      emit(state.copyWith(loading: true, loadError: () => null));
    }
    try {
      final User user = await _getCurrentUser.execute();
      final MyCircle? circle = await _getMyCircle.execute();
      final String? token = await _storage.getToken();
      emit(
        state.copyWith(
          loading: false,
          loadError: () => null,
          user: user,
          circle: () => circle,
          token: token,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(loading: false, loadError: () => ErrorMessages.from(e)),
      );
    }
  }

  void showMessage(String message) {
    emit(state.copyWith(message: () => message));
  }

  void clearMessage() {
    emit(state.copyWith(message: () => null));
  }

  void askSignOut() {
    emit(state.copyWith(confirmingSignOut: true));
  }

  void cancelSignOut() {
    emit(state.copyWith(confirmingSignOut: false));
  }

  Future<void> signOut() async {
    if (state.signingOut) return;
    emit(state.copyWith(signingOut: true));
    try {
      await _signOut.execute();
      emit(state.copyWith(signingOut: false, signedOut: true));
    } catch (e) {
      emit(
        state.copyWith(signingOut: false, message: () => ErrorMessages.from(e)),
      );
    }
  }
}
