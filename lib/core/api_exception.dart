import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiException implements Exception {
  final int statusCode;
  final String? code;
  final String message;

  const new({required this.statusCode, this.code, required this.message});

  factory ApiException.fromResponse(http.Response response) {
    String? code;
    String? message;
    try {
      final Map<String, dynamic> json = jsonDecode(
        utf8.decode(response.bodyBytes),
      );
      code = json['code'];
      message = json['message'];
    } catch (_) {}
    return ApiException(
      statusCode: response.statusCode,
      code: code,
      message: message ?? 'Error ${response.statusCode}',
    );
  }

  @override
  String toString() => message;
}
