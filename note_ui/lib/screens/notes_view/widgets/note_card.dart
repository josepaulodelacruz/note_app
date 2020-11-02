import 'dart:io';
import 'package:camera/camera.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:note_common/models/pictures.dart';
import 'package:note_common/models/sub_notes.dart';
import 'package:note_ui/model/screen_argument.dart';

class NoteCard extends StatelessWidget {
  String noteId;
  SubNotes subNotes;
  final Function onHandle;

  NoteCard({Key key, this.noteId, this.subNotes, this.onHandle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(subNotes.photos);
    return Container(
      margin: EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      child: Card(
        elevation: 20,
        child: Column(
          children: [
            _titleSection(context),
            subNotes.photos.isEmpty ? SizedBox() : _noteAlbum(context),
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
      child: CarouselSlider.builder(
        itemCount: subNotes.photos.length,
        itemBuilder: (context, int itemIndex) {
          Pictures pp = subNotes.photos[itemIndex];
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/gallery', arguments: ScreenArguments(photos: subNotes.photos, index: itemIndex, noteId: noteId, subNoteId: subNotes.id));
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(),
              child: Hero(tag: pp.id, child: Image.file(File(pp.imagePath), fit: BoxFit.cover))
            ),
          );
        },
        options: CarouselOptions(
          enableInfiniteScroll: false,
          reverse: false,
          initialPage: 0,
          height: 250,
          viewportFraction: 1.0,
          enlargeCenterPage: false
        ),
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
          Navigator.pushNamed(context, '/camera', arguments: ScreenArguments(firstCamera: firstCamera, noteId: noteId, subNoteId: subNotes.id, photos: subNotes.photos));
        },
        icon: Icon(Icons.photo_album)
      ),
    );
  }
}