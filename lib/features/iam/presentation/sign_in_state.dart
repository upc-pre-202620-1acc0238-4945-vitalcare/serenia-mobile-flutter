import 'package:serenia_app/features/iam/domain/user.dart';

enum SignInField { email, password }

sealed class SignInState {
  const new();
}

class SignInInitial extends SignInState {
  const new();
}

class SignInLoading extends SignInState {
  const new();
}

class SignInInvalid extends SignInState {
  final String? emailError;
  final String? passwordError;

  const new({this.emailError, this.passwordError});

  SignInInvalid without(SignInField field) {
    return SignInInvalid(
      emailError: field == SignInField.email ? null : emailError,
      passwordError: field == SignInField.password ? null : passwordError,
    );
  }
}

class SignInSuccess extends SignInState {
  final User user;
  const new({required this.user});
}

class SignInFailure extends SignInState {
  final String message;
  final bool credentialsRejected;

  const new({required this.message, this.credentialsRejected = false});
}
