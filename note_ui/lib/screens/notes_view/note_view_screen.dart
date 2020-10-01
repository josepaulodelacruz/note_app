import 'package:flutter/material.dart';
import 'package:note_common/models/note_model.dart';
import 'package:note_ui/screens/notes_view/widgets/navbar.dart';
import 'package:note_ui/widgets/bottom_modal.dart';

class NoteViewScreen extends StatelessWidget {
  final NoteModel noteModel;

  NoteViewScreen({this.noteModel}) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: NavBar(
          noteModel: noteModel,
          renderBottomModal: () {
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
          },
        ),
      ),
      body: Center(
        child: Text('HELLO'),
      )
    );
  }
}
