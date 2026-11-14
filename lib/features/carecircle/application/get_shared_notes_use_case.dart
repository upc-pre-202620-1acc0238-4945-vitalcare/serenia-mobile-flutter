import 'package:serenia_app/features/carecircle/domain/shared_note.dart';
import 'package:serenia_app/features/carecircle/domain/shared_note_repository.dart';

class GetSharedNotesUseCase {
  final SharedNoteRepository _repository;
  const new({required this._repository});

  Future<List<SharedNote>> execute(String careCircleId) async {
    final List<SharedNote> notes = await _repository.getSharedNotes(
      careCircleId,
    );
    return [...notes]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }
}
