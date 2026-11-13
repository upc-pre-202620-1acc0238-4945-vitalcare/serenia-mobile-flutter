import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serenia_app/core/serenia_colors.dart';
import 'package:serenia_app/core/serenia_typography.dart';
import 'package:serenia_app/core/service_locator.dart';
import 'package:serenia_app/core/widgets/alert_banner.dart';
import 'package:serenia_app/core/widgets/back_link.dart';
import 'package:serenia_app/core/widgets/serenia_buttons.dart';
import 'package:serenia_app/core/widgets/serenia_text_field.dart';
import 'package:serenia_app/features/home/presentation/home_page.dart';
import 'package:serenia_app/features/iam/presentation/account_prompt.dart';
import 'package:serenia_app/features/iam/presentation/role_selection_page.dart';
import 'package:serenia_app/features/iam/presentation/sign_in_state.dart';
import 'package:serenia_app/features/iam/presentation/sign_in_view_model.dart';

class SignInPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SignInViewModel>(),
      child: const _SignInForm(),
    );
  }
}

class _SignInForm extends StatefulWidget {
  const new();

  @override
  State<_SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<_SignInForm> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    context.read<SignInViewModel>().signIn(_email.text, _password.text);
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = SereniaTypography.mayor;
    final SignInViewModel viewModel = context.read<SignInViewModel>();

    return BlocConsumer<SignInViewModel, SignInState>(
      listener: (context, state) {
        if (state is SignInSuccess) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
            (route) => false,
          );
        }
        if (state is SignInFailure && state.credentialsRejected) {
          _password.clear();
        }
      },
      builder: (context, state) {
        final SignInInvalid? invalid = state is SignInInvalid ? state : null;
        final bool rejected =
            state is SignInFailure && state.credentialsRejected;
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
              child: AutofillGroup(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 20,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 4,
                      children: [
                        const BackLink(mayor: true),
                        Semantics(
                          header: true,
                          child: Text(
                            'Iniciar sesión',
                            style: textTheme.displaySmall?.copyWith(
                              color: SereniaColors.title,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (state is SignInFailure)
                      AlertBanner(state.message, mayor: true),
                    SereniaTextField(
                      label: 'Correo',
                      controller: _email,
                      hint: 'Ej. rosa@correo.com',
                      error: invalid?.emailError,
                      invalid: rejected,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.email],
                      mayor: true,
                      onChanged: (_) => viewModel.clearError(SignInField.email),
                    ),
                    SereniaTextField(
                      label: 'Contraseña',
                      controller: _password,
                      hint: 'Tu contraseña',
                      error: invalid?.passwordError,
                      invalid: rejected,
                      isPassword: true,
                      textInputAction: TextInputAction.done,
                      autofillHints: const [AutofillHints.password],
                      mayor: true,
                      onChanged: (_) =>
                          viewModel.clearError(SignInField.password),
                      onSubmitted: (_) => _submit(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        spacing: 8,
                        children: [
                          PrimaryButton(
                            label: 'Entrar',
                            onPressed: _submit,
                            size: ButtonSize.mayor,
                            loading: state is SignInLoading,
                          ),
                          AccountPrompt(
                            question: '¿Aún no tienes cuenta?',
                            action: 'Crear mi cuenta',
                            mayor: true,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RoleSelectionPage(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
