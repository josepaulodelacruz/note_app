import 'package:flutter/material.dart';
import 'package:note_common/models/note_model.dart';
import 'package:note_ui/screens/notes_view/widgets/navbar.dart';

class NoteViewScreen extends StatelessWidget {
  final NoteModel noteModel;

  NoteViewScreen({this.noteModel}) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: NavBar(noteModel: noteModel),
      ),
      body: Center(child: Text('Hello world')),
    );
  }
}