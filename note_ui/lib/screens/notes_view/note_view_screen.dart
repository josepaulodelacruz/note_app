import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_common/bloc/note/note_cubit.dart';
import 'package:note_common/bloc/note/note_state.dart';
import 'package:note_common/models/note_model.dart';
import 'package:note_ui/screens/notes_view/widgets/navbar.dart';
import 'package:note_ui/widgets/bottom_modal.dart';

class NoteViewScreen extends StatefulWidget {
  NoteModel noteModel;

  NoteViewScreen({this.noteModel}) : super();

  @override
  _NoteViewScreenState createState () => _NoteViewScreenState();
}

class _NoteViewScreenState extends State<NoteViewScreen>{
  NoteModel noteModel;
  DateTime selectedDate = DateTime.now();
  final TextEditingController _subNotes = TextEditingController();
  final TextEditingController _subject = TextEditingController();

  @override
  void initState () {
    super.initState();
    noteModel = widget.noteModel;
    BlocProvider.of<NoteCubit>(context).sub = [];
    BlocProvider.of<NoteCubit>(context).listen((state) {
      if(state is LoadedNoteState) {
        NoteModel a = state.notes.firstWhere((note) => note.id == noteModel.id);
        if(mounted) {
          setState(() {
            noteModel = a;
          });
        }
      }
    });
  }

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
                  child: BottomModal(
                    noteModel: noteModel,
                    selectedDate: selectedDate,
                    subNotes: _subNotes,
                    subject: _subject,
                  ),
                ),
              )
            );
          },
        ),
      ),
      body: ListView(
        children: noteModel.subNotes?.map((note) {
          int index = noteModel.subNotes.indexOf(note);
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              title: Text(note.title),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  setState(() {
                    _subNotes.text = note.subTitle;
                    _subject.text = note.title;
                  });
                  return showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (_) => SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: BottomModal(
                          isEdit: true,
                          editSubNotes: note,
                          noteModel: noteModel,
                          selectedDate: selectedDate,
                          subNotes: _subNotes,
                          subject: _subject,
                          index: index,
                        ),
                      ),
                    )
                  );
                },
              ),
            ),
          );
        })?.toList() ?? [],
      )
    );
  }
}
