import 'package:serenia_app/features/carecircle/domain/shared_note.dart';

abstract class SharedNoteRepository {
  Future<List<SharedNote>> getSharedNotes(String careCircleId);
}
