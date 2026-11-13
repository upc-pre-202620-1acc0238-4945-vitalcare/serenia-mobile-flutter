import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:serenia_app/core/authorized_image.dart';
import 'package:serenia_app/core/serenia_colors.dart';
import 'package:serenia_app/core/serenia_dimens.dart';
import 'package:serenia_app/core/service_locator.dart';
import 'package:serenia_app/core/widgets/alert_banner.dart';
import 'package:serenia_app/core/widgets/back_link.dart';
import 'package:serenia_app/core/widgets/serenia_avatar.dart';
import 'package:serenia_app/core/widgets/serenia_buttons.dart';
import 'package:serenia_app/core/widgets/serenia_snack_bar.dart';
import 'package:serenia_app/core/widgets/serenia_text_field.dart';
import 'package:serenia_app/features/account/presentation/profile_data_view_model.dart';
import 'package:serenia_app/features/iam/domain/phone_number.dart';
import 'package:serenia_app/features/iam/domain/user.dart';

class ProfileDataPage extends StatelessWidget {
  final User _user;
  final String? _token;
  final String? _olderAdultFirstName;

  const new({
    super.key,
    required this._user,
    this._token,
    this._olderAdultFirstName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ProfileDataViewModel>(param1: _user),
      child: _ProfileDataForm(
        user: _user,
        token: _token,
        olderAdultFirstName: _olderAdultFirstName,
      ),
    );
  }
}

class _ProfileDataForm extends StatefulWidget {
  final User _user;
  final String? _token;
  final String? _olderAdultFirstName;

  const new({required this._user, this._token, this._olderAdultFirstName});

  @override
  State<_ProfileDataForm> createState() => _ProfileDataFormState();
}

class _ProfileDataFormState extends State<_ProfileDataForm> {
  late final TextEditingController _fullName = TextEditingController(
    text: widget._user.fullName,
  );
  late final TextEditingController _phoneNumber = TextEditingController(
    text: widget._user.phoneNumber == null
        ? ''
        : PhoneNumber.toLocal(widget._user.phoneNumber!),
  );

  @override
  void dispose() {
    _fullName.dispose();
    _phoneNumber.dispose();
    super.dispose();
  }

  Future<void> _changePhoto() async {
    final ProfileDataViewModel viewModel = context.read<ProfileDataViewModel>();
    final ImageSource? source = kIsWeb
        ? ImageSource.gallery
        : await showModalBottomSheet<ImageSource>(
            context: context,
            backgroundColor: SereniaColors.surface,
            showDragHandle: true,
            builder: (context) => const _PhotoSourceSheet(),
          );
    if (source == null) return;
    try {
      final XFile? file = await ImagePicker().pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (file == null) return;
      viewModel.changePhoto(await file.readAsBytes());
    } catch (_) {
      viewModel.photoNotAvailable();
    }
  }

  void _save() {
    FocusScope.of(context).unfocus();
    context.read<ProfileDataViewModel>().save(
      _fullName.text,
      _phoneNumber.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ProfileDataViewModel viewModel = context.read<ProfileDataViewModel>();
    final String olderAdult = widget._olderAdultFirstName ?? 'Tu familiar';

    return BlocConsumer<ProfileDataViewModel, ProfileDataState>(
      listener: (context, state) {
        if (state.saved) {
          Navigator.pop(context, true);
          return;
        }
        if (state.message != null) {
          showSereniaSnackBar(context, state.message!);
          viewModel.clearMessage();
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
                                'Mis datos',
                                style: textTheme.headlineLarge?.copyWith(
                                  color: SereniaColors.title,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          spacing: 14,
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                SereniaAvatar(
                                  name: state.user.fullName,
                                  photo: AuthorizedImage.provider(
                                    state.user.photoUrl,
                                    widget._token,
                                  ),
                                  tone: AvatarTone.me,
                                  size: 72,
                                ),
                                if (state.uploadingPhoto)
                                  const SizedBox(
                                    width: 72,
                                    height: 72,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 3,
                                    ),
                                  ),
                              ],
                            ),
                            OutlinedButton.icon(
                              onPressed: state.uploadingPhoto
                                  ? null
                                  : _changePhoto,
                              icon: const Icon(
                                Icons.photo_camera_outlined,
                                size: 20,
                              ),
                              label: const Text('Cambiar foto'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: SereniaColors.primary,
                                backgroundColor: SereniaColors.surface,
                                minimumSize: const Size(0, SereniaTouch.min),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: SereniaSpacing.md,
                                ),
                                side: const BorderSide(
                                  color: SereniaColors.primary,
                                  width: 2,
                                ),
                                shape: const StadiumBorder(),
                                textStyle: const TextStyle(
                                  fontFamily: 'Nunito',
                                  fontSize: 15,
                                  height: 20 / 15,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (state.photoError != null)
                          AlertBanner(state.photoError!),
                        if (state.formError != null)
                          AlertBanner(state.formError!),
                        SereniaTextField(
                          label: 'Tu nombre',
                          controller: _fullName,
                          error: state.fullNameError,
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.next,
                          autofillHints: const [AutofillHints.name],
                          onChanged: (_) => viewModel.clearFullNameError(),
                        ),
                        SereniaTextField(
                          label: 'Celular (opcional)',
                          controller: _phoneNumber,
                          hint: '987 654 321',
                          error: state.phoneNumberError,
                          prefixText: '${PhoneNumber.countryCode} ',
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.done,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(
                              PhoneNumber.localLength,
                            ),
                          ],
                          onChanged: (_) => viewModel.clearPhoneNumberError(),
                          onSubmitted: (_) => _save(),
                        ),
                        Text(
                          '$olderAdult verá tu nombre y foto en su app, en Familia.',
                          style: const TextStyle(
                            color: SereniaColors.neutro700,
                            fontSize: 14,
                            height: 20 / 14,
                          ),
                        ),
                        const Spacer(),
                        PrimaryButton(
                          label: 'Guardar cambios',
                          loading: state.saving,
                          onPressed: _save,
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

class _PhotoSourceSheet extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          SereniaSpacing.screen,
          0,
          SereniaSpacing.screen,
          SereniaSpacing.md,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 12,
          children: [
            SecondaryButton(
              label: 'Tomar una foto',
              icon: Icons.photo_camera_outlined,
              onPressed: () => Navigator.pop(context, ImageSource.camera),
            ),
            SecondaryButton(
              label: 'Elegir de mis fotos',
              icon: Icons.photo_library_outlined,
              onPressed: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
  }
}
