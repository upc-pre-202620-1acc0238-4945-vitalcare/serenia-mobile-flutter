import 'package:serenia_app/features/carecircle/domain/shared_note.dart';

abstract class SharedNoteRepository {
  Future<List<SharedNote>> getSharedNotes(String careCircleId);
  Future<SharedNote> createSharedNote(String careCircleId, String text);
  Future<SharedNote> editSharedNote(
    String careCircleId,
    String sharedNoteId,
    String text,
  );
}
