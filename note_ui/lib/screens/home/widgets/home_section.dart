import 'dart:io';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:note_common/models/note_model.dart';
import 'package:note_ui/utils/get_initials.dart';

class HomeSection extends StatelessWidget {
  List<NoteModel> notes;
  bool isView;

  HomeSection({this.notes, this.isView});

  @override
  Widget build(BuildContext context) {
    return PageTransitionSwitcher(
      transitionBuilder: (child, animation, secondaryAnimation) {
        return SharedAxisTransition(
          child: child,
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          transitionType: SharedAxisTransitionType.vertical,
          fillColor: Color(0xFF111111),
        );
      },
      child: !isView ?
        _listView(context): _gridView(context),
    );
  }

  Widget _listView (BuildContext context) {
    Widget _noteCard (BuildContext context, NoteModel note, int index) {
      final _title = note.checkIfNull() ?
      getInitials(title: note.title) : note.coverPhoto;
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        width: MediaQuery.of(context).size.width * 0.90,
        child: ListTile(
          leading: note.subNotes.isEmpty || note.subNotes[0].photos.isEmpty ?
          Hero(
            tag: note.id,
            child: CircleAvatar(
              backgroundColor: Color(0xFF333333),
              radius: 20,
              child: Material(child: Text(_title))),
          ) :
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

    return Stack(
      children: [
        Container(
          color: Color(0xFF111111),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
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

  Widget _gridView (context) {
    Widget _gridTile (BuildContext context, NoteModel note, int index) {
      final _title = note.checkIfNull() ?
      getInitials(title: note.title) : note.coverPhoto;
      return GridTile(
        footer: Material(
          color: Colors.transparent,
          shape: const RoundedRectangleBorder(
          ),
          clipBehavior: Clip.antiAlias,
          child: GridTileBar(
            backgroundColor: Colors.black45,
            title: Text(note.title, style: Theme.of(context).textTheme.bodyText1),
            subtitle: Text(note.description, overflow: TextOverflow.ellipsis),
          ),
        ),
        child: Container(
          color: Color(0xFF333333),
          child: InkWell(
            onTap: () {
              Navigator
                .pushNamed(
                context, '/view',
                arguments: NoteModel(
                    note.id,
                    note.title,
                    note.description,
                    subNotes: note.subNotes,
                    coverPhoto: note.coverPhoto));
            },
            child: note.subNotes.isEmpty || note.subNotes[0].photos.isEmpty ?
            Hero(
              tag: note.id,
              child: Center(
                child: Material(child: Text(_title))),
            ) :
            Hero(
              tag: note.subNotes[0].photos[0].id,
              child: Image.file(File(note.subNotes[0].photos[0].imagePath), fit: BoxFit.cover)
            ),
          ),
        )
      );
    }

    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      padding: const EdgeInsets.all(8),
      childAspectRatio: 1,
      children: notes?.map((note) {
        int index = notes.indexOf(note);
        return _gridTile(context, note, index);
      })?.toList() ?? [],
    );
  }


}