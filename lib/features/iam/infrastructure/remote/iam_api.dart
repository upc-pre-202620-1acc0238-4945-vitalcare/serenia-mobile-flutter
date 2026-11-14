import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:serenia_app/core/api_constants.dart';
import 'package:serenia_app/core/api_exception.dart';
import 'package:serenia_app/core/api_headers.dart';
import 'package:serenia_app/features/iam/infrastructure/remote/authenticated_user_dto.dart';
import 'package:serenia_app/features/iam/infrastructure/remote/change_password_request_dto.dart';
import 'package:serenia_app/features/iam/infrastructure/remote/register_user_request_dto.dart';
import 'package:serenia_app/features/iam/infrastructure/remote/sign_in_request_dto.dart';
import 'package:serenia_app/features/iam/infrastructure/remote/update_profile_request_dto.dart';
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

  Future<UserDto> getUser(String userId, String token) async {
    final http.Response response = await http.get(
      Uri.parse('$usersUrl/$userId'),
      headers: ApiHeaders.json(token: token),
    );

    if (response.statusCode == HttpStatus.ok) {
      final Map<String, dynamic> json = jsonDecode(
        utf8.decode(response.bodyBytes),
      );
      return UserDto.fromJson(json);
    }
    throw ApiException.fromResponse(response);
  }

  Future<UserDto> updateProfile(
    String userId,
    UpdateProfileRequestDto request,
    String token,
  ) async {
    final http.Response response = await http.put(
      Uri.parse('$usersUrl/$userId/profile'),
      headers: ApiHeaders.json(token: token),
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == HttpStatus.ok) {
      final Map<String, dynamic> json = jsonDecode(
        utf8.decode(response.bodyBytes),
      );
      return UserDto.fromJson(json);
    }
    throw ApiException.fromResponse(response);
  }

  Future<UserDto> uploadPhoto(
    String userId,
    List<int> bytes,
    MediaType contentType,
    String token,
  ) async {
    final http.MultipartRequest request =
        http.MultipartRequest('PUT', Uri.parse('$usersUrl/$userId/photo'))
          ..headers.addAll({
            'Accept': 'application/json',
            'Accept-Language': ApiHeaders.language,
            'Authorization': 'Bearer $token',
          })
          ..files.add(
            http.MultipartFile.fromBytes(
              'file',
              bytes,
              filename: 'profile.${contentType.subtype}',
              contentType: contentType,
            ),
          );
    final http.Response response = await http.Response.fromStream(
      await request.send(),
    );

    if (response.statusCode == HttpStatus.ok) {
      final Map<String, dynamic> json = jsonDecode(
        utf8.decode(response.bodyBytes),
      );
      return UserDto.fromJson(json);
    }
    throw ApiException.fromResponse(response);
  }

  Future<void> changePassword(
    String userId,
    ChangePasswordRequestDto request,
    String token,
  ) async {
    final http.Response response = await http.put(
      Uri.parse('$usersUrl/$userId/password'),
      headers: ApiHeaders.json(token: token),
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == HttpStatus.noContent) {
      return;
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
