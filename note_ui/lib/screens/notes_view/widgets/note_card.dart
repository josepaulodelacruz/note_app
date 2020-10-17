import 'dart:io';
import 'package:camera/camera.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:note_common/models/sub_notes.dart';
import 'package:note_ui/model/screen_argument.dart';

class NoteCard extends StatelessWidget {
  String noteId;
  SubNotes subNotes;
  final Function onHandle;

  NoteCard({Key key, this.noteId, this.subNotes, this.onHandle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      child: Card(
        elevation: 20,
        child: Column(
          children: [
            _titleSection(context),
            _noteAlbum(context),
            _noteFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _titleSection (context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Icon(Icons.notes),
            ),
            Text(subNotes.title),
            Spacer(),
            PopupMenuButton(
              onSelected: (value) {
                if(value == 'view') {
                  onHandle('view');
                } else if(value == 'edit') {
                  onHandle('edit');
                } else {
                  onHandle('delete');
                }
              },
              itemBuilder: (_) => <PopupMenuItem<String>>[
                new PopupMenuItem<String>(
                  value: 'view',
                  child: Text('View'),
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
          ],
        ),
      ),
    );
  }

  Widget _noteAlbum (context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 250,
      color: Colors.blue,
      child: CarouselSlider(
        options: CarouselOptions(
          height: 250,
          viewportFraction: 1.0,
          enlargeCenterPage: false
        ),
        items: subNotes.photos?.map((pp) {
          return Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(),
            child: Image.file(File(pp.imagePath), fit: BoxFit.cover)
          );
        })?.toList() ?? [],
      )
    );
  }

  Widget _noteFooter (context) {
    return ListTile(
      title: Text('${subNotes.isDate.month}/${subNotes.isDate.day}/${subNotes.isDate.year}', style: TextStyle(fontSize: 12)),
      subtitle: Text('12:20', style: TextStyle(fontSize: 12)),
      trailing: IconButton(
        onPressed: () async {
          final cameras = await availableCameras();
          final firstCamera = cameras.first;
          Navigator.pushNamed(context, '/camera', arguments: ScreenArguments(firstCamera: firstCamera, noteId: noteId, subNoteId: subNotes.id));
        },
        icon: Icon(Icons.photo_album)
      ),
    );
  }
}