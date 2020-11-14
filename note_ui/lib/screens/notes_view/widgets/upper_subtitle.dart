import 'package:flutter/material.dart';
import 'package:note_common/models/note_model.dart';
import 'package:note_ui/fixtures/random_quotes.dart';
import 'package:note_ui/screens/notes_view/widgets/edit_modal.dart';

class UpperSubtitle extends StatelessWidget {
  NoteModel noteModel;
  final TextEditingController newTitle;
  final TextEditingController newDescription;

  UpperSubtitle({this.noteModel, this.newDescription, this.newTitle});

  @override
  Widget build(BuildContext context) {
    int quotesIndex = quotes.indexWhere((quote) => quote.quotes == noteModel.description);
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
                  return showDialog(
                    context: context,
                    builder: (_) => EditModal(
                      noteModel: noteModel,
                      newTitle: newTitle,
                      newDescription: newDescription,
                    ),
                  );
                },
                icon: Icon(Icons.edit),
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
        if(quotesIndex != -1) ...[
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
                '- ${quotes[quotesIndex].author}',
                textAlign: TextAlign.end,
                style: Theme.of(context).textTheme.caption
            ),
          ),
        ]
      ],
    );
  }
}