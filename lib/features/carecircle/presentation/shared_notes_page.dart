import 'package:flutter/material.dart';
import 'package:serenia_app/core/authorized_image.dart';
import 'package:serenia_app/core/serenia_colors.dart';
import 'package:serenia_app/core/serenia_dimens.dart';
import 'package:serenia_app/core/serenia_typography.dart';
import 'package:serenia_app/core/widgets/back_link.dart';
import 'package:serenia_app/core/widgets/load_error.dart';
import 'package:serenia_app/core/widgets/note_card.dart';
import 'package:serenia_app/core/widgets/screen_header.dart';
import 'package:serenia_app/core/widgets/serenia_avatar.dart';
import 'package:serenia_app/core/widgets/serenia_buttons.dart';
import 'package:serenia_app/core/widgets/serenia_snack_bar.dart';
import 'package:serenia_app/core/widgets/serenia_text_field.dart';
import 'package:serenia_app/features/carecircle/domain/circle_member.dart';
import 'package:serenia_app/features/carecircle/domain/shared_note.dart';
import 'package:serenia_app/features/carecircle/presentation/circle_date_format.dart';
import 'package:serenia_app/features/carecircle/presentation/shared_notes_view_model.dart';

class SharedNotesPage extends StatelessWidget {
  final SharedNotesViewModel _viewModel;

  const new({super.key, required this._viewModel});

  Future<void> _create(BuildContext context) async {
    FocusScope.of(context).unfocus();
    if (await _viewModel.create() && context.mounted) {
      showSereniaSnackBar(context, 'Nota guardada.');
    }
  }

  Future<void> _saveEdit(BuildContext context, SharedNote note) async {
    FocusScope.of(context).unfocus();
    if (await _viewModel.saveEdit(note) && context.mounted) {
      showSereniaSnackBar(context, 'Nota actualizada.');
    }
  }

  Widget _note(BuildContext context, SharedNote note, DateTime now) {
    final CircleMember? author = _viewModel.authorOf(note);
    final bool editing = _viewModel.editingNoteId == note.id;
    return NoteCard(
      avatar: SereniaAvatar(
        name: author?.name ?? _viewModel.authorName(note),
        photo: AuthorizedImage.provider(author?.photoUrl, _viewModel.token),
        tone: note.isMine ? AvatarTone.me : AvatarTone.other,
        size: SereniaSizes.avatarTiny,
      ),
      author: _viewModel.authorName(note),
      when: CircleDateFormat.noteWhen(note.createdAt, now),
      text: note.text,
      mine: note.isMine,
      editing: editing,
      saving: editing && _viewModel.isSavingEdit,
      error: editing ? _viewModel.editError : null,
      controller: editing ? _viewModel.editedNote : null,
      onEdit: _viewModel.editingNoteId == null
          ? () => _viewModel.startEdit(note)
          : null,
      onSave: () => _saveEdit(context, note),
      onCancel: _viewModel.cancelEdit,
    );
  }

  List<Widget> _notes(BuildContext context) {
    if (_viewModel.errorMessage != null) {
      return [
        LoadError(message: _viewModel.errorMessage!, onRetry: _viewModel.load),
      ];
    }
    if (_viewModel.isLoading && _viewModel.notes.isEmpty) {
      return const [
        Padding(
          padding: EdgeInsets.all(SereniaSpacing.xl),
          child: Center(child: CircularProgressIndicator()),
        ),
      ];
    }
    if (_viewModel.notes.isEmpty) {
      return [
        Text(
          'Aún no hay notas. Escribe la primera.',
          style: SereniaTypography.cardBody.copyWith(
            color: SereniaColors.neutro700,
          ),
        ),
      ];
    }
    final DateTime now = DateTime.now();
    return [
      for (final SharedNote note in _viewModel.notes) _note(context, note, now),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _viewModel,
          builder: (context, child) {
            final List<Widget> sections = [
              ScreenHeader(
                title: 'Notas compartidas',
                subtitle:
                    'Lo que todos en el círculo deben saber sobre '
                    '${_viewModel.olderAdultFirstName}.',
              ),
              ..._notes(context),
              SereniaTextField(
                label: 'Nueva nota',
                controller: _viewModel.newNote,
                hint: 'Algo que los demás deban saber',
                error: _viewModel.createError,
                maxLines: SereniaSizes.noteLines,
                keyboardType: TextInputType.multiline,
                textCapitalization: TextCapitalization.sentences,
                onChanged: (_) => _viewModel.clearCreateError(),
              ),
              PrimaryButton(
                label: 'Guardar nota',
                loading: _viewModel.isCreating,
                onPressed: () => _create(context),
              ),
            ];
            return ListView(
              padding: const EdgeInsets.fromLTRB(
                SereniaSpacing.screen,
                SereniaSpacing.sm,
                SereniaSpacing.screen,
                SereniaSpacing.cardInset,
              ),
              children: [
                const BackLink(parent: 'Círculo'),
                for (final Widget section in sections) ...[
                  const SizedBox(height: SereniaSpacing.gap),
                  section,
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
