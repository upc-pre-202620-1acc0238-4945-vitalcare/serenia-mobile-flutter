import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serenia_app/core/error_messages.dart';
import 'package:serenia_app/features/carecircle/application/redeem_invitation_code_use_case.dart';
import 'package:serenia_app/features/carecircle/domain/invalid_invitation_code_exception.dart';
import 'package:serenia_app/features/carecircle/domain/relationship.dart';

sealed class InvitationCodeState {
  const new();
}

class InvitationCodeInitial extends InvitationCodeState {
  const new();
}

class InvitationCodeLoading extends InvitationCodeState {
  const new();
}

class InvitationCodeInvalid extends InvitationCodeState {
  final String message;
  const new({required this.message});
}

class InvitationCodeFailure extends InvitationCodeState {
  final String message;
  const new({required this.message});
}

class InvitationCodeSuccess extends InvitationCodeState {
  const new();
}

class InvitationCodeViewModel extends Cubit<InvitationCodeState> {
  final RedeemInvitationCodeUseCase _redeem;
  new({required this._redeem}) : super(const InvitationCodeInitial());

  static const int codeLength = 8;
  static const String incompleteCode =
      'Escribe las 8 letras y números del código.';
  static const String invalidCode =
      'Este código no es válido, ya se usó o venció. '
      'Pídele a tu familiar uno nuevo.';

  void clearError() {
    if (state is InvitationCodeInvalid || state is InvitationCodeFailure) {
      emit(const InvitationCodeInitial());
    }
  }

  Future<void> link(String code, Relationship relationship) async {
    if (state is InvitationCodeLoading) return;
    final String cleanCode = code.replaceAll(RegExp(r'[^A-Za-z0-9]'), '');
    if (cleanCode.length != codeLength) {
      emit(const InvitationCodeInvalid(message: incompleteCode));
      return;
    }
    emit(const InvitationCodeLoading());
    try {
      await _redeem.execute(cleanCode, relationship);
      emit(const InvitationCodeSuccess());
    } on InvalidInvitationCodeException {
      emit(const InvitationCodeInvalid(message: invalidCode));
    } catch (e) {
      emit(InvitationCodeFailure(message: ErrorMessages.from(e)));
    }
  }
}
