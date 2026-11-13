import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serenia_app/core/serenia_colors.dart';
import 'package:serenia_app/core/serenia_dimens.dart';
import 'package:serenia_app/core/service_locator.dart';
import 'package:serenia_app/core/widgets/alert_banner.dart';
import 'package:serenia_app/core/widgets/back_link.dart';
import 'package:serenia_app/core/widgets/serenia_buttons.dart';
import 'package:serenia_app/core/widgets/step_indicator.dart';
import 'package:serenia_app/features/carecircle/domain/relationship.dart';
import 'package:serenia_app/features/carecircle/presentation/connected_page.dart';
import 'package:serenia_app/features/carecircle/presentation/invitation_code_view_model.dart';
import 'package:serenia_app/features/carecircle/presentation/invite_code_field.dart';

class InvitationCodePage extends StatelessWidget {
  final Relationship _relationship;

  const new({super.key, required this._relationship});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<InvitationCodeViewModel>(),
      child: _InvitationCodeForm(relationship: _relationship),
    );
  }
}

class _InvitationCodeForm extends StatefulWidget {
  final Relationship _relationship;

  const new({required this._relationship});

  @override
  State<_InvitationCodeForm> createState() => _InvitationCodeFormState();
}

class _InvitationCodeFormState extends State<_InvitationCodeForm> {
  final TextEditingController _code = TextEditingController();

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    context.read<InvitationCodeViewModel>().link(
      _code.text,
      widget._relationship,
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final InvitationCodeViewModel viewModel = context
        .read<InvitationCodeViewModel>();

    return BlocConsumer<InvitationCodeViewModel, InvitationCodeState>(
      listener: (context, state) {
        if (state is InvitationCodeSuccess) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const ConnectedPage()),
            (route) => false,
          );
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
                      12,
                      SereniaSpacing.screen,
                      28,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      spacing: 18,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: SereniaSpacing.sm,
                          children: [
                            const BackLink(),
                            const StepIndicator(current: 3),
                            Semantics(
                              header: true,
                              child: Text(
                                'Escribe el código de tu familiar',
                                style: textTheme.displaySmall?.copyWith(
                                  color: SereniaColors.title,
                                ),
                              ),
                            ),
                            Text(
                              'Son 8 letras y números. Con él, tu app y la suya quedan conectadas.',
                              style: textTheme.bodyLarge?.copyWith(
                                color: SereniaColors.neutro700,
                              ),
                            ),
                          ],
                        ),
                        if (state is InvitationCodeFailure)
                          AlertBanner(state.message),
                        InviteCodeField(
                          controller: _code,
                          error: state is InvitationCodeInvalid
                              ? state.message
                              : null,
                          onChanged: (_) => viewModel.clearError(),
                          onSubmitted: (_) => _submit(),
                        ),
                        const _CodeHelp(),
                        const Spacer(),
                        PrimaryButton(
                          label: 'Vincularme',
                          size: ButtonSize.large,
                          loading: state is InvitationCodeLoading,
                          onPressed: _submit,
                        ),
                      ],
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

class _CodeHelp extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(SereniaSpacing.md),
      decoration: BoxDecoration(
        color: SereniaColors.durazno100,
        borderRadius: BorderRadius.circular(SereniaRadius.md),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: SereniaColors.durazno200,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.help_outline_rounded,
              color: SereniaColors.durazno900,
              size: 22,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 2,
              children: [
                Semantics(
                  header: true,
                  child: const Text(
                    '¿Dónde está el código?',
                    style: TextStyle(
                      color: SereniaColors.text,
                      fontSize: 16,
                      height: 22 / 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const Text.rich(
                  TextSpan(
                    text: 'Tu familiar lo encuentra en su app, en ',
                    children: [
                      TextSpan(
                        text: 'Familia › Mi círculo',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                      TextSpan(text: '.'),
                    ],
                  ),
                  style: TextStyle(
                    color: SereniaColors.neutro700,
                    fontSize: 15,
                    height: 22 / 15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
