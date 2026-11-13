import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:serenia_app/core/api_exception.dart';

class ErrorMessages {
  static const String connection =
      'No pudimos conectarnos. Revisa tu internet e intenta de nuevo.';
  static const String unexpected =
      'Algo salió mal. Intenta de nuevo en un momento.';

  static String from(Object error) {
    if (error is http.ClientException || error is TimeoutException) {
      return connection;
    }
    if (error is ApiException) {
      return error.message;
    }
    return unexpected;
  }
}
