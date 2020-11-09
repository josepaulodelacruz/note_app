import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_common/bloc/note/note_cubit.dart';
import 'package:note_common/bloc/note/note_state.dart';
import 'package:note_common/models/note_model.dart';
import 'package:note_ui/model/screen_argument.dart';
import 'package:note_ui/screens/notes_view/widgets/edit_modal.dart';
import 'package:note_ui/screens/notes_view/widgets/navbar.dart';
import 'package:note_ui/screens/notes_view/widgets/note_card.dart';
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
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _upperHeader(),
              _upperSubtitle(),
              _albumSlider(),
            ],
          ),
        )
      )
    );
  }


  Widget _upperHeader () {
    return Container(
      height: MediaQuery
            .of(context)
            .size
            .height * 0.50,
        child: Stack(
          children: [
            if(noteModel.coverPhoto != null ) ...[
              Container(
                child: Opacity(
                  opacity: 0.8,
                  child: Image.file(
                    File(noteModel.coverPhoto),
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                  ),
                ),
              ),
            ],
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xCC000000),
                    const Color(0x00000000),
                    const Color(0x00000000),
                    Colors.black87,
                  ],
                ),
              ),
            ),
            NavBar(
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
            Padding(
              padding: const EdgeInsets.only(left: 32.0),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  noteModel.title,
                  overflow: TextOverflow.ellipsis,
                  style: Theme
                      .of(context)
                      .textTheme
                      .headline3,
                ),
              ),
            )
          ],
        )
    );
  }

  Widget _upperSubtitle () {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
          child: Row(
            children: [
              Icon(Icons.photo_album_sharp),
              Spacer(),
              IconButton(
                onPressed: () {
                },
                icon: Icon(Icons.add_comment),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 32),
          child: Divider(thickness: 2),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
          child: Text(
              noteModel.description.toUpperCase(),
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.caption
          ),
        ),
      ],
    );
  }

  Widget _albumSlider () {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text('Collections', style: Theme.of(context).textTheme.subtitle1),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 32),
            child: Divider(thickness: 2),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.15,
            padding: EdgeInsets.only(left: 32),
            child: ListView(
              scrollDirection: Axis.horizontal,
              physics: ClampingScrollPhysics(),
              children: noteModel.subNotes?.map((note) {
                int index = noteModel.subNotes.indexOf(note);
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.grey[500],
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  height: MediaQuery.of(context).size.height * 0.10,
                  width: MediaQuery.of(context).size.width * 0.30,
                  child: Card(
                    child: Stack(
                      children: [
                        if(note.photos.length > 0) ...[
                          Align(
                            alignment: Alignment.center,
                            child: Image.file(File(note.photos[0].imagePath), fit: BoxFit.cover, width: 150),
                          ),
                        ],
                        Align(
                          alignment: Alignment.center,
                          child: PopupMenuButton(
                            icon: Icon(Icons.add_box),
                            onSelected: (value) {
                              switch(value) {
                                case 'view':
                                  Navigator
                                    .pushNamed(
                                    context, '/gallery',
                                    arguments: ScreenArguments(
                                      photos: note.photos,
                                      index: index,
                                      noteId: noteModel.id,
                                      subNoteId: note.id)
                                    );
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
                                          selectedDate: noteModel.subNotes[index].isDate,
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
                            itemBuilder: (_) => <PopupMenuItem<String>>[
                              new PopupMenuItem<String>(
                                value: 'view',
                                child: Text('Gallery'),
                              ),
                              new PopupMenuItem<String>(
                                value: 'edit',
                                child: Text('Edit'),
                              ),
                              new PopupMenuItem<String>(
                                value: 'delete',
                                child: Text('Delete'),
                              ),
                            ],
                          ),
                        ),

                        Align(
                          alignment: Alignment.topLeft,
                          child: Text('${note.isDate.month}/${note.isDate.day}/${note.isDate.year}', style: Theme.of(context).textTheme.caption)
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text('${note.title}', style: Theme.of(context).textTheme.caption)
                        )
                      ],
                    )
                  ),
                );
              })?.toList() ?? []
            ),
          ),
        ],
      ),
    );
  }
}
