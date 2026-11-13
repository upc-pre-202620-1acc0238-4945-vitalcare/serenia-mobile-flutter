import 'package:serenia_app/features/alertsandsafety/domain/phone_dialer.dart';

class CallOlderAdultUseCase {
  final PhoneDialer _dialer;
  const new({required this._dialer});

  Future<bool> execute(String phoneNumber) {
    return _dialer.dial(phoneNumber);
  }
}
