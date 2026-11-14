import 'dart:io';

import 'package:serenia_app/core/api_exception.dart';
import 'package:serenia_app/core/session.dart';
import 'package:serenia_app/core/session_storage.dart';
import 'package:serenia_app/features/carecircle/domain/care_circle.dart';
import 'package:serenia_app/features/carecircle/domain/care_circle_repository.dart';
import 'package:serenia_app/features/carecircle/domain/family_link.dart';
import 'package:serenia_app/features/carecircle/domain/invalid_invitation_code_exception.dart';
import 'package:serenia_app/features/carecircle/domain/revoke_family_link_not_allowed_exception.dart';
import 'package:serenia_app/features/carecircle/infrastructure/remote/care_circle_api.dart';
import 'package:serenia_app/features/carecircle/infrastructure/remote/care_circle_dto.dart';
import 'package:serenia_app/features/carecircle/infrastructure/remote/family_link_dto.dart';
import 'package:serenia_app/features/carecircle/infrastructure/remote/redeem_invitation_code_request_dto.dart';

class CareCircleRepositoryImpl implements CareCircleRepository {
  final CareCircleApi _api;
  final SessionStorage _storage;
  new({required this._api, required this._storage});

  String? _cachedUserId;
  FamilyLink? _cachedLink;
  final Map<String, CareCircle> _cachedCircles = {};

  @override
  Future<FamilyLink?> getMyFamilyLink() async {
    final Session? session = await _storage.getSession();
    if (session == null) return null;
    if (_cachedUserId == session.userId && _cachedLink != null) {
      return _cachedLink;
    }
    final List<FamilyLinkDto> dtos = await _api.getFamilyLinksByRelative(
      session.userId,
    );
    _cachedUserId = session.userId;
    _cachedLink = dtos.isEmpty ? null : _toFamilyLink(dtos.first);
    return _cachedLink;
  }

  @override
  Future<FamilyLink> redeemInvitationCode(
    String code,
    String relationshipLabel,
  ) async {
    try {
      final FamilyLinkDto dto = await _api.redeemInvitationCode(
        RedeemInvitationCodeRequestDto(
          code: code,
          relationshipLabel: relationshipLabel,
        ),
      );
      final Session? session = await _storage.getSession();
      _cachedUserId = session?.userId;
      _cachedLink = _toFamilyLink(dto);
      return _cachedLink!;
    } on ApiException catch (e) {
      if (e.statusCode == HttpStatus.notFound ||
          e.statusCode == HttpStatus.conflict) {
        throw const InvalidInvitationCodeException();
      }
      rethrow;
    }
  }

  @override
  Future<CareCircle> getCareCircle(String careCircleId) async {
    final CareCircle? cached = _cachedCircles[careCircleId];
    if (cached != null) return cached;
    final CareCircleDto dto = await _api.getCareCircle(careCircleId);
    final CareCircle circle = CareCircle(
      id: dto.id,
      olderAdultId: dto.olderAdultId,
    );
    _cachedCircles[careCircleId] = circle;
    return circle;
  }

  @override
  Future<List<FamilyLink>> getCircleFamilyLinks(String careCircleId) async {
    final List<FamilyLinkDto> dtos = await _api.getFamilyLinksOfCircle(
      careCircleId,
    );
    return dtos.map(_toFamilyLink).toList();
  }

  @override
  Future<void> revokeFamilyLink(
    String careCircleId,
    String familyLinkId,
  ) async {
    try {
      await _api.revokeFamilyLink(careCircleId, familyLinkId);
    } on ApiException catch (e) {
      if (e.statusCode == HttpStatus.forbidden ||
          e.statusCode == HttpStatus.notFound) {
        throw const RevokeFamilyLinkNotAllowedException();
      }
      if (e.statusCode != HttpStatus.conflict) rethrow;
    }
    if (_cachedLink?.id == familyLinkId) {
      _cachedLink = null;
      _cachedUserId = null;
    }
  }

  FamilyLink _toFamilyLink(FamilyLinkDto dto) {
    return FamilyLink(
      id: dto.id,
      careCircleId: dto.careCircleId,
      relativeId: dto.relativeId,
      relationshipLabel: dto.relationshipLabel,
    );
  }
}
