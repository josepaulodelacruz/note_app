import 'dart:io';

import 'package:flutter/material.dart';
import 'package:note_common/models/note_model.dart';
import 'package:note_ui/utils/get_initials.dart';

class SearchSection extends StatelessWidget {
  TextEditingController input;
  Function clearText;
  Function fuzzySearch;
  List<NoteModel> notes;

  SearchSection({this.input, this.clearText, this.notes, this.fuzzySearch})
      : assert(input != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF111111),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Flexible(
              flex: 1,
              child: TextField(
                controller: input,
                textAlign: TextAlign.start,
                onChanged: (value) => fuzzySearch(),
                decoration: InputDecoration(
                  hintText: 'Search Title',
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: IconButton(icon: Icon(Icons.close), onPressed: () {
                    clearText();
                  }),
                  border: OutlineInputBorder(
                    borderRadius:  BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(
                      color: Colors.black,
                      width: 1.0,
                    ),
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 3,
              child: Container(
                color: Color(0xFF111111),
                padding: EdgeInsets.only(top: 20),
                width: MediaQuery.of(context).size.width,
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: ListTile.divideTiles(
                    context: context,
                    tiles: notes?.map((note) {
                      int index = notes.indexOf(note);
                      return _noteCard(context, note, index);
                    })?.toList() ?? [],
                  ).toList(),
                ),
              ),
            ),
          ],
        ),
      )
    );
  }

  Widget _noteCard (BuildContext context, NoteModel note, int index) {
    final _title = note.checkIfNull() ?
    getInitials(title: note.title) : note.coverPhoto;
    return Container(
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