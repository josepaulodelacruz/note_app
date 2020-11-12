import 'dart:io';

import 'package:flutter/material.dart';
import 'package:note_common/models/note_model.dart';
import 'package:note_ui/utils/get_initials.dart';

class HomeSection extends StatelessWidget {
  List<NoteModel> notes;

  HomeSection({this.notes});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Color(0xFF111111),
          width: MediaQuery
              .of(context)
              .size
              .width,
          height: MediaQuery
              .of(context)
              .size
              .height,
          child: ListView(
            children: ListTile.divideTiles(
              context: context,
              tiles: notes?.map((note) {
                int index = notes.indexOf(note);
                return _noteCard(context, note, index);
              })?.toList() ?? [],
            ).toList(),
          ),
        ),
      ],
    );
  }


  Widget _noteCard (BuildContext context, NoteModel note, int index) {
    final _title = note.checkIfNull() ?
    getInitials(title: note.title) : note.coverPhoto;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      width: MediaQuery.of(context).size.width * 0.90,
      child: ListTile(
        leading: note.subNotes.isEmpty || note.subNotes[0].photos.isEmpty ?
        CircleAvatar(
          radius: 20,
          backgroundColor: Colors.black12,
          child: Text(_title)) :
        Hero(
          tag: note.subNotes[0].photos[0].id,
          child: Image.file(File(note.subNotes[0].photos[0].imagePath), fit: BoxFit.cover)
        ),
        title: Text(note.title, style: Theme.of(context).textTheme.bodyText1),
        subtitle: Text(note.description, overflow: TextOverflow.ellipsis),
        trailing: IconButton(
          onPressed: () {
            Navigator.pushNamed(context, '/view', arguments: NoteModel(note.id, note.title, note.description, subNotes: note.subNotes, coverPhoto: note.coverPhoto));
          },
          icon: Icon(Icons.arrow_forward_ios),
        ),
      ),
    );
  }
}