import 'package:serenia_app/features/alertsandsafety/domain/phone_dialer.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlLauncherPhoneDialer implements PhoneDialer {
  const new();

  @override
  Future<bool> dial(String phoneNumber) async {
    try {
      return await launchUrl(Uri(scheme: 'tel', path: phoneNumber));
    } catch (_) {
      return false;
    }
  }
}
