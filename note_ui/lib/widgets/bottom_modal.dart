import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_common/bloc/note/note_cubit.dart';
import 'package:note_common/models/note_model.dart';
import 'package:note_common/models/sub_notes.dart';
import 'package:note_ui/utils/generate_uuid.dart';

class BottomModal extends StatefulWidget {
  final NoteModel noteModel;

  BottomModal({Key key, this.noteModel}) : super(key: key);

  @override
  _BottomModalState createState () => _BottomModalState();
}

class _BottomModalState extends State<BottomModal>{
  DateTime selectedDate = DateTime.now();
  final TextEditingController _subNotes = TextEditingController();
  final TextEditingController _subject = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff757575),
      child: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _dateRow(),
            _noteTitle(),
            _noteInputs(),
            _handleSubmit(),
          ],
        ),
      ),
    );
  }

  Widget _dateRow () {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Date:'),
          Expanded(
            child: Card(
              child: ListTile(
                onTap: () async {
                  final DateTime date = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(1950),
                    lastDate: DateTime(2030),
                  );
                  setState(() {
                    selectedDate = date;
                  });
                },
                title: Text('${selectedDate.month}/${selectedDate.day}/${selectedDate.year}', textAlign: TextAlign.center)
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _noteTitle () {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Subject: '),
        Container(
          width: MediaQuery.of(context).size.width * 0.90,
          child: Card(
            child: TextFormField(
              controller: _subject,
              onChanged: (value) {
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
              ),
            ),
          )
        ),
      ],
    );
  }

  Widget _noteInputs () {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Your notes', style: TextStyle(fontWeight: FontWeight.w300, fontSize: 17)),
        Container(
          width: MediaQuery.of(context).size.width * 0.90,
          child: Card(
            child: TextFormField(
              controller: _subNotes,
              maxLines: 5,
              onChanged: (value) {
              },
              decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
              ),
            ),
          )
        ),
      ]
    );
  }

  RaisedButton _handleSubmit () {
    return RaisedButton(
      onPressed: () {
        final generatedId = genId();
        SubNotes subNotes = SubNotes(generatedId, selectedDate, _subject.text, _subNotes.text);
        context.bloc<NoteCubit>().addSubNotes(widget.noteModel, subNotes);
        Navigator.pop(context);
      },
      child: Text('Submit'),
    );
  }
}
