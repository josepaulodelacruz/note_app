import 'package:flutter/material.dart';
import 'package:note_common/bloc/note/note_cubit.dart';
import 'package:note_common/models/note_model.dart';
import 'package:note_ui/widgets/bottom_modal.dart';
import 'package:note_ui/widgets/confirmation_modal.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NavBar extends StatelessWidget {
  final NoteModel noteModel;

  NavBar({this.noteModel});

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
            } else {
              return showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (_) => SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: BottomModal(),
                  ),
                )
              );
            }
          },
          itemBuilder: (_) => <PopupMenuItem<String>>[
            new PopupMenuItem<String>(
              value: 'add',
              child: Text('Add Notes'),
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