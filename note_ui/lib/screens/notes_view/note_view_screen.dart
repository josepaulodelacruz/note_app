import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_common/bloc/note/note_cubit.dart';
import 'package:note_common/bloc/note/note_state.dart';
import 'package:note_common/models/note_model.dart';
import 'package:note_common/models/sub_notes.dart';
import 'package:note_ui/screens/notes_view/widgets/album_slider.dart';
import 'package:note_ui/screens/notes_view/widgets/navbar.dart';
import 'package:note_ui/screens/notes_view/widgets/upper_header.dart';
import 'package:note_ui/screens/notes_view/widgets/upper_subtitle.dart';
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
  final TextEditingController _newTitle = TextEditingController();
  final TextEditingController _newDescription = TextEditingController();
  SubNotes subNotes;

  @override
  void initState () {
    super.initState();
    noteModel = widget.noteModel;
    subNotes =
      noteModel.subNotes.isEmpty ? null : noteModel.subNotes[0];
    BlocProvider.of<NoteCubit>(context).listen((state) {
      if(state is LoadedNoteState) {
        NoteModel a =
          state.notes.firstWhere((note) => note.id == noteModel.id, orElse: () => null);
        if(mounted) {
          setState(() {
            noteModel = a != null ?
              a : widget.noteModel;
            subNotes =
              noteModel.subNotes.isEmpty ? null : noteModel.subNotes[0];
          });
        }
      }
    });
  }

  @override
  void dispose () {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: NavBar(
          noteModel: noteModel,
          newTitle: _newTitle,
          newDescription: _newDescription,

        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              UpperHeader(
                noteModel: noteModel,
                subNotes: subNotes),
              UpperSubtitle(
                noteModel: noteModel,
                newTitle: _newTitle,
                newDescription:  _newDescription),
              AlbumSlider(
                noteModel: noteModel,
                renderBottomModal: () {
                  return showModalBottomSheet(
                    context: context,
                    builder: (_) => SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: BottomModal(
                          noteModel: noteModel,
                          selectedDate: selectedDate,
                        ),
                      )
                    )
                  );
                },
                isSetState: (note) {
                setState(() {
                  subNotes =
                  note.photos.isEmpty ? null : note;
                });
              }),
            ],
          ),
        )
      )
    );
  }
}
