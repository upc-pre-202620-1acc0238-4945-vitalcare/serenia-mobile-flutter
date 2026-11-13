import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:serenia_app/core/api_constants.dart';
import 'package:serenia_app/core/api_exception.dart';
import 'package:serenia_app/core/api_headers.dart';
import 'package:serenia_app/core/session_storage.dart';
import 'package:serenia_app/features/carecircle/infrastructure/remote/shared_note_dto.dart';

class SharedNotesApi {
  final SessionStorage _storage;
  const new({required this._storage});

  static const String careCirclesUrl = '${ApiConstants.baseUrl}/care-circles';

  Future<Map<String, String>> _headers() async {
    return ApiHeaders.json(token: await _storage.getToken());
  }

  dynamic _decode(http.Response response) {
    return jsonDecode(utf8.decode(response.bodyBytes));
  }

  Future<List<SharedNoteDto>> getSharedNotes(String careCircleId) async {
    final http.Response response = await http.get(
      Uri.parse('$careCirclesUrl/$careCircleId/shared-notes'),
      headers: await _headers(),
    );

    if (response.statusCode == HttpStatus.ok) {
      final List jsons = _decode(response);
      return jsons.map((json) => SharedNoteDto.fromJson(json)).toList();
    }
    throw ApiException.fromResponse(response);
  }
}
