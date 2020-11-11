import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_common/bloc/note/note_cubit.dart';
import 'package:note_common/bloc/note/note_state.dart';
import 'package:note_common/models/note_model.dart';
import 'package:note_common/models/pictures.dart';
import 'package:note_common/models/sub_notes.dart';
import 'package:note_ui/model/screen_argument.dart';
import 'package:note_ui/screens/notes_view/widgets/album_slider.dart';
import 'package:note_ui/screens/notes_view/widgets/edit_modal.dart';
import 'package:note_ui/screens/notes_view/widgets/navbar.dart';
import 'package:note_ui/screens/notes_view/widgets/note_card.dart';
import 'package:note_ui/screens/notes_view/widgets/upper_header.dart';
import 'package:note_ui/screens/notes_view/widgets/upper_subtitle.dart';
import 'package:note_ui/widgets/bottom_modal.dart';
import 'package:note_ui/widgets/confirmation_modal.dart';

final List<String> imgList = [
  'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
  'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
  'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
  'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
];


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
        int index = state.notes.indexWhere((note) => note.id == noteModel.id);
        print(index);
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
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              UpperHeader(noteModel: noteModel, subNotes: subNotes),
              UpperSubtitle(noteModel: noteModel),
              AlbumSlider(
                noteModel: noteModel,
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
