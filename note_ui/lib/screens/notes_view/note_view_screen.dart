import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_common/bloc/note/note_cubit.dart';
import 'package:note_common/bloc/note/note_state.dart';
import 'package:note_common/models/note_model.dart';
import 'package:note_ui/screens/notes_view/widgets/navbar.dart';
import 'package:note_ui/widgets/bottom_modal.dart';

class NoteViewScreen extends StatefulWidget {
  final NoteModel noteModel;

  NoteViewScreen({this.noteModel}) : super();

  @override
  _NoteViewScreenState createState () => _NoteViewScreenState();
}

class _NoteViewScreenState extends State<NoteViewScreen>{
  NoteModel noteModel;

  @override
  void initState () {
    noteModel = widget.noteModel;
    BlocProvider.of<NoteCubit>(context).listen((state) {
      if(state is LoadedSubNotesState) {
        setState(() {
          noteModel.subNotes = state.subNotes;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(noteModel.subNotes.length);
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
                  child: BottomModal(noteModel: noteModel),
                ),
              )
            );
          },
        ),
      ),
      body: ListView(
        children: noteModel.subNotes?.map((note) {
          return Card(
            child: ListTile(
              title: Text(note.title)
            ),
          );
        })?.toList() ?? [],
      )
    );
  }
}
