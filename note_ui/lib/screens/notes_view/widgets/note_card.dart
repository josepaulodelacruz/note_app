import 'package:flutter/material.dart';

class NoteCard extends StatelessWidget {
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
            Text('Note Title'),
            Spacer(),
            PopupMenuButton(
              onSelected: (value) {
                print(value);
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
      color: Colors.blue,
      child: Text(
        'Album Here'
      ),

    );
  }

  Widget _noteFooter (context) {
    return ListTile(
      title: Text('12/23/20', style: TextStyle(fontSize: 12)),
      subtitle: Text('12:20', style: TextStyle(fontSize: 12)),
    );
  }
}