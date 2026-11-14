import 'package:flutter/widgets.dart';
import 'package:serenia_app/core/error_messages.dart';
import 'package:serenia_app/features/carecircle/application/create_shared_note_use_case.dart';
import 'package:serenia_app/features/carecircle/application/edit_shared_note_use_case.dart';
import 'package:serenia_app/features/carecircle/application/get_shared_notes_use_case.dart';
import 'package:serenia_app/features/carecircle/domain/circle_member.dart';
import 'package:serenia_app/features/carecircle/domain/empty_shared_note_exception.dart';
import 'package:serenia_app/features/carecircle/domain/shared_note.dart';
import 'package:serenia_app/features/carecircle/domain/shared_note_edit_not_allowed_exception.dart';
import 'package:serenia_app/features/carecircle/presentation/circle_date_format.dart';

class SharedNotesViewModel extends ChangeNotifier {
  final GetSharedNotesUseCase _getSharedNotes;
  final CreateSharedNoteUseCase _createSharedNote;
  final EditSharedNoteUseCase _editSharedNote;

  new({
    required this._getSharedNotes,
    required this._createSharedNote,
    required this._editSharedNote,
  });

  static const String emptyNote = 'Escribe algo antes de guardar.';
  static const String editNotAllowed = 'Solo puedes editar tus propias notas.';

  final TextEditingController newNote = TextEditingController();
  final TextEditingController editedNote = TextEditingController();

  bool isLoading = false;
  String? errorMessage;
  bool isCreating = false;
  String? createError;
  String? editingNoteId;
  bool isSavingEdit = false;
  String? editError;

  String careCircleId = '';
  String olderAdultFirstName = '';
  List<CircleMember> members = [];
  String? token;
  List<SharedNote> notes = [];

  Future<void> open({
    required String careCircleId,
    required String olderAdultFirstName,
    required List<CircleMember> members,
    String? token,
  }) async {
    this.careCircleId = careCircleId;
    this.olderAdultFirstName = olderAdultFirstName;
    this.members = members;
    this.token = token;
    notes = [];
    newNote.clear();
    createError = null;
    cancelEdit();
    await CircleDateFormat.ensureInitialized();
    await load();
  }

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      notes = await _getSharedNotes.execute(careCircleId);
    } catch (e) {
      errorMessage = ErrorMessages.from(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  CircleMember? authorOf(SharedNote note) {
    for (final CircleMember member in members) {
      if (member.userId == note.authorId) return member;
    }
    return null;
  }

  String authorName(SharedNote note) {
    if (note.isMine) return 'Tú';
    return authorOf(note)?.firstName ?? 'Un familiar';
  }

  String _messageFor(Object error) {
    if (error is EmptySharedNoteException) return emptyNote;
    if (error is SharedNoteEditNotAllowedException) return editNotAllowed;
    return ErrorMessages.from(error);
  }

  void clearCreateError() {
    if (createError == null) return;
    createError = null;
    notifyListeners();
  }

  Future<bool> create() async {
    if (isCreating) return false;
    isCreating = true;
    createError = null;
    notifyListeners();
    try {
      await _createSharedNote.execute(careCircleId, newNote.text);
      newNote.clear();
      notes = await _getSharedNotes.execute(careCircleId);
      return true;
    } catch (e) {
      createError = _messageFor(e);
      return false;
    } finally {
      isCreating = false;
      notifyListeners();
    }
  }

  void startEdit(SharedNote note) {
    if (!note.isMine) return;
    editingNoteId = note.id;
    editedNote.text = note.text;
    editError = null;
    notifyListeners();
  }

  void cancelEdit() {
    editingNoteId = null;
    editedNote.clear();
    editError = null;
    isSavingEdit = false;
    notifyListeners();
  }

  Future<bool> saveEdit(SharedNote note) async {
    if (isSavingEdit) return false;
    isSavingEdit = true;
    editError = null;
    notifyListeners();
    try {
      await _editSharedNote.execute(careCircleId, note, editedNote.text);
      editingNoteId = null;
      editedNote.clear();
      notes = await _getSharedNotes.execute(careCircleId);
      return true;
    } catch (e) {
      editError = _messageFor(e);
      return false;
    } finally {
      isSavingEdit = false;
      notifyListeners();
    }
  }
}
