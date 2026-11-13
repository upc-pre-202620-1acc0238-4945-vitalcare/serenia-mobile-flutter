import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:serenia_app/core/api_constants.dart';
import 'package:serenia_app/core/api_exception.dart';
import 'package:serenia_app/core/api_headers.dart';
import 'package:serenia_app/features/iam/infrastructure/remote/authenticated_user_dto.dart';
import 'package:serenia_app/features/iam/infrastructure/remote/register_user_request_dto.dart';
import 'package:serenia_app/features/iam/infrastructure/remote/sign_in_request_dto.dart';
import 'package:serenia_app/features/iam/infrastructure/remote/user_dto.dart';

class IamApi {
  final String sessionsUrl = '${ApiConstants.baseUrl}/sessions';
  final String usersUrl = '${ApiConstants.baseUrl}/users';

  Future<AuthenticatedUserDto> signIn(SignInRequestDto request) async {
    final http.Response response = await http.post(
      Uri.parse(sessionsUrl),
      headers: ApiHeaders.json(),
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == HttpStatus.created) {
      final Map<String, dynamic> json = jsonDecode(
        utf8.decode(response.bodyBytes),
      );
      return AuthenticatedUserDto.fromJson(json);
    }
    throw ApiException.fromResponse(response);
  }

  Future<UserDto> register(RegisterUserRequestDto request) async {
    final http.Response response = await http.post(
      Uri.parse(usersUrl),
      headers: ApiHeaders.json(),
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == HttpStatus.created) {
      final Map<String, dynamic> json = jsonDecode(
        utf8.decode(response.bodyBytes),
      );
      return UserDto.fromJson(json);
    }
    throw ApiException.fromResponse(response);
  }

  Future<void> signOut(String sessionId, String token) async {
    final http.Response response = await http.delete(
      Uri.parse('$sessionsUrl/$sessionId'),
      headers: ApiHeaders.json(token: token),
    );

    if (response.statusCode == HttpStatus.noContent ||
        response.statusCode == HttpStatus.unauthorized ||
        response.statusCode == HttpStatus.notFound) {
      return;
    }
    throw ApiException.fromResponse(response);
  }
}
