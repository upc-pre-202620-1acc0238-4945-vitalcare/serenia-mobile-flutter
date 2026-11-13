import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serenia_app/core/api_exception.dart';
import 'package:serenia_app/core/error_messages.dart';
import 'package:serenia_app/features/iam/application/sign_in_use_case.dart';
import 'package:serenia_app/features/iam/domain/older_adult_account_exception.dart';
import 'package:serenia_app/features/iam/domain/user.dart';
import 'package:serenia_app/features/iam/presentation/sign_in_state.dart';

class SignInViewModel extends Cubit<SignInState> {
  final SignInUseCase _signIn;
  new({required this._signIn}) : super(const SignInInitial());

  static const String wrongCredentials =
      'El correo o la contraseña no son correctos. Revisa e intenta de nuevo.';
  static const String olderAdultAccount =
      'Esta cuenta es de adulto mayor y esta app es para familiares. '
      'Entra con tu cuenta de familiar.';

  void clearError(SignInField field) {
    final SignInState current = state;
    if (current is SignInInvalid) {
      emit(current.without(field));
    } else if (current is SignInFailure && current.credentialsRejected) {
      emit(SignInFailure(message: current.message));
    }
  }

  Future<void> signIn(String email, String password) async {
    if (state is SignInLoading) return;

    final String? emailError = email.trim().isEmpty
        ? 'Escribe tu correo.'
        : null;
    final String? passwordError = password.isEmpty
        ? 'Escribe tu contraseña.'
        : null;

    if (emailError != null || passwordError != null) {
      emit(SignInInvalid(emailError: emailError, passwordError: passwordError));
      return;
    }

    emit(const SignInLoading());

    try {
      final User user = await _signIn.execute(email, password);
      emit(SignInSuccess(user: user));
    } on OlderAdultAccountException {
      emit(const SignInFailure(message: olderAdultAccount));
    } on ApiException catch (e) {
      if (e.statusCode == HttpStatus.unauthorized) {
        emit(
          const SignInFailure(
            message: wrongCredentials,
            credentialsRejected: true,
          ),
        );
      } else {
        emit(SignInFailure(message: ErrorMessages.from(e)));
      }
    } catch (e) {
      emit(SignInFailure(message: ErrorMessages.from(e)));
    }
  }
}
