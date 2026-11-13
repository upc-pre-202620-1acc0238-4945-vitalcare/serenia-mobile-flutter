import 'package:flutter/painting.dart';

class AuthorizedImage {
  static ImageProvider? provider(String? url, String? token) {
    if (url == null || token == null) return null;
    return NetworkImage(url, headers: {'Authorization': 'Bearer $token'});
  }
}
