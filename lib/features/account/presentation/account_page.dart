import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serenia_app/core/authorized_image.dart';
import 'package:serenia_app/core/serenia_colors.dart';
import 'package:serenia_app/core/serenia_dimens.dart';
import 'package:serenia_app/core/service_locator.dart';
import 'package:serenia_app/core/widgets/inline_confirm_card.dart';
import 'package:serenia_app/core/widgets/load_error.dart';
import 'package:serenia_app/core/widgets/nav_card.dart';
import 'package:serenia_app/core/widgets/section_label.dart';
import 'package:serenia_app/core/widgets/serenia_buttons.dart';
import 'package:serenia_app/core/widgets/serenia_snack_bar.dart';
import 'package:serenia_app/features/account/presentation/account_cards.dart';
import 'package:serenia_app/features/account/presentation/account_view_model.dart';
import 'package:serenia_app/features/account/presentation/change_password_page.dart';
import 'package:serenia_app/features/account/presentation/profile_data_page.dart';
import 'package:serenia_app/features/carecircle/domain/my_circle.dart';
import 'package:serenia_app/features/carecircle/domain/relationship.dart';
import 'package:serenia_app/features/iam/domain/user.dart';
import 'package:serenia_app/features/iam/presentation/welcome_page.dart';
import 'package:serenia_app/features/main/main_page.dart';
import 'package:serenia_app/features/main/serenia_navigation_bar.dart';

class AccountPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AccountViewModel>()..load(),
      child: const _AccountView(),
    );
  }
}

class _AccountView extends StatelessWidget {
  const new();

  Future<void> _openProfileData(
    BuildContext context,
    AccountState state,
  ) async {
    final AccountViewModel viewModel = context.read<AccountViewModel>();
    final bool? saved = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileDataPage(
          user: state.user!,
          token: state.token,
          olderAdultFirstName: state.circle?.olderAdultFirstName,
        ),
      ),
    );
    await viewModel.load();
    if (saved == true) {
      viewModel.showMessage('Listo, guardamos tus datos.');
    }
  }

  Future<void> _openChangePassword(BuildContext context) async {
    final AccountViewModel viewModel = context.read<AccountViewModel>();
    final bool? changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => const ChangePasswordPage()),
    );
    if (changed == true) {
      viewModel.showMessage('Listo, tu contraseña cambió.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final AccountViewModel viewModel = context.read<AccountViewModel>();

    return BlocConsumer<AccountViewModel, AccountState>(
      listener: (context, state) {
        if (state.signedOut) {
          Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const WelcomePage()),
            (route) => false,
          );
          return;
        }
        if (state.message != null) {
          showSereniaSnackBar(context, state.message!);
          viewModel.clearMessage();
        }
      },
      builder: (context, state) {
        final User? user = state.user;
        final MyCircle? circle = state.circle;
        return Scaffold(
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                SereniaSpacing.screen,
                SereniaSpacing.screen,
                SereniaSpacing.screen,
                12,
              ),
              children: [
                Semantics(
                  header: true,
                  child: Text(
                    'Mi cuenta',
                    style: textTheme.headlineLarge?.copyWith(
                      color: SereniaColors.title,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                if (user == null)
                  state.loadError != null
                      ? LoadError(
                          message: state.loadError!,
                          onRetry: viewModel.load,
                        )
                      : const Padding(
                          padding: EdgeInsets.all(SereniaSpacing.xl),
                          child: Center(child: CircularProgressIndicator()),
                        )
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 10,
                    children: [
                      ProfileCard(
                        fullName: user.fullName,
                        photo: AuthorizedImage.provider(
                          user.photoUrl,
                          state.token,
                        ),
                        onTap: () => _openProfileData(context, state),
                      ),
                      if (circle != null) ...[
                        const Padding(
                          padding: EdgeInsets.only(top: 6),
                          child: SectionLabel('Tu vínculo'),
                        ),
                        LinkCard(
                          olderAdultName: circle.olderAdult.fullName,
                          photo: AuthorizedImage.provider(
                            circle.olderAdult.photoUrl,
                            state.token,
                          ),
                          relationship: Relationship.display(
                            circle.link.relationshipLabel,
                          ).toLowerCase(),
                          onTap: () =>
                              MainPage.showTab(context, SereniaTab.circle),
                        ),
                      ],
                      const Padding(
                        padding: EdgeInsets.only(top: 6),
                        child: SectionLabel('Seguridad'),
                      ),
                      NavCard(
                        icon: Icons.lock_outline_rounded,
                        tint: SereniaColors.neutro200,
                        iconColor: SereniaColors.neutro800,
                        title: 'Cambiar mi contraseña',
                        onTap: () => _openChangePassword(context),
                      ),
                      const SizedBox(height: 2),
                      if (state.confirmingSignOut)
                        InlineConfirmCard(
                          title: '¿Quieres cerrar sesión?',
                          body:
                              'Mientras no entres de nuevo, no te llegarán las '
                              'alertas de ${circle?.olderAdultFirstName ?? 'tu familiar'} '
                              'en este celular.',
                          confirmLabel: 'Sí, salir',
                          cancelLabel: 'Cancelar',
                          loading: state.signingOut,
                          onConfirm: viewModel.signOut,
                          onCancel: viewModel.cancelSignOut,
                        )
                      else
                        QuietButton(
                          label: 'Cerrar sesión',
                          onPressed: viewModel.askSignOut,
                        ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
