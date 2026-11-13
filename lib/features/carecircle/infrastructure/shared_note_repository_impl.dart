import 'package:serenia_app/core/session.dart';
import 'package:serenia_app/core/session_storage.dart';
import 'package:serenia_app/features/carecircle/domain/shared_note.dart';
import 'package:serenia_app/features/carecircle/domain/shared_note_repository.dart';
import 'package:serenia_app/features/carecircle/infrastructure/remote/shared_note_dto.dart';
import 'package:serenia_app/features/carecircle/infrastructure/remote/shared_notes_api.dart';

class SharedNoteRepositoryImpl implements SharedNoteRepository {
  final SharedNotesApi _api;
  final SessionStorage _storage;
  const new({required this._api, required this._storage});

  @override
  Future<List<SharedNote>> getSharedNotes(String careCircleId) async {
    final List<SharedNoteDto> dtos = await _api.getSharedNotes(careCircleId);
    final Session? session = await _storage.getSession();
    return dtos.map((dto) => _toSharedNote(dto, session?.userId)).toList();
  }

  SharedNote _toSharedNote(SharedNoteDto dto, String? myUserId) {
    final String? updatedAt = dto.updatedAt;
    return SharedNote(
      id: dto.id,
      authorId: dto.authorId,
      createdAt: DateTime.parse(dto.createdAt).toLocal(),
      updatedAt: updatedAt == null ? null : DateTime.parse(updatedAt).toLocal(),
      text: dto.content,
      isMine: dto.authorId == myUserId,
    );
  }
}
