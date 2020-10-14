import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_common/bloc/note/note_cubit.dart';
import 'package:note_common/bloc/note/note_state.dart';
import 'package:note_common/models/note_model.dart';
import 'package:note_ui/screens/notes_view/widgets/navbar.dart';
import 'package:note_ui/screens/notes_view/widgets/note_card.dart';
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
  final TextEditingController _newTitle = TextEditingController();
  final TextEditingController _newDescription = TextEditingController();

  @override
  void initState () {
    super.initState();
    noteModel = widget.noteModel;
    BlocProvider.of<NoteCubit>(context).sub = []; // initialized empty
    BlocProvider.of<NoteCubit>(context).listen((state) {
      if(state is LoadedNoteState) {
        NoteModel a =
          state.notes.firstWhere((note) => note.id == noteModel.id, orElse: () => null);
        if(mounted) {
          setState(() {
            noteModel = a != null ?
              a : widget.noteModel;
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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: NavBar(
          noteModel: noteModel,
          newTitle: _newTitle,
          newDescription: _newDescription,
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
        physics: ClampingScrollPhysics(),
        children: noteModel.subNotes?.map((note) {
          int index = noteModel.subNotes.indexOf(note);
          return NoteCard(
            subNotes: note,
            onHandle: (String value) async {
              switch(value) {
                case 'view':
                  break;
                case 'edit':
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
                  break;
                case 'delete':
                  context.bloc<NoteCubit>().deleteSubNotes(index, noteModel);
                  break;
              }
            },
          );
        })?.toList() ?? [],
      ),
    );
  }
}
