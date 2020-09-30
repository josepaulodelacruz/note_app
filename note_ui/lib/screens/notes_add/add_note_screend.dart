import 'package:flutter/material.dart';
import 'package:note_common/bloc/note/note_cubit.dart';
import 'package:note_ui/screens/home/widgets/inputs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddNoteScreen extends StatefulWidget {
  @override
  createState () => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen>{
  final _title = TextEditingController();
  final _description = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Notes'),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 10),
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InputCard(
              controller: _title,
              field: 'Title',
            ),
            InputCard(
              controller: _description,
              field: 'Description',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.bloc<NoteCubit>().addNote(_title.text, _description.text);
          Navigator.of(context).pop();
        },
        child: Icon(Icons.check),
      ),
    );
  }
}