import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_common/bloc/note/note_cubit.dart';
import 'package:note_common/models/note_model.dart';
import 'package:note_common/models/sub_notes.dart';
import 'package:note_ui/utils/generate_uuid.dart';

class BottomModal extends StatefulWidget {
  int index;
  bool isEdit;
  NoteModel noteModel;
  SubNotes editSubNotes;
  DateTime selectedDate;

  BottomModal({
    Key key,
    this.index,
    this.editSubNotes,
    this.isEdit = false,
    this.selectedDate,
    this.noteModel,
  }) : super(key: key);

  @override
  _BottomModalState createState () => _BottomModalState();
}

class _BottomModalState extends State<BottomModal>{
  int index;
  bool isEdit;
  NoteModel noteModel;
  SubNotes editSubNotes;
  DateTime selectedDate;
  TextEditingController subNotes = TextEditingController();
  TextEditingController subject = TextEditingController();
  List<SubNotes> _subNotes;

  @override
  void initState () {
    super.initState();
    noteModel = widget.noteModel;
    isEdit = widget.isEdit;
    index = widget.index;
    editSubNotes = widget.editSubNotes;
    selectedDate = editSubNotes != null ? editSubNotes.isDate : DateTime.now();
    _subNotes = widget.noteModel.subNotes;
  }



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
            _dateRow(context),
            _noteTitle(context),
            _noteInputs(context),
            _handleSubmit(context),
          ],
        ),
      ),
    );
  }

  Widget _dateRow (context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Date:'),
          Expanded(
            child: Card(
              child: ListTile(
                onTap: () async {
                  DateTime date = await showDatePicker(
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

  Widget _noteTitle (context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Subject: '),
        Container(
          width: MediaQuery.of(context).size.width * 0.90,
          child: Card(
            child: TextFormField(
              controller: subject,
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

  Widget _noteInputs (context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Your notes', style: TextStyle(fontWeight: FontWeight.w300, fontSize: 17)),
        Container(
          width: MediaQuery.of(context).size.width * 0.90,
          child: Card(
            child: TextFormField(
              controller: subNotes,
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

  Widget _handleSubmit (context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if(isEdit) ...[
          RaisedButton(
            color: Colors.red,
            onPressed: () {
              BlocProvider.of<NoteCubit>(context).deleteSubNotes(index, noteModel);
              Navigator.pop(context);
            },
            child: Text('Delete'),
          )
        ],
        SizedBox(width: 10),
        RaisedButton(
          onPressed: () {
            if(!isEdit) {
              final generatedId = genId();
              SubNotes _isSubNotes = SubNotes(generatedId, selectedDate, subject.text, subNotes.text, photos: []);
              setState(() {
                _subNotes.add(_isSubNotes);
              });
              BlocProvider.of<NoteCubit>(context).addSubNotes(noteModel, _subNotes);
              Navigator.pop(context);
            } else {
              SubNotes _subNotes = SubNotes(editSubNotes.id, selectedDate, subject.text, subNotes.text, photos: []);
              BlocProvider.of<NoteCubit>(context).editSubNotes(noteModel, _subNotes, index);
              Navigator.pop(context);
            }
          },
          child: Text('Submit'),
        ),
      ],
    );
  }
}
