import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serenia_app/core/error_messages.dart';
import 'package:serenia_app/features/iam/application/change_password_use_case.dart';
import 'package:serenia_app/features/iam/domain/credentials_validator.dart';
import 'package:serenia_app/features/iam/domain/incorrect_password_exception.dart';

class ChangePasswordState {
  final String? currentPasswordError;
  final String? newPasswordError;
  final String? formError;
  final bool saving;
  final bool incorrectCurrentPassword;
  final bool changed;

  const new({
    this.currentPasswordError,
    this.newPasswordError,
    this.formError,
    this.saving = false,
    this.incorrectCurrentPassword = false,
    this.changed = false,
  });
}

class ChangePasswordViewModel extends Cubit<ChangePasswordState> {
  final ChangePasswordUseCase _changePassword;
  new({required this._changePassword}) : super(const ChangePasswordState());

  static const String incorrectPassword =
      'Esa no es tu contraseña actual. Intenta de nuevo.';

  void clearCurrentPasswordError() {
    emit(ChangePasswordState(newPasswordError: state.newPasswordError));
  }

  void clearNewPasswordError() {
    emit(ChangePasswordState(currentPasswordError: state.currentPasswordError));
  }

  Future<void> change(String currentPassword, String newPassword) async {
    if (state.saving) return;

    final String? currentPasswordError = currentPassword.isEmpty
        ? 'Escribe tu contraseña actual.'
        : null;
    String? newPasswordError;
    if (newPassword.length < CredentialsValidator.minPasswordLength) {
      newPasswordError = 'Debe tener al menos 8 letras o números.';
    } else if (!CredentialsValidator.isValidPassword(newPassword)) {
      newPasswordError = 'Debe tener como máximo 72 letras o números.';
    }

    if (currentPasswordError != null || newPasswordError != null) {
      emit(
        ChangePasswordState(
          currentPasswordError: currentPasswordError,
          newPasswordError: newPasswordError,
        ),
      );
      return;
    }

    emit(const ChangePasswordState(saving: true));
    try {
      await _changePassword.execute(currentPassword, newPassword);
      emit(const ChangePasswordState(changed: true));
    } on IncorrectPasswordException {
      emit(
        const ChangePasswordState(
          currentPasswordError: incorrectPassword,
          incorrectCurrentPassword: true,
        ),
      );
    } catch (e) {
      emit(ChangePasswordState(formError: ErrorMessages.from(e)));
    }
  }
}
