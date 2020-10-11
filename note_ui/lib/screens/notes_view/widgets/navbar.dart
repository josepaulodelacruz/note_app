import 'package:flutter/material.dart';
import 'package:note_common/bloc/note/note_cubit.dart';
import 'package:note_common/models/note_model.dart';
import 'package:note_ui/screens/notes_view/widgets/edit_modal.dart';
import 'package:note_ui/widgets/confirmation_modal.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NavBar extends StatelessWidget {
  final NoteModel noteModel;
  final Function renderBottomModal;

  NavBar({this.noteModel, this.renderBottomModal});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(noteModel.title),
      actions: [
        PopupMenuButton(
          onSelected: (value) {
            if(value == 'delete') {
              showDialog(
                context: context,
                child: ConfirmationModal(
                  handle: () {
                    context.bloc<NoteCubit>().deleteNote(noteModel.id);
                    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                  },
                ),
              );
            } else if(value == 'edit') {
              return showDialog(
                context: context,
                builder: (_) => EditModal(noteModel: noteModel),
              );
            } else {
              renderBottomModal();
            }
          },
          itemBuilder: (_) => <PopupMenuItem<String>>[
            new PopupMenuItem<String>(
              value: 'add',
              child: Text('Add Notes'),
            ),
            new PopupMenuItem<String>(
              value: 'edit',
              child: Text('Edit Notes'),
            ),
            new PopupMenuItem<String>(
              value: 'delete',
              child: Text('Delete Notes'),
            ),
          ],
        ),
      ],
    );
  }
}