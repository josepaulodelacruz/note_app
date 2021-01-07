import 'dart:io';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_common/bloc/note/note_cubit.dart';
import 'package:note_common/models/note_model.dart';
import 'package:note_ui/model/screen_argument.dart';
import 'package:note_ui/widgets/bottom_modal.dart';

class AlbumSlider extends StatelessWidget {
  NoteModel noteModel;
  Function isSetState;
  final Function renderBottomModal;
  final Function expand;
  bool isView;

  AlbumSlider({this.noteModel, this.isSetState, this.renderBottomModal, this.expand, this.isView})
      : assert(isView != null);


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: InkWell(
                    onTap: () => expand(false),
                    child: Text('Collections',
                        style: Theme.of(context).textTheme.subtitle1.copyWith(color: !isView ?
                        Colors.yellowAccent : Colors.white))
                ),
              ),
              Padding(
                padding: EdgeInsets.zero,
                child: InkWell(
                    onTap: () => expand(true),
                    child: Text('Albums', style: Theme.of(context).textTheme.subtitle1.copyWith(color: isView ?
                    Colors.yellowAccent : Colors.white))),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 32.0),
                child: GestureDetector(
                    onTap: () {
                      renderBottomModal();
                    },
                    child: Icon(Icons.add_a_photo)
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Divider(thickness: 2),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.15,
            padding: EdgeInsets.only(left: 20),
            child: _sliderCollection(context),
          ),
        ],
      ),
    );
  }

  Widget _sliderCollection (context) {
    return ListView(
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
            child: InkWell(
              onTap: () => isSetState(note),
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context, '/gallery',
                    arguments: ScreenArguments(
                      subNotes: note,
                      photos: note.photos,
                      index: index,
                      noteId: noteModel.id,
                      noteModel: noteModel,
                      subNoteId: note.id)
                  );
                },
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
              ),
            ),
          );
        })?.toList() ?? []
    );
  }
}