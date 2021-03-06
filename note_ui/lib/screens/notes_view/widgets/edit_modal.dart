import 'package:flutter/material.dart';
import 'package:note_common/bloc/note/note_cubit.dart';
import 'package:note_common/models/note_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditModal extends StatelessWidget {
  NoteModel noteModel;
  TextEditingController newTitle;
  TextEditingController newDescription;

  EditModal({
    this.noteModel,
    this.newTitle,
    this.newDescription,
  }) : super();

  @override
  Widget build(BuildContext context) {
    newTitle.text = noteModel.title;
    return AlertDialog(
      content: Container(
        height: MediaQuery.of(context).size.height * 0.15,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextFormField(
              controller: newTitle,
              decoration: InputDecoration(
                hintText: '${noteModel.title}'
              ),
            ),
            TextField(
              controller: newDescription,
              decoration: InputDecoration(
              ),
            ),
          ],
        ),
      ),
      actions: [
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('No'),
        ),
        FlatButton(
          onPressed: () {
           NoteModel newNoteModel = NoteModel(noteModel.id, newTitle.text, newDescription.text, subNotes: noteModel.subNotes);
           context.bloc<NoteCubit>().editNote(newNoteModel);
           Navigator.pop(context);
          },
          child: Text('Yes'),
        ),
      ],
    );
  }
}
