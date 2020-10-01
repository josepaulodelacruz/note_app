import 'package:flutter/material.dart';
import 'package:note_common/bloc/note/note_cubit.dart';
import 'package:note_common/models/note_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditModal extends StatefulWidget {
  final NoteModel noteModel;
  EditModal({this.noteModel}) : super();

  @override
  _EditModalState createState () => _EditModalState();

}

class _EditModalState extends State<EditModal>{
  final TextEditingController _newTitle = TextEditingController();
  final TextEditingController _newDescription = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        height: MediaQuery.of(context).size.height * 0.15,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextField(
              controller: _newTitle,
              decoration: InputDecoration(
                hintText: '${widget.noteModel.title}'
              ),
            ),
            TextField(
              controller: _newDescription,
              decoration: InputDecoration(
                  hintText: '${widget.noteModel.description}'
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
            NoteModel newNoteModel = NoteModel(widget.noteModel.id, _newTitle.text, _newDescription.text);
           context.bloc<NoteCubit>().editNote(newNoteModel);
           Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
          },
          child: Text('Yes'),
        ),
      ],
    );
  }
}
