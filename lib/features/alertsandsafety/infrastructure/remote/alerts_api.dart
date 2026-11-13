import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:serenia_app/core/api_constants.dart';
import 'package:serenia_app/core/api_exception.dart';
import 'package:serenia_app/core/api_headers.dart';
import 'package:serenia_app/core/session_storage.dart';
import 'package:serenia_app/features/alertsandsafety/infrastructure/remote/alert_dto.dart';
import 'package:serenia_app/features/alertsandsafety/infrastructure/remote/resolve_alert_request_dto.dart';

class AlertsApi {
  final SessionStorage _storage;
  const new({required this._storage});

  static const String alertsUrl = '${ApiConstants.baseUrl}/alerts';

  Future<Map<String, String>> _headers() async {
    return ApiHeaders.json(token: await _storage.getToken());
  }

  dynamic _decode(http.Response response) {
    return jsonDecode(utf8.decode(response.bodyBytes));
  }

  Future<List<AlertDto>> getAlerts(String olderAdultId) async {
    final http.Response response = await http.get(
      Uri.parse('$alertsUrl?olderAdultId=$olderAdultId'),
      headers: await _headers(),
    );

    if (response.statusCode == HttpStatus.ok) {
      final List jsons = _decode(response);
      return jsons.map((json) => AlertDto.fromJson(json)).toList();
    }
    throw ApiException.fromResponse(response);
  }

  Future<AlertDto> acknowledge(String typePath, String alertId) async {
    final http.Response response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}/$typePath/$alertId/acknowledge'),
      headers: await _headers(),
    );

    if (response.statusCode == HttpStatus.ok) {
      return AlertDto.fromJson(_decode(response));
    }
    throw ApiException.fromResponse(response);
  }

  Future<AlertDto> resolve(
    String typePath,
    String alertId,
    ResolveAlertRequestDto request,
  ) async {
    final http.Response response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}/$typePath/$alertId/resolve'),
      headers: await _headers(),
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == HttpStatus.ok) {
      return AlertDto.fromJson(_decode(response));
    }
    throw ApiException.fromResponse(response);
  }
}
