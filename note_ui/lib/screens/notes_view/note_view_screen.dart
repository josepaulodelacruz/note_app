import 'package:flutter/material.dart';
import 'package:note_common/bloc/note/note_cubit.dart';
import 'package:note_common/models/note_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_ui/screens/notes_view/widgets/edit_modal.dart';
import 'package:note_ui/widgets/bottom_modal.dart';
import 'package:note_ui/widgets/confirmation_modal.dart';

class NoteViewScreen extends StatelessWidget {
  final NoteModel noteModel;

  NoteViewScreen({this.noteModel}) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
              } else if(value == 'add') {
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
              } else {
                return showDialog(
                  context: context,
                  builder: (context) => EditModal(
                    noteModel: noteModel,
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
              new PopupMenuItem<String>(
                value: 'edit',
                child: Text('Edit Notes'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
