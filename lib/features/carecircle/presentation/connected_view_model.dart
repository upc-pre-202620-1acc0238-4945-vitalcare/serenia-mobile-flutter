import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serenia_app/features/carecircle/application/get_my_circle_use_case.dart';
import 'package:serenia_app/features/carecircle/domain/my_circle.dart';
import 'package:serenia_app/features/iam/application/get_current_user_use_case.dart';
import 'package:serenia_app/features/iam/domain/user.dart';

class ConnectedState {
  final bool loading;
  final String? myName;
  final String? olderAdultName;

  const new({this.loading = true, this.myName, this.olderAdultName});

  String? get olderAdultFirstName {
    return olderAdultName?.trim().split(RegExp(r'\s+')).first;
  }
}

class ConnectedViewModel extends Cubit<ConnectedState> {
  final GetMyCircleUseCase _getMyCircle;
  final GetCurrentUserUseCase _getCurrentUser;

  new({required this._getMyCircle, required this._getCurrentUser})
    : super(const ConnectedState());

  Future<void> load() async {
    try {
      final User me = await _getCurrentUser.execute();
      final MyCircle? circle = await _getMyCircle.execute();
      emit(
        ConnectedState(
          loading: false,
          myName: me.fullName,
          olderAdultName: circle?.olderAdult.fullName,
        ),
      );
    } catch (_) {
      emit(const ConnectedState(loading: false));
    }
  }
}
