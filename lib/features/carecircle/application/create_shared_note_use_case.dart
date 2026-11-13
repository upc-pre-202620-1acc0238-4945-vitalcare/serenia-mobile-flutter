import 'package:serenia_app/features/carecircle/domain/empty_shared_note_exception.dart';
import 'package:serenia_app/features/carecircle/domain/shared_note.dart';
import 'package:serenia_app/features/carecircle/domain/shared_note_repository.dart';

class CreateSharedNoteUseCase {
  final SharedNoteRepository _repository;
  const new({required this._repository});

  Future<SharedNote> execute(String careCircleId, String text) {
    final String content = text.trim();
    if (content.isEmpty) throw const EmptySharedNoteException();
    return _repository.createSharedNote(careCircleId, content);
  }
}
