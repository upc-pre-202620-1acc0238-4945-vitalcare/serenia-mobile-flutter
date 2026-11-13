import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serenia_app/core/serenia_colors.dart';
import 'package:serenia_app/core/serenia_dimens.dart';
import 'package:serenia_app/core/service_locator.dart';
import 'package:serenia_app/core/widgets/alert_banner.dart';
import 'package:serenia_app/core/widgets/back_link.dart';
import 'package:serenia_app/core/widgets/serenia_buttons.dart';
import 'package:serenia_app/core/widgets/serenia_text_field.dart';
import 'package:serenia_app/core/widgets/step_indicator.dart';
import 'package:serenia_app/features/carecircle/presentation/relationship_page.dart';
import 'package:serenia_app/features/iam/domain/phone_number.dart';
import 'package:serenia_app/features/iam/presentation/account_prompt.dart';
import 'package:serenia_app/features/iam/presentation/sign_in_page.dart';
import 'package:serenia_app/features/iam/presentation/sign_up_state.dart';
import 'package:serenia_app/features/iam/presentation/sign_up_view_model.dart';

class SignUpPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SignUpViewModel>(),
      child: const _SignUpForm(),
    );
  }
}

class _SignUpForm extends StatefulWidget {
  const new();

  @override
  State<_SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<_SignUpForm> {
  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  void dispose() {
    _fullName.dispose();
    _email.dispose();
    _phoneNumber.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    context.read<SignUpViewModel>().signUp(
      fullName: _fullName.text,
      email: _email.text,
      phoneNumber: _phoneNumber.text,
      password: _password.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final SignUpViewModel viewModel = context.read<SignUpViewModel>();

    return BlocConsumer<SignUpViewModel, SignUpState>(
      listener: (context, state) {
        if (state is SignUpSuccess) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const RelationshipPage()),
            (route) => false,
          );
        }
      },
      builder: (context, state) {
        final SignUpInvalid? invalid = state is SignUpInvalid ? state : null;
        return Scaffold(
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      SereniaSpacing.screen,
                      12,
                      SereniaSpacing.screen,
                      28,
                    ),
                    child: AutofillGroup(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        spacing: 18,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: SereniaSpacing.sm,
                            children: [
                              const BackLink(),
                              const StepIndicator(current: 1),
                              Semantics(
                                header: true,
                                child: Text(
                                  'Crea tu cuenta',
                                  style: textTheme.displaySmall?.copyWith(
                                    color: SereniaColors.title,
                                  ),
                                ),
                              ),
                              Text(
                                'Para saber cómo está tu familiar sin tener que llamarle a cada rato.',
                                style: textTheme.bodyLarge?.copyWith(
                                  color: SereniaColors.neutro700,
                                ),
                              ),
                            ],
                          ),
                          if (state is SignUpFailure)
                            AlertBanner(state.message),
                          SereniaTextField(
                            label: 'Tu nombre',
                            controller: _fullName,
                            hint: 'Ej. Lucía Mendoza',
                            error: invalid?.fullNameError,
                            textCapitalization: TextCapitalization.words,
                            textInputAction: TextInputAction.next,
                            autofillHints: const [AutofillHints.name],
                            onChanged: (_) =>
                                viewModel.clearError(SignUpField.fullName),
                          ),
                          SereniaTextField(
                            label: 'Correo',
                            controller: _email,
                            hint: 'Ej. lucia@correo.com',
                            error: invalid?.emailError,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            autofillHints: const [AutofillHints.email],
                            onChanged: (_) =>
                                viewModel.clearError(SignUpField.email),
                          ),
                          SereniaTextField(
                            label: 'Celular (opcional)',
                            controller: _phoneNumber,
                            hint: '987 654 321',
                            error: invalid?.phoneNumberError,
                            prefixText: '${PhoneNumber.countryCode} ',
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.next,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(
                                PhoneNumber.localLength,
                              ),
                            ],
                            autofillHints: const [
                              AutofillHints.telephoneNumberNational,
                            ],
                            onChanged: (_) =>
                                viewModel.clearError(SignUpField.phoneNumber),
                          ),
                          SereniaTextField(
                            label: 'Contraseña',
                            controller: _password,
                            hint: 'Mínimo 8 letras o números',
                            helper: 'Mínimo 8 letras o números.',
                            error: invalid?.passwordError,
                            isPassword: true,
                            textInputAction: TextInputAction.done,
                            autofillHints: const [AutofillHints.newPassword],
                            onChanged: (_) =>
                                viewModel.clearError(SignUpField.password),
                            onSubmitted: (_) => _submit(),
                          ),
                          const Spacer(),
                          PrimaryButton(
                            label: 'Crear mi cuenta',
                            onPressed: _submit,
                            size: ButtonSize.large,
                            loading: state is SignUpLoading,
                          ),
                          AccountPrompt(
                            question: '¿Ya tienes cuenta?',
                            action: 'Iniciar sesión',
                            onTap: () => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignInPage(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
