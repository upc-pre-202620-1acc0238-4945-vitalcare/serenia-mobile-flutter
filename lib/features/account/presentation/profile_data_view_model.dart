import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serenia_app/core/api_exception.dart';
import 'package:serenia_app/core/error_messages.dart';
import 'package:serenia_app/features/iam/application/update_profile_use_case.dart';
import 'package:serenia_app/features/iam/application/upload_profile_photo_use_case.dart';
import 'package:serenia_app/features/iam/domain/credentials_validator.dart';
import 'package:serenia_app/features/iam/domain/phone_number.dart';
import 'package:serenia_app/features/iam/domain/unsupported_photo_exception.dart';
import 'package:serenia_app/features/iam/domain/user.dart';

class ProfileDataState {
  final User user;
  final String? fullNameError;
  final String? phoneNumberError;
  final String? formError;
  final String? photoError;
  final bool saving;
  final bool uploadingPhoto;
  final bool saved;
  final String? message;

  const new({
    required this.user,
    this.fullNameError,
    this.phoneNumberError,
    this.formError,
    this.photoError,
    this.saving = false,
    this.uploadingPhoto = false,
    this.saved = false,
    this.message,
  });

  ProfileDataState copyWith({
    User? user,
    String? Function()? fullNameError,
    String? Function()? phoneNumberError,
    String? Function()? formError,
    String? Function()? photoError,
    bool? saving,
    bool? uploadingPhoto,
    bool? saved,
    String? Function()? message,
  }) {
    return ProfileDataState(
      user: user ?? this.user,
      fullNameError: fullNameError == null
          ? this.fullNameError
          : fullNameError(),
      phoneNumberError: phoneNumberError == null
          ? this.phoneNumberError
          : phoneNumberError(),
      formError: formError == null ? this.formError : formError(),
      photoError: photoError == null ? this.photoError : photoError(),
      saving: saving ?? this.saving,
      uploadingPhoto: uploadingPhoto ?? this.uploadingPhoto,
      saved: saved ?? this.saved,
      message: message == null ? this.message : message(),
    );
  }
}

class ProfileDataViewModel extends Cubit<ProfileDataState> {
  final UpdateProfileUseCase _updateProfile;
  final UploadProfilePhotoUseCase _uploadPhoto;

  new({
    required this._updateProfile,
    required this._uploadPhoto,
    required User user,
  }) : super(ProfileDataState(user: user));

  static const String photoNotRead = 'No pudimos abrir esa foto. Elige otra.';
  static const String photoTooLarge =
      'Esa foto pesa mucho. Elige otra o tómala de nuevo.';

  void clearFullNameError() {
    emit(state.copyWith(fullNameError: () => null));
  }

  void clearPhoneNumberError() {
    emit(state.copyWith(phoneNumberError: () => null));
  }

  void clearMessage() {
    emit(state.copyWith(message: () => null));
  }

  void photoNotAvailable() {
    emit(state.copyWith(photoError: () => photoNotRead));
  }

  Future<void> changePhoto(List<int> bytes) async {
    if (state.uploadingPhoto) return;
    emit(state.copyWith(uploadingPhoto: true, photoError: () => null));
    try {
      final User user = await _uploadPhoto.execute(bytes);
      emit(
        state.copyWith(
          user: user,
          uploadingPhoto: false,
          message: () => 'Listo, cambiamos tu foto.',
        ),
      );
    } on UnsupportedPhotoException {
      emit(
        state.copyWith(uploadingPhoto: false, photoError: () => photoNotRead),
      );
    } on ApiException catch (e) {
      emit(
        state.copyWith(
          uploadingPhoto: false,
          photoError: () => e.statusCode == HttpStatus.requestEntityTooLarge
              ? photoTooLarge
              : ErrorMessages.from(e),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          uploadingPhoto: false,
          photoError: () => ErrorMessages.from(e),
        ),
      );
    }
  }

  Future<void> save(String fullName, String phoneNumber) async {
    if (state.saving) return;

    String? fullNameError;
    if (fullName.trim().isEmpty) {
      fullNameError = 'Escribe tu nombre.';
    } else if (!CredentialsValidator.isValidName(fullName)) {
      fullNameError = 'Tu nombre es muy largo. Usa uno más corto.';
    }
    final String? phoneNumberError =
        phoneNumber.isEmpty || PhoneNumber.isValidLocal(phoneNumber)
        ? null
        : 'Revisa el celular: debe tener 9 números y empezar con 9.';

    if (fullNameError != null || phoneNumberError != null) {
      emit(
        state.copyWith(
          fullNameError: () => fullNameError,
          phoneNumberError: () => phoneNumberError,
          formError: () => null,
        ),
      );
      return;
    }

    emit(state.copyWith(saving: true, formError: () => null));
    try {
      final User user = await _updateProfile.execute(
        fullName: fullName,
        phoneNumber: phoneNumber.isEmpty
            ? null
            : PhoneNumber.fromLocal(phoneNumber),
        birthDate: state.user.birthDate,
      );
      emit(state.copyWith(user: user, saving: false, saved: true));
    } catch (e) {
      emit(
        state.copyWith(saving: false, formError: () => ErrorMessages.from(e)),
      );
    }
  }
}
