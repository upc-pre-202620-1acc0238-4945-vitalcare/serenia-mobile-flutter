import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serenia_app/core/serenia_colors.dart';
import 'package:serenia_app/core/serenia_dimens.dart';
import 'package:serenia_app/core/service_locator.dart';
import 'package:serenia_app/core/widgets/alert_banner.dart';
import 'package:serenia_app/core/widgets/back_link.dart';
import 'package:serenia_app/core/widgets/serenia_buttons.dart';
import 'package:serenia_app/core/widgets/serenia_text_field.dart';
import 'package:serenia_app/features/account/presentation/change_password_view_model.dart';

class ChangePasswordPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ChangePasswordViewModel>(),
      child: const _ChangePasswordForm(),
    );
  }
}

class _ChangePasswordForm extends StatefulWidget {
  const new();

  @override
  State<_ChangePasswordForm> createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<_ChangePasswordForm> {
  final TextEditingController _currentPassword = TextEditingController();
  final TextEditingController _newPassword = TextEditingController();

  @override
  void dispose() {
    _currentPassword.dispose();
    _newPassword.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    context.read<ChangePasswordViewModel>().change(
      _currentPassword.text,
      _newPassword.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ChangePasswordViewModel viewModel = context
        .read<ChangePasswordViewModel>();

    return BlocConsumer<ChangePasswordViewModel, ChangePasswordState>(
      listener: (context, state) {
        if (state.changed) {
          Navigator.pop(context, true);
        }
        if (state.incorrectCurrentPassword) {
          _currentPassword.clear();
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      SereniaSpacing.screen,
                      SereniaSpacing.sm,
                      SereniaSpacing.screen,
                      14,
                    ),
                    child: AutofillGroup(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        spacing: SereniaSpacing.md,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 2,
                            children: [
                              const BackLink(parent: 'Mi cuenta'),
                              Semantics(
                                header: true,
                                child: Text(
                                  'Cambiar mi contraseña',
                                  style: textTheme.headlineLarge?.copyWith(
                                    color: SereniaColors.title,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (state.formError != null)
                            AlertBanner(state.formError!),
                          SereniaTextField(
                            label: 'Contraseña actual',
                            controller: _currentPassword,
                            error: state.currentPasswordError,
                            isPassword: true,
                            textInputAction: TextInputAction.next,
                            autofillHints: const [AutofillHints.password],
                            onChanged: (_) =>
                                viewModel.clearCurrentPasswordError(),
                          ),
                          SereniaTextField(
                            label: 'Contraseña nueva',
                            controller: _newPassword,
                            helper: 'Mínimo 8 letras o números.',
                            error: state.newPasswordError,
                            isPassword: true,
                            textInputAction: TextInputAction.done,
                            autofillHints: const [AutofillHints.newPassword],
                            onChanged: (_) => viewModel.clearNewPasswordError(),
                            onSubmitted: (_) => _submit(),
                          ),
                          const Text(
                            'Por seguridad, cerraremos tu sesión en otros celulares.',
                            style: TextStyle(
                              color: SereniaColors.neutro700,
                              fontSize: 15,
                              height: 22 / 15,
                            ),
                          ),
                          const Spacer(),
                          PrimaryButton(
                            label: 'Guardar contraseña',
                            loading: state.saving,
                            onPressed: _submit,
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
