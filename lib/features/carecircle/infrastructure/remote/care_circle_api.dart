import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:serenia_app/core/api_constants.dart';
import 'package:serenia_app/core/api_exception.dart';
import 'package:serenia_app/core/api_headers.dart';
import 'package:serenia_app/core/session_storage.dart';
import 'package:serenia_app/features/carecircle/infrastructure/remote/care_circle_dto.dart';
import 'package:serenia_app/features/carecircle/infrastructure/remote/family_link_dto.dart';
import 'package:serenia_app/features/carecircle/infrastructure/remote/redeem_invitation_code_request_dto.dart';

class CareCircleApi {
  final SessionStorage _storage;
  const new({required this._storage});

  static const String familyLinksUrl = '${ApiConstants.baseUrl}/family-links';
  static const String careCirclesUrl = '${ApiConstants.baseUrl}/care-circles';

  Future<Map<String, String>> _headers() async {
    return ApiHeaders.json(token: await _storage.getToken());
  }

  dynamic _decode(http.Response response) {
    return jsonDecode(utf8.decode(response.bodyBytes));
  }

  Future<List<FamilyLinkDto>> getFamilyLinksByRelative(
    String relativeId,
  ) async {
    final http.Response response = await http.get(
      Uri.parse('$familyLinksUrl?relativeId=$relativeId'),
      headers: await _headers(),
    );

    if (response.statusCode == HttpStatus.ok) {
      final List jsons = _decode(response);
      return jsons.map((json) => FamilyLinkDto.fromJson(json)).toList();
    }
    throw ApiException.fromResponse(response);
  }

  Future<FamilyLinkDto> redeemInvitationCode(
    RedeemInvitationCodeRequestDto request,
  ) async {
    final http.Response response = await http.post(
      Uri.parse(familyLinksUrl),
      headers: await _headers(),
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == HttpStatus.created) {
      return FamilyLinkDto.fromJson(_decode(response));
    }
    throw ApiException.fromResponse(response);
  }

  Future<CareCircleDto> getCareCircle(String careCircleId) async {
    final http.Response response = await http.get(
      Uri.parse('$careCirclesUrl/$careCircleId'),
      headers: await _headers(),
    );

    if (response.statusCode == HttpStatus.ok) {
      return CareCircleDto.fromJson(_decode(response));
    }
    throw ApiException.fromResponse(response);
  }
}
