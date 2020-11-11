import 'package:flutter/material.dart';
import 'package:note_common/models/note_model.dart';

class UpperSubtitle extends StatelessWidget {
  NoteModel noteModel;

  UpperSubtitle({this.noteModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
          padding: const EdgeInsets.only(left: 20),
          child: Divider(thickness: 2),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
              noteModel.description.toUpperCase(),
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.caption
          ),
        ),
      ],
    );
  }
}