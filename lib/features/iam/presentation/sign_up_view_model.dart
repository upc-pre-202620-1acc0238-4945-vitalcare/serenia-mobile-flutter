import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serenia_app/core/api_exception.dart';
import 'package:serenia_app/core/error_messages.dart';
import 'package:serenia_app/features/iam/application/sign_up_use_case.dart';
import 'package:serenia_app/features/iam/domain/credentials_validator.dart';
import 'package:serenia_app/features/iam/domain/phone_number.dart';
import 'package:serenia_app/features/iam/domain/user.dart';
import 'package:serenia_app/features/iam/presentation/sign_up_state.dart';

class SignUpViewModel extends Cubit<SignUpState> {
  final SignUpUseCase _signUp;
  new({required this._signUp}) : super(const SignUpInitial());

  static const String emailTaken =
      'Este correo ya tiene una cuenta. Inicia sesión o usa otro correo.';

  void clearError(SignUpField field) {
    final SignUpState current = state;
    if (current is SignUpInvalid) {
      emit(current.without(field));
    }
  }

  Future<void> signUp({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    if (state is SignUpLoading) return;

    final String? fullNameError = _fullNameError(fullName);
    final String? emailError = _emailError(email);
    final String? phoneNumberError = _phoneNumberError(phoneNumber);
    final String? passwordError = _passwordError(password);

    if (fullNameError != null ||
        emailError != null ||
        phoneNumberError != null ||
        passwordError != null) {
      emit(
        SignUpInvalid(
          fullNameError: fullNameError,
          emailError: emailError,
          phoneNumberError: phoneNumberError,
          passwordError: passwordError,
        ),
      );
      return;
    }

    emit(const SignUpLoading());

    try {
      final User user = await _signUp.execute(
        fullName: fullName,
        email: email,
        password: password,
        phoneNumber: phoneNumber.isEmpty
            ? null
            : PhoneNumber.fromLocal(phoneNumber),
      );
      emit(SignUpSuccess(user: user));
    } on ApiException catch (e) {
      if (e.statusCode == HttpStatus.conflict) {
        emit(const SignUpInvalid(emailError: emailTaken));
      } else {
        emit(SignUpFailure(message: ErrorMessages.from(e)));
      }
    } catch (e) {
      emit(SignUpFailure(message: ErrorMessages.from(e)));
    }
  }

  String? _fullNameError(String fullName) {
    if (fullName.trim().isEmpty) return 'Escribe tu nombre.';
    if (!CredentialsValidator.isValidName(fullName)) {
      return 'Tu nombre es muy largo. Usa uno más corto.';
    }
    return null;
  }

  String? _emailError(String email) {
    if (email.trim().isEmpty) return 'Escribe tu correo.';
    if (!CredentialsValidator.isValidEmail(email)) {
      return 'Revisa el correo: parece incompleto.';
    }
    return null;
  }

  String? _phoneNumberError(String phoneNumber) {
    if (phoneNumber.isEmpty || PhoneNumber.isValidLocal(phoneNumber)) {
      return null;
    }
    return 'Revisa el celular: debe tener 9 números y empezar con 9.';
  }

  String? _passwordError(String password) {
    if (password.length < CredentialsValidator.minPasswordLength) {
      return 'Debe tener al menos 8 letras o números.';
    }
    if (!CredentialsValidator.isValidPassword(password)) {
      return 'Debe tener como máximo 72 letras o números.';
    }
    return null;
  }
}
