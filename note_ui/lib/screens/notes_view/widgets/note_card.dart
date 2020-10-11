import 'package:camera/camera.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:note_common/models/note_model.dart';
import 'package:note_common/models/sub_notes.dart';

class NoteCard extends StatelessWidget {
  SubNotes subNotes;
  final Function onHandle;

  NoteCard({Key key, this.subNotes, this.onHandle}) : super(key: key);

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
            Checkbox(value: true),
            Text(subNotes.title),
            Spacer(),
            PopupMenuButton(
              onSelected: (value) {
                if(value == 'view') {
                  onHandle('view');
                } else if(value == 'edit') {
                  onHandle('edit');
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
        items: [1,2,3,4,5].map((i) {
          return Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.amber
            ),
            child: Text('${subNotes.subTitle} $i', style: TextStyle(fontSize: 16.0),)
          );
        }).toList(),
      )
    );
  }

  Widget _noteFooter (context) {
    return ListTile(
      title: Text('12/23/20', style: TextStyle(fontSize: 12)),
      subtitle: Text('12:20', style: TextStyle(fontSize: 12)),
      trailing: IconButton(
        onPressed: () async {
          final cameras = await availableCameras();
          final firstCamera = cameras.first;
          Navigator.pushNamed(context, '/camera', arguments: firstCamera);
        },
        icon: Icon(Icons.photo_album)
      ),
    );
  }
}