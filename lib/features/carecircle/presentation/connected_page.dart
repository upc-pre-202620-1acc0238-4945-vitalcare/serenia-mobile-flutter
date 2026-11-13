import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serenia_app/core/serenia_colors.dart';
import 'package:serenia_app/core/serenia_dimens.dart';
import 'package:serenia_app/core/service_locator.dart';
import 'package:serenia_app/core/widgets/serenia_avatar.dart';
import 'package:serenia_app/core/widgets/serenia_buttons.dart';
import 'package:serenia_app/features/carecircle/presentation/connected_view_model.dart';
import 'package:serenia_app/features/main/main_page.dart';

class ConnectedPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ConnectedViewModel>()..load(),
      child: const _ConnectedView(),
    );
  }
}

class _ConnectedView extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return BlocBuilder<ConnectedViewModel, ConnectedState>(
      builder: (context, state) {
        final String? olderAdult = state.olderAdultFirstName;
        return Scaffold(
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
                    child: state.loading
                        ? const Center(child: CircularProgressIndicator())
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            spacing: SereniaSpacing.md,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  spacing: 20,
                                  children: [
                                    if (state.myName != null &&
                                        state.olderAdultName != null)
                                      _ConnectedAvatars(
                                        myName: state.myName!,
                                        olderAdultName: state.olderAdultName!,
                                      ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 12),
                                      child: Semantics(
                                        header: true,
                                        child: Text(
                                          olderAdult == null
                                              ? 'Ya estás en el círculo'
                                              : 'Ya estás en el círculo de $olderAdult',
                                          textAlign: TextAlign.center,
                                          style: textTheme.displaySmall
                                              ?.copyWith(
                                                color: SereniaColors.title,
                                              ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      'Desde hoy verás cómo amanece '
                                      '${olderAdult ?? 'tu familiar'}. '
                                      'Te avisaremos solo si algo se sale de lo habitual.',
                                      textAlign: TextAlign.center,
                                      style: textTheme.bodyLarge?.copyWith(
                                        color: SereniaColors.neutro700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              PrimaryButton(
                                label: olderAdult == null
                                    ? 'Ir al panel'
                                    : 'Ir al panel de $olderAdult',
                                size: ButtonSize.large,
                                onPressed: () => Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const MainPage(),
                                  ),
                                  (route) => false,
                                ),
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

class _ConnectedAvatars extends StatelessWidget {
  final String _myName;
  final String _olderAdultName;

  const new({required this._myName, required this._olderAdultName});

  Widget _ringed(Widget child, Color ring) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: ring, shape: BoxShape.circle),
      child: child,
    );
  }

  Widget _dots() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 3,
      children: [
        for (int dot = 0; dot < 4; dot++)
          Container(
            width: 3,
            height: 3,
            decoration: const BoxDecoration(
              color: SereniaColors.durazno500,
              shape: BoxShape.circle,
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: FittedBox(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 2,
          children: [
            _ringed(
              SereniaAvatar(name: _myName, tone: AvatarTone.me, size: 96),
              SereniaColors.verde100,
            ),
            _dots(),
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: SereniaColors.durazno300,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite_rounded,
                color: SereniaColors.error,
                size: 24,
              ),
            ),
            _dots(),
            _ringed(
              SereniaAvatar(name: _olderAdultName, size: 96),
              SereniaColors.durazno100,
            ),
          ],
        ),
      ),
    );
  }
}
