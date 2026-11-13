import 'package:serenia_app/features/iam/domain/user.dart';

enum SignUpField { fullName, email, phoneNumber, password }

sealed class SignUpState {
  const new();
}

class SignUpInitial extends SignUpState {
  const new();
}

class SignUpLoading extends SignUpState {
  const new();
}

class SignUpInvalid extends SignUpState {
  final String? fullNameError;
  final String? emailError;
  final String? phoneNumberError;
  final String? passwordError;

  const new({
    this.fullNameError,
    this.emailError,
    this.phoneNumberError,
    this.passwordError,
  });

  SignUpInvalid without(SignUpField field) {
    return SignUpInvalid(
      fullNameError: field == SignUpField.fullName ? null : fullNameError,
      emailError: field == SignUpField.email ? null : emailError,
      phoneNumberError: field == SignUpField.phoneNumber
          ? null
          : phoneNumberError,
      passwordError: field == SignUpField.password ? null : passwordError,
    );
  }
}

class SignUpSuccess extends SignUpState {
  final User user;
  const new({required this.user});
}

class SignUpFailure extends SignUpState {
  final String message;
  const new({required this.message});
}
