import 'package:serenia_app/features/carecircle/domain/empty_shared_note_exception.dart';
import 'package:serenia_app/features/carecircle/domain/shared_note.dart';
import 'package:serenia_app/features/carecircle/domain/shared_note_edit_not_allowed_exception.dart';
import 'package:serenia_app/features/carecircle/domain/shared_note_repository.dart';

class EditSharedNoteUseCase {
  final SharedNoteRepository _repository;
  const new({required this._repository});

  Future<SharedNote> execute(
    String careCircleId,
    SharedNote note,
    String text,
  ) {
    if (!note.isMine) throw const SharedNoteEditNotAllowedException();
    final String content = text.trim();
    if (content.isEmpty) throw const EmptySharedNoteException();
    return _repository.editSharedNote(careCircleId, note.id, content);
  }
}
